import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// ViewModel untuk semua operasi autentikasi.
/// Digunakan via Provider di seluruh app.
class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Untuk menyimpan data sementara antar step registrasi
  String? _pendingUid; // uid setelah register, sebelum upload selfie

  // ================================================================
  // GETTERS
  // ================================================================
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get pendingUid => _pendingUid;

  // ================================================================
  // LOGIN
  // ================================================================

  /// Login user. Returns true jika berhasil.
  Future<bool> login(String email, String password, {bool enableBiometric = false}) async {
    _setLoading(true);
    _clearError();
    try {
      _currentUser = await _authService.signIn(email, password);
      
      // Simpan kredensial untuk biometric jika diizinkan
      if (enableBiometric) {
        await _authService.saveBiometricCredentials(email, password);
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ================================================================
  // BIOMETRIC & LUPA PASSWORD
  // ================================================================

  /// Reset Password by Email
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();
    try {
      if (email.isEmpty) throw Exception("Email tidak boleh kosong");
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Login via Biometric (FaceID/Fingerprint)
  Future<bool> loginBiometric() async {
    _setLoading(true);
    _clearError();
    try {
      _currentUser = await _authService.loginWithBiometric();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ================================================================
  // REGISTER — STEP 1: Simpan data KTP + buat akun Auth + upload KTP
  // ================================================================

  /// Registrasi warga baru. Upload foto KTP ke Cloudinary, simpan ke Firestore.
  /// Returns true jika berhasil, false jika gagal (cek errorMessage).
  Future<bool> registerStep1({
    required String email,
    required String password,
    required Map<String, String> ktpData,
    File? ktpImageFile,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      final uid = await _authService.registerWarga(
        email: email,
        password: password,
        ktpData: ktpData,
        ktpImageFile: ktpImageFile,
      );
      _pendingUid = uid;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ================================================================
  // REGISTER — STEP 2: Upload selfie
  // ================================================================

  /// Upload selfie ke Cloudinary dan update Firestore.
  /// Returns true jika berhasil.
  Future<bool> registerStep2(File selfieFile) async {
    if (_pendingUid == null) {
      _errorMessage = 'Sesi registrasi tidak valid. Mulai ulang dari awal.';
      notifyListeners();
      return false;
    }
    _setLoading(true);
    _clearError();
    try {
      await _authService.uploadSelfieAndFinish(_pendingUid!, selfieFile);
      // Langsung logout agar user perlu login manual (keamanan)
      await _authService.signOut();
      _clearPendingData();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 🐛 DEBUG ONLY: Skip selfie upload, langsung finalize registrasi.
  Future<bool> registerStep2Skip() async {
    if (_pendingUid == null) {
      _errorMessage = 'Sesi registrasi tidak valid. Mulai ulang dari awal.';
      notifyListeners();
      return false;
    }
    _setLoading(true);
    _clearError();
    try {
      await _authService.signOut();
      _clearPendingData();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ================================================================
  // LOAD USER (dipanggil saat AuthGate detect login)
  // ================================================================

  Future<void> loadCurrentUser(String uid) async {
    try {
      _currentUser = await _authService.getUserById(uid);
      notifyListeners();
    } catch (e) {
      debugPrint('[AuthViewModel] Gagal load user: $e');
    }
  }

  // ================================================================
  // LOGOUT
  // ================================================================

  Future<void> logout() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // ================================================================
  // HELPERS
  // ================================================================

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void _clearPendingData() {
    _pendingUid = null;
  }
}

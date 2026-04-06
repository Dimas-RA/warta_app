import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import '../models/user_model.dart';
import 'cloudinary_service.dart';

/// Service utama untuk autentikasi Firebase dan manajemen data user di Firestore.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CloudinaryService _cloudinary = CloudinaryService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Stream status login — digunakan oleh AuthGate
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// User Firebase saat ini
  User? get currentFirebaseUser => _auth.currentUser;

  // ================================================================
  // SIGN IN
  // ================================================================

  /// Login dengan email/username & password.
  /// Returns UserModel jika berhasil, throws Exception jika gagal.
  Future<UserModel> signIn(String emailOrUsername, String password) async {
    try {
      String emailToLogin = emailOrUsername.trim();

      // Jika input bukan email (tidak ada '@'), asumsikan user login pakai Nama Lengkap
      if (!emailToLogin.contains('@')) {
        final snapshot = await _firestore
            .collection('users')
            .where('nama', isEqualTo: emailToLogin)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          emailToLogin = snapshot.docs.first.data()['email'] as String? ?? '';
        } else {
          throw Exception('Nama pengguna tidak terdaftar. Silakan daftar dulu.');
        }
      }

      final credential = await _auth.signInWithEmailAndPassword(
        email: emailToLogin,
        password: password,
      );
      
      final uid = credential.user!.uid;
      final userModel = await getUserById(uid);
      if (userModel == null) {
        throw Exception('Data akun tidak ditemukan. Silakan hubungi admin.');
      }
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e.code));
    }
  }

  // ================================================================
  // REGISTER
  // ================================================================

  /// Registrasi akun warga baru.
  /// 1. Buat akun Firebase Auth
  /// 2. Upload foto KTP ke Cloudinary
  /// 3. Simpan data ke Firestore dengan role 'warga'
  /// Returns uid jika berhasil.
  Future<String> registerWarga({
    required String email,
    required String password,
    required Map<String, String> ktpData,
    File? ktpImageFile,
  }) async {
    try {
      // 1. Buat akun Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final uid = credential.user!.uid;

      // 2. Upload foto KTP ke Cloudinary (jika ada)
      String? ktpUrl;
      if (ktpImageFile != null) {
        ktpUrl = await _cloudinary.uploadImage(
          ktpImageFile,
          folder: 'ktp_photos',
        );
        debugPrint('[AuthService] KTP URL: $ktpUrl');
      }

      // 3. Simpan data ke Firestore
      final userModel = UserModel(
        uid: uid,
        email: email.trim(),
        nama: ktpData['nama'] ?? '',
        nik: ktpData['nik'] ?? '',
        role: 'warga',
        status: 'pending',
        ktpUrl: ktpUrl,
        tempatLahir: ktpData['tempat_lahir'],
        tanggalLahir: ktpData['tanggal_lahir'],
        jenisKelamin: ktpData['jenis_kelamin'],
        golDarah: ktpData['gol_darah'],
        agama: ktpData['agama'],
        statusPerkawinan: ktpData['status_perkawinan'],
        pekerjaan: ktpData['pekerjaan'],
        kewarganegaraan: ktpData['kewarganegaraan'],
        alamat: ktpData['alamat'],
        rt: ktpData['rt'],
        rw: ktpData['rw'],
        kelurahan: ktpData['kelurahan'],
        kecamatan: ktpData['kecamatan'],
        kabupaten: ktpData['kabupaten'],
      );

      await _firestore
          .collection('users')
          .doc(uid)
          .set(userModel.toFirestore());

      debugPrint('[AuthService] User terdaftar: $uid');
      return uid;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e.code));
    }
  }

  /// Upload selfie ke Cloudinary dan update field selfieUrl di Firestore.
  Future<void> uploadSelfieAndFinish(String uid, File selfieFile) async {
    final selfieUrl = await _cloudinary.uploadImage(
      selfieFile,
      folder: 'selfies',
    );

    if (selfieUrl == null) {
      throw Exception('Gagal mengupload foto selfie. Coba lagi.');
    }

    await _firestore.collection('users').doc(uid).update({
      'selfieUrl': selfieUrl,
    });

    debugPrint('[AuthService] Selfie URL: $selfieUrl');
  }

  // ================================================================
  // SIGN OUT
  // ================================================================

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ================================================================
  // LUPA PASSWORD & BIOMETRIK
  // ================================================================

  /// Kirim email reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e.code));
    }
  }

  /// Aktifkan login biometrik dengan menyimpan kredensial ke secure storage
  Future<void> saveBiometricCredentials(String email, String password) async {
    await _secureStorage.write(key: 'bio_email', value: email);
    await _secureStorage.write(key: 'bio_password', value: password);
    await _secureStorage.write(key: 'bio_enabled', value: 'true');
  }

  /// Proses Login Biometrik - Membaca sensor & kredensial
  Future<UserModel?> loginWithBiometric() async {
    try {
      final isBiometricEnabled = await _secureStorage.read(key: 'bio_enabled');
      if (isBiometricEnabled != 'true') {
        throw Exception("Biometrik belum diaktifkan. Silakan login manual dan centang opsi 'Gunakan Biometrik'.");
      }

      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        throw Exception("Perangkat ini tidak mendukung fitur Biometrik.");
      }

      final authenticated = await _localAuth.authenticate(
        localizedReason: "Pindai biometrik Anda untuk masuk secara otomatis",
      );

      if (!authenticated) {
        throw Exception("Otentikasi biometrik dibatalkan.");
      }

      final email = await _secureStorage.read(key: 'bio_email');
      final password = await _secureStorage.read(key: 'bio_password');

      if (email == null || password == null) {
        throw Exception("Kredensial hilang. Harap login manual kembali.");
      }

      return await signIn(email, password);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(e.toString());
    }
  }

  // ================================================================
  // GET USER DATA
  // ================================================================

  /// Ambil data UserModel dari Firestore berdasarkan uid.
  Future<UserModel?> getUserById(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  /// Ambil role user (string) dari Firestore.
  Future<String?> getUserRole(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data()?['role'] as String?;
  }

  // ================================================================
  // ERROR MAPPING
  // ================================================================

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Akun tidak ditemukan. Pastikan email sudah terdaftar.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email atau password salah.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-disabled':
        return 'Akun ini telah dinonaktifkan. Hubungi admin.';
      case 'email-already-in-use':
        return 'Email sudah digunakan oleh akun lain.';
      case 'weak-password':
        return 'Password terlalu lemah. Minimal 6 karakter.';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti.';
      default:
        return 'Terjadi kesalahan. Silakan coba lagi. ($code)';
    }
  }
}

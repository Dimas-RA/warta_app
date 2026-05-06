import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../main/main_view.dart';

class RwProfilView extends StatefulWidget {
  const RwProfilView({super.key});

  @override
  State<RwProfilView> createState() => _RwProfilViewState();
}

class _RwProfilViewState extends State<RwProfilView> {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color bgApp = Color(0xFFF8F9FA);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textGray = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color goldColor = Color(0xFFD4AF37);

  bool _useBiometric = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadBiometricState());
  }

  Future<void> _loadBiometricState() async {
    final authVM = context.read<AuthViewModel>();
    final isEnabled = await authVM.isBiometricEnabled();
    if (mounted) setState(() => _useBiometric = isEnabled);
  }

  Future<void> _showEditPhotoSheet(BuildContext context, AuthViewModel authVM) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ganti Foto Profil',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pilih sumber foto profil Anda',
              style: TextStyle(color: textGray, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildPhotoBtn(
                    icon: Icons.camera_alt_rounded,
                    label: 'Kamera',
                    onTap: () => Navigator.pop(ctx, 'camera'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPhotoBtn(
                    icon: Icons.photo_library_rounded,
                    label: 'Galeri',
                    onTap: () => Navigator.pop(ctx, 'gallery'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: borderColor, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'Batal',
                  style: TextStyle(color: textGray, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (choice == null || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final success = await authVM.updateProfilePhoto(fromCamera: choice == 'camera');
    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(success ? 'Foto profil berhasil diperbarui!' : (authVM.errorMessage ?? 'Gagal memperbarui foto.')),
        backgroundColor: success ? const Color(0xFF16A34A) : primaryPurple,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildPhotoBtn({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF3E5F5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryPurple.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: primaryPurple, size: 32),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: primaryPurple, fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  void _promptBiometricToggle(bool turnOn, AuthViewModel authVM) {
    if (!turnOn) {
      authVM.disableBiometric();
      setState(() => _useBiometric = false);
      return;
    }

    final passCtrl = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Konfirmasi Keamanan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Masukkan kata sandi Anda untuk mengaktifkan biometrik.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: primaryPurple),
                    hintText: 'Kata Sandi',
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: primaryPurple, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        setState(() => _useBiometric = false);
                      },
                      child: const Text('BATAL', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        final password = passCtrl.text;
                        if (password.isEmpty) return;
                        Navigator.pop(ctx);
                        final success = await authVM.enableBiometricWithReauth(password);
                        if (mounted) {
                          setState(() => _useBiometric = success);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(success ? 'Biometrik berhasil diaktifkan!' : (authVM.errorMessage ?? 'Gagal mengatur biometrik')),
                              backgroundColor: success ? Colors.green : primaryPurple,
                            ),
                          );
                        }
                      },
                      child: const Text('VERIFIKASI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthViewModel authVM) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: AlertDialog(
          backgroundColor: Colors.white.withValues(alpha: 0.95),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Keluar', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Apakah kamu yakin ingin keluar dari akun ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: textGray)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                Navigator.pop(context);
                await authVM.logout();
              },
              child: const Text('Keluar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final user = authVM.currentUser;

    return Scaffold(
      backgroundColor: bgApp,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // ── HEADER ──
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    // Background gradient
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF4A148C), Color(0xFF6A1B9A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                        child: Stack(
                          children: [
                            Positioned(
                              right: -20,
                              top: -20,
                              child: Transform.rotate(
                                angle: 12 * 3.14159 / 180,
                                child: Image(
                                  image: const AssetImage('assets/images/warta_logo.png'),
                                  width: 180,
                                  height: 180,
                                  color: Colors.white.withValues(alpha: 0.05),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(24, 60, 24, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Profil Pengurus',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Kartu Identitas ──
                    Padding(
                      padding: const EdgeInsets.only(top: 110, left: 24, right: 24),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Foto profil
                            GestureDetector(
                              onTap: () => _showEditPhotoSheet(context, authVM),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: primaryPurple, width: 3),
                                      color: const Color(0xFFF3E5F5),
                                    ),
                                    child: ClipOval(
                                      child: (user?.selfieUrl != null && user!.selfieUrl!.isNotEmpty)
                                          ? Image.network(
                                              user.selfieUrl!,
                                              fit: BoxFit.cover,
                                              width: 74,
                                              height: 74,
                                              loadingBuilder: (_, child, progress) =>
                                                  progress == null ? child : const Center(child: CircularProgressIndicator(color: primaryPurple, strokeWidth: 2)),
                                              errorBuilder: (_, __, ___) =>
                                                  const Icon(Icons.person, size: 40, color: primaryPurple),
                                            )
                                          : const Icon(Icons.person, size: 40, color: primaryPurple),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: primaryPurple,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                      ),
                                      child: const Icon(Icons.camera_alt, size: 12, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              user?.nama ?? 'Ketua RW',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'NIK: ${user?.nik ?? '-'}',
                              style: const TextStyle(color: textGray, fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: goldColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                (user?.roleLabel ?? 'Ketua RW').toUpperCase(),
                                style: const TextStyle(
                                  color: goldColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            if (user?.rw != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                'RW ${user!.rw!}  ·  ${user.kelurahan ?? '-'}',
                                style: const TextStyle(color: textGray, fontSize: 12),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // ── Menu Sistem Administrasi ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sistem Administrasi',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textDark),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildMenuItem(
                              Icons.people_alt_outlined,
                              'Daftar Penduduk RW',
                              subtitle: 'Seluruh warga dalam wilayah RW',
                              onTap: () => _showComingSoon(context, 'Daftar Penduduk'),
                            ),
                            const Divider(height: 1, color: borderColor),
                            _buildMenuItem(
                              Icons.history_outlined,
                              'Riwayat Persetujuan',
                              subtitle: 'Arsip laporan & surat yang ditangani',
                              onTap: () => _showComingSoon(context, 'Riwayat'),
                            ),
                            const Divider(height: 1, color: borderColor),
                            _buildMenuItem(
                              Icons.fingerprint,
                              'Autentikasi Biometrik',
                              subtitle: 'Login instan dengan sidik jari / FaceID',
                              isSwitch: true,
                              switchValue: _useBiometric,
                              onSwitchChanged: (val) => _promptBiometricToggle(val, authVM),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
                      const Text(
                        'Akses Peran',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textDark),
                      ),
                      const SizedBox(height: 16),

                      // Switch ke panel warga
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MainView()),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1F2937), Color(0xFF374151)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.swap_horiz, color: Colors.white, size: 28),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Beralih ke Panel Warga',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    Text(
                                      'Gunakan panel reguler untuk keperluan pribadi.',
                                      style: TextStyle(color: Colors.grey, fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right, color: Colors.white),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Tombol Keluar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: _buildMenuItem(
                          Icons.logout,
                          'Keluar dari Aplikasi',
                          isLogout: true,
                          onTap: () => _showLogoutDialog(context, authVM),
                        ),
                      ),

                      const SizedBox(height: 32),
                      const Center(
                        child: Text(
                          'WARTA APP v1.0.0',
                          style: TextStyle(color: textGray, fontSize: 10, letterSpacing: 1),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Loading overlay saat upload foto
          if (authVM.isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.35),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                    SizedBox(height: 16),
                    Text(
                      'Mengupload foto...',
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label — Segera hadir!'),
        backgroundColor: primaryPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title, {
    String? subtitle,
    bool isLogout = false,
    bool isSwitch = false,
    bool switchValue = false,
    ValueChanged<bool>? onSwitchChanged,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: isSwitch ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isLogout
                    ? primaryPurple.withValues(alpha: 0.1)
                    : const Color(0xFFF3E5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: isLogout ? Colors.red : primaryPurple, size: 18),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isLogout ? Colors.red : textDark,
                      fontSize: 14,
                      fontWeight: isLogout ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: textGray, fontSize: 10)),
                  ],
                ],
              ),
            ),
            if (isSwitch)
              Switch(value: switchValue, onChanged: onSwitchChanged, activeThumbColor: primaryPurple)
            else if (!isLogout)
              const Icon(Icons.chevron_right, color: textGray, size: 20),
          ],
        ),
      ),
    );
  }
}

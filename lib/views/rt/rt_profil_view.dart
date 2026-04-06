import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../auth/auth_gate.dart';
import '../main/main_view.dart';

class RtProfilView extends StatelessWidget {
  const RtProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final user = authVM.currentUser;

    const Color primaryRed = Color(0xFF8B0000);
    const Color bgApp = Color(0xFFF8F9FA);
    const Color textDark = Color(0xFF1F2937);
    const Color textGray = Color(0xFF6B7280);
    const Color borderColor = Color(0xFFE5E7EB);
    const Color goldColor = Color(0xFFD4AF37);

    return Scaffold(
      backgroundColor: bgApp,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER PROFIL MELENGKUNG (Sejalan dengan Warga) ---
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                // Box background gradien lengkung
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 83, 0, 0),
                        Color(0xFF8B0000),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(40),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20,
                          top: -20,
                          child: Transform.rotate(
                            angle: 12 * 3.14159 / 180,
                            child: Image(
                              image: const AssetImage(
                                'assets/images/warta_logo.png',
                              ),
                              width: 180,
                              height: 180,
                              color: const Color.fromARGB(
                                255,
                                58,
                                1,
                                1,
                              ).withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(24, 60, 24, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Profil Pengurus",
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

                // BOX IDENTITAS PROFIL
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
                        // Foto Profil
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: primaryRed, width: 3),
                            color: const Color(0xFFFEF2F2),
                          ),
                          child: (user?.selfieUrl != null &&
                                  user!.selfieUrl!.isNotEmpty)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    user.selfieUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: primaryRed,
                                ),
                        ),
                        const SizedBox(height: 16),
                        // Nama Utama
                        Text(
                          user?.nama ?? "Bapak RT",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // NIK & Hak Akses
                        Text(
                          "NIK: ${user?.nik ?? '-'}",
                          style: const TextStyle(
                            color: textGray,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: goldColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            (user?.roleLabel ?? "Ketu RT").toUpperCase(),
                            style: const TextStyle(
                              color: goldColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),

            // --- MENU SETTINGS PENGURUS ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sistem Administrasi",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Menu List
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
                          Icons.edit_document,
                          "Tanda Tangan Digital",
                          subtitle: "Atur tanda tangan untuk persetujuan surat",
                          onTap: () {},
                        ),
                        const Divider(height: 1, color: borderColor),
                        _buildMenuItem(
                          Icons.people_alt_outlined,
                          "Daftar Penduduk",
                          subtitle: "Manajemen data penduduk lengkap",
                          onTap: () {},
                        ),
                        const Divider(height: 1, color: borderColor),
                        _buildMenuItem(
                          Icons.history_outlined,
                          "Riwayat Persetujuan",
                          subtitle: "Arsip berkas dan surat yang pernah ditangani",
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  const Text(
                    "Akses Peran",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ROLE SWITCHER BUTTON
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
                                  "Beralih ke Panel Warga",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(
                                  "Gunakan panel reguler untuk keperluan pribadi.",
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
                  
                  // BOX MENU KELUAR
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
                      "Keluar dari Aplikasi",
                      isLogout: true,
                      onTap: () {
                        _showLogoutDialog(context, authVM);
                      },
                    ),
                  ),

                  const SizedBox(height: 32),
                  // VERSI APLIKASI
                  const Center(
                    child: Text(
                      "WARTA APP v1.0.0",
                      style: TextStyle(
                        color: textGray,
                        fontSize: 10,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---
  Widget _buildMenuItem(
    IconData icon,
    String title, {
    String? subtitle,
    bool isLogout = false,
    VoidCallback? onTap,
  }) {
    const primaryRed = Color(0xFF8B0000);
    const textDark = Color(0xFF1F2937);
    const textGray = Color(0xFF6B7280);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isLogout
                    ? primaryRed.withOpacity(0.1)
                    : const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: primaryRed,
                size: 18,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isLogout ? primaryRed : textDark,
                      fontSize: 14,
                      fontWeight: isLogout ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(color: textGray, fontSize: 10),
                    ),
                  ],
                ],
              ),
            ),
            if (!isLogout)
              const Icon(Icons.chevron_right, color: textGray, size: 20),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthViewModel authVM) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Konfirmasi Logout",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Apakah Anda yakin ingin keluar dari sesi aplikasi WARTA Anda saat ini?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                      child: const Text("BATAL", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B0000),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () async {
                        await authVM.logout();
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const AuthGate()),
                            (route) => false,
                          );
                        }
                      },
                      child: const Text("KELUAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
}

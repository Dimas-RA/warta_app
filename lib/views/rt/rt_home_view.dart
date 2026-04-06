import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'package:intl/intl.dart';

class RtHomeView extends StatefulWidget {
  final Function(int) onNavigate;
  const RtHomeView({super.key, required this.onNavigate});

  @override
  State<RtHomeView> createState() => _RtHomeViewState();
}

class _RtHomeViewState extends State<RtHomeView> {
  static const Color primaryRed = Color(0xFF8B0000);
  static const Color bgGray = Color(0xFFF9FAFB);
  static const Color textDark = Color(0xFF1F2937);
  static const Color goldColor = Color(0xFFD4AF37);

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Selamat Pagi,";
    if (hour < 15) return "Selamat Siang,";
    if (hour < 18) return "Selamat Sore,";
    return "Selamat Malam,";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGray,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER MELENGKUNG (SAMA SEPERTI WARGA) ---
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 250,
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getGreeting(),
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.7,
                                          ),
                                          fontSize: 14,
                                        ),
                                      ),
                                      Consumer<AuthViewModel>(
                                        builder: (context, authVM, _) {
                                          final name =
                                              authVM.currentUser?.nama ??
                                              "Bapak RT";
                                          return Text(
                                            name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  // --- TOMBOL NOTIFIKASI ---
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: goldColor, // Emas
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.2),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      "PENGURUS RT",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              
                              // Kotak Info Laporan Cepat
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.mark_email_unread_outlined, color: Colors.white, size: 20),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        "Terdapat 3 Laporan Warga baru yang membutuhkan tindak lanjut Anda.",
                                        style: TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // BOX STATISTIK CEPAT (Mirip Quick Action Warga)
                Positioned(
                  bottom: -40,
                  left: 24,
                  right: 24,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildQuickAction(
                          Icons.request_page_outlined,
                          Colors.orange,
                          Colors.orange.withValues(alpha: 0.1),
                          "Surat",
                          () => widget.onNavigate(2),
                        ),
                        _buildQuickAction(
                          Icons.report_problem_outlined,
                          Colors.red,
                          Colors.red.withValues(alpha: 0.1),
                          "Laporan",
                          () => widget.onNavigate(2),
                        ),
                        _buildQuickAction(
                          Icons.payments_outlined,
                          Colors.green,
                          Colors.green.withValues(alpha: 0.1),
                          "Iuran",
                          () => widget.onNavigate(1),
                        ),
                        _buildQuickAction(
                          Icons.security_outlined,
                          Colors.blue,
                          Colors.blue.withValues(alpha: 0.1),
                          "Ronda",
                          () => widget.onNavigate(1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 70),

            // --- TABEL DATA TERBARU ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Daftar Aktivitas Baru",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      TextButton(
                        onPressed: () => widget.onNavigate(2), // Pindah ke tab Approval
                        child: const Text(
                          "Lihat Semua",
                          style: TextStyle(
                            color: primaryRed,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Dummy ListView yang bisa diklik
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          // Trigger pindah tab Approval
                          widget.onNavigate(2);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.1),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.description_outlined,
                                  color: Color(0xFF8B0000),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      index == 0 ? "Surat Keterangan Usaha" : "Laporan Infrastruktur",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      "Menunggu Persetujuan Anda",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tombol Aksi Cepat
  Widget _buildQuickAction(
    IconData icon,
    Color iconColor,
    Color bgColor,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: textDark,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  // Warna sesuai CSS Figma
  static const Color primaryRed = Color(0xFF8B0000);
  static const Color bgGray = Color(0xFFF9FAFB);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textGray = Color(0xFF6B7280);
  static const Color goldColor = Color(0xFFD4AF37);
  static const Color greenSuccess = Color(0xFF16A34A);
  static const Color bgSuccess = Color(0xFFDCFCE7);
  static const Color yellowProcess = Color(0xFFA16207);
  static const Color bgProcess = Color(0xFFFEF9C3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGray,
      
      // ==========================================
      // KONTEN UTAMA (BODY)
      // ==========================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40), // Jarak agar tidak tertutup nav bar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER (Merah Melengkung & Card Status)
            SizedBox(
              height: 230,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Latar Belakang Merah
                  Container(
                    height: 198,
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
                    decoration: const BoxDecoration(
                      color: primaryRed,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(40),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Teks Sapaan
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Selamat Pagi,",
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            Text(
                              "Budi Setiawan",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // Ikon Notif & Pencarian
                        Row(
                          children: [
                            _buildTopIcon(Icons.notifications_none),
                            const SizedBox(width: 12),
                            _buildTopIcon(Icons.search),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Card Status Identitas (Menimpa garis bawah merah)
                  Positioned(
                    bottom: 0,
                    left: 24,
                    right: 24,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: goldColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.fingerprint, color: goldColor, size: 20),
                              ),
                              const SizedBox(width: 12),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("STATUS IDENTITAS", style: TextStyle(color: textGray, fontSize: 10, fontWeight: FontWeight.bold)),
                                  Text("Terverifikasi (E-KTP)", style: TextStyle(color: textDark, fontSize: 14, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: primaryRed,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "LIHAT QR",
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 2. LAYANAN DIGITAL (Menu Grid)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Layanan Digital", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textDark)),
                      Text("Lihat Semua", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryRed.withOpacity(0.8))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMenuBtn(Icons.badge, "Digital ID"),
                      _buildMenuBtn(Icons.campaign, "Pengaduan"),
                      _buildMenuBtn(Icons.article, "Berita"),
                      // Tombol Darurat / Panic Button
                      _buildMenuBtn(Icons.priority_high, "Darurat"), 
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 3. AKTIVITAS TERAKHIR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Aktivitas Terakhir", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textDark)),
                      Text("Riwayat", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryRed.withOpacity(0.8))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildActivityItem(Icons.check_circle, greenSuccess, bgSuccess, "Verifikasi E-KTP", "2 Jam yang lalu", "BERHASIL", greenSuccess, bgSuccess),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(color: bgGray, thickness: 1.5),
                        ),
                        _buildActivityItem(Icons.description, Colors.blue, Colors.blue.withOpacity(0.1), "Permohonan Surat", "Kemarin, 14:20", "PROSES", yellowProcess, bgProcess),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 4. BANNER INFORMASI PUBLIK
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primaryRed, Color(0xFF660000)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("INFORMASI PUBLIK", style: TextStyle(color: goldColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    SizedBox(height: 8),
                    Text(
                      "Vaksinasi Massal\nKecamatan Merdeka",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ==========================================
      // TOMBOL KAMERA MELAYANG (FLOATING ACTION BUTTON)
      // ==========================================
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigasi ke E-Report / Scan QR
        },
        backgroundColor: goldColor,
        shape: CircleBorder(
          side: const BorderSide(color: Colors.white, width: 4), // Border putih seperti Figma
        ),
        elevation: 6,
        child: const Icon(Icons.camera_alt, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ==========================================
      // BOTTOM NAVIGATION BAR
      // ==========================================
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(Icons.home, "Home", true),
              _buildBottomNavItem(Icons.mail, "Surat", false),
              const SizedBox(width: 48), // Ruang kosong untuk tombol kamera di tengah
              _buildBottomNavItem(Icons.history, "Aktivitas", false),
              _buildBottomNavItem(Icons.person, "Profil", false),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  // Ikon Bulat Transparan di Header
  Widget _buildTopIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  // Tombol Menu Layanan Digital
  Widget _buildMenuBtn(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF3F4F6)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          child: Icon(icon, color: primaryRed, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: textGray, fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // Item List Aktivitas
  Widget _buildActivityItem(IconData icon, Color iconColor, Color iconBg, String title, String time, String status, Color statusColor, Color statusBg) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: textDark, fontSize: 14, fontWeight: FontWeight.bold)),
                Text(time, style: const TextStyle(color: textGray, fontSize: 10)),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
          child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  // Item Bottom Navigation
  Widget _buildBottomNavItem(IconData icon, String label, bool isActive) {
    final color = isActive ? primaryRed : Colors.grey.shade400;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }
}
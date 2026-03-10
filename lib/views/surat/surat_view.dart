import 'package:flutter/material.dart';

class SuratView extends StatelessWidget {
  const SuratView({super.key});

  // Warna sesuai CSS Figma
  static const Color primaryRed = Color(0xFF8B0000);
  static const Color bgApp = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF111827);
  static const Color textGray = Color(0xFF6B7280);
  static const Color goldColor = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgApp,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 1. HEADER MERAH & SEARCH BAR (Tumpang Tindih)
            // ==========================================
            SizedBox(
              height: 230,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Latar Belakang Merah Lengkung
                  Container(
                    height: 200,
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
                    decoration: BoxDecoration(
                      color: primaryRed,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Baris Ikon Atas (Back & History)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTopIcon(Icons.arrow_back),
                            _buildTopIcon(Icons.history),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Teks Judul
                        const Text(
                          "Layanan Surat",
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Ajukan permohonan surat secara online",
                          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),

                  // Search Bar Melayang
                  Positioned(
                    bottom: 5,
                    left: 24,
                    right: 24,
                    child: Row(
                      children: [
                        // Kotak Input Pencarian
                        Expanded(
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFF3F4F6)),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 4)),
                              ],
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                                SizedBox(width: 12),
                                Text("Cari jenis surat...", style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Tombol Filter Merah
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: primaryRed,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: const Icon(Icons.filter_list, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ==========================================
            // 2. KATEGORI SURAT (Grid 2x2)
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Kategori Surat", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark)),
                  const SizedBox(height: 16),
                  
                  // Baris 1
                  Row(
                    children: [
                      Expanded(child: _buildCategoryCard(Icons.description, const Color(0xFF2563EB), const Color(0xFFEFF6FF), "Administrasi", "KK, KTP, Akta")),
                      const SizedBox(width: 16),
                      Expanded(child: _buildCategoryCard(Icons.domain, const Color(0xFFEA580C), const Color(0xFFFFF7ED), "Perizinan", "Usaha, Bangunan")),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Baris 2
                  Row(
                    children: [
                      Expanded(child: _buildCategoryCard(Icons.volunteer_activism, const Color(0xFF9333EA), const Color(0xFFFAF5FF), "Keterangan", "Tidak Mampu, Domisili")),
                      const SizedBox(width: 16),
                      Expanded(child: _buildCategoryCard(Icons.gavel, const Color(0xFF16A34A), const Color(0xFFF0FDF4), "Hukum", "Ahli Waris, Tanah")),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ==========================================
            // 3. PALING SERING DIAKSES (List View)
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Paling Sering Diakses", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark)),
                  const SizedBox(height: 16),
                  _buildPopularItem(Icons.home, "Surat Keterangan Domisili", "Administrasi Kependudukan"),
                  const SizedBox(height: 12),
                  _buildPopularItem(Icons.storefront, "Surat Izin Usaha Mikro", "Perizinan Usaha"),
                  const SizedBox(height: 12),
                  _buildPopularItem(Icons.family_restroom, "Surat Keterangan Kelahiran", "Pencatatan Sipil"),
                ],
              ),
            ),
          ],
        ),
      ),

      // ==========================================
      // FLOATING ACTION BUTTON (KAMERA)
      // ==========================================
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: goldColor,
        shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 4)),
        elevation: 6,
        child: const Icon(Icons.camera_alt, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ==========================================
      // BOTTOM NAVIGATION BAR (Surat Aktif)
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
              _buildBottomNavItem(Icons.home, "Home", false),
              _buildBottomNavItem(Icons.mail, "Surat", true), // STATUS AKTIF DI SINI
              const SizedBox(width: 48), // Ruang kosong untuk kamera
              _buildBottomNavItem(Icons.history, "Aktivitas", false),
              _buildBottomNavItem(Icons.person, "Profil", false),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  // Ikon Bulat Transparan di Header (Back & History)
  Widget _buildTopIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  // Kotak Kategori (Grid)
  Widget _buildCategoryCard(IconData icon, Color iconColor, Color bgColor, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF9FAFB)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textDark)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: textGray, fontSize: 10)),
        ],
      ),
    );
  }

  // Item List "Paling Sering Diakses"
  Widget _buildPopularItem(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Ikon Merah Muda
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: Color(0xFFFEF2F2), shape: BoxShape.circle),
            child: Icon(icon, color: const Color(0xFF991B1B), size: 20),
          ),
          const SizedBox(width: 16),
          // Teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textDark)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: textGray, fontSize: 11)),
              ],
            ),
          ),
          // Panah Kanan
          const Icon(Icons.chevron_right, color: Color(0xFFD1D5DB)),
        ],
      ),
    );
  }

  // Item Bottom Navigation (Berubah jadi pill merah kalau aktif)
  Widget _buildBottomNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isActive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(icon, color: primaryRed, size: 20),
                const SizedBox(width: 4),
                Text(label, style: const TextStyle(color: primaryRed, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        else ...[
          Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 10, fontWeight: FontWeight.w500)),
        ],
      ],
    );
  }
} 
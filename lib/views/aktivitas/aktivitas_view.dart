import 'package:flutter/material.dart';

class AktivitasView extends StatelessWidget {
  const AktivitasView({super.key});

  // Warna Konsisten WARTA
  static const Color primaryRed = Color(0xFF8B0000);
  static const Color primaryRedDark = Color(0xFFB10000); // Merah untuk tombol aktif
  static const Color bgApp = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textGray = Color(0xFF64748B);
  static const Color textLightGray = Color(0xFF94A3B8);
  static const Color goldColor = Color(0xFFD4AF37);
  static const Color borderColor = Color(0xFFF1F5F9);

  // Warna Status
  static const Color colorSuccess = Color(0xFF10B981);
  static const Color bgSuccess = Color(0xFFF0FDF4);
  static const Color colorProcess = Color(0xFF3B82F6);
  static const Color bgProcess = Color(0xFFEFF6FF);
  static const Color colorReject = Color(0xFFEF4444);
  static const Color bgReject = Color(0xFFFEF2F2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgApp,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 1. HEADER MERAH LENGKUNG & FILTER TABS
            // ==========================================
            SizedBox(
              height: 200,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
                    decoration: BoxDecoration(
                      color: primaryRed,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Aktivitas Saya",
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Pantau status pengajuan dan laporan Anda",
                          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),

                  // Filter Tabs (Semua, Menunggu, Selesai) - Menimpa Header
                  Positioned(
                    bottom: 24,
                    left: 24,
                    right: 24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTabButton("Semua", isActive: true),
                        _buildTabButton("Menunggu", isActive: false),
                        _buildTabButton("Selesai", isActive: false),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ==========================================
            // 2. KELOMPOK: HARI INI
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "HARI INI",
                    style: TextStyle(color: textLightGray, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                  ),
                  const SizedBox(height: 16),
                  
                  // Item 1: Verifikasi E-KTP (Berhasil)
                  _buildActivityCard(
                    icon: Icons.check_circle,
                    iconColor: colorSuccess,
                    iconBg: bgSuccess,
                    title: "Verifikasi E-KTP",
                    subtitle: "Identitas Kependudukan Digital",
                    status: "BERHASIL",
                    statusColor: colorSuccess,
                    statusBg: bgSuccess,
                    time: "14:30 WIB",
                    actionText: "LIHAT DETAIL",
                  ),
                  const SizedBox(height: 16),

                  // Item 2: Permohonan SKCK (Proses) dengan indikator tahapan
                  _buildActivityCard(
                    icon: Icons.description,
                    iconColor: colorProcess,
                    iconBg: bgProcess,
                    title: "Permohonan SKCK",
                    subtitle: "Layanan Kepolisian",
                    status: "PROSES",
                    statusColor: colorProcess,
                    statusBg: bgProcess,
                    time: "09:15 WIB",
                    actionText: "LIHAT DETAIL",
                    customContent: _buildProgressIndicator(), // Indikator 1-2-3
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ==========================================
            // 3. KELOMPOK: KEMARIN
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "KEMARIN",
                    style: TextStyle(color: textLightGray, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                  ),
                  const SizedBox(height: 16),
                  
                  // Item 3: Pengajuan KK Baru (Ditolak)
                  _buildActivityCard(
                    icon: Icons.cancel,
                    iconColor: colorReject,
                    iconBg: bgReject,
                    title: "Pengajuan KK Baru",
                    subtitle: "Dokumen Tidak Lengkap",
                    status: "DITOLAK",
                    statusColor: colorReject,
                    statusBg: bgReject,
                    time: "16:45 WIB",
                    actionText: "AJUKAN ULANG",
                    actionColor: goldColor,
                  ),
                  const SizedBox(height: 16),

                  // Item 4: Laporan Jalan Rusak (Selesai/Berhasil)
                  _buildActivityCard(
                    icon: Icons.campaign, // Menggunakan ikon pengeras suara seperti di desain
                    iconColor: const Color(0xFFF97316), // Oranye
                    iconBg: const Color(0xFFFFF7ED),
                    title: "Laporan Jalan Rusak",
                    subtitle: "Pengaduan Masyarakat",
                    status: "SELESAI",
                    statusColor: colorSuccess,
                    statusBg: bgSuccess,
                    time: "10:20 WIB",
                    actionText: "LIHAT TANGGAPAN",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ==========================================
      // FLOATING ACTION BUTTON & BOTTOM NAV
      // ==========================================
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: goldColor,
        shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 4)),
        elevation: 6,
        child: const Icon(Icons.camera_alt, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

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
              _buildBottomNavItem(Icons.mail, "Surat", false),
              const SizedBox(width: 48), // Ruang Kamera
              _buildBottomNavItem(Icons.history, "Aktivitas", true), // TAB AKTIF DI SINI
              _buildBottomNavItem(Icons.person, "Profil", false),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  // Tombol Filter Tab di Header
  Widget _buildTabButton(String label, {required bool isActive}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? primaryRedDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isActive ? null : Border.all(color: borderColor),
          boxShadow: isActive
              ? null
              : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : textDark,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Komponen Kartu Aktivitas Keseluruhan
  Widget _buildActivityCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required String status,
    required Color statusColor,
    required Color statusBg,
    required String time,
    required String actionText,
    Color? actionColor, // Opsional, default merah marun
    Widget? customContent, // Untuk indikator 1-2-3 pada proses SKCK
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ikon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              // Teks Judul & Subjudul
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textDark)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: textGray, fontSize: 12)),
                    if (customContent != null) ...[
                      const SizedBox(height: 12),
                      customContent,
                    ]
                  ],
                ),
              ),
              // Label Status (Kanan Atas)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(4)),
                child: Text(
                  status,
                  style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: bgApp, thickness: 1.5),
          const SizedBox(height: 8),
          // Baris Waktu & Aksi (Kanan Bawah)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(time, style: const TextStyle(color: textLightGray, fontSize: 11, fontWeight: FontWeight.w500)),
              Text(
                actionText,
                style: TextStyle(
                  color: actionColor ?? primaryRed,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget Khusus untuk Tahapan SKCK (Bulatan 1, 2, 3)
  Widget _buildProgressIndicator() {
    return Row(
      children: [
        _buildStepCircle("1", isDone: true),
        const SizedBox(width: 4),
        _buildStepCircle("2", isCurrent: true),
        const SizedBox(width: 4),
        _buildStepCircle("3"),
        const SizedBox(width: 8),
        const Text("Tahap Verifikasi Berkas", style: TextStyle(color: textLightGray, fontSize: 10, fontWeight: FontWeight.w500)),
      ],
    );
  }

  // Lingkaran kecil untuk tahap proses
  Widget _buildStepCircle(String step, {bool isDone = false, bool isCurrent = false}) {
    Color bgColor = const Color(0xFFF1F5F9); // Abu-abu (Default)
    Color textColor = textLightGray;

    if (isDone) {
      bgColor = const Color(0xFFDBEAFE); // Biru muda
      textColor = const Color(0xFF60A5FA);
    } else if (isCurrent) {
      bgColor = const Color(0xFF3B82F6); // Biru tua
      textColor = Colors.white;
    }

    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Text(step, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  // Item Bottom Navigation
  Widget _buildBottomNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isActive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(color: primaryRed.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
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
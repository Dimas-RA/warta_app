import 'package:flutter/material.dart';
import '../../utils/top_notification.dart';

class LaporView extends StatelessWidget {
  const LaporView({super.key});

  // Warna Konsisten WARTA
  static const Color primaryRed = Color(0xFF8B0000);
  static const Color primaryRedDark = Color(0xFF921515); // Warna tombol kirim
  static const Color bgApp = Color(0xFFF8F9FA);
  static const Color textDark = Color(0xFF475569);
  static const Color textGray = Color(0xFF94A3B8);
  static const Color goldColor = Color(0xFFD4AF37);
  static const Color borderColor = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgApp,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 60),
        child: Column(
          children: [
            // ==========================================
            // 1. HEADER MERAH MELENGKUNG & KOTAK KAMERA
            // ==========================================
            SizedBox(
              height: 380, // Tinggi area tumpang tindih
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  // A. Latar Belakang Merah
                  Container(
                    height: 200,
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
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
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Tombol Back
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Teks Header & Sub
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Lapor Kejadian",
                                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Lapor Kejadian tidak sesuai di lingkungan anda",
                                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // B. Kotak Kamera Raksasa (Menimpa Header)
                  Positioned(
                    top: 160,
                    left: 24,
                    right: 24,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Logika buka kamera (CameraX / FR-23)
                      },
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: goldColor, width: 1.5), // Border Emas
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Ikon Kamera Merah + Lingkaran Transparan
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: primaryRed.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(color: primaryRed.withOpacity(0.2)),
                              ),
                              child: const Icon(Icons.camera_alt, color: primaryRed, size: 36),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Ambil Foto Bukti",
                              style: TextStyle(color: primaryRed, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "(Kamera Langsung)",
                              style: TextStyle(color: textGray, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ==========================================
            // 2. FORMULIR INPUT LAPORAN
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Input: Judul Laporan
                  const Text("JUDUL LAPORAN", style: TextStyle(color: textDark, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  const SizedBox(height: 12),
                  TextFormField(
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: "Contoh: Lampu Jalan Padam",
                      hintStyle: const TextStyle(color: textGray, fontSize: 14),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: primaryRed, width: 2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Input: Deskripsi Kejadian (Textarea)
                  const Text("DESKRIPSI KEJADIAN", style: TextStyle(color: textDark, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  const SizedBox(height: 12),
                  TextFormField(
                    maxLines: 5, // Membuatnya jadi kotak besar (Textarea)
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: "Ceritakan detail kejadian secara lengkap...",
                      hintStyle: const TextStyle(color: textGray, fontSize: 14),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: primaryRed, width: 2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Hint Geotagging
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined, color: primaryRed, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Lokasi dan Waktu akan dicatat secara otomatis\n(Geotagging)",
                          style: TextStyle(color: textDark.withOpacity(0.7), fontSize: 11, height: 1.5),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Tombol Kirim Laporan
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRedDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Colors.yellow, width: 1), // Sesuai CSS
                        ),
                        elevation: 5,
                        shadowColor: primaryRedDark.withOpacity(0.4),
                      ),
                      onPressed: () {
                        TopNotification.show(
                          context: context,
                          message: "Laporan kejadian berhasil dikirim!",
                          isSuccess: true,
                        );
                        Future.delayed(const Duration(seconds: 1), () {
                          if (context.mounted) {
                            Navigator.popUntil(context, (route) => route.isFirst);
                          }
                        });
                      },
                      child: const Text(
                        "Kirim Laporan",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
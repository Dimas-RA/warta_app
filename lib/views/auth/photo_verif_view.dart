import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class PhotoVerifView extends StatelessWidget {
  const PhotoVerifView({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi Warna dari CSS Figma
    const Color bgGray = Color(0xFFF9FAFB);
    const Color primaryRed = Color(0xFF8B1E1E); 
    const Color textDark = Color(0xFF0F172A);
    const Color textGray = Color(0xFF64748B);
    const Color goldColor = Color(0xFFD4AF37);
    const Color iconBgLight = Color(0xFFFEE2E2); 

    return Scaffold(
      backgroundColor: bgGray,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HEADER MERAH MELENGKUNG (Konsisten dengan halaman sebelumnya)
            Container(
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: primaryRed,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(400, 80),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.people_alt_rounded, size: 50, color: goldColor),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 2. KONTEN TENGAH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  // Ikon Wajah/Pin Bulat Pink
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: iconBgLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    // Memakai ikon yang mirip dengan desain Figma kamu (Pin + Wajah)
                    child: Icon(Icons.person_pin_circle_rounded, size: 40, color: primaryRed.withOpacity(0.6)),
                  ),
                  const SizedBox(height: 24),

                  // Judul
                  const Text(
                    "Ambil Foto Selfie",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: textDark,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Subjudul/Instruksi
                  const Text(
                    "Lengkapi proses ini dengan mengambil foto wajah Anda. Pastikan wajah terlihat jelas tanpa masker/kacamata hitam.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: textGray,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 3. AREA SCAN SELFIE (Dotted Border Kotak Besar)
                  DottedBorder(
                    color: goldColor,
                    strokeWidth: 2,
                    dashPattern: const [8, 4], 
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(24), // Radius lebih melengkung sesuai Figma
                    child: Container(
                      width: 260, // Lebar lebih kecil dari layar agar membentuk kotak potret
                      height: 245, // Tinggi disesuaikan dengan proporsi muka
                      decoration: BoxDecoration(
                        color: goldColor.withOpacity(0.05), 
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined, size: 45, color: goldColor),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // 4. TOMBOL AMBIL SELFIE 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Colors.yellow, width: 1), 
                    ),
                    elevation: 5,
                    shadowColor: primaryRed.withOpacity(0.5),
                  ),
                  onPressed: () {
                    // TODO: Buka kamera depan
                  },
                  // Memakai ikon kamera depan
                  icon: const Icon(Icons.camera_front, color: Colors.white), 
                  label: const Text(
                    "MULAI AMBIL SELFIE",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
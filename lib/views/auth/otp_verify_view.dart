import 'package:flutter/material.dart';

class OtpVerifyView extends StatelessWidget {
  const OtpVerifyView({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi Warna dari CSS Figma
    const Color bgGray = Color(0xFFF9FAFB);
    const Color primaryRed = Color(0xFF921515); // Mengikuti hex dari CSS OTP
    const Color textDark = Color(0xFF111827);
    const Color textGray = Color(0xFF6B7280);
    const Color goldColor = Color(0xFFEAB308); // Emas terang untuk border OTP
    const Color goldBg = Color(0xFFFEF08A); // Latar ikon gembok

    return Scaffold(
      backgroundColor: bgGray,
      body: SafeArea(
        child: Column(
          children: [
            // 1. HEADER (Tombol Back)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    // TODO: Aksi kembali
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: const Icon(Icons.arrow_back, color: textDark, size: 20),
                  ),
                ),
              ),
            ),

            // 2. KONTEN TENGAH (Ikon & Teks)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Ikon Keamanan / Gembok Emas
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: goldBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock_outline_rounded, size: 40, color: goldColor),
                    ),
                    const SizedBox(height: 32),

                    // Judul
                    const Text(
                      "Verifikasi 2 Langkah",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subjudul
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "Masukkan 6 digit kode OTP yang telah kami kirimkan ke email Anda.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: textGray,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 3. KOTAK INPUT OTP (6 Kotak)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (index) {
                          return Container(
                            width: 44,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: goldColor, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                counterText: "", // Menghilangkan teks "0/1" di bawah
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 4. TEKS KIRIM ULANG KODE
                    GestureDetector(
                      onTap: () {
                        // TODO: Logika kirim ulang OTP
                      },
                      child: const Text(
                        "Kirim ulang kode",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryRed,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 5. TOMBOL VERIFIKASI (Di bagian paling bawah)
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Colors.yellow, width: 1), // Border kuning sesuai CSS
                    ),
                    elevation: 5,
                    shadowColor: primaryRed.withOpacity(0.4),
                  ),
                  onPressed: () {
                    // TODO: Logika Verifikasi OTP
                  },
                  child: const Text(
                    "VERIFIKASI",
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
          ],
        ),
      ),
    );
  }
}
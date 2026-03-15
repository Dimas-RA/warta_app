import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../services/media_service.dart';
import '../../services/ocr_service.dart';
import 'form_register_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  // Warna konsisten WARTA
  static const Color bgGray = Color(0xFFF9FAFB);
  static const Color primaryRed = Color(0xFF8B1E1E);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textGray = Color(0xFF64748B);
  static const Color goldColor = Color(0xFFD4AF37);
  static const Color iconBgLight = Color(0xFFFEE2E2);

  final MediaService _mediaService = MediaService();
  final OcrService _ocrService = OcrService();

  File? _ktpImage;
  bool _isProcessing = false;

  Future<void> _ambilFotoKTP() async {
    // Pilih dari kamera atau galeri
    final source = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            const Text("Pilih Sumber Foto KTP", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context, 'camera'),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(16)),
                        child: const Icon(Icons.camera_alt, color: primaryRed, size: 32),
                      ),
                      const SizedBox(height: 8),
                      const Text("Kamera", style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context, 'gallery'),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(16)),
                        child: const Icon(Icons.photo_library, color: Color(0xFF3B82F6), size: 32),
                      ),
                      const SizedBox(height: 8),
                      const Text("Galeri", style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );

    if (source == null) return;

    File? image;
    if (source == 'camera') {
      image = await _mediaService.pickImageFromCamera();
    } else {
      image = await _mediaService.pickImageFromGallery();
    }

    if (image == null || !mounted) return;

    setState(() {
      _ktpImage = image;
      _isProcessing = true;
    });

    // Jalankan OCR untuk ekstrak teks dari KTP
    final ocrText = await _ocrService.processImage(image);
    
    if (!mounted) return;
    setState(() => _isProcessing = false);

    // Parse data dari teks OCR (sederhana - cari NIK dan Nama)
    final Map<String, String> parsedData = _parseKTPData(ocrText ?? '');

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormRegistView(prefilledData: parsedData),
      ),
    );
  }

  /// Parse basic KTP fields from raw OCR text
  Map<String, String> _parseKTPData(String rawText) {
    final lines = rawText.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
    final data = <String, String>{};

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].toUpperCase();

      // NIK: biasanya 16 digit angka
      final nikMatch = RegExp(r'\b\d{16}\b').firstMatch(lines[i]);
      if (nikMatch != null) data['nik'] = nikMatch.group(0)!;

      // Nama: baris setelah "NAMA"
      if (line.contains('NAMA') && i + 1 < lines.length) {
        final nama = lines[i + 1].replaceAll(RegExp(r'[^a-zA-Z\s]'), '').trim();
        if (nama.length > 3) data['nama'] = nama;
      }

      // Tempat/Tgl Lahir
      if ((line.contains('TEMPAT') || line.contains('LAHIR')) && i + 1 < lines.length) {
        data['ttl'] = lines[i + 1].trim();
      }

      // Alamat
      if (line.contains('ALAMAT') && i + 1 < lines.length) {
        data['alamat'] = lines[i + 1].trim();
      }
    }

    return data;
  }

  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGray,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HEADER MERAH MELENGKUNG
            SizedBox(
              height: 180,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color.fromARGB(255, 83, 0, 0), Color(0xFF8B0000)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 20,
                            top: 20,
                            child: Transform.rotate(
                              angle: 12 * 3.14159 / 180,
                              child: Image(
                                image: const AssetImage('assets/images/warta_logo.png'),
                                width: 140,
                                height: 140,
                                color: const Color.fromARGB(255, 58, 1, 1).withValues(alpha: 0.1),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () => Navigator.pop(context),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Text(
                                    "Scan e-KTP",
                                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
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

            // 2. KONTEN TENGAH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(color: iconBgLight, borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.credit_card, size: 40, color: primaryRed),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    "Foto & Verifikasi e-KTP",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: textDark, letterSpacing: -0.6),
                  ),
                  const SizedBox(height: 12),

                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(fontSize: 14, color: textGray, height: 1.5),
                      children: [
                        TextSpan(text: "Posisikan e-KTP kamu di dalam bingkai agar data bisa terbaca otomatis oleh sistem "),
                        TextSpan(text: "WARTA", style: TextStyle(color: primaryRed, fontWeight: FontWeight.bold)),
                        TextSpan(text: "."),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 3. Area Preview KTP
                  DottedBorder(
                    color: goldColor,
                    strokeWidth: 2,
                    dashPattern: const [8, 4],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    child: Container(
                      width: double.infinity,
                      height: 190,
                      decoration: BoxDecoration(
                        color: goldColor.withValues(alpha: 0.05),
                      ),
                      child: _ktpImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  kIsWeb ? Image.network(_ktpImage!.path, fit: BoxFit.cover) : Image.file(_ktpImage!, fit: BoxFit.cover),
                                  if (_isProcessing)
                                    Container(
                                      color: Colors.black.withValues(alpha: 0.5),
                                      child: const Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(color: Colors.white),
                                          SizedBox(height: 12),
                                          Text("Membaca data KTP...", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt_outlined, size: 30, color: goldColor),
                                SizedBox(height: 8),
                                Text("Area e-KTP", style: TextStyle(color: goldColor, fontSize: 14, fontWeight: FontWeight.w500)),
                                SizedBox(height: 4),
                                Text("Ketuk tombol di bawah untuk memulai", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 4. TOMBOL AMBIL FOTO
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
                    shadowColor: primaryRed.withValues(alpha: 0.5),
                  ),
                  onPressed: _isProcessing ? null : _ambilFotoKTP,
                  icon: const Icon(Icons.camera, color: Colors.white),
                  label: Text(
                    _isProcessing ? "MEMPROSES..." : "AMBIL FOTO KTP",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: 0.8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

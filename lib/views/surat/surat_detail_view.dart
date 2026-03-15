import 'package:flutter/material.dart';
import 'surat_preview_view.dart';

class SuratDetailView extends StatefulWidget {
  final String title;

  const SuratDetailView({super.key, required this.title});

  @override
  State<SuratDetailView> createState() => _SuratDetailViewState();
}

class _SuratDetailViewState extends State<SuratDetailView> {
  static const Color primaryRed = Color(0xFF8B0000);
  static const Color bgApp = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF111827);

  void _ajukanPermohonan() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SuratPreviewView(title: widget.title)),
    );
  }

  // Helper untuk membuat singkatan dinamis
  String _generatePenyelipanSk(String title) {
    if (title.toUpperCase().contains("SURAT KETERANGAN USAHA"))
      return "Surat Keterangan Usaha (SKU)";
    if (title.toUpperCase().contains("TIDAK MAMPU"))
      return "Surat Keterangan Tidak Mampu (SKTM)";
    if (title.toUpperCase().contains("DOMISILI"))
      return "Surat Keterangan Domisili";
    return title;
  }

  // --- KUMPULAN IKON DINAMIS BERDASARKAN JUDUL SURAT ---
  IconData _getIconForTitle(String title) {
    String t = title.toLowerCase();

    // Administrasi
    if (t.contains("ktp") || t.contains("tanda penduduk")) return Icons.badge;
    if (t.contains("kk") || t.contains("keluarga"))
      return Icons.family_restroom;
    if (t.contains("akta kelahiran")) return Icons.child_care;
    if (t.contains("akta kematian")) return Icons.nights_stay;
    if (t.contains("pindah")) return Icons.transfer_within_a_station;

    // Perizinan
    if (t.contains("usaha") || t.contains("situ") || t.contains("sku"))
      return Icons.storefront;
    if (t.contains("bangunan") || t.contains("imb")) return Icons.domain;
    if (t.contains("reklame")) return Icons.campaign;
    if (t.contains("keramaian")) return Icons.festival;

    // Keterangan & Hukum
    if (t.contains("domisili")) return Icons.location_on;
    if (t.contains("tidak mampu") || t.contains("sktm"))
      return Icons.volunteer_activism;
    if (t.contains("skck")) return Icons.local_police;
    if (t.contains("ahli waris")) return Icons.account_balance;
    if (t.contains("menikah") || t.contains("janda") || t.contains("duda"))
      return Icons.favorite_border;
    if (t.contains("tanah")) return Icons.landscape;

    // Default
    return Icons.description;
  }

  // --- KUMPULAN FORM BERDASARKAN JUDUL SURAT ---
  List<Widget> _buildDynamicFormFields() {
    String t = widget.title.toLowerCase();
    List<Widget> fields = [];

    Widget buildField(String label, String hint, {int maxLines = 1}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, color: textDark),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD1D5DB)),
              ),
              child: TextField(
                maxLines: maxLines,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (t.contains("usaha") || t.contains("sku") || t.contains("situ")) {
      fields.add(buildField("Nama Usaha", "Misal: Warung Sembako Berkah"));
      fields.add(buildField("Jenis Usaha", "Misal: Kuliner / Dagang"));
      fields.add(buildField("Alamat Usaha", "Masukkan alamat lengkap usaha", maxLines: 3));
    } else if (t.contains("pindah")) {
      fields.add(buildField("Alamat Tujuan", "Masukkan alamat domisili baru", maxLines: 3));
      fields.add(buildField("Alasan Pindah", "Misal: Mengikuti Keluarga / Pekerjaan"));
    } else if (t.contains("tidak mampu") || t.contains("sktm")) {
      fields.add(buildField("Keperluan / Tujuan", "Misal: Pendaftaran Sekolah Anak"));
      fields.add(buildField("Penghasilan Per Bulan", "Misal: Rp 1.500.000"));
    } else {
      fields.add(buildField("Keperluan", "Jelaskan keperluan pengajuan surat ini", maxLines: 2));
    }

    return fields;
  }

  // --- KUMPULAN SYARAT BERDASARKAN JUDUL SURAT ---
  Widget _buildRequirements() {
    String t = widget.title.toLowerCase();
    List<String> reqs = ["Fotokopi KTP / E-KTP", "Fotokopi Kartu Keluarga (KK)"];

    if (t.contains("usaha") || t.contains("bangunan") || t.contains("reklame")) {
      reqs.add("Foto Tempat Usaha / Objek Lengkap");
      reqs.add("Surat Pengantar RT/RW");
    } else if (t.contains("pindah") || t.contains("domisili")) {
      reqs.add("Surat Pengantar RT/RW");
      reqs.add("Bukti Kepemilikan Lahan / Sewa");
    } else if (t.contains("tidak mampu") || t.contains("sktm")) {
      reqs.add("Surat Pengantar RT/RW");
      reqs.add("Surat Pernyataan Bermaterai");
    } else {
      reqs.add("Surat Pengantar RT/RW");
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Persyaratan Berkas",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 16),
          ...reqs.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text(e, style: const TextStyle(color: textDark, fontSize: 14))),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

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
            // 1. HEADER MERAH MELENGKUNG (GRADASI & WATERMARK)
            // ==========================================
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
                            right: 20,
                            top: 20,
                            child: Transform.rotate(
                              angle: 12 * 3.14159 / 180,
                              child: Image(
                                image: const AssetImage(
                                  'assets/icons/ic_document_after.png',
                                ),
                                width: 140,
                                height: 140,
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () => Navigator.pop(context),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _getIconForTitle(widget.title),
                                    color: primaryRed,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: const Text(
                                    "Pengajuan Surat",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
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

            // --- KONTEN FORMULIR ---
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Surat Bold Tebal
                  Center(
                    child: Text(
                      _generatePenyelipanSk(widget.title),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Kotak Persyaratan Berkas Dinamis
                  _buildRequirements(),
                  
                  const SizedBox(height: 32),

                  // Label Kategori Form
                  const Text(
                    "Preview Format Dokumen",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Kotak Kartu Preview Placeholder
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.feed_outlined,
                          size: 48,
                          color: Color(0xFFD1D5DB),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Template_${widget.title.replaceAll(' ', '_')}.pdf",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  // Label Lengkapi Data
                  const Text(
                    "Lengkapi Data Berikut",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Notifikasi Biru
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Data profil Anda akan diisi otomatis oleh sistem. Silakan lengkapi data spesifik yang masih kosong.",
                      style: TextStyle(
                        color: Color(0xFF1D4ED8),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  
                  // Form Text Field Dinamis
                  ..._buildDynamicFormFields(),
                  
                  const SizedBox(height: 48),

                  // Tombol Ajukan Surat
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _ajukanPermohonan,
                      child: const Text(
                        "Lihat Preview",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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

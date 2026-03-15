import 'package:flutter/material.dart';
import 'surat_detail_view.dart';

class SuratCategoryView extends StatelessWidget {
  final String categoryName;

  const SuratCategoryView({super.key, required this.categoryName});

  // Data Surat Mock up berdasarkan Kategori
  static const Map<String, List<Map<String, String>>> suratMockData = {
    "Administrasi": [
      {"title": "Kartu Keluarga (KK)", "desc": "Pembuatan atau Perubahan KK"},
      {
        "title": "Kartu Tanda Penduduk (KTP)",
        "desc": "Perekaman atau Penggantian KTP Baru",
      },
      {"title": "Akta Kelahiran", "desc": "Penerbitan Surat Keterangan Lahir"},
      {"title": "Akta Kematian", "desc": "Pelaporan Meninggal Dunia"},
      {"title": "Surat Pindah", "desc": "Mengurus Perpindahan Domisili"},
    ],
    "Perizinan": [
      {
        "title": "Surat Izin Tempat Usaha (SITU)",
        "desc": "Pendaftaran Lokasi Usaha",
      },
      {
        "title": "Izin Mendirikan Bangunan (IMB)",
        "desc": "Persetujuan Pendirian Bangunan",
      },
      {"title": "Izin Reklame", "desc": "Pemasangan Papan Reklame/Spanduk"},
      {"title": "Izin Keramaian", "desc": "Pemberitahuan Acara Skala Besar"},
    ],
    "Keterangan": [
      {
        "title": "Surat Keterangan Domisili",
        "desc": "Bukti Tempat Tinggal Sementara",
      },
      {
        "title": "Keterangan Tidak Mampu (SKTM)",
        "desc": "Pengajuan Keringanan Biaya",
      },
      {
        "title": "Surat Keterangan Usaha (SKU)",
        "desc": "Pernyataan Memiliki Usaha",
      },
      {
        "title": "Pengantar SKCK",
        "desc": "Syarat Pembuatan Catatan Kepolisian",
      },
    ],
    "Hukum": [
      {
        "title": "Keterangan Ahli Waris",
        "desc": "Pernyataan Silsilah Keluarga",
      },
      {"title": "Keterangan Belum Menikah", "desc": "Status Perkawinan Lajang"},
      {
        "title": "Keterangan Janda/Duda",
        "desc": "Pernyataan Status Cerai Mati/Hidup",
      },
      {"title": "Surat Kuasa Tanah", "desc": "Pelimpahan Wewenang Properti"},
    ],
  };

  @override
  Widget build(BuildContext context) {
    // Definisi Warna dari CSS Figma
    const Color bgGray = Color(0xFFF9FAFB);
    const Color textDark = Color(0xFF111827);
    const Color textGray = Color(0xFF6B7280);

    // Ambil list surat berdasarkan kategori yang dipilih
    List<Map<String, String>> suratList = suratMockData[categoryName] ?? [];

    return Scaffold(
      backgroundColor: bgGray,
      body: Column(
        children: [
          // 1. HEADER MERAH MELENGKUNG (Sama persis dengan komponen lain)
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
                                'assets/images/warta_logo.png',
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
                                    color: Colors.white.withValues(alpha: 0.2),
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
                              Expanded(
                                child: Text(
                                  "Kategori: $categoryName",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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

          // 2. DAFTAR SURAT (List View Dinamis)
          Expanded(
            child: suratList.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada surat di kategori ini.",
                      style: TextStyle(color: textGray, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: suratList.length,
                    itemBuilder: (context, index) {
                      var data = suratList[index];
                      // Menentukan Ikon berdasakan kategori
                      IconData categoryIcon = Icons.document_scanner;
                      if (categoryName == "Administrasi")
                        categoryIcon = Icons.description;
                      if (categoryName == "Perizinan")
                        categoryIcon = Icons.domain;
                      if (categoryName == "Keterangan")
                        categoryIcon = Icons.volunteer_activism;
                      if (categoryName == "Hukum") categoryIcon = Icons.gavel;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SuratDetailView(
                                  title: data['title'] ?? 'Surat',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFF3F4F6),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Ikon Kiri
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFEF2F2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    categoryIcon,
                                    color: const Color(0xFF991B1B),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Text Tengah
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['title'] ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: textDark,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        data['desc'] ?? '',
                                        style: const TextStyle(
                                          color: textGray,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Panah Kanan
                                const Icon(
                                  Icons.chevron_right,
                                  color: Color(0xFFD1D5DB),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

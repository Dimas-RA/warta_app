import 'dart:ui';
import 'package:flutter/material.dart';
import '../report/lapor_view.dart';
import '../darurat/darurat_view.dart';
import '../berita/berita_view.dart';
import '../berita/berita_detail_view.dart';
import '../../utils/top_notification.dart';
import '../aktivitas/aktivitas_detail_view.dart';
import '../../models/berita_model.dart';
import '../../services/berita_service.dart';
import '../../services/berita_api_service.dart';
import '../../models/aktivitas_model.dart';
import '../../services/aktivitas_service.dart';

class HomeView extends StatefulWidget {
  final Function(int) onNavigate;
  const HomeView({super.key, required this.onNavigate});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _hasNotification = false;

  // Warna sesuai CSS Figma
  static const Color primaryRed = Color(0xFF8B0000);
  static const Color bgGray = Color(0xFFF9FAFB);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textGray = Color(0xFF6B7280);
  static const Color goldColor = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGray,

      // ==========================================
      // KONTEN UTAMA (BODY)
      // ==========================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          bottom: 40,
        ), // Jarak agar tidak tertutup nav bar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 1. HEADER (GRADASI & WATERMARK)
            // ==========================================
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 83, 0, 0), Color(0xFF8B0000)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
              ),
              // Gunakan ClipRRect agar ikon rumah yang melayang tetap terpotong rapi mengikuti lengkungan merah
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Transform.rotate(
                        angle: 12 * 3.14159 / 180,
                        child: Image(
                          image: const AssetImage(
                            'assets/icons/ic_home_after.png',
                          ),
                          width:
                              180, // Ukuran diperbesar sedikit agar lebih gagah
                          height: 180,
                          color: const Color.fromARGB(255, 58, 1, 1)
                              .withOpacity(
                                0.1,
                              ), // Opacity halus agar tidak menabrak teks
                        ),
                      ),
                    ),

                    // --- Konten Utama ---
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Teks Sapaan & Ikon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Selamat Pagi,",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Text(
                                    "Budi Setiawan",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _hasNotification = !_hasNotification;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: _buildTopIcon(_hasNotification ? Icons.notifications_active : Icons.notifications_none),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () {
                                      _showSearchBottomSheet(context);
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: _buildTopIcon(Icons.search),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // --- Card Status Identitas ---
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                24,
                              ), // Disamakan dengan radius umum
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Kotak Fingerprint (Revisi Border)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFFDF7E7,
                                    ), // Warna emas pudar
                                    // REVISI: BorderRadius disamakan biar tidak kaku
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.fingerprint,
                                    color: Color(0xFFD4AF37),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "STATUS IDENTITAS",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Terverifikasi (E-KTP)",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Tombol Lihat QR
                                GestureDetector(
                                  onTap: () {
                                    _showQrDialog(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF8B0000),
                                      borderRadius: BorderRadius.circular(
                                        12,
                                      ), // Radius disesuaikan
                                    ),
                                    child: const Text(
                                      "LIHAT QR",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
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
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 2. LAYANAN DIGITAL (Menu Grid)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Layanan Digital",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          TopNotification.show(
                            context: context,
                            message: "Menampilkan semua layanan...",
                          );
                        },
                        child: Text(
                          "Lihat Semua",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: primaryRed.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => widget.onNavigate(4), // Profil
                          borderRadius: BorderRadius.circular(16),
                          child: _buildMenuBtn(Icons.badge, "Digital ID"),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LaporView()),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: _buildMenuBtn(Icons.campaign, "Pengaduan"),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const BeritaView()),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: _buildMenuBtn(Icons.article, "Berita"),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const DaruratView()),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: _buildMenuBtn(Icons.warning_amber_rounded, "Darurat"),
                        ),
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
                      const Text(
                        "Aktivitas Terakhir",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      InkWell(
                        onTap: () => widget.onNavigate(3), // Aktivitas
                        child: Text(
                          "Riwayat",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: primaryRed.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: FutureBuilder<List<AktivitasModel>>(
                      future: AktivitasService().getRecentAktivitas(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: primaryRed));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("Belum ada aktivitas."));
                        }

                        final items = snapshot.data!;
                        return Column(
                          children: items.asMap().entries.map((entry) {
                            int idx = entry.key;
                            AktivitasModel item = entry.value;
                            
                            return Column(
                              children: [
                                _buildActivityItem(
                                  context,
                                  IconData(item.iconCodePoint, fontFamily: item.iconFontFamily),
                                  item.iconColor,
                                  item.iconBgColor,
                                  item.title,
                                  item.subtitle,
                                  item.date,
                                  item.status,
                                  item.statusTextColor,
                                  item.statusBgColor,
                                ),
                                if (idx < items.length - 1)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Divider(color: bgGray, thickness: 1.5),
                                  ),
                              ],
                            );
                          }).toList(),
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 4. BANNER INFORMASI PUBLIK
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FutureBuilder<BeritaModel?>(
                future: BeritaApiService().getLatestHeadline().then((v) async {
                  // If API returns null, fallback to dummy
                  return v ?? await BeritaService().getLatestHeadline();
                }),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(child: CircularProgressIndicator(color: primaryRed)),
                    );
                  }
                  if (!snapshot.hasData) return const SizedBox();
                  
                  final berita = snapshot.data!;
                  // Determine background: use imageUrl from API or fallback to local asset
                  final ImageProvider bgImage = (berita.imageUrl != null && berita.imageUrl!.isNotEmpty)
                      ? NetworkImage(berita.imageUrl!) as ImageProvider
                      : AssetImage(berita.imagePath);
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => BeritaDetailView(berita: berita)),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: primaryRed, // Warna dasar merah
                        borderRadius: BorderRadius.circular(16),
                        // PERUBAHAN: Background efek kota transparan
                        image: DecorationImage(
                          image: bgImage,
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            primaryRed.withOpacity(0.3),
                            BlendMode.dstATop,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            berita.category,
                            style: const TextStyle(
                              color: goldColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            berita.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ),
            ),
          ],
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

  // Tombol Menu Layanan Digital (PERUBAHAN: Diperbesar ukurannya)
  Widget _buildMenuBtn(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 64, // Diperbesar dari 56 agar tidak kelihatan renggang
          height: 64, // Diperbesar dari 56
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18), // Melengkung lebih halus
            border: Border.all(color: const Color(0xFFF3F4F6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: primaryRed,
            size: 28,
          ), // Ikon juga diperbesar
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: textGray,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // Item List Aktivitas
  Widget _buildActivityItem(
    BuildContext context,
    IconData icon,
    Color iconColor,
    Color iconBg,
    String title,
    String subtitle,
    String time,
    String status,
    Color statusColor,
    Color statusBg,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AktivitasDetailView(
              title: title,
              subtitle: subtitle,
              status: status,
              time: time,
            ),
          ),
        );
      },
      child: Row(
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
                Text(
                  title,
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(color: textGray, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    );
  }

  void _showSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Pencarian",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                onSubmitted: (value) {
                  Navigator.pop(context); // close bottom sheet
                  TopNotification.show(
                    context: context,
                    message: "Mendaftar pencarian: $value",
                    isSuccess: true,
                  );
                },
                decoration: InputDecoration(
                  hintText: "Cari layanan, berita, dll...",
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF8B0000)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  void _showQrDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Digital ID QR",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Pindai kode QR ini untuk verifikasi identitas fisik.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.qr_code_2,
                      size: 160,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B0000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Tutup",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

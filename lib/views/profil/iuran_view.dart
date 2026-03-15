import 'package:flutter/material.dart';
import '../../models/profil_model.dart';
import '../../services/profil_service.dart';
import '../../utils/top_notification.dart';

class IuranView extends StatelessWidget {
  const IuranView({super.key});

  static const Color primaryRed = Color(0xFF8B0000);
  static const Color bgApp = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textGray = Color(0xFF64748B);
  static const Color goldColor = Color(0xFFD4AF37);

  String _formatRupiah(int nominal) {
    String str = nominal.toString();
    String result = "";
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      result = str[i] + result;
      count++;
      if (count % 3 == 0 && i != 0) {
        result = ".$result";
      }
    }
    return "Rp $result";
  }

  String _formatDate(DateTime date) {
    const List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgApp,
      body: FutureBuilder<List<IuranModel>>(
        future: KeuanganService().getRiwayatIuran(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: primaryRed));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data iuran."));
          }
          
          final iuranList = snapshot.data!;
          final tagihanBelumBayar = iuranList.where((i) => i.status == "BELUM DIBAYAR").toList();
          final riwayatLunas = iuranList.where((i) => i.status == "LUNAS").toList();
          
          return SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 60),
        child: Column(
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
                        colors: [Color.fromARGB(255, 83, 0, 0), Color(0xFF8B0000)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
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
                                image: const AssetImage('assets/icons/ic_document_after.png'),
                                width: 140,
                                height: 140,
                                color: const Color.fromARGB(255, 58, 1, 1).withOpacity(0.1),
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
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Text(
                                    "Iuran Warga",
                                    style: TextStyle(
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
            
            // --- KONTEN DETAIL ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tagihan Bulan Ini",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textGray,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (tagihanBelumBayar.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Iuran Kebersihan & Keamanan",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: textDark,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  tagihanBelumBayar.first.status,
                                  style: const TextStyle(
                                    color: primaryRed,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Periode: ${tagihanBelumBayar.first.bulan} ${tagihanBelumBayar.first.tahun}",
                            style: const TextStyle(color: textGray, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatRupiah(tagihanBelumBayar.first.nominal),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryRed,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryRed,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                TopNotification.show(
                                  context: context,
                                  message: "Sedang mengalihkan ke Payment Gateway...",
                                  isSuccess: true,
                                );
                              },
                              child: const Text("Bayar Sekarang", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("Tidak ada tagihan bulan ini", style: TextStyle(color: textGray)),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  const Text(
                    "Riwayat Pembayaran",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textGray,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (riwayatLunas.isEmpty)
                    const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text("Belum ada riwayat pembayaran", style: TextStyle(color: textGray))))
                  else
                    ...riwayatLunas.map((iuran) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildRiwayatCard(
                          "${iuran.bulan} ${iuran.tahun}",
                          iuran.tanggalBayar != null ? _formatDate(iuran.tanggalBayar!) : "-",
                          iuran.status,
                          iuran.nominal,
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ],
        ),
      );
        },
      ),
    );
  }

  Widget _buildRiwayatCard(String bulan, String tanggal, String status, int nominal) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Iuran $bulan",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: textDark, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tanggal,
                    style: const TextStyle(color: textGray, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          Text(
            _formatRupiah(nominal),
            style: const TextStyle(fontWeight: FontWeight.bold, color: textDark, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

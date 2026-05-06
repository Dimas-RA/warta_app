import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../models/report_model.dart';
import '../../services/report_service.dart';

class RwApprovalView extends StatelessWidget {
  const RwApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: const Color(0xFF6A1B9A),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'Verifikasi & Laporan',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'Laporan Masuk'),
              Tab(text: 'Surat Keterangan'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _TabLaporanMasuk(),
            _TabSuratKeterangan(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TAB 1 — Laporan Masuk dari RT
// ─────────────────────────────────────────────

class _TabLaporanMasuk extends StatefulWidget {
  const _TabLaporanMasuk();

  @override
  State<_TabLaporanMasuk> createState() => _TabLaporanMasukState();
}

class _TabLaporanMasukState extends State<_TabLaporanMasuk> {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color accentPurple = Color(0xFFAB47BC);

  final ReportService _reportService = ReportService();

  String _formatTime(DateTime? value) {
    if (value == null) return 'Baru';
    final diff = DateTime.now().difference(value);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inHours < 1) return '${diff.inMinutes} mnt lalu';
    if (diff.inDays < 1) return '${diff.inHours} jam lalu';
    return '${diff.inDays} hari lalu';
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryPurple),
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Tutup', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authVM, _) {
        final user = authVM.currentUser;
        final rw = user?.rw ?? '';

        if (rw.isEmpty) {
          return const Center(child: Text('Data RW akun belum tersedia.'));
        }

        return StreamBuilder<List<ReportModel>>(
          stream: _reportService.streamReportsForRw(rw: rw),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: primaryPurple),
              );
            }

            final reports = snap.data ?? [];
            if (reports.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    const Text(
                      'Belum ada laporan yang\nditeruskan dari RT.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: primaryPurple.withValues(alpha: 0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header laporan
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(Icons.report_problem_outlined, color: primaryPurple, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      report.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF1F2937),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              _formatTime(report.createdAt),
                              style: const TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Badge RT pengirim
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: accentPurple.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Dari RT ${report.reporterRt}  ·  ${report.reporterName}',
                            style: const TextStyle(
                              color: primaryPurple,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Deskripsi
                        Text(
                          report.description,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF374151),
                            height: 1.4,
                          ),
                        ),

                        // Foto laporan
                        if (report.imageUrl != null && report.imageUrl!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () => _showImageDialog(context, report.imageUrl!),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                report.imageUrl!,
                                height: 140,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 12),

                        // Tombol aksi
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  await _reportService.resolveReport(report.id);
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Laporan ditandai selesai.'),
                                      backgroundColor: Color(0xFF2E7D32),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.check_circle_outline, size: 16),
                                label: const Text('Selesai'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF2E7D32),
                                  side: const BorderSide(color: Color(0xFF2E7D32)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  await _reportService.forwardReportToLurah(report.id);
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Laporan diteruskan ke Lurah.'),
                                      backgroundColor: Color(0xFF6A1B9A),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.upload_outlined, size: 16),
                                label: const Text('Ke Lurah', style: TextStyle(fontSize: 12)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryPurple,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// TAB 2 — Surat Keterangan RW
// ─────────────────────────────────────────────

class _TabSuratKeterangan extends StatelessWidget {
  const _TabSuratKeterangan();

  static const Color primaryPurple = Color(0xFF6A1B9A);

  void _showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label — Segera hadir!'),
        backgroundColor: primaryPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const dummySurat = [
      _SuratItem(jenis: 'Surat Keterangan Domisili', pemohon: 'Ahmad Fauzan', nik: '3201xxxxxxx', tanggal: '28 Apr 2026'),
      _SuratItem(jenis: 'Surat Keterangan Tidak Mampu', pemohon: 'Siti Rahayu', nik: '3201xxxxxxx', tanggal: '27 Apr 2026'),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dummySurat.length,
      itemBuilder: (context, i) {
        final surat = dummySurat[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: primaryPurple.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.description_outlined, color: primaryPurple, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          surat.jenis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Menunggu',
                        style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Pemohon: ${surat.pemohon}',
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF374151), fontSize: 13),
                ),
                Text(
                  'NIK: ${surat.nik}  ·  ${surat.tanggal}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showComingSoon(context, 'Tanda Tangani'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPurple,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Tanda Tangani', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showComingSoon(context, 'Tolak'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Tolak'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SuratItem {
  final String jenis;
  final String pemohon;
  final String nik;
  final String tanggal;
  const _SuratItem({
    required this.jenis,
    required this.pemohon,
    required this.nik,
    required this.tanggal,
  });
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../models/report_model.dart';
import '../../services/report_service.dart';
import '../../services/darurat_service.dart';
import '../../models/darurat_model.dart';
import '../darurat/darurat_rt_action_view.dart';

class RwHomeView extends StatefulWidget {
  final Function(int) onNavigate;
  const RwHomeView({super.key, required this.onNavigate});

  @override
  State<RwHomeView> createState() => _RwHomeViewState();
}

class _RwHomeViewState extends State<RwHomeView> {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color accentPurple = Color(0xFFAB47BC);
  static const Color bgGray = Color(0xFFF9FAFB);
  static const Color textDark = Color(0xFF1F2937);
  static const Color goldColor = Color(0xFFD4AF37);

  final ReportService _reportService = ReportService();

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi,';
    if (hour < 15) return 'Selamat Siang,';
    if (hour < 18) return 'Selamat Sore,';
    return 'Selamat Malam,';
  }

  String _formatTime(DateTime? value) {
    if (value == null) return 'Baru';
    final diff = DateTime.now().difference(value);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inHours < 1) return '${diff.inMinutes} mnt lalu';
    if (diff.inDays < 1) return '${diff.inHours} jam lalu';
    return '${diff.inDays} hari lalu';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGray,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BANNER DARURAT (untuk semua RT di bawah RW) ---
            Consumer<AuthViewModel>(
              builder: (context, authVM, _) {
                final String rwId = authVM.currentUser?.rw ?? '';
                final String rtId = authVM.currentUser?.rt ?? '';
                if (rwId.isEmpty || rtId.isEmpty) return const SizedBox.shrink();

                return StreamBuilder<List<EmergencySignalModel>>(
                  stream: DaruratService().streamActiveEmergencies(rtId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    final emergency = snapshot.data!.first;
                    return GestureDetector(
                      onTap: () => DaruratActionModal.show(context, emergency),
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: MediaQuery.of(context).padding.top + 10,
                          bottom: 10,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE53935), Color(0xFFC62828)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD32F2F).withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '🚨 DARURAT (TRACE)',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${emergency.namaWarga} menekan tombol bahaya!',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.95),
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Ketuk untuk rincian & tindakan',
                                    style: TextStyle(
                                      color: Color(0xFFFFD54F),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.white70),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // --- HEADER MELENGKUNG ---
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4A148C), Color(0xFF6A1B9A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x196A1B9A),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20,
                          top: -20,
                          child: Transform.rotate(
                            angle: 12 * 3.14159 / 180,
                            child: Image(
                              image: const AssetImage('assets/images/warta_logo.png'),
                              width: 180,
                              height: 180,
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getGreeting(),
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.7),
                                          fontSize: 14,
                                        ),
                                      ),
                                      Consumer<AuthViewModel>(
                                        builder: (context, authVM, _) {
                                          final name = authVM.currentUser?.nama ?? 'Ketua RW';
                                          return Text(
                                            name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: goldColor,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.2),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      'PENGURUS RW',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Info laporan cepat
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                                ),
                                child: Consumer<AuthViewModel>(
                                  builder: (context, authVM, _) {
                                    final rw = authVM.currentUser?.rw ?? '';
                                    if (rw.isEmpty) {
                                      return const Row(
                                        children: [
                                          Icon(Icons.info_outline, color: Colors.white70, size: 18),
                                          SizedBox(width: 8),
                                          Text(
                                            'Data RW belum tersedia.',
                                            style: TextStyle(color: Colors.white70, fontSize: 12),
                                          ),
                                        ],
                                      );
                                    }
                                    return StreamBuilder<List<ReportModel>>(
                                      stream: _reportService.streamReportsForRw(rw: rw),
                                      builder: (context, snap) {
                                        final count = snap.data?.length ?? 0;
                                        return Row(
                                          children: [
                                            const Icon(Icons.mark_email_unread_outlined, color: Colors.white, size: 20),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                count == 0
                                                    ? 'Tidak ada laporan baru dari RT saat ini.'
                                                    : 'Terdapat $count laporan dari RT yang memerlukan tindak lanjut Anda.',
                                                style: const TextStyle(color: Colors.white, fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // QUICK ACTION BOX
                Positioned(
                  bottom: -40,
                  left: 24,
                  right: 24,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildQuickAction(
                          Icons.inbox_outlined, accentPurple,
                          accentPurple.withValues(alpha: 0.1),
                          'Laporan', () => widget.onNavigate(2),
                        ),
                        _buildQuickAction(
                          Icons.description_outlined, Colors.orange,
                          Colors.orange.withValues(alpha: 0.1),
                          'Surat', () => widget.onNavigate(2),
                        ),
                        _buildQuickAction(
                          Icons.groups_outlined, Colors.blue,
                          Colors.blue.withValues(alpha: 0.1),
                          'Koordinasi', () => widget.onNavigate(1),
                        ),
                        _buildQuickAction(
                          Icons.person_outline, Colors.green,
                          Colors.green.withValues(alpha: 0.1),
                          'Profil', () => widget.onNavigate(3),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 60),

            // --- DAFTAR LAPORAN TERBARU ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Laporan Terbaru dari RT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      TextButton(
                        onPressed: () => widget.onNavigate(2),
                        child: const Text(
                          'Lihat Semua',
                          style: TextStyle(color: primaryPurple, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Consumer<AuthViewModel>(
                    builder: (context, authVM, _) {
                      final rw = authVM.currentUser?.rw ?? '';
                      if (rw.isEmpty) {
                        return const Text('Data RW belum tersedia.', style: TextStyle(color: Colors.grey));
                      }
                      return StreamBuilder<List<ReportModel>>(
                        stream: _reportService.streamReportsForRw(rw: rw),
                        builder: (context, snap) {
                          if (snap.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator(color: primaryPurple, strokeWidth: 2));
                          }
                          final reports = snap.data ?? [];
                          if (reports.isEmpty) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Column(
                                children: [
                                  Icon(Icons.inbox_outlined, size: 40, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text(
                                    'Belum ada laporan masuk dari RT.',
                                    style: TextStyle(color: Colors.grey, fontSize: 13),
                                  ),
                                ],
                              ),
                            );
                          }
                          final preview = reports.take(3).toList();
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: preview.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, i) {
                              final report = preview[i];
                              return InkWell(
                                onTap: () => widget.onNavigate(2),
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.02),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: accentPurple.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(Icons.report_problem_outlined, color: primaryPurple, size: 22),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              report.title,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: textDark,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'RT ${report.reporterRt} · ${_formatTime(report.createdAt)}',
                                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right, color: Colors.grey),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    IconData icon, Color iconColor, Color bgColor, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: textDark, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

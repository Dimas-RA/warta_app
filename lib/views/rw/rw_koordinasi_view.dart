import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../models/user_model.dart';

class RwKoordinasiView extends StatefulWidget {
  const RwKoordinasiView({super.key});

  @override
  State<RwKoordinasiView> createState() => _RwKoordinasiViewState();
}

class _RwKoordinasiViewState extends State<RwKoordinasiView> {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color accentPurple = Color(0xFFAB47BC);
  static const Color bgGray = Color(0xFFF9FAFB);
  static const Color textDark = Color(0xFF1F2937);

  Stream<List<UserModel>> _streamKetuaRT(String rw) {
    if (rw.isEmpty) return Stream.value([]);
    return FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'rt')
        .where('rw', isEqualTo: rw)
        .where('status', isEqualTo: 'aktif')
        .snapshots()
        .map((snap) => snap.docs.map(UserModel.fromFirestore).toList());
  }

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
    final user = context.watch<AuthViewModel>().currentUser;
    final rw = user?.rw ?? '';

    return Scaffold(
      backgroundColor: bgGray,
      appBar: AppBar(
        backgroundColor: primaryPurple,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Koordinasi RT',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Kirim Pengumuman ke Semua RT',
            icon: const Icon(Icons.campaign_outlined, color: Colors.white),
            onPressed: () => _showComingSoon(context, 'Pengumuman'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Info RW Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            decoration: BoxDecoration(
              color: primaryPurple,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.location_city_rounded, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RW ${user?.rw ?? '-'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${user?.kelurahan ?? '-'}, ${user?.kecamatan ?? '-'}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Daftar Ketua RT
          Expanded(
            child: rw.isEmpty
                ? const Center(
                    child: Text(
                      'Data RW pada akun belum tersedia.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : StreamBuilder<List<UserModel>>(
                    stream: _streamKetuaRT(rw),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: primaryPurple),
                        );
                      }
                      final list = snap.data ?? [];
                      if (list.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.groups_outlined, size: 56, color: Colors.grey.shade300),
                              const SizedBox(height: 12),
                              const Text(
                                'Belum ada data Ketua RT\ndi bawah RW ini.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final rt = list[i];
                          return Container(
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
                              child: Row(
                                children: [
                                  // Avatar
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: accentPurple.withValues(alpha: 0.12),
                                    ),
                                    child: rt.selfieUrl != null && rt.selfieUrl!.isNotEmpty
                                        ? ClipOval(
                                            child: Image.network(
                                              rt.selfieUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  const Icon(Icons.person, color: primaryPurple, size: 28),
                                            ),
                                          )
                                        : const Icon(Icons.person, color: primaryPurple, size: 28),
                                  ),
                                  const SizedBox(width: 14),

                                  // Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          rt.nama,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: textDark,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: primaryPurple.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                'RT ${rt.rt ?? '-'}',
                                                style: const TextStyle(
                                                  color: primaryPurple,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            if (rt.nomorTelepon != null && rt.nomorTelepon!.isNotEmpty)
                                              Text(
                                                rt.nomorTelepon!,
                                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Tombol hubungi
                                  IconButton(
                                    onPressed: () => _showComingSoon(context, 'Hubungi ${rt.nama}'),
                                    icon: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: accentPurple.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.message_outlined, color: primaryPurple, size: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

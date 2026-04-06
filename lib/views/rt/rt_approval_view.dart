import 'package:flutter/material.dart';

class RtApprovalView extends StatelessWidget {
  const RtApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryRed = Color(0xFF8B0000);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: primaryRed, // Disesuaikan dengan WARTA (Merah)
          elevation: 0,
          title: const Text(
            "Verifikasi Berkas",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(text: "Surat Pengantar"),
              Tab(text: "Laporan Warga"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _TabSuratPengantar(),
            _TabLaporanWarga(),
          ],
        ),
      ),
    );
  }
}

class _TabSuratPengantar extends StatelessWidget {
  const _TabSuratPengantar();

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Aksi verifikasi surat segera hadir di iterasi berikutnya."),
        backgroundColor: Color(0xFF8B0000),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            onTap: () => _showComingSoon(context),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.mark_email_unread_outlined, color: Color(0xFF8B0000), size: 20),
                          const SizedBox(width: 8),
                          Text(
                            index == 0 ? "Surat SKU" : "Surat Domisili",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1F2937)),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Menunggu",
                          style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text("Pemohon: Agus Santoso\nNIK: 3201xxxxxxx", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showComingSoon(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B0000),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          child: const Text("Tanda Tangani", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showComingSoon(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text("Tolak"),
                        ),
                      ),
                    ],
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

class _TabLaporanWarga extends StatelessWidget {
  const _TabLaporanWarga();

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Aksi tinjauan laporan segera terhubung di iterasi berikutnya."),
        backgroundColor: Color(0xFF8B0000),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            onTap: () => _showComingSoon(context),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.report_problem_outlined, color: Color(0xFF8B0000), size: 18),
                          SizedBox(width: 8),
                          Text(
                            "Infrastruktur Rusak",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF8B0000)),
                          ),
                        ],
                      ),
                      const Text(
                        "Hari Ini, 10:00",
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Lampu jalan di depan pos ronda utama mati. Gelap sekali membahayakan warga.",
                    style: TextStyle(fontSize: 13, color: Color(0xFF1F2937)),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Icon(Icons.person, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text("Pelapor: Dimas (Blok C1)", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showComingSoon(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFD4AF37), // Emas
                            side: const BorderSide(color: Color(0xFFD4AF37)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text("Tinjau"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showComingSoon(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B0000), // Merah
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          child: const Text("Forward ke RW", style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ),
                    ],
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

import 'package:flutter/material.dart';

class RtManajemenView extends StatelessWidget {
  const RtManajemenView({super.key});

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
            "Manajemen Pengurus",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(text: "Iuran Warga"),
              Tab(text: "Jadwal Ronda"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _TabIuranWarga(),
            _TabJadwalRonda(),
          ],
        ),
      ),
    );
  }
}

class _TabIuranWarga extends StatelessWidget {
  const _TabIuranWarga();

  void _showComingSoon(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF8B0000),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("Bulan Ini: LUNAS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        const SizedBox(height: 8),
        _buildWargaCard(context, "Bapak Joko", "Blok A1", true),
        _buildWargaCard(context, "Ibu Yani", "Blok B2", true),
        const SizedBox(height: 24),
        const Text("Bulan Ini: BELUM BAYAR", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
        const SizedBox(height: 8),
        _buildWargaCard(context, "Bapak Budi", "Blok C4", false),
        _buildWargaCard(context, "Pemuda Anton", "Blok A3", false),
      ],
    );
  }

  Widget _buildWargaCard(BuildContext context, String nama, String alamat, bool isLunas) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showComingSoon(context, "Detail Iuran $nama segera hadir."),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isLunas ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isLunas ? Icons.check_circle_outline : Icons.error_outline,
                  color: isLunas ? Colors.green : Colors.red,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nama, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(alamat, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              isLunas
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text("Lunas", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 10)),
                    )
                  : ElevatedButton(
                      onPressed: () => _showComingSoon(context, "Fitur Penagihan Segera Hadir."),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFEF2F2),
                        foregroundColor: const Color(0xFF8B0000),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Tagih", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabJadwalRonda extends StatelessWidget {
  const _TabJadwalRonda();

  void _showComingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Aksi detail $title belum tersedia di iterasi ini."),
        backgroundColor: const Color(0xFF8B0000),
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
        final isToday = index == 0;
        final title = isToday ? "Hari Ini (Jumat Malam)" : "Besok (Sabtu Malam)";

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            onTap: () => _showComingSoon(context, "Jadwal Ronda"),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isToday ? const Color(0xFF8B0000) : const Color(0xFF1F2937)),
                      ),
                      Icon(Icons.shield_outlined, color: isToday ? const Color(0xFF8B0000) : Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Icon(Icons.groups, size: 16, color: Colors.grey),
                      SizedBox(width: 8),
                      Text("Regu 1: Pak Anton, Pak Budi, Mas Dimas", style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _showComingSoon(context, "Atur Ulang Jadwal"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF8B0000),
                        side: const BorderSide(color: Color(0xFF8B0000)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Atur Ulang Jadwal", style: TextStyle(fontWeight: FontWeight.bold)),
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

import 'package:flutter/material.dart';
import '../../viewmodels/main_viewmodel.dart';
import '../home/home_view.dart';
import '../surat/surat_view.dart';
import '../aktivitas/aktivitas_view.dart';
import '../profil/profil_view.dart';
import '../report/lapor_view.dart'; 

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  // Memanggil ViewModel
  final MainViewModel _viewModel = MainViewModel();

  // Daftar halaman yang akan ditampilkan sesuai urutan tab
  final List<Widget> _pages = [
    const HomeView(),      // Index 0
    const SuratView(),     // Index 1
    const SizedBox(),      // Index 2 (Dikosongkan karena ini area tombol Kamera)
    const AktivitasView(), // Index 3
    const ProfilView(),    // Index 4
  ];

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder akan memantau perubahan dari MainViewModel
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          // Menampilkan halaman sesuai index yang aktif di ViewModel
          body: _pages[_viewModel.currentIndex],
          
          // Tombol Kamera (E-Report) melayang di tengah
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Navigasi tumpuk (Push) ke halaman Lapor
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LaporView()),
              );
            },
            backgroundColor: const Color(0xFFD4AF37),
            shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 4)),
            elevation: 6,
            child: const Icon(Icons.camera_alt, color: Colors.white, size: 28),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

          // Bottom Navigation Bar WARTA
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            child: SizedBox(
              height: 65,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomNavItem(Icons.home, "Home", 0),
                  _buildBottomNavItem(Icons.mail, "Surat", 1),
                  const SizedBox(width: 48), // Ruang kosong untuk kamera
                  _buildBottomNavItem(Icons.history, "Aktivitas", 3),
                  _buildBottomNavItem(Icons.person, "Profil", 4),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Fungsi pembuat tombol Navigasi Bawah
  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    final isActive = _viewModel.currentIndex == index;
    final primaryRed = const Color(0xFF8B0000);

    return InkWell(
      onTap: () => _viewModel.setIndex(index), // Mengubah state via ViewModel
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(color: primaryRed.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Icon(icon, color: primaryRed, size: 20),
                  const SizedBox(width: 4),
                  Text(label, style: TextStyle(color: primaryRed, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          else ...[
            Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 10, fontWeight: FontWeight.w500)),
          ],
        ],
      ),
    );
  }
}
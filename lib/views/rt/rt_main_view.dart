import 'package:flutter/material.dart';
import 'rt_home_view.dart';
import 'rt_manajemen_view.dart';
import 'rt_approval_view.dart';
import 'rt_profil_view.dart';

class RtMainView extends StatefulWidget {
  final int initialIndex;
  const RtMainView({super.key, this.initialIndex = 0});

  @override
  State<RtMainView> createState() => _RtMainViewState();
}

class _RtMainViewState extends State<RtMainView> {
  late int _currentIndex;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    // Halaman-halaman tab RT
    _pages = [
      RtHomeView(onNavigate: (index) => _setPage(index)),
      const RtManajemenView(),
      const RtApprovalView(),
      const RtProfilView(),
    ];
  }

  void _setPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showScannerDummy() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                "Scan QR Code Warga",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 32),
              // Kotak dummy scanner
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF8B0000), width: 3),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code_scanner, color: Colors.white, size: 60),
                      SizedBox(height: 16),
                      Text("Kamera Aktif\nArahkan ke QR Code", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  "Fitur untuk memvalidasi KTP Digital atau Kehadiran Ronda Warga secara cepat.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // Tombol Scan Floating
      floatingActionButton: FloatingActionButton(
        onPressed: _showScannerDummy,
        backgroundColor: const Color(0xFFD4AF37), // Emas
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, Icons.home, "Home", 0),
              _buildNavItem(Icons.account_balance_wallet_outlined, Icons.account_balance_wallet, "Manajemen", 1),
              const SizedBox(width: 48), // Space untuk FAB
              _buildNavItem(Icons.fact_check_outlined, Icons.fact_check, "Approval", 2),
              _buildNavItem(Icons.person_outline, Icons.person, "Profil", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData iconOutlined, IconData iconFilled, String label, int index) {
    final isSelected = _currentIndex == index;
    final primaryRed = const Color(0xFF8B0000);
    final textGray = const Color(0xFF6B7280);

    return InkWell(
      onTap: () => _setPage(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? iconFilled : iconOutlined,
            color: isSelected ? primaryRed : textGray,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? primaryRed : textGray,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

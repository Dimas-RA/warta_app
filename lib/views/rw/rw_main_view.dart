import 'package:flutter/material.dart';
import 'rw_home_view.dart';
import 'rw_koordinasi_view.dart';
import 'rw_approval_view.dart';
import 'rw_profil_view.dart';

class RwMainView extends StatefulWidget {
  final int initialIndex;
  const RwMainView({super.key, this.initialIndex = 0});

  @override
  State<RwMainView> createState() => _RwMainViewState();
}

class _RwMainViewState extends State<RwMainView> {
  late int _currentIndex;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pages = [
      RwHomeView(onNavigate: (index) => _setPage(index)),
      const RwKoordinasiView(),
      const RwApprovalView(),
      const RwProfilView(),
    ];
  }

  void _setPage(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, Icons.home, 'Home', 0),
              _buildNavItem(Icons.groups_outlined, Icons.groups, 'Koordinasi', 1),
              _buildNavItem(Icons.inbox_outlined, Icons.inbox, 'Approval', 2),
              _buildNavItem(Icons.person_outline, Icons.person, 'Profil', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData iconOutlined, IconData iconFilled, String label, int index) {
    final isSelected = _currentIndex == index;
    const primaryPurple = Color(0xFF6A1B9A);
    const textGray = Color(0xFF6B7280);

    return InkWell(
      onTap: () => _setPage(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? iconFilled : iconOutlined,
            color: isSelected ? primaryPurple : textGray,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? primaryPurple : textGray,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

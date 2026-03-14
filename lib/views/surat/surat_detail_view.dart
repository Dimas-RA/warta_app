import 'package:flutter/material.dart';
import '../../utils/top_notification.dart';

class SuratDetailView extends StatefulWidget {
  final String title;

  const SuratDetailView({super.key, required this.title});

  @override
  State<SuratDetailView> createState() => _SuratDetailViewState();
}

class _SuratDetailViewState extends State<SuratDetailView> {
  static const Color primaryRed = Color(0xFF8B0000);
  static const Color bgApp = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF111827);

  bool _isDiserahkan = false;

  void _ajukanPermohonan() {
    setState(() {
      _isDiserahkan = true;
    });
    TopNotification.show(
      context: context,
      message: "Permohonan berhasil diajukan!",
      isSuccess: true,
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgApp,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Persyaratan Berkas",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCheckbox("Fotokopi KTP / E-KTP", true),
                  _buildCheckbox("Fotokopi Kartu Keluarga (KK)", true),
                  _buildCheckbox("Surat Pengantar RT/RW", false),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isDiserahkan ? Colors.grey : primaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isDiserahkan ? null : _ajukanPermohonan,
                child: Text(
                  _isDiserahkan ? "Diserahkan" : "Ajukan Permohonan",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(String label, bool isChecked) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            isChecked ? Icons.check_box : Icons.check_box_outline_blank,
            color: isChecked ? primaryRed : Colors.grey,
          ),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: textDark)),
        ],
      ),
    );
  }
}

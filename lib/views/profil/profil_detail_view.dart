import 'package:flutter/material.dart';

class ProfilDetailView extends StatelessWidget {
  final String menuName;

  const ProfilDetailView({super.key, required this.menuName});

  static const Color primaryRed = Color(0xFF8B0000);
  static const Color bgApp = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textGray = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgApp,
      appBar: AppBar(
        title: Text(menuName),
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _buildContentForMenu(menuName),
      ),
    );
  }

  Widget _buildContentForMenu(String menu) {
    switch (menu) {
      case "Informasi Pribadi":
        return _buildForm(
          [
            "Nama Lengkap",
            "NIK / No. KTP",
            "Nomor Telepon",
            "Email",
            "Alamat Domisili"
          ],
        );
      case "Ubah PIN Keamanan":
      case "Kata Sandi":
        return _buildForm(
          [
            "PIN Kata Sandi Lama",
            "PIN Kata Sandi Baru",
            "Konfirmasi Kata Sandi Baru",
          ],
          isPassword: true,
        );
      case "Pengaturan Akun":
      case "Notifikasi":
        return Column(
          children: [
            _buildToggleSetting("Notifikasi Push"),
            _buildToggleSetting("Email Updates"),
            _buildToggleSetting("Autentikasi Biometrik"),
          ],
        );
      case "Kebijakan Privasi":
      case "Syarat & Ketentuan":
      case "Pusat Bantuan":
      default:
        return _buildTextContent(menu);
    }
  }

  Widget _buildForm(List<String> fields, {bool isPassword = false}) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          ...fields.map((field) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextField(
                  obscureText: isPassword,
                  decoration: InputDecoration(
                    labelText: field,
                    labelStyle: const TextStyle(color: textGray),
                    border: const UnderlineInputBorder(),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryRed, width: 2),
                    ),
                  ),
                ),
              )),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: const Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSetting(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: textDark)),
          Switch(
            value: true,
            activeColor: primaryRed,
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent(String title) {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Text(
        "Ini adalah halaman detail untuk $title. Seluruh konten statis, panduan, atau informasi persetujuan hukum dapat ditampilkan di area teks ini beserta formatting yang relevan untuk dibaca oleh pengguna secara jelas.",
        style: const TextStyle(
          height: 1.6,
          color: textDark,
          fontSize: 14,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/top_notification.dart';
import '../../services/media_service.dart';
import '../../services/ocr_service.dart';

class ProfilDetailView extends StatefulWidget {
  final String menuName;

  const ProfilDetailView({super.key, required this.menuName});

  @override
  State<ProfilDetailView> createState() => _ProfilDetailViewState();
}

class _ProfilDetailViewState extends State<ProfilDetailView> {
  static const Color primaryRed = Color(0xFF8B0000);
  static const Color bgApp = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textGray = Color(0xFF64748B);

  // States for toggles
  bool _pushNotification = true;
  bool _emailUpdates = false;
  bool _biometricAuth = true;

  // OCR & Media Services
  final MediaService _mediaService = MediaService();
  final OcrService _ocrService = OcrService();
  
  // Controllers for Edit Profile Form
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  bool _isScanningKtp = false;

  @override
  void dispose() {
    _ocrService.dispose();
    _nikController.dispose();
    _namaController.dispose();
    super.dispose();
  }

  Future<void> _scanKtp() async {
    setState(() => _isScanningKtp = true);
    
    // 1. Buka Kamera (XFile untuk OCR, support content URIs)
    final XFile? xfile = await _mediaService.pickImageXFileFromCamera();
    if (xfile != null) {
      // 2. Proses OCR via XFile
      final String? text = await _ocrService.processImage(xfile);
      
      if (text != null && text.isNotEmpty && !text.startsWith('__ERROR__:')) {
        // Cari urutan 16 digit angka yang kemungkinan besar NIK
        final RegExp nikRegex = RegExp(r'\b\d{16}\b');
        final match = nikRegex.firstMatch(text);
        
        if (mounted) {
          if (match != null) {
            setState(() {
              _nikController.text = match.group(0)!;
            });
            TopNotification.show(
              context: context,
              message: "NIK berhasil dipindai!",
              isSuccess: true,
            );
          } else {
            TopNotification.show(
              context: context,
              message: "KTP tidak terbaca jelas. Mohon foto ulang.",
            );
          }
        }
      }
    }
    
    if (mounted) {
      setState(() => _isScanningKtp = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgApp,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          children: [
            // ==========================================
            // 1. HEADER MERAH MELENGKUNG (GRADASI & WATERMARK)
            // ==========================================
            SizedBox(
              height: 180,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color.fromARGB(255, 83, 0, 0), Color(0xFF8B0000)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 20,
                            top: 20,
                            child: Transform.rotate(
                              angle: 12 * 3.14159 / 180,
                              child: Image(
                                image: const AssetImage('assets/icons/ic_document_after.png'),
                                width: 140,
                                height: 140,
                                color: const Color.fromARGB(255, 58, 1, 1).withOpacity(0.1),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () => Navigator.pop(context),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    widget.menuName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // --- KONTEN DETAIL ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: _buildContentForMenu(widget.menuName),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentForMenu(String menu) {
    switch (menu) {
      case "Edit Informasi Pribadi":
      case "Informasi Pribadi": // Menjaga kompatibilitas jika masih ada yang pakai
        return _buildProfileForm();
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
            _buildToggleSetting(
              "Notifikasi Push",
              _pushNotification,
              (val) => setState(() => _pushNotification = val),
            ),
            _buildToggleSetting(
              "Email Updates",
              _emailUpdates,
              (val) => setState(() => _emailUpdates = val),
            ),
            _buildToggleSetting(
              "Autentikasi Biometrik",
              _biometricAuth,
              (val) => setState(() => _biometricAuth = val),
            ),
          ],
        );
      case "Syarat & Ketentuan":
        return _buildSyaratKetentuanContent();
      case "Kebijakan Privasi":
      case "Pusat Bantuan":
      default:
        return _buildTextContent(menu);
    }
  }

  Widget _buildProfileForm() {
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
          _buildTextField("Nama Lengkap", controller: _namaController),
          const SizedBox(height: 16),
          
          // Field NIK dengan Tombol Scan OCR
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _nikController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "NIK / No. KTP",
                    labelStyle: TextStyle(color: textGray),
                    border: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryRed, width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: _isScanningKtp ? null : _scanKtp,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: primaryRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: primaryRed.withOpacity(0.3)),
                  ),
                  child: _isScanningKtp 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: primaryRed, strokeWidth: 2))
                      : const Row(
                          children: [
                            Icon(Icons.document_scanner, color: primaryRed, size: 20),
                            SizedBox(width: 8),
                            Text("Scan NIK", style: TextStyle(color: primaryRed, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          _buildTextField("Nomor Telepon"),
          const SizedBox(height: 16),
          _buildTextField("Email"),
          const SizedBox(height: 16),
          _buildTextField("Alamat Domisili"),
          const SizedBox(height: 32),
          
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryRed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                TopNotification.show(
                  context: context,
                  message: "Data berhasil disimpan",
                  isSuccess: true,
                );
              },
              child: const Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, {TextEditingController? controller, bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: textGray),
        border: const UnderlineInputBorder(),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: primaryRed, width: 2),
        ),
      ),
    );
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
              onPressed: () {
                TopNotification.show(
                  context: context,
                  message: "Data berhasil disimpan",
                  isSuccess: true,
                );
              },
              child: const Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSetting(String title, bool value, Function(bool) onChanged) {
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
            value: value,
            activeColor: primaryRed,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSyaratKetentuanContent() {
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
          const Text(
            "Syarat dan Ketentuan Penggunaan Aplikasi WARTA",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "1. Penerimaan Syarat dan Ketentuan\n"
            "Dengan mengunduh, menginstal, dan/atau menggunakan aplikasi WARTA ('Aplikasi'), Anda setuju untuk terikat oleh Syarat dan Ketentuan ini. Jika Anda tidak setuju dengan Syarat dan Ketentuan ini, Anda tidak diperkenankan untuk menggunakan Aplikasi ini. Aplikasi ini disediakan oleh Rukun Warga setempat sebagai sarana komunikasi dan pelayanan administrasi warga.\n\n"
            "2. Penggunaan Aplikasi\n"
            "Anda setuju untuk menggunakan Aplikasi ini hanya untuk tujuan yang sah dan sesuai dengan peraturan perundang-undangan yang berlaku di Republik Indonesia. Anda dilarang menggunakan Aplikasi ini untuk menyebarkan informasi palsu (hoaks), ujaran kebencian, konten pornografi, atau materi apa pun yang dapat melanggar hak orang lain atau mengganggu ketertiban umum.\n\n"
            "3. Privasi dan Data Pribadi\n"
            "Kami menghargai privasi Anda. Data pribadi yang Anda berikan saat pendaftaran, seperti Nama, NIK, Alamat, dan Nomor Telepon, akan disimpan dengan aman dan hanya digunakan untuk keperluan administrasi warga, validasi layanan, dan komunikasi resmi. Kami tidak akan menjual atau membagikan data Anda kepada pihak ketiga tanpa persetujuan Anda, kecuali diwajibkan oleh hukum.\n\n"
            "4. Tanggung Jawab Pengguna\n"
            "Anda bertanggung jawab penuh atas keamanan akun Anda, termasuk kata sandi (PIN) dan perangkat yang digunakan untuk mengakses Aplikasi. Segala aktivitas yang terjadi di bawah akun Anda adalah tanggung jawab Anda sepenuhnya. Harap segera laporkan kepada pengurus RW jika Anda mencurigai adanya akses tidak sah ke akun Anda.",
            style: TextStyle(
              height: 1.6,
              color: textDark,
              fontSize: 14,
            ),
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


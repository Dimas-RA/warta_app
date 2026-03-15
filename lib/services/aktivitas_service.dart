import 'package:flutter/material.dart';
import '../models/aktivitas_model.dart';

class AktivitasService {
  static const Color greenSuccess = Color(0xFF10B981);
  static const Color bgSuccess = Color(0xFFD1FAE5);
  static const Color yellowProcess = Color(0xFFF59E0B);
  static const Color bgProcess = Color(0xFFFEF3C7);
  static const Color redFailed = Color(0xFFEF4444);
  static const Color bgFailed = Color(0xFFFEE2E2);

  Future<List<AktivitasModel>> getAktivitasList() async {
    await Future.delayed(const Duration(milliseconds: 700));

    return [
      AktivitasModel(
        id: "1",
        title: "Verifikasi E-KTP",
        subtitle: "Pengajuan disetujui",
        date: "2 Jam yang lalu",
        status: "BERHASIL",
        iconCodePoint: Icons.check_circle.codePoint,
        iconFontFamily: Icons.check_circle.fontFamily,
        iconColor: greenSuccess,
        iconBgColor: bgSuccess,
        statusTextColor: greenSuccess,
        statusBgColor: bgSuccess,
      ),
      AktivitasModel(
        id: "2",
        title: "Permohonan Surat",
        subtitle: "Surat Keterangan Usaha",
        date: "Kemarin, 14:20",
        status: "PROSES",
        iconCodePoint: Icons.description.codePoint,
        iconFontFamily: Icons.description.fontFamily,
        iconColor: Colors.blue,
        iconBgColor: Colors.blue.withOpacity(0.1),
        statusTextColor: yellowProcess,
        statusBgColor: bgProcess,
      ),
      AktivitasModel(
        id: "3",
        title: "Pengaduan Masyarakat",
        subtitle: "Lampu Jalan Padam di RT 03",
        date: "12 Okt 2023",
        status: "LAPORAN TIDAK SESUAI",
        iconCodePoint: Icons.report_problem.codePoint,
        iconFontFamily: Icons.report_problem.fontFamily,
        iconColor: const Color(0xFF8B0000),
        iconBgColor: const Color(0xFF8B0000).withOpacity(0.1),
        statusTextColor: redFailed,
        statusBgColor: bgFailed,
      ),
      AktivitasModel(
        id: "4",
        title: "Permohonan Surat",
        subtitle: "Surat Pengantar Nikah",
        date: "10 Okt 2023",
        status: "BERHASIL",
        iconCodePoint: Icons.favorite.codePoint,
        iconFontFamily: Icons.favorite.fontFamily,
        iconColor: Colors.pink,
        iconBgColor: Colors.pink.withOpacity(0.1),
        statusTextColor: greenSuccess,
        statusBgColor: bgSuccess,
      ),
      AktivitasModel(
        id: "5",
        title: "Pembayaran Iuran",
        subtitle: "Iuran Keamanan Bulan Oktober",
        date: "05 Okt 2023",
        status: "BERHASIL",
        iconCodePoint: Icons.payment.codePoint,
        iconFontFamily: Icons.payment.fontFamily,
        iconColor: Colors.purple,
        iconBgColor: Colors.purple.withOpacity(0.1),
        statusTextColor: greenSuccess,
        statusBgColor: bgSuccess,
      ),
    ];
  }

  Future<List<AktivitasModel>> getRecentAktivitas({int limit = 2}) async {
    final list = await getAktivitasList();
    return list.take(limit).toList();
  }
}

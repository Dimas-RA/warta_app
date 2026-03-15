import 'package:flutter/material.dart';
import '../models/darurat_model.dart';

class DaruratService {
  // Simulating an API call with Future.delayed
  Future<List<KontakDaruratModel>> getKontakDarurat() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Mock network delay

    return [
      KontakDaruratModel(
        namaInstansi: "Polsek Setempat",
        nomorTelepon: "110",
        jarak: "1.2 km",
        jenisLayanan: "Keamanan & Ketertiban",
        iconCodePoint: Icons.local_police.codePoint,
        iconFontFamily: Icons.local_police.fontFamily!,
      ),
      KontakDaruratModel(
        namaInstansi: "Rumah Sakit Umum",
        nomorTelepon: "119",
        jarak: "2.5 km",
        jenisLayanan: "Ambulans & Gawat Darurat",
        iconCodePoint: Icons.local_hospital.codePoint,
        iconFontFamily: Icons.local_hospital.fontFamily!,
      ),
      KontakDaruratModel(
        namaInstansi: "Pemadam Kebakaran",
        nomorTelepon: "113",
        jarak: "3.0 km",
        jenisLayanan: "Kebakaran & Penyelamatan",
        iconCodePoint: Icons.fire_extinguisher.codePoint,
        iconFontFamily: Icons.fire_extinguisher.fontFamily!,
      ),
      KontakDaruratModel(
        namaInstansi: "Puskesmas Kecamatan",
        nomorTelepon: "021-1234567",
        jarak: "0.8 km",
        jenisLayanan: "Fasilitas Kesehatan",
        iconCodePoint: Icons.medical_services.codePoint,
        iconFontFamily: Icons.medical_services.fontFamily!,
      ),
      KontakDaruratModel(
        namaInstansi: "PLN (Gangguan Listrik)",
        nomorTelepon: "123",
        jarak: "-",
        jenisLayanan: "Layanan Pelanggan Listrik",
        iconCodePoint: Icons.electrical_services.codePoint,
        iconFontFamily: Icons.electrical_services.fontFamily!,
      ),
    ];
  }
}

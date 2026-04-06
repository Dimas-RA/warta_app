import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Service untuk upload gambar ke Cloudinary (free tier).
/// Menggunakan unsigned upload preset — tidak butuh API Secret di client.
class CloudinaryService {
  static const String _cloudName = 'dm8ub8uew';
  static const String _uploadPreset = 'warta_db';

  static const String _baseUrl =
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';

  /// Upload gambar ke Cloudinary.
  /// [folder]: 'ktp_photos' atau 'selfies'
  /// Returns URL string jika sukses, null jika gagal.
  Future<String?> uploadImage(File imageFile, {String folder = 'warta'}) async {
    try {
      debugPrint('[Cloudinary] Mengupload ke folder: $folder');

      final request = http.MultipartRequest('POST', Uri.parse(_baseUrl));
      request.fields['upload_preset'] = _uploadPreset;
      request.fields['folder'] = folder;

      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonData = json.decode(responseBody) as Map<String, dynamic>;
        final url = jsonData['secure_url'] as String?;
        debugPrint('[Cloudinary] Upload sukses: $url');
        return url;
      } else {
        debugPrint('[Cloudinary] Upload gagal [${response.statusCode}]: $responseBody');
        return null;
      }
    } catch (e) {
      debugPrint('[Cloudinary] ERROR: $e');
      return null;
    }
  }
}

class BeritaModel {
  final String id;
  final String title;
  final String category;
  final String author;
  final String date;
  final String content;
  final String imagePath; // local asset path
  final String? imageUrl;  // remote URL from API

  BeritaModel({
    required this.id,
    required this.title,
    required this.category,
    required this.author,
    required this.date,
    required this.content,
    required this.imagePath,
    this.imageUrl,
  });

  /// Maps from DetikNews scraper JSON shape
  factory BeritaModel.fromDetik(Map<String, dynamic> json, String id) {
    return BeritaModel(
      id: id,
      title: json['judul'] ?? '',
      category: 'DetikNews',
      author: 'Detik.com',
      date: json['waktu'] ?? '',
      content: json['body'] ?? json['judul'] ?? '',
      imagePath: 'assets/images/city_bg.webp',
      imageUrl: json['gambar'],
    );
  }

  /// Maps from NewsData.io JSON shape
  factory BeritaModel.fromNewsData(Map<String, dynamic> json, String id) {
    // Safely extract category list (can be null or empty from API)
    final categoryList = json['category'];
    String cat = 'Berita';
    if (categoryList is List && categoryList.isNotEmpty) {
      cat = categoryList.first?.toString() ?? 'Berita';
    }

    // Pick the best available content
    final content = json['full_description'] ??
        json['description'] ??
        json['title'] ?? '';

    return BeritaModel(
      id: id,
      title: json['title'] ?? '',
      category: cat,
      author: json['source_name'] ?? 'Unknown',
      date: json['pubDate'] ?? '',
      content: content.toString().replaceAll(RegExp(r'<[^>]*>'), ''), // strip HTML
      imagePath: 'assets/images/city_bg.webp',
      imageUrl: json['image_url'],
    );
  }
}

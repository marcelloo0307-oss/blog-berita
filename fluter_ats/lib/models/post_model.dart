class PostModel {
  final int id;
  final String title;
  final String content;
  final String categoryName;

  PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.categoryName,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id_post'], // Sesuai dengan kolom di database MySQL
      title: json['title'],
      content: json['content'],
      categoryName: json['category'] ?? 'Tanpa Kategori', // Mengambil alias dari query JOIN
    );
  }
}
class PostModel {
  const PostModel({
    required this.id,
    required this.title,
    required this.body,
  });

  final int id;
  final String title;
  final String body;

  String get preview {
    if (body.length <= 90) return body;
    return '${body.substring(0, 90)}...';
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] is int ? json['id'] as int : 0,
      title: (json['title'] ?? '').toString(),
      body: (json['body'] ?? '').toString(),
    );
  }
}

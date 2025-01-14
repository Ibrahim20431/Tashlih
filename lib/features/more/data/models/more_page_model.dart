final class MorePageModel {
  const MorePageModel({
    required this.id,
    required this.title,
    required this.image,
    required this.html,
  });

  final int id;
  final String title;
  final String? image;
  final String html;

  bool get hasImage => image != null;

  factory MorePageModel.fromMap(Map<String, dynamic> map) => MorePageModel(
        id: map['id'],
        title: map['title'],
        image: map['image'],
        html: map['content'],
      );
}

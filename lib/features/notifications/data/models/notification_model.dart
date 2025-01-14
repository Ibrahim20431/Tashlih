final class NotificationModel {
  const NotificationModel({
    required this.title,
    required this.subtitle,
    required this.date,
  });

  final String title;
  final String subtitle;
  final String date;

  factory NotificationModel.fromMap(Map<String, dynamic> map) =>
      NotificationModel(
        title: map['title'],
        subtitle: map['subtitle'],
        date: map['date'],
      );
}

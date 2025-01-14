import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard(this.notification, {super.key});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline_rounded, color: primaryColor),
      title: Text(notification.title),
      subtitle: Text(notification.subtitle),
      trailing: Text(notification.date),
    );
  }
}

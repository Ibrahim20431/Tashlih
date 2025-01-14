import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../data/models/notification_model.dart';
import '../widgets/notification_card.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppScaffold(
        title: 'الإشعارات',
        body: ListView(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          children: const [
            NotificationCard(
              NotificationModel(
                title: 'title',
                subtitle: 'subtitle',
                date: 'date',
              ),
            ),
            CustomDivider(height: 0),
            NotificationCard(
              NotificationModel(
                title: 'title',
                subtitle: 'subtitle',
                date: 'date',
              ),
            ),
            CustomDivider(height: 0),
            NotificationCard(
              NotificationModel(
                title: 'title',
                subtitle: 'subtitle',
                date: 'date',
              ),
            ),
            CustomDivider(height: 0),
            NotificationCard(
              NotificationModel(
                title: 'title',
                subtitle: 'subtitle',
                date: 'date',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

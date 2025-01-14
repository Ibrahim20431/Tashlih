import 'package:flutter/material.dart'
    show Dialog, EdgeInsets, Padding, Widget, showDialog;

import '../../../core/extensions/context_extension.dart';
import '../../../features/auth/data/models/user_model.dart';
import '../../constants/app_dimensions.dart';
import '../../widgets/login_card.dart';
import '../navigator_key.dart';

void checkLoginNavigation(UserModel? user, Widget page) {
  final context = navigatorKey.currentContext!;
  if (user != null) {
    context.push(page);
  } else {
    showDialog(
      context: context,
      builder: (_) => const Dialog(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.padding32),
          child: LoginCard(),
        ),
      ),
    );
  }
}

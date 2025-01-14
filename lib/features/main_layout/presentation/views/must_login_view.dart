import 'package:flutter/widgets.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/login_card.dart';

class MustLoginView extends StatelessWidget {
  const MustLoginView(this.page, {super.key});

  final String page;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: page,
      body: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPadding,
        ),
        child: Center(child: LoginCard()),
      ),
    );
  }
}

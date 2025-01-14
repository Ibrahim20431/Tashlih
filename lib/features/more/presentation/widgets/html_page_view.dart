import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_scaffold.dart';

class HtmlPageView extends StatelessWidget {
  const HtmlPageView(this.title, this.html, {super.key});

  final String title;
  final String html;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppScaffold(
        title: title,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          child: HtmlWidget(html),
        ),
      ),
    );
  }
}

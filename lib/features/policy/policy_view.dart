import 'package:flutter/widgets.dart';

import '../more/presentation/widgets/async_html_page_view.dart';

class PolicyView extends StatelessWidget {
  const PolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AsyncHtmlPageView('سياسة التطبيق', 'policy');
  }
}

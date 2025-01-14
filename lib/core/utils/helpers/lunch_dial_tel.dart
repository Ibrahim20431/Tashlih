import 'package:url_launcher/url_launcher.dart';

void lunchDialTel(String mobile) async {
  final Uri uri = Uri(scheme: 'tel', path: mobile);
  await launchUrl(uri);
}

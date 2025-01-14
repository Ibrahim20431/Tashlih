import 'package:flutter/widgets.dart' show Locale, LocalizationsDelegate;
import 'package:flutter_localizations/flutter_localizations.dart';

abstract final class AppLocales {
  static const Locale ar = Locale('ar');

  static const List<Locale> supportedLocales = [ar];

  static const Iterable<LocalizationsDelegate> delegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
}

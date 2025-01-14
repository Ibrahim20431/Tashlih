import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/text_styles.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme => _lightTheme();

  static ThemeData _lightTheme() {
    final theme = ThemeData.light(useMaterial3: true);
    return theme.copyWith(
      primaryColor: primaryColor,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: theme.colorScheme.copyWith(primary: primaryColor),
      canvasColor: Colors.transparent,
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: primaryColor[400],
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyles.largeBold,
        scrolledUnderElevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          fixedSize: const Size(double.maxFinite, AppDimensions.widgetHeight),
          textStyle: TextStyles.largeBold,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius26),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: primaryColor,
          fixedSize: const Size(double.maxFinite, AppDimensions.widgetHeight),
          textStyle: TextStyles.largeBold,
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius26),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: TextStyles.mediumBold,
          visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
            vertical: VisualDensity.minimumDensity,
          ),
        ),
      ),
      radioTheme: theme.radioTheme.copyWith(
        fillColor: MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Colors.white;
          return primaryColor;
        }),
        visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity,
        ),
      ),
      tabBarTheme: theme.tabBarTheme.copyWith(
        labelPadding: const EdgeInsets.symmetric(vertical: 8),
        labelStyle: TextStyles.largeBold.copyWith(fontFamily: appFont),
        labelColor: Colors.white,
        unselectedLabelStyle: TextStyles.largeRegular.copyWith(
          fontFamily: appFont,
        ),
        unselectedLabelColor: Colors.white,
        indicatorColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: primaryColor,
        ),
        dividerColor: Colors.transparent,
        dividerHeight: 0,
      ),
      cardTheme: theme.cardTheme.copyWith(
        margin: EdgeInsets.zero,
        elevation: 0,
      ),
      dialogTheme: theme.dialogTheme.copyWith(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      bottomSheetTheme: theme.bottomSheetTheme.copyWith(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      textTheme: theme.textTheme.apply(
        fontFamily: appFont,
        displayColor: Colors.black,
        bodyColor: Colors.black,
      ),
    );
  }
}

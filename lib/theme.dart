import 'package:flutter/material.dart';

class AppColors {
  static const Color coralReef = Color(0xFFFF736C);
  static const Color coralReef700 = Color(0xFFFF8F89);
  static const Color melon = Color(0xFFFFBCB9);
  static const Color white = Colors.white;
  static const Color darkBlue = Color(0xFF0E0E52);
  static const Color mediumBlue = Color(0xFF26547C);
  static const Color lightBlue = Color.fromARGB(255, 87, 133, 225);
  static const Color teaGreen = Color(0xFFC4F1BE);

  static const Color errorRed = Color(0xFFff5252);
  static const Color successGreen = Color(0xFF00C853);
  static const Color lightGrey = Colors.grey;
  static const Color black = Colors.black;
}

class AppUnits {
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 14.0;
  static const double lg = 20.0;
  static const double xl = 22.0;
  static const double xxl = 32.0;
}

class AppGradients {
  static BoxDecoration get coralGradient {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.1, 0.9],
        colors: [
          Colors.deepOrange[50],
          Colors.deepOrange[300],
        ],
      ),
    );
  }
}

class AppTheme {
  ThemeData buildDartTheme() {
    return buildTheme();
  }

  ThemeData buildTheme() {
    final ThemeData base = ThemeData.light();

    return base.copyWith(
      accentColor: AppColors.lightBlue,
      primaryColor: AppColors.coralReef,
      primaryColorLight: AppColors.melon,
      cardColor: AppColors.white,
      textSelectionColor: AppColors.melon,
      errorColor: AppColors.errorRed,
      scaffoldBackgroundColor: AppColors.white,
      bottomAppBarColor: AppColors.white,
      canvasColor: AppColors.white,
      backgroundColor: AppColors.white,
      dialogBackgroundColor: AppColors.white,
      cursorColor: AppColors.lightBlue,
      unselectedWidgetColor: Colors.grey[700],
      buttonTheme: base.buttonTheme.copyWith(
          buttonColor: AppColors.lightBlue,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
      appBarTheme: _buildAppBarTheme(base.appBarTheme),
      iconTheme: IconThemeData(color: AppColors.white),
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildPrimaryTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildAccentTextTheme(base.accentTextTheme),
      primaryIconTheme: base.iconTheme.copyWith(color: AppColors.white),
      inputDecorationTheme: InputDecorationTheme(filled: false, border: InputBorder.none),
    );
  }

  AppBarTheme _buildAppBarTheme(AppBarTheme base) {
    return base.copyWith(
      brightness: Brightness.light,
      elevation: 0.5,
      color: AppColors.white,
      textTheme: TextTheme(
          title: TextStyle(
        color: AppColors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      )),
      iconTheme: IconThemeData(color: AppColors.white, size: 19.0),
    );
  }

  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
        title: TextStyle(color: Colors.black, fontSize: AppUnits.xxl, fontWeight: FontWeight.bold),
        headline: TextStyle(fontWeight: FontWeight.bold, fontSize: AppUnits.xl, color: Colors.black),
        subhead: TextStyle(fontWeight: FontWeight.normal, fontSize: AppUnits.lg, color: Colors.black),
        caption: TextStyle(fontStyle: FontStyle.italic, fontSize: AppUnits.md, color: Colors.grey[500]),
        display1: TextStyle(fontWeight: FontWeight.bold, fontSize: AppUnits.md, color: Colors.black),
        display2: TextStyle(fontWeight: FontWeight.normal, fontSize: AppUnits.sm, color: Colors.grey[500]),
        body1: TextStyle(fontSize: AppUnits.md, color: Colors.black));
  }

  TextTheme _buildPrimaryTextTheme(TextTheme base) {
    return base.copyWith(
      title: TextStyle(color: AppColors.coralReef, fontSize: AppUnits.xxl, fontWeight: FontWeight.bold),
      display1: TextStyle(fontWeight: FontWeight.bold, fontSize: AppUnits.md, color: AppColors.coralReef),
      display2: TextStyle(fontWeight: FontWeight.normal, fontSize: AppUnits.sm, color: AppColors.melon),
    );
  }

  TextTheme _buildAccentTextTheme(TextTheme base) {
    return base
        .copyWith(
            overline: TextStyle(
          color: AppColors.lightBlue,
          fontWeight: FontWeight.bold,
          fontSize: AppUnits.md,
          decoration: TextDecoration.underline,
        ))
        .apply(displayColor: AppColors.white);
  }
}

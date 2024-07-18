import 'package:flutter/material.dart';

class AppTheme {
  // Define the colors used in the app
  static const Color accentColor = Color(0xFFff939b);
  static const Color primaryColor = Color(0xFFef2a39);
  static const Color secondaryColor = Color.fromRGBO(80, 80, 80, 1);
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color greyColor  = Color.fromARGB(255, 221, 221, 221);
  
  static final TextTheme poppinsTextTheme = TextTheme(
    headline1: TextStyle(fontSize: 32.0, fontWeight: FontWeight.normal, fontFamily: 'Poppins'),
    headline2: TextStyle(fontSize: 28.0, fontWeight: FontWeight.normal, fontFamily: 'Poppins'),
    headline3: TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal, fontFamily: 'Poppins'),
    headline4: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, fontFamily: 'Poppins'),
    bodyText1: TextStyle(fontSize: 18.0, fontFamily: 'Poppins'),
    bodyText2: TextStyle(fontSize: 16.0, fontFamily: 'Poppins'),
    button: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
  );

  // Text theme for titles styled with 'Lobster'
  static final TextTheme lobsterTextTheme = TextTheme(
    headline1: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold, fontFamily: 'Lobster'),
    headline2: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold, fontFamily: 'Lobster'),
    headline3: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, fontFamily: 'Lobster'),
  );

  // Method to apply the app theme globally
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: primaryColor,
      hintColor: accentColor,
      textTheme: poppinsTextTheme,
      primaryTextTheme: lobsterTextTheme,
    );
  }
}

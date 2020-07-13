import 'package:flutter/material.dart';

import 'size_config.dart';

class AppTheme {
  AppTheme._();

  static const Color textColor = Color(0XFF333333);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.white,
    accentColor: Color(0xffFCB62E),
    scaffoldBackgroundColor: Color(0XFFF4F4F4), //Color(0xFFF3F5F7)
    inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: textColor),
        fillColor: Color(0xFFFAFAFA),
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Color(0xffE8E8E8), width: 1.0)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff64C4ED), width: 2.0),
        )),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.black87),
    ),
  );

  static final TextStyle titleTextStyle = TextStyle(
      fontSize: 4.5 * SizeConfig.textMultiplier,
      fontWeight: FontWeight.bold,
      color: textColor);
}

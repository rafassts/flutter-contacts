import 'package:contacts/shared/styles.dart';
import 'package:flutter/material.dart';

const brightness = Brightness.light;
const primaryColor = basePrimaryColor;
const accentColor = baseAccentColor;

ThemeData androidTheme() {
  var textTheme = new TextTheme(
    bodyText1: new TextStyle(fontFamily: "Poppins"),
    bodyText2: TextStyle(fontFamily: "Poppins"),
    caption: TextStyle(fontFamily: "Poppins"),
    subtitle1: TextStyle(fontFamily: "Poppins"),
    subtitle2: TextStyle(fontFamily: "Poppins"),
    headline1: TextStyle(fontFamily: "Poppins"),
    headline2: TextStyle(fontFamily: "Poppins"),
    headline3: TextStyle(fontFamily: "Poppins"),
    headline4: TextStyle(fontFamily: "Poppins"),
    headline5: TextStyle(fontFamily: "Poppins"),
    headline6: TextStyle(fontFamily: "Poppins"),
    button: TextStyle(fontFamily: "Poppins"),
  );

  return ThemeData(
    appBarTheme: AppBarTheme(
        centerTitle: true,
        color: Colors.transparent,
        elevation: 0,
        iconTheme: new IconThemeData(color: primaryColor),
        textTheme: textTheme),
    brightness: brightness,
    primaryColor: primaryColor,
    accentColor: accentColor,
    iconTheme: new IconThemeData(color: primaryColor),
    textTheme: textTheme,
  );
}

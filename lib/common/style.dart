import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final Color primaryBrandColor = Color(0xFFFFFFFF);
final Color secondaryBrandColor = Color(0xFF04A1C2);
final Color accentBrandColor = Color(0xFFF54022);
final Color backgoundColor = Color(0xFFF2F2F2);

final Color primaryDarkColor = Color(0xFF121212);
final Color secondaryDarkColor = Color(0xFF04A1C2);

ThemeData lightTheme = ThemeData(
  primaryColor: primaryBrandColor,
  accentColor: secondaryBrandColor,
  dividerColor: accentBrandColor,
  scaffoldBackgroundColor: backgoundColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: brandTextTheme,
  appBarTheme: AppBarTheme(textTheme: brandTextTheme.apply(bodyColor: Colors.black), elevation: 0),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: secondaryBrandColor,
    unselectedItemColor: Colors.grey,
  ),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: primaryDarkColor,
  accentColor: secondaryDarkColor,
  dividerColor: accentBrandColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: brandTextTheme,
  appBarTheme: AppBarTheme(textTheme: brandTextTheme.apply(bodyColor: Colors.white), elevation: 0),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: secondaryBrandColor,
    unselectedItemColor: Colors.grey,
  ),
);

final TextTheme brandTextTheme = TextTheme(
  headline1: GoogleFonts.lobster(fontSize: 92, fontWeight: FontWeight.w400, letterSpacing: -0.5),
  headline2: GoogleFonts.lobster(fontSize: 57, fontWeight: FontWeight.w400, letterSpacing: -0.5),
  headline3: GoogleFonts.lobster(fontSize: 46, fontWeight: FontWeight.w400, letterSpacing: -0.5),
  headline4: GoogleFonts.lobster(fontSize: 32, fontWeight: FontWeight.w400, letterSpacing: -0.5),
  headline5: GoogleFonts.lobster(fontSize: 23, fontWeight: FontWeight.w400, letterSpacing: -0.5),
  headline6: GoogleFonts.lobster(fontSize: 19, fontWeight: FontWeight.w400, letterSpacing: -0.5),
  subtitle1: GoogleFonts.lobster(fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: -0.5),
  subtitle2: GoogleFonts.lora(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: -0.5),
  bodyText1: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: -0.5),
  bodyText2: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: -0.5),
  button: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.5),
  caption: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: -0.5),
  overline: GoogleFonts.lato(fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: -0.5),
);

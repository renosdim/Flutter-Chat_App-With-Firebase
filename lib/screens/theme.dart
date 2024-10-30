import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chat/common/typo.dart';

ThemeData darkTheme() {
  return ThemeData(fontFamily: GoogleFonts.poppins().fontFamily,brightness: Brightness.dark).copyWith(

    colorScheme: const ColorScheme.dark().copyWith(
      primary: Colors.black,
      secondary: const Color.fromRGBO(201, 196, 181,1),

      surface: Colors.white,
      background: Colors.black87,
      onBackground: Colors.white,
    ),

    scaffoldBackgroundColor: Colors.transparent,
    iconTheme: const IconThemeData(color: Colors.white),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color:
        Colors.white,
      ), // IconThemeData
    ),
    // AppBarTheme
    textTheme: GoogleFonts.comfortaaTextTheme(TextTheme(

        titleLarge: TextStyle(color: Colors.white,fontSize: 15),
        titleMedium: small,
        titleSmall: xsmall,
        displayMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        displaySmall: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
        displayLarge:TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        bodyLarge: TextStyle(color: Color(0xFF172774)),
        bodyMedium: TextStyle(color: Color(0xFF172774)),
        bodySmall: TextStyle(color: Color(0xFF172774))
    )),
  );

}
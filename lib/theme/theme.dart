import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  scaffoldBackgroundColor: const Color.fromARGB(255, 31, 31, 31),
  primarySwatch: Colors.yellow,
  dividerColor: Colors.white24,
  appBarTheme: AppBarTheme(
      backgroundColor: Color.fromARGB(255, 31, 31, 31),
      elevation: 6,
      titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700
      )
  ),
  listTileTheme: const ListTileThemeData(iconColor: Colors.white),
  textTheme: TextTheme(
      bodyMedium: TextStyle(
          color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
      labelSmall: TextStyle(
          color: Colors.white.withAlpha(155),
          fontWeight: FontWeight.w700,
          fontSize: 14)),
);
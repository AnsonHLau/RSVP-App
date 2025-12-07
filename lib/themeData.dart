import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light, 
  colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 20, 80, 220),
      brightness: Brightness.light
  ),
  
  
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(250, 20, 80, 220),
      brightness: Brightness.dark,
  ),
  
);

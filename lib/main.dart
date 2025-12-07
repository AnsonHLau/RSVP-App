import 'package:flutter/material.dart';
import 'package:rsvp_app/themeData.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //const MyApp({super.key});
  final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _notifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: 'RSVP Reader',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: mode,
          home: MyHomePage(
            title: 'RSVP Reader', 
            themeNotifier: _notifier,
          ),

        );
      }
    );
    
  }
}

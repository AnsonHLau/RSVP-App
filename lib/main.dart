import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RSVP Reader',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 20, 80, 220)),
      ),
      home: const MyHomePage(title: 'RSVP Reader'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    var words = [
    "Never", "gonna", "give", "you", "up,",
    "never", "gonna", "let", "you", "down,",
    "never", "gonna", "run", "around", "and", "desert", "you.",
    "Never", "gonna", "make", "you", "cry,",
    "never", "gonna", "say", "goodbye,",
    "never", "gonna", "tell", "a", "lie", "and", "hurt", "you."
  ];
  int _index = 0;
  int _wpm = 240;
  Timer? _timer;
  bool get _isRunning => _timer?.isActive == true;

  void _incrementIndex() {
    setState(() {
      _index = (_index < words.length-1) ? _index + 1 : _index;
    });
  }

  Duration get _speed {
    return Duration(milliseconds: (60000 / _wpm).round());
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(_speed, (timer) {_incrementIndex();});
    setState(() {});
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {}); 
  }

  void _toggleTimer() {
    if (_isRunning) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }

  void _resetIndex() {
    setState(() {
      _index = 0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    words[_index],
                    style: const TextStyle(fontSize: 52, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 64),
                  FloatingActionButton.extended(
                    onPressed: _toggleTimer,
                    tooltip: 'Play/Pause',
                    label: Text(_isRunning ? 'Pause' : 'Play'),
                    icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  ),
                ],
              ),
            ),
          ),

          // Settings button 
          Positioned(
            left: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
              tooltip: 'Settings',
              child: const Icon(Icons.settings),
            ),
          ),
        ],
      ),

      // Reset button (default FAB position)
      floatingActionButton: FloatingActionButton(
        onPressed: _resetIndex,
        tooltip: 'Reset',
        child: const Icon(Icons.restart_alt),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Text('Settings go here'),
      ),
    );
  }
}
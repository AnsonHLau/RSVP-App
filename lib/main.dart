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
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Center(
          // Keep the content tightly wrapped and centered
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                words[_index],
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              // Play Pause Button
              const SizedBox(height: 32), 
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
      // Reset Button
      floatingActionButton: FloatingActionButton(
        onPressed: _resetIndex,
        tooltip: 'Reset',
        child: const Icon(Icons.restart_alt),
      ),
    );
  }
}
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 20, 80, 220),
        ),
      ),
      home: const MyHomePage(title: 'RSVP Reader'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

int _index = 0;

class _MyHomePageState extends State<MyHomePage> {
  var words = [];
  int _wpm = 240;
  Timer? _timer;
  bool get _isRunning => _timer?.isActive == true;

  void _incrementIndex() {
    setState(() {
      _index = (_index < readingWords.length - 1) ? _index + 1 : _index;
    });
  }

  Duration get _speed {
    return Duration(milliseconds: (60000 / _wpm).round());
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(_speed, (timer) {
      _incrementIndex();
    });
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

  void _forcePausePlayback() {
    _stopTimer();
  }

  void _updateWpm(int newWpm) {
    setState(() {
      _wpm = newWpm.clamp(100, 800);
    });
    if (_isRunning) {
      _startTimer();
    }
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
                    readingWords[_index],
                    style: const TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  //Wpm Slider
                  const SizedBox(height: 64),
                  Text(
                    'Speed: $_wpm WPM',
                    style: const TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    width: 500,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        tickMarkShape: SliderTickMarkShape.noTickMark,
                        activeTickMarkColor: Colors.transparent,
                        inactiveTickMarkColor: Colors.transparent,
                      ),
                      child: Slider(
                        min: 100,
                        max: 800,
                        divisions: 28, // keeps discrete steps
                        value: _wpm.toDouble(),
                        label: '$_wpm WPM',
                        onChanged: (v) => _updateWpm(v.round()),
                      ),
                    ),
                  ),

                  //Play/Pause Button
                  const SizedBox(height: 24),
                  FloatingActionButton.extended(
                    heroTag: "play_pause",
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
              heroTag: "settings",
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
        heroTag: "reset",
        onPressed: _resetIndex,
        tooltip: 'Reset',
        child: const Icon(Icons.restart_alt),
      ),
    );
  }
}

var inputWords = [""];
var readingWords = [""];

class _SettingsPageState extends State<SettingsPage> {
  void _submitWords() {
    readingWords = inputWords;
    _index = 0;
    Navigator.pop(context);
  }

  List<String> _tokenize(String text) {
    return text
        .replaceAll(RegExp(r'\r\n?'), '\n')
        .split(RegExp(r'\s+')) // spaces, tabs, newlines
        .where((s) => s.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Settings'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  minLines: 4,
                  maxLines: 10,
                  decoration: InputDecoration(
                    labelText: 'Paste or type your text',
                    hintText: 'Enter text',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (text) {
                    //Setting the display text arrray into the input text
                    inputWords = _tokenize(text);
                  },
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: _submitWords,
                    icon: const Icon(Icons.check),
                    label: const Text('Submit'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

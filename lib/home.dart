import 'dart:async';
import 'package:flutter/material.dart';
import 'settings.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/* Home Page */
class _MyHomePageState extends State<MyHomePage> {
  List<String> readingWords = const ["OpenSettingsToAddWords"];
  int _index = 0;
  int _wpm = 250;
  Timer? _timer;

  bool get _isRunning => _timer?.isActive == true;
  Duration get _speed => Duration(milliseconds: (60000 / _wpm).round());

  // Move to next word
  void _incrementIndex() {
    if (readingWords.isEmpty) return;
    setState(() {
      _index = (_index < readingWords.length - 1) ? _index + 1 : _index;
    });
  }

  void _startTimer() {
    _timer?.cancel();
    if (readingWords.isEmpty) return;
    _timer = Timer.periodic(_speed, (_) => _incrementIndex());
    setState(() {});
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {});
  }

  void _toggleTimer() => _isRunning ? _stopTimer() : _startTimer();

  void _resetIndex() => setState(() => _index = 0);

  void _updateWpm(int newWpm) {
    _wpm = newWpm.clamp(100, 800).toInt();
    if (_isRunning) _startTimer();
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _openSettings() async {
    _stopTimer(); // Pause reader
    final result = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(builder: (_) => const SettingsPage()),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        readingWords = result;
        _index = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentWord = (readingWords.isEmpty || _index >= readingWords.length)
        ? ''
        : readingWords[_index];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Displayed Word
                  Text(
                    currentWord,
                    style: const TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // Wpm Slider
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
                        divisions: 28, // Each division is 25WPM
                        value: _wpm.toDouble(),
                        label: '$_wpm WPM',
                        onChanged: (v) => _updateWpm(v.round()),
                      ),
                    ),
                  ),

                  // Play & Pause Button
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
              onPressed: _openSettings,
              tooltip: 'Settings',
              child: const Icon(Icons.settings),
            ),
          ),
        ],
      ),

      // Reset button
      floatingActionButton: FloatingActionButton(
        heroTag: "reset",
        onPressed: _resetIndex,
        tooltip: 'Reset',
        child: const Icon(Icons.restart_alt),
      ),
    );
  }
}

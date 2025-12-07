import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

/* Settings Page */
class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.initialText,
    required this.initialFontSize,
    required this.initialPauseSentence,
    //required this.initialDarkMode,
    required this.themeNotifier,
  });

  final String initialText;
  final double initialFontSize;
  final bool initialPauseSentence;
  //final bool initialDarkMode; 
  final ValueNotifier<ThemeMode> themeNotifier; 

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String _text;
  late double _fontSize;
  late bool _pauseSentence;
  //late bool _darkMode;
  late TextEditingController _controller;
  late  final ValueNotifier<ThemeMode> _themeNotifier; 

  @override
  void initState() {
    super.initState();
    _text = widget.initialText;
    _fontSize = widget.initialFontSize;
    _pauseSentence = widget.initialPauseSentence;
   // _darkMode = widget.initialDarkMode; 
    _themeNotifier = widget.themeNotifier; 
    _controller = TextEditingController(text: _text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Splits input text into words
  List<String> _tokenize(String text) {
    return text
    // spaces, tabs, newlines
        .replaceAll(RegExp(r'\r\n?'), '\n')
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
  }

  // Submit words and return to home
  void _submitWords() {
    final tokens = _tokenize(_controller.text);
    Navigator.pop(context, {
      'tokens': tokens,
      'fontSize': _fontSize,
      'pauseSentence': _pauseSentence,
      //'darkMode' : _darkMode,
    });
  }

  // File input
  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'md'],
        withData: true, // allows web importing
      );

      if (result == null) return;
      final file = result.files.single;
      String contents;

      if (file.bytes != null) {
        // WEB or platforms where no path is provided
        contents = String.fromCharCodes(file.bytes!);
      } else if (file.path != null) {
        // Desktop / mobile (real file path)
        contents = await File(file.path!).readAsString();
      } else {
        throw Exception("Unsupported file source");
      }

      setState(() {
        _controller.text = contents;
        _text = contents;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to read file: $e')),
      );
    }
  }

  // Widgets and UI
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor:
      colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Text input',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: _pickFile,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          icon: const Icon(Icons.upload_file, size: 18),
                          label: const Text('Import from file'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Paste text or import a file to get started.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color
                            ?.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Text field
                    TextField(
                      controller: _controller,
                      minLines: 6,
                      maxLines: 12,
                      decoration: InputDecoration(
                        hintText: 'Paste or type your text here…',
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (text) => _text = text,
                    ),

                    const SizedBox(height: 24),
                    const Divider(height: 1),
                    const SizedBox(height: 24),

                    // Font size row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Font size',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_fontSize.round()} pt',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color:
                                  theme.textTheme.bodySmall?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        tickMarkShape: SliderTickMarkShape.noTickMark,
                        activeTickMarkColor: Colors.transparent,
                        inactiveTickMarkColor: Colors.transparent,
                      ),
                      child: Slider(
                        min: 20,
                        max: 120,
                        divisions: 20,
                        value: _fontSize,
                        label: '$_fontSize pt',
                        onChanged: (value) {
                          setState(() => _fontSize = value);
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SwitchListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text('Pause at End of Sentence'),
                        value: _pauseSentence,
                        onChanged: (value) {
                          setState(() => _pauseSentence = value);
                        },
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SwitchListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text('Dark Mode'),
                        value: _themeNotifier.value == ThemeMode.dark,
                        onChanged: (isDark) {
                          setState(() => _themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light);  
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _submitWords,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

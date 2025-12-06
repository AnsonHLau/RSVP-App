import 'package:flutter/material.dart';

/* Settings Page */
class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.initialText,
    required this.initialPauseSentence,
  });

  final String initialText;
  final bool initialPauseSentence;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String _text;
  late bool _pauseSentence;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _text = widget.initialText;
    _pauseSentence = widget.initialPauseSentence;
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
      'pauseSentence': _pauseSentence,
    });
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton.icon(
                      //onPressed: _pickFile,
                      onPressed: () {  }, // PLACEHOLDER
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Import from file'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _controller,
                  minLines: 4,
                  maxLines: 10,
                  decoration: InputDecoration(
                    labelText: 'Paste or type your text',
                    hintText: 'Enter text',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (text) => _text = text,
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Punctuation Awareness'),
                  subtitle: const Text('Pause a little after each sentence.'),
                  value: _pauseSentence,
                  onChanged: (value) {
                    setState(() => _pauseSentence = value);
                  },
                ),
                const SizedBox(height: 25),
                Center(
                  child: FilledButton(
                    onPressed: _submitWords,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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

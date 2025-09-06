import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslationScreen extends StatefulWidget {
  final String initialText;

  const TranslationScreen({super.key, required this.initialText});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  late final OnDeviceTranslator _translator;
  String _translatedText = '';
  bool _isTranslating = false;
  TranslateLanguage _targetLanguage = TranslateLanguage.hindi;

  final Map<TranslateLanguage, String> _languageMap = {
    TranslateLanguage.hindi: 'Hindi',
    TranslateLanguage.bengali: 'Bengali',
    TranslateLanguage.tamil: 'Tamil',
    TranslateLanguage.telugu: 'Telugu',
  };

  @override
  void initState() {
    super.initState();
    _translator = OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.english, targetLanguage: _targetLanguage);
    _translateText();
  }

  @override
  void dispose() {
    _translator.close();
    super.dispose();
  }

  Future<void> _translateText() async {
    setState(() {
      _isTranslating = true;
    });

    try {
      final translatedText = await _translator.translateText(widget.initialText);
      setState(() {
        _translatedText = translatedText;
      });
    } catch (e) {
      setState(() {
        _translatedText = 'Error: ${e.toString()}';
      });
    }

    setState(() {
      _isTranslating = false;
    });
  }

  void _onLanguageChanged(TranslateLanguage? newLanguage) {
    if (newLanguage != null) {
      setState(() {
        _targetLanguage = newLanguage;
      });
      _translator = OnDeviceTranslator(
          sourceLanguage: TranslateLanguage.english, targetLanguage: _targetLanguage);
      _translateText();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<TranslateLanguage>(
              value: _targetLanguage,
              onChanged: _onLanguageChanged,
              items: _languageMap.entries
                  .map((entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            if (_isTranslating)
              const Center(child: CircularProgressIndicator())
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Original Text:', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(widget.initialText, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 24),
                  Text('Translated Text:', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(_translatedText, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _translatedText));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

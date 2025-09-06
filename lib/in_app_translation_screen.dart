import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class InAppTranslationScreen extends StatefulWidget {
  const InAppTranslationScreen({super.key});

  @override
  State<InAppTranslationScreen> createState() => _InAppTranslationScreenState();
}

class _InAppTranslationScreenState extends State<InAppTranslationScreen> {
  final TextEditingController _textController = TextEditingController();
  final OnDeviceTranslator _translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english, targetLanguage: TranslateLanguage.hindi);
  String _translatedText = '';
  Timer? _debounce;
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
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _translator.close();
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_textController.text.isNotEmpty) {
        _translateText(_textController.text);
      } else {
        setState(() {
          _translatedText = '';
        });
      }
    });
  }

  Future<void> _translateText(String text) async {
    setState(() {
      _isTranslating = true;
    });
    try {
      final result = await _translator.translateText(text);
      setState(() {
        _translatedText = result;
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
      _translator.close();
      final newTranslator = OnDeviceTranslator(
          sourceLanguage: TranslateLanguage.english, targetLanguage: newLanguage);
      if (_textController.text.isNotEmpty) {
        _translateText(_textController.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('In-App Translation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter text to translate',
                border: const OutlineInputBorder(),
                counterText: '${_textController.text.length} characters',
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        // Implement copy functionality
                      },
                      tooltip: 'Copy Translation',
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _textController.clear();
                      },
                      tooltip: 'Clear Text',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: _isTranslating
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Text(
                          _translatedText,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

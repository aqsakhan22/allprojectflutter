import 'package:flutter/material.dart';
import 'package:flutter_speech/flutter_speech.dart';
class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class SpeechRecognitionEx extends StatefulWidget {
  const SpeechRecognitionEx({Key? key}) : super(key: key);

  @override
  State<SpeechRecognitionEx> createState() => _SpeechRecognitionExState();
}

class _SpeechRecognitionExState extends State<SpeechRecognitionEx> {

  List<Language> languages = [
    Language('English', 'en_US'),
    Language('Hindi', 'hi'),
    Language('Francais', 'fr_FR'),
    Language('Pусский', 'ru_RU'),
    Language('Italiano', 'it_IT'),
    Language('Español', 'es_ES') ,
    Language('urdu', 'ur'),
  ];
  late SpeechRecognition _speech;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  String transcription = '';
 late Language selectedLang ;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedLang=languages.first;
    activateSpeechRecognizer();
  }
  void activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);
    _speech.activate('en_US').then((res) {
      setState(() => _speechRecognitionAvailable = res);
    });
  }
  Widget _buildButton({required String label, VoidCallback? onPressed}) =>
      Padding(
          padding: EdgeInsets.all(12.0),
          child: ElevatedButton(
            onPressed: onPressed,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ));

  void start() => _speech.activate(selectedLang.code).then((_) {
    return _speech.listen().then((result) {
      print('_MyAppState.start => result $result');
      setState(() {
        _isListening = result;
      });
    });
  });

  void cancel() =>
      _speech.cancel().then((_) => setState(() => _isListening = false));

  void stop() => _speech.stop().then((_) {
    setState(() => _isListening = false);
  });

  void _selectLangHandler(Language lang) {
    print("set language is ${lang.name}");
    setState(() => selectedLang = lang);
  }

  List<CheckedPopupMenuItem<Language>> get _buildLanguagesWidgets => languages
      .map((l) => CheckedPopupMenuItem<Language>(
    value: l,
    checked: selectedLang == l,
    child: Text(l.name),
  ))
      .toList();
  void onCurrentLocale(String locale) {
    print('_MyAppState.onCurrentLocale... $locale');
    setState(() => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) {
    print('_MyAppState.onRecognitionResult... $text');
    setState(() => transcription = text);
  }

  void onRecognitionComplete(String text) {
    print('_MyAppState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
  }

  void errorHandler() => activateSpeechRecognizer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  automaticallyImplyLeading: false,
        title: const Text('Flutter Voice Searching Demo'),
        actions: [
          PopupMenuButton<Language>(
            onSelected: _selectLangHandler,
            itemBuilder: (BuildContext context) => _buildLanguagesWidgets,
          )
        ],),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.grey.shade200,
                  child: Text(transcription))),
          _buildButton(
            onPressed: _speechRecognitionAvailable && !_isListening
                ? () => start()
                : null,
            label: _isListening
                ? 'Listening...'
                : 'Listen (${selectedLang.code})',
          ),
          _buildButton(
            onPressed: _isListening ? () => cancel() : null,
            label: 'Cancel',
          ),
          _buildButton(
            onPressed: _isListening ? () => stop() : null,
            label: 'Stop',
          ),

        ],
      ),
    );

  }
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';


void main() {
  runApp(MonkimeterApp());
}

class MonkimeterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monkimeter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MonkimeterHomePage(),
    );
  }
}

class MonkimeterHomePage extends StatefulWidget {
  @override
  _MonkimeterHomePageState createState() => _MonkimeterHomePageState();
}

class _MonkimeterHomePageState extends State<MonkimeterHomePage> {
  int _seconds = 0;
  Timer? _timer;
  bool _isHanging = false;
  bool _inCountDown = false;
  FlutterTts flutterTts = FlutterTts();
  AudioPlayer audioPlayer = AudioPlayer();

  void _startCountdown() {
    setState(() {
      _seconds = 5;  // Inicia el contador en 5 segundos
      _isHanging = true;  // Cambia el estado a colgado (hang)
      _inCountDown = true;
      _playAudio('audio/beep.mp3'); // Reproduce el sonido de beep cada segundo
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 1) {
          _seconds--;  // Decrementa el contador cada segundo
          _playAudio('audio/beep.mp3'); // Reproduce el sonido de beep cada segundo
        } else {
          _timer?.cancel();  // Cancela el temporizador de la cuenta regresiva
          _inCountDown = false;
          _seconds=0;
          _startTimer();  // Inicia el temporizador principal después de la cuenta regresiva
        }
      });
    });
  }

  void _startTimer() {
    // Aquí se inicia el temporizador principal
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        _speak('${_seconds}'); // Anuncia el número (1, 2, 3, etc.)
      });
    });
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("es-ES");
    await flutterTts.setSpeechRate(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }


  Future<void> _playAudio(String audioPath) async {
  try {
    await audioPlayer.setSource(AssetSource(audioPath));
    await audioPlayer.resume();
    print('Audio playing successfully');
  } catch (e) {
    // Manejo de errores, si ocurre alguno
    print('Error playing audio: $e');
  }
  }

  void _stopTimer() {
    _timer?.cancel();
    _seconds=0;
    _inCountDown = false;
    setState(() {
      _isHanging = false;
    });
    // Aquí se guarda el tiempo de colgado en la base de datos
    _saveHang(_seconds);
  }

  Future<void> _saveHang(int duration) async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'hangboard_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE hangs(id INTEGER PRIMARY KEY, duration INTEGER, date TEXT)",
        );
      },
      version: 1,
    );

    final db = await database;
    await db.insert(
      'hangs',
      {'duration': duration, 'date': DateTime.now().toString()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monkimeter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '🦧 Tiempo colgado 🦧',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            _inCountDown
              ? Text(
              '-$_seconds s',
              style: Theme.of(context).textTheme.headlineLarge,
              ): Text(
              '$_seconds s',
              style: Theme.of(context).textTheme.headlineLarge,
              ),
            SizedBox(height: 20),
            _isHanging
                ? ElevatedButton(
                    onPressed: _stopTimer,
                    child: Text('Detener'),
                  )
                : ElevatedButton(
                    onPressed: _startCountdown,  // Cambiado a _startCountdown
                    child: const Text('Iniciar'),
                  ),
          ],
        ),
      ),
    );
  }
}

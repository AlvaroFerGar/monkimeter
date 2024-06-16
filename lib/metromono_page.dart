import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'globals.dart';


class MetromonoPage extends StatefulWidget {
  @override
  _MetromonoPageState createState() => _MetromonoPageState();
}

class _MetromonoPageState extends State<MetromonoPage> {
  int _seconds = 0;
  Timer? _timer;
  bool _isHanging = false;
  bool _inCountDown = false;
  FlutterTts flutterTts = FlutterTts();
  AudioPlayer audioPlayer = AudioPlayer();

  void _startCountdown() {
    setState(() {
      _seconds = countdownStartValue; // Inicia el contador en 5 segundos
      _isHanging = true; // Cambia el estado a colgado (hang)
      _inCountDown = true;
      _playAudio('audio/beep.mp3'); // Reproduce el sonido de beep al inicio
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 1) {
          _seconds--; // Decrementa el contador cada segundo
          _playAudio('audio/beep.mp3'); // Reproduce el sonido de beep cada segundo
        } else {
          _timer?.cancel(); // Cancela el temporizador de la cuenta regresiva
          _inCountDown = false;
          _seconds = 0;
          _startTimer(); // Inicia el temporizador principal después de la cuenta regresiva
        }
      });
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
         if (_seconds == 1 || (_seconds) % speakInterval == 0) {
          _speak('$_seconds');
        }
        else
        {
          _playAudio('audio/beep.mp3'); // Reproduce el sonido de beep cada segundo
        }
      });
    });
  }

  Future<void> _speak(String text) async {
    try {
      await flutterTts.setLanguage("es-ES");
      await flutterTts.setSpeechRate(1.0);
      await flutterTts.setPitch(1.0);
      await flutterTts.speak(text);
    } catch (e) {
      print('Error al hablar: $e');
    }
  }

  Future<void> _playAudio(String audioPath) async {
    try {
      await audioPlayer.setSource(AssetSource(audioPath));
      await audioPlayer.resume();
      print('Audio playing successfully');
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    int hangTime = _seconds; // Guarda el tiempo antes de reiniciar a 0
    setState(() {
      _seconds = 0;
      _isHanging = false;
      _inCountDown = false;
    });
    _saveHang(hangTime); // Guarda el tiempo de colgado en la base de datos
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
        title: Text('Metromono'),
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
                  )
                : Text(
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
                    onPressed: _startCountdown,
                    child: const Text('Iniciar'),
                  ),
          ],
        ),
      ),
    );
  }
}

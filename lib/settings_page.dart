import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart';
import 'audio_service.dart';

class AjustesPage extends StatefulWidget {
  @override
  _AjustesPageState createState() => _AjustesPageState();
}

class _AjustesPageState extends State<AjustesPage> {
  TextEditingController _countdownController = TextEditingController();
  TextEditingController _speakintervalController = TextEditingController();
  final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      countdownStartValue = prefs.getInt('countdownStartValue') ?? 5;
      speakInterval = prefs.getInt('speakInterval') ?? 5;
      soundEnabled = prefs.getBool('soundEnabled') ?? true;
      _countdownController.text = countdownStartValue.toString();
      _speakintervalController.text = speakInterval.toString();
    });
  }

  void _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('countdownStartValue', countdownStartValue);
    prefs.setInt('speakInterval', speakInterval);
    prefs.setBool('soundEnabled', soundEnabled);
  }

  void _restoreDefaults() {
    setState(() {
      countdownStartValue = 5;
      speakInterval = 5;
      soundEnabled = true;
      _countdownController.text = '5';
      _speakintervalController.text = '5';
    });
    _saveSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildSection(
                'Cuenta atrás',
                TextField(
                  controller: _countdownController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Segundos',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      countdownStartValue = int.tryParse(value) ?? 5;
                      _saveSettings();
                    });
                  },
                ),
              ),
              _buildSection(
                'Intervalo de vocalización',
                TextField(
                  controller: _speakintervalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Segundos',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      speakInterval = int.tryParse(value) ?? 5;
                      _saveSettings();
                    });
                  },
                ),
              ),
              _buildSection(
                'Sonido cada segundo',
                Switch(
                  value: soundEnabled,
                  onChanged: (value) {
                    setState(() {
                      soundEnabled = value;
                      _saveSettings();
                      if(soundEnabled){
                        _audioService.playAudio('audio/water.mp3');
                        }
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _restoreDefaults,
                  child: Text('Volver a configuración por defecto'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
              Center(
                child: Text(
                  '⚙️🦍',
                  style: TextStyle(fontSize: 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        content,
      ],
    );
  }
}
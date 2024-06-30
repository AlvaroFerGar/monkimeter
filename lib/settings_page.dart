import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart';

class AjustesPage extends StatefulWidget {
  @override
  _AjustesPageState createState() => _AjustesPageState();
}

class _AjustesPageState extends State<AjustesPage> {
  TextEditingController _countdownController = TextEditingController();
  TextEditingController _speakintervalController = TextEditingController();

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
      _countdownController.text = countdownStartValue.toString();
      _speakintervalController.text = speakInterval.toString();
    });
  }

  void _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('countdownStartValue', countdownStartValue);
    prefs.setInt('speakInterval', speakInterval);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             SizedBox(height: 20),
            Text(
              'Cuenta atrás',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextField(
              controller: _countdownController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Segundos',
              ),
              onChanged: (value) {
                setState(() {
                  countdownStartValue = int.tryParse(value) ?? 5;
                  _saveSettings();
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Intervalo de vocalización',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextField(
              controller: _speakintervalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Segundos',
              ),
              onChanged: (value) {
                setState(() {
                  speakInterval = int.tryParse(value) ?? 5;
                  _saveSettings();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

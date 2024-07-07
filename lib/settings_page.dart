import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart';
import 'audio_service.dart';
import 'manage_griptypes_page.dart';

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
    loadSettings();
    _countdownController.text = countdownStartValue.toString();
    _speakintervalController.text = speakInterval.toString();
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

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // El usuario debe tocar un botón para cerrar el diálogo
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Seguro que quieres eliminar el historial de datos?'),
                Text('🙈 Esta acción no se puede deshacer 🙈'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteDB();
              },
            ),
          ],
        );
      },
    );
  }

    void _deleteDB() {
      print("Aquí se borrará la DB");
  }

    Future<void> _addAgarre() async {
       await Navigator.push(context, MaterialPageRoute(builder: (context) => ManageGripsPage()),);
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
                    //backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _addAgarre,
                  child: Text('Añadir/quitar tipos de agarre'),
                  style: ElevatedButton.styleFrom(
                    //backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _showDeleteConfirmationDialog,
                  child: Text('Borrar histórico de cuelgues'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
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
      bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.timer),
                  label: 'Metromono',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.save),
                  label: 'Guardar',
                ),
              ],
              onTap: (index) {
                if (index == 0) {
                  Navigator.pushReplacementNamed(context, '/metromono');
                } else if (index == 1) {
                  Navigator.pushReplacementNamed(context, '/guardar_cuelgue');
                }
              },
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
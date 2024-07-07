import 'package:flutter/material.dart';
import 'package:monkimeter/globals.dart';

import 'metromono_page.dart';
import 'save_page.dart';
import 'settings_page.dart';

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
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
      routes: {
        '/metromono': (context) => MetromonoPage(),
        '/guardar_cuelgue': (context) => GuardarCuelguePage(),
        '/ajustes': (context) => AjustesPage(),
      },
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Se cargan en primer lugar los settings
    loadSettings();
    loadGripTypes();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildLogo(),
                          SizedBox(height: 30),
                          Text(
                            '🍌Monkimeter🍌',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                          SizedBox(height: 50),
                          _buildButton(context, 'Metromono', '/metromono', Icons.timer),
                          SizedBox(height: 16),
                          _buildButton(context, 'Guardar Cuelgue', '/guardar_cuelgue', Icons.save),
                          SizedBox(height: 16),
                          _buildButton(context, 'Ajustes', '/ajustes', Icons.settings),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      child: Image(
        image: AssetImage('assets/icon/icon.png'),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading image: $error');
          return Text('Failed to load image');
        },
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, String route, IconData icon) {
    return Container(
      width: 250,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(
          text,
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}
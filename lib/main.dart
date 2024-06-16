import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Monkimeter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/metromono');
              },
              child: Text(
                'Metromono',
                style: TextStyle(fontSize: 24), // Aumenta el tamaño del texto
              ),
            ),
            SizedBox(height: 20), // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/guardar_cuelgue');
              },
              child: Text(
                'Guardar Cuelgue',
                style: TextStyle(fontSize: 24), // Aumenta el tamaño del texto
              ),
            ),
            SizedBox(height: 20), // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/ajustes');
              },
              child: Text(
                'Ajustes',
                style: TextStyle(fontSize: 24), // Aumenta el tamaño del texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}

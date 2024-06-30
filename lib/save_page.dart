import 'package:flutter/material.dart';

class GuardarCuelguePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guardar Cuelgue'),
      ),
      body: Center(
        child: Text(
          'WIP\n Monos laburando 🔧🐵',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.timer),
          label: 'Metromono',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Ajustes',
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacementNamed(context, '/metromono');
        } else if (index == 1) {
          Navigator.pushReplacementNamed(context, '/ajustes');
        }
      },
    ),
    );
  }
}

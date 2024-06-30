import 'package:flutter/material.dart';

class GuardarCuelguePage extends StatefulWidget {
  @override
  _GuardarCuelguePageState createState() => _GuardarCuelguePageState();
}

class _GuardarCuelguePageState extends State<GuardarCuelguePage> {
  final TextEditingController _secondsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController(text: '0');
  int _selectedHandIndex = 1;
  String _selectedGrip = 'Barra';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guardar Cuelgue'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _secondsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Número de segundos',
                prefixIcon: Icon(Icons.timer),
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon:  Transform(
                        transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
                        alignment: Alignment.center,
                        child: Icon(Icons.pan_tool),
                      ),
                  onPressed: () {
                    setState(() {
                      _selectedHandIndex = 0;
                    });
                  },
                  color: _selectedHandIndex == 0 ? Colors.blue : Colors.grey,
                ),
                SizedBox(width: 16),
                IconButton(
                  icon: Row(
                        children: [
                          Transform(
                            transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
                            alignment: Alignment.center,
                            child: Icon(Icons.pan_tool),
                          ),
                          SizedBox(width: 5),    // Espacio entre los iconos
                          Icon(Icons.pan_tool)
                          
                          ]
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedHandIndex = 1;
                    });
                  },
                  color: _selectedHandIndex == 1 ? Colors.blue : Colors.grey,
                ),
                SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.pan_tool),
                  onPressed: () {
                    setState(() {
                      _selectedHandIndex = 2;
                    });
                  },
                  color: _selectedHandIndex == 2 ? Colors.blue : Colors.grey,
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.anchor),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Peso extra (kg)',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.panorama_horizontal),
                SizedBox(width: 10),
                Text(
                  'Tipo de agarre:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedGrip,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGrip = newValue!;
                    });
                  },
                  items: <String>['Barra', '4Fx40', '4Fx25', 'romo 22º', 'romo 12º']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _guardarDatos();
              },
              child: Text('Guardar'),
            ),
          ],
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

  void _guardarDatos() {
    int segundos = int.tryParse(_secondsController.text) ?? 0;
    int pesoExtra = int.tryParse(_weightController.text) ?? 0;

    print('Datos introducidos:');
    print('Número de segundos: $segundos');
    print('Mano seleccionada: ${_selectedHandIndex == 0 ? 'Mano Izquierda' : (_selectedHandIndex == 1 ? 'Ambas' : 'Mano Derecha')}');
    print('Peso extra: $pesoExtra kg');
    print('Tipo de agarre: $_selectedGrip');
  }
}

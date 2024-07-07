import 'package:flutter/material.dart';
import 'package:monkimeter/globals.dart';
import "package:monkimeter/database_helper.dart";
import "package:monkimeter/historical_datatable.dart";

class GuardarCuelguePage extends StatefulWidget {
  @override
  _GuardarCuelguePageState createState() => _GuardarCuelguePageState();
}

class _GuardarCuelguePageState extends State<GuardarCuelguePage> {
  final TextEditingController _secondsController = TextEditingController(text: lastSecondsInMonkimeter.toString());
  final TextEditingController _weightController = TextEditingController(text: '0');
  int _selectedHandIndex = 1;
  String _selectedGrip = 'Barra';
  List<Map<String, dynamic>> _recentCuelgues = [];

  @override
  void initState() {
    super.initState();
    _loadRecentCuelgues();
  }

  Future<void> _loadRecentCuelgues() async {
    String mano = _selectedHandIndex == 0 ? 'Izquierda' : (_selectedHandIndex == 1 ? 'Ambas' : 'Derecha');
    int pesoExtra = int.tryParse(_weightController.text) ?? 0;
    
    List<Map<String, dynamic>> cuelgues = await DatabaseHelper.instance.getRecentMatchingCuelgues(
      mano: mano,
      pesoExtra: pesoExtra,
      tipoAgarre: _selectedGrip,
      limit: 3
    );
    
    setState(() {
      _recentCuelgues = cuelgues;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guardar Cuelgue'),
              backgroundColor: Colors.blue,
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
                      _loadRecentCuelgues();
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
                      _loadRecentCuelgues();
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
                      _loadRecentCuelgues();
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
                    onChanged: (value) {
                      _loadRecentCuelgues();
                    },
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
                      _loadRecentCuelgues();
                    });
                  },
                  items: gripTypes
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _guardarDatos();
                    },
                    child: Text('Guardar'),
                  ),
                ),
                SizedBox(width: 10),
                Text('🧮🐒',style: TextStyle(fontSize: 30),),
                SizedBox(width: 10),
                ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoricalDataTable()),
                  );
                },
                  child: Text('Ver histórico'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Últimos cuelgues similares:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildRecentCuelguesList(),
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

  Widget _buildRecentCuelguesList() {
      if (_recentCuelgues.isEmpty) {
        return Text('No hay cuelgues recientes con esta configuración.');
      }
      
      return Column(
        children: _recentCuelgues.map((cuelgue) {
          return ListTile(
            title: Text('${cuelgue['segundos']} s - ${cuelgue['fecha']} ${cuelgue['hora']}'),
            //subtitle: Text('Peso extra: ${cuelgue['pesoExtra']} kg'),
          );
        }).toList(),
      );
    }

  Future<void> _guardarDatos() async {
    int segundos = int.tryParse(_secondsController.text) ?? 0;
    if(segundos<=0)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al guardar el cuelgue')));
      return;
    }
    int pesoExtra = int.tryParse(_weightController.text) ?? 0;
    String mano = _selectedHandIndex == 0 ? 'Izquierda' : (_selectedHandIndex == 1 ? 'Ambas' : 'Derecha');
    DateTime now = DateTime.now();
    String fecha = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    String hora = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

    print('Datos introducidos:');
    print('Número de segundos: $segundos');
    print('Mano seleccionada: $mano');
    print('Peso extra: $pesoExtra kg');
    print('Tipo de agarre: $_selectedGrip');
    print('Fecha: $fecha');
    print('Hora: $hora');
    print('===========');


     Map<String, dynamic> row = {
      'segundos': segundos,
      'mano': mano,
      'pesoExtra': pesoExtra,
      'tipoAgarre': _selectedGrip,
      'fecha': fecha,
      'hora': hora,
     };

     final id = await DatabaseHelper.instance.insertCuelgue(row);

     if (id > 0)
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cuelgue guardado con éxito')));
     else 
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al guardar el cuelgue')));


    print('\nHistórico de Cuelgues:');
    List<Map<String, dynamic>> cuelgues = await DatabaseHelper.instance.getCuelgues();
    for (var cuelgue in cuelgues) {
      print('Fecha: ${cuelgue['fecha']}, Hora: ${cuelgue['hora']}, Segundos: ${cuelgue['segundos']}, Mano: ${cuelgue['mano']}, Peso Extra: ${cuelgue['pesoExtra']}kg, Tipo de Agarre: ${cuelgue['tipoAgarre']}');
    }
      print('===========');

    await _loadRecentCuelgues();
  }
}

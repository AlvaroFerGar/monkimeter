import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class ManageGripsPage extends StatefulWidget {
  @override
  _ManageGripsPageState createState() => _ManageGripsPageState();
}

class _ManageGripsPageState extends State<ManageGripsPage> {
  final TextEditingController _controller = TextEditingController();

  void _addGripType() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        globals.gripTypes.add(_controller.text);
        _controller.clear();
      }
    });
  }

  void _removeGripType(int index) {
    if (globals.gripTypes.length > 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmar eliminación'),
            content: Text('¿Estás seguro de que quieres eliminar este agarre?🙊'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    globals.gripTypes.removeAt(index);
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Eliminar'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No puedes eliminar el último tipo de agarre.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tipos de agarre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nuevo agarre',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addGripType,
              child: Text('Añadir nuevo agarre'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: globals.gripTypes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(globals.gripTypes[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeGripType(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

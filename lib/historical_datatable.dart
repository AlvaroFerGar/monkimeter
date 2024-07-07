import 'package:flutter/material.dart';
import 'package:monkimeter/database_helper.dart';
import 'dart:math' as math;



class HistoricalDataTable extends StatefulWidget {
  @override
  _HistoricalDataTableState createState() => _HistoricalDataTableState();
}

class _HistoricalDataTableState extends State<HistoricalDataTable> {
  List<Map<String, dynamic>> _data = [];
  int _rowsPerPage = 10;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await DatabaseHelper.instance.getCuelgues();
    setState(() {
      _data = data;
    });
  }

  void _sort<T>(Comparable<T> Function(Map<String, dynamic> d) getField, int columnIndex, bool ascending) {
    _data.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return AppBar(
              title: Text(
                orientation == Orientation.portrait
                    ? 'Gira el dispositivo'
                    : 'Histórico de Cuelgues',
              ),
              actions: orientation == Orientation.portrait
                  ? [
                      IconButton(
                        icon: Icon(Icons.screen_rotation),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Gira tu dispositivo para una mejor visualización'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ]
                  : null,
            );
          },
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.screen_rotation, size: 50),
                  SizedBox(height: 20),
                  Text(
                    'Gira tu dispositivo para ver la tabla completa',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  Transform.rotate(
                    angle: -math.pi / 2,  // Rotación de 90 grados en sentido horario
                    child: Text(
                      '🦧',  // Emoji de orangután
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return _data.isEmpty
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: PaginatedDataTable(
                      header: Text('Registros de Cuelgues'),
                      rowsPerPage: _rowsPerPage,
                      onRowsPerPageChanged: (value) {
                        setState(() {
                          _rowsPerPage = value!;
                        });
                      },
                      sortColumnIndex: _sortColumnIndex,
                      sortAscending: _sortAscending,
                      columns: [
                        DataColumn(
                          label: Text('Fecha'),
                          onSort: (columnIndex, ascending) =>
                              _sort<String>((d) => d['fecha'], columnIndex, ascending),
                        ),
                        DataColumn(
                          label: Text('Hora'),
                          onSort: (columnIndex, ascending) =>
                              _sort<String>((d) => d['hora'], columnIndex, ascending),
                        ),
                        DataColumn(
                          label: Text('Segundos'),
                          numeric: true,
                          onSort: (columnIndex, ascending) =>
                              _sort<num>((d) => d['segundos'], columnIndex, ascending),
                        ),
                        DataColumn(label: Text('Mano')),
                        DataColumn(
                          label: Text('Peso Extra'),
                          numeric: true,
                          onSort: (columnIndex, ascending) =>
                              _sort<num>((d) => d['pesoExtra'], columnIndex, ascending),
                        ),
                        DataColumn(label: Text('Tipo Agarre')),
                      ],
                      source: _DataSource(context, _data),
                   ),
                  );
                }
              },
             ),
          );
         }
}

class _DataSource extends DataTableSource {
  final BuildContext context;
  final List<Map<String, dynamic>> _data;

  _DataSource(this.context, this._data);

  @override
  DataRow getRow(int index) {
    final item = _data[index];
    return DataRow(
      cells: [
        DataCell(Text(item['fecha'])),
        DataCell(Text(item['hora'])),
        DataCell(Text(item['segundos'].toString())),
        DataCell(Text(item['mano'])),
        DataCell(Text(item['pesoExtra'].toString())),
        DataCell(Text(item['tipoAgarre'])),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}
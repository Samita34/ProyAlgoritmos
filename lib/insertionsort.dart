import 'dart:math';

import 'package:flutter/material.dart';

class InsertionSortScreen extends StatefulWidget {
  @override
  _InsertionSortScreenState createState() => _InsertionSortScreenState();
}

class _InsertionSortScreenState extends State<InsertionSortScreen> {
  final _formKey = GlobalKey<FormState>();
  List<int> _unsortedList = [];
  List<int>? _sortedList;
  Stopwatch _stopwatch = Stopwatch();
  TextEditingController campo=TextEditingController();
  List<int> _generarArrayAleatorio(int cantidad) {
    Random rng = Random();
    return List<int>.generate(cantidad, (i) => rng.nextInt(100));
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insertion Sort Resultado'),
      ),
      body: Center(
        child: _sortedList == null
            ? Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Ingrese un número'),
                      keyboardType: TextInputType.number,
                      controller: campo,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese un número';
                        }
                        final n = int.tryParse(value);
                        if (n == null) {
                          return 'Por favor, ingrese un número válido';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _unsortedList.add(int.parse(value!));
                        campo.clear();
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() {
                            // Agregado manualmente a la lista, no se genera automáticamente
                          });
                        }
                      },
                      child: Text('Agregar a la lista'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_unsortedList.isNotEmpty) {
                          setState(() {
                            _startSorting();
                          });
                        }
                      },
                      child: Text('Ordenar lista'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                          setState(() {
                            _unsortedList = _generarArrayAleatorio(int.parse(campo.text));
                            _startSorting();
                          });
                      },
                      child: Text('Generar lista aleatorea'),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lista antes de ordenar:'),
                  Text(_unsortedList.toString()),
                  SizedBox(height: 20),
                  Text('Lista después de ordenar:'),
                  Text(_sortedList!.toString()),
                  SizedBox(height: 20),
                  Text('Tiempo transcurrido:'),
                  Text('${(_stopwatch.elapsedMilliseconds / 1000).toStringAsFixed(4)} segundos'),
                ],
              ),
      ),
    );
  }

  void _startSorting() {
    _sortedList = null;
    _stopwatch.reset();
    _stopwatch.start();
    _insertionSort();
  }

  void _insertionSort() async {
    _sortedList = List<int>.from(_unsortedList);
    for (int i = 1; i < _sortedList!.length; i++) {
      int key = _sortedList![i];
      int j = i - 1;

      while (j >= 0 && _sortedList![j] > key) {
        _sortedList![j + 1] = _sortedList![j];
        j--;
      }

      _sortedList![j + 1] = key;

      await Future.delayed(Duration(milliseconds: 100));
      setState(() {});
    }
    _stopwatch.stop();
  }
}
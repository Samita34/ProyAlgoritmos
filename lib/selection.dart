import 'package:flutter/material.dart';
import 'dart:math';
class SelectionSortScreen extends StatefulWidget {
  @override
  _SelectionSortScreenState createState() => _SelectionSortScreenState();
}

class _SelectionSortScreenState extends State<SelectionSortScreen> {
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
        title: Text('Selection Sort Resultado'),
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
    _selectionSort();
  }

  void _selectionSort() async {
    _sortedList = List<int>.from(_unsortedList);
    for (int i = 0; i < _sortedList!.length - 1; i++) {
      int minIndex = i;
      for (int j = i + 1; j < _sortedList!.length; j++) {
        if (_sortedList![j] < _sortedList![minIndex]) {
          minIndex = j;
        }
      }
      if (minIndex != i) {
        int temp = _sortedList![i];
        _sortedList![i] = _sortedList![minIndex];
        _sortedList![minIndex] = temp;
      }
      await Future.delayed(Duration(milliseconds: 100));
      setState(() {});
    }
    _stopwatch.stop();
  }
}

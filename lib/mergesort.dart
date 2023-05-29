import 'dart:math';

import 'package:flutter/material.dart';

class MergeSortScreen extends StatefulWidget {
  @override
  _MergeSortScreenState createState() => _MergeSortScreenState();
}

class _MergeSortScreenState extends State<MergeSortScreen> {
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
        title: Text('Merge Sort Resultado'),
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
    _mergeSort().then((_) {
      _stopwatch.stop();
      setState(() {});
    });
  }

  Future<void> _mergeSort() async {
    _sortedList = List<int>.from(_unsortedList);
    await mergeSort(_sortedList!, 0, _sortedList!.length - 1);
  }

  Future<void> mergeSort(List<int> list, int low, int high) async {
    if (low < high) {
      int mid = (low + high) ~/ 2;
      await mergeSort(list, low, mid);
      await mergeSort(list, mid + 1, high);
      await merge(list, low, mid, high);
    }
  }

  Future<void> merge(List<int> list, int low, int mid, int high) async {
    int n1 = mid - low + 1;
    int n2 = high - mid;

    List<int> left = List<int>.filled(n1, 0);
    List<int> right = List<int>.filled(n2, 0);

    for (int i = 0; i < n1; i++) {
      left[i] = list[low + i];
    }
    for (int j = 0; j < n2; j++) {
      right[j] = list[mid + 1 + j];
    }

    int i = 0, j = 0, k = low;

    while (i < n1 && j < n2) {
      if (left[i] <= right[j]) {
        list[k] = left[i];
        i++;
      } else {
        list[k] = right[j];
        j++;
      }
      k++;
      await Future.delayed(Duration(milliseconds: 100));
      setState(() {});
    }

    while (i < n1) {
      list[k] = left[i];
      i++;
      k++;
      await Future.delayed(Duration(milliseconds: 100));
      setState(() {});
    }

    while (j < n2) {
      list[k] = right[j];
      j++;
      k++;
      await Future.delayed(Duration(milliseconds: 100));
      setState(() {});
    }
  }
}
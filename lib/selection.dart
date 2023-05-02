import 'package:flutter/material.dart';
import 'dart:math';

class SelectionSortScreen extends StatefulWidget {
  @override
  _SelectionSortScreenState createState() => _SelectionSortScreenState();
}

class _SelectionSortScreenState extends State<SelectionSortScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _cantidad;
  List<int>? _unsortedList;
  List<int>? _sortedList;
  Duration? _elapsedTime;

  List<int> _generarArrayAleatorio(int cantidad) {
    Random rng = Random();
    return List<int>.generate(cantidad, (i) => rng.nextInt(100));
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
                      decoration: InputDecoration(labelText: 'Cantidad de elementos'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese un número';
                        }
                        final n = int.tryParse(value);
                        if (n == null || n <= 0) {
                          return 'Por favor, ingrese un número válido';
                        }
                        return null;
                      },
                      onSaved: (value) => _cantidad = int.parse(value!),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() {
                            _unsortedList = _generarArrayAleatorio(_cantidad!);
                            Stopwatch stopwatch = Stopwatch()..start();
                            _sortedList = selectionSort(List<int>.from(_unsortedList!)); // crear una copia del array para evitar modificar el original
                            stopwatch.stop();
                            _elapsedTime = stopwatch.elapsed;
                          });
                        }
                      },
                      child: Text('Generar y ordenar array'),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Array antes de ordenar:'),
                  Text(_unsortedList!.toString()),
                  SizedBox(height: 20),
                  Text('Array después de ordenar:'),
                  Text(_sortedList!.toString()),
                  SizedBox(height: 20),
                  Text('Tiempo transcurrido:'),
                  Text('${(_elapsedTime!.inMicroseconds / 1000000).toStringAsFixed(4)} segundos'),
                ],
              ),
      ),
    );
  }

  List<int> selectionSort(List<int> list) {
    list = List<int>.from(list); // crear una copia del array para evitar modificar el original
    for (int i = 0; i < list.length - 1; i++) {
      int minIndex = i;
      for (int j = i + 1; j < list.length; j++) {
        if (list[j] < list[minIndex]) {
          minIndex = j;
        }
      }
      int temp = list[i];
      list[i] = list[minIndex];
      list[minIndex] = temp;
    }
    return list;
  }
}




/*
class Selection {
  selection(List<List<String>> matrix) {
    List<int> result = [];

    for (int i = 1; i < matrix.length; i++) {
      for (int j = 1; j < matrix.length; j++) {
        result.add(int.parse(matrix[i][j]));
      }
    }

    selectionSort(result);

    return result;
  }

  void selectionSort(List<int> arr) {
    int n = arr.length;

    for (int i = 0; i < n - 1; i++) {
      int minIndex = i;
      for (int j = i + 1; j < n; j++) {
        if (arr[j] < arr[minIndex]) {
          minIndex = j;
        }
      }

      if (minIndex != i) {
        int temp = arr[i];
        arr[i] = arr[minIndex];
        arr[minIndex] = temp;
      }
    }
  }
}
*/
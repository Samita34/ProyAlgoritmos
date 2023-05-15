import 'package:flutter/material.dart';
import 'dart:math';

class ShellSortScreen extends StatefulWidget {
  @override
  _ShellSortScreenState createState() => _ShellSortScreenState();
}

class _ShellSortScreenState extends State<ShellSortScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _cantidad;
  List<int>? _arr;
  List<int>? _sortedArr;
  Duration? _elapsedTime;

  List<int> _generarArrayAleatorio(int cantidad) {
    Random rng = Random();
    return List<int>.generate(cantidad, (i) => rng.nextInt(100));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shell Sort Resultado'),
      ),
      body: Center(
        child: _sortedArr == null
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
                            _arr = _generarArrayAleatorio(_cantidad!);
                            Stopwatch stopwatch = Stopwatch()..start();
                            _sortedArr = shellSort(_arr!);
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
                  Text(_arr.toString()),
                  SizedBox(height: 20),
                  Text('Array después de ordenar:'),
                  Text(_sortedArr.toString()),
                  SizedBox(height: 20),
                  Text('Tiempo transcurrido:'),
                  Text('${(_elapsedTime!.inMicroseconds / 1000000).toStringAsFixed(4)} segundos'),
                ],
              ),
      ),
    );
  }

  List<int> shellSort(List<int> arr) {
    int n = arr.length;

    // Definir secuencia de brechas
    List<int> gaps = [];
    int gap = n ~/ 2;
    while (gap > 0) {
      gaps.add(gap);
      gap = gap ~/ 2;
    }

    // Aplicar inserción por brecha a cada brecha
    for (int gap in gaps) {
      for (int i = gap; i < n; i++) {
        int temp = arr[i];
        int j = i;
        while (j >= gap && arr[j - gap] > temp) {
          arr[j] = arr[j - gap];
          j -= gap;
        }
        arr[j] = temp;
      }
    }
    return arr;
  }
}
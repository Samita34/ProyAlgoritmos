import 'package:flutter/material.dart';
import 'dart:math';
class InsertScreen extends StatefulWidget {
  @override
  _InsertScreenState createState() => _InsertScreenState();
}
class _InsertScreenState extends State<InsertScreen> {
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
        title: Text('Insert Sort'),
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
                            print(_arr);
                            _sortedArr = insertionSort(_arr!);
                            print(_arr);
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
}

List<int> insertionSort(List<int> arrinput) {
  List<int> arr = [...arrinput];
  for (int i = 1; i < arr.length; i++) {
    int key = arr[i];
    int j = i - 1;
    while (j >= 0 && arr[j] > key) {
      arr[j + 1] = arr[j];
      j--;
    }
    arr[j + 1] = key;
  }

  return arr;
}

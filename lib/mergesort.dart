import 'package:flutter/material.dart';
import 'dart:math';
class MergeSortScreen extends StatefulWidget {
  @override
  _MergeSortScreenState createState() => _MergeSortScreenState();
}

class _MergeSortScreenState extends State<MergeSortScreen> {
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
        title: Text('Merge Sort Resultado'),
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
                            _sortedArr = mergeSort(_arr!);
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

  // Aquí puedes colocar las funciones mergeSort y merge que proporcioné en respuestas anteriores
}


  List<int> _generarArrayAleatorio(int cantidad) {
  Random rng = Random();
  List<int> arr = List<int>.generate(cantidad, (i) => rng.nextInt(100));
  return arr;
}

List<int> mergeSort(List<int> arr) {
  if (arr.length <= 1) {
    return arr;
  }

  int mid = (arr.length / 2).floor();
  List<int> left = arr.sublist(0, mid);
  List<int> right = arr.sublist(mid);

  return merge(mergeSort(left), mergeSort(right));
}

List<int> merge(List<int> left, List<int> right) {
  List<int> result = [];

  while (left.isNotEmpty && right.isNotEmpty) {
    if (left.first <= right.first) {
      result.add(left.removeAt(0));
    } else {
      result.add(right.removeAt(0));
    }
  }

  // Si uno de los dos subarrays no está vacío, agrega los elementos restantes al resultado
  while (left.isNotEmpty) {
    result.add(left.removeAt(0));
  }
  while (right.isNotEmpty) {
    result.add(right.removeAt(0));
  }

  return result;
}// Aquí puedes colocar las funciones mergeSort y merge que proporcioné en respuestas anteriores


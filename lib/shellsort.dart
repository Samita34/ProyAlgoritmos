import 'package:flutter/material.dart';

class ShellSortScreen extends StatefulWidget {
  @override
  _ShellSortScreenState createState() => _ShellSortScreenState();
}

class _ShellSortScreenState extends State<ShellSortScreen> {
  final _formKey = GlobalKey<FormState>();
  List<int> _unsortedList = [];
  List<int>? _sortedList;
  Stopwatch _stopwatch = Stopwatch();

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shell Sort Resultado'),
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
    _shellSort();
  }

  void _shellSort() async {
    _sortedList = List<int>.from(_unsortedList);
    int n = _sortedList!.length;
    for (int gap = n ~/ 2; gap > 0; gap ~/= 2) {
      for (int i = gap; i < n; i++) {
        int temp = _sortedList![i];
        int j;
        for (j = i; j >= gap && _sortedList![j - gap] > temp; j -= gap) {
          _sortedList![j] = _sortedList![j - gap];
        }
        _sortedList![j] = temp;
      }
      await Future.delayed(Duration(milliseconds: 100));
      setState(() {});
    }
    _stopwatch.stop();
  }
}

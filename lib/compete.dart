import 'package:flutter/material.dart';

class CompeteScreen extends StatefulWidget {
  @override
  _CompeteScreenState createState() => _CompeteScreenState();
}

class _CompeteScreenState extends State<CompeteScreen> {
  final _formKey = GlobalKey<FormState>();
  List<double> _unsortedList = [];
  List<double>? _sortedList;
  Stopwatch _stopwatch = Stopwatch();
  TextEditingController xController = TextEditingController();
  TextEditingController yController = TextEditingController();
  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Algoritmo Compet'),
      ),
      body: Center(
        child: _sortedList == null
            ? Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Coordenada X'),
                      keyboardType: TextInputType.number,
                      controller: xController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese un número';
                        }
                        final x = double.tryParse(value);
                        if (x == null) {
                          return 'Por favor, ingrese un número válido';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Coordenada Y'),
                      keyboardType: TextInputType.number,
                      controller: yController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese un número';
                        }
                        final y = double.tryParse(value);
                        if (y == null) {
                          return 'Por favor, ingrese un número válido';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() {
                            _unsortedList.add(double.parse(xController.text));
                            _unsortedList.add(double.parse(yController.text));
                            xController.clear();
                            yController.clear();
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
                      child: Text('Algoritmo Compete GO!'),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lista de coordenadas dadas:'),
                  Text(_unsortedList.toString()),
                  SizedBox(height: 20),
                  Text('Coordenadas resultado:'),
                  Text(_sortedList!.toString()),
                  SizedBox(height: 20),
                  Text('Tiempo transcurrido:'),
                  Text(
                      '${(_stopwatch.elapsedMilliseconds / 1000).toStringAsFixed(4)} segundos'),
                ],
              ),
      ),
    );
  }

  void _startSorting() {
    _sortedList = null;
    _stopwatch.reset();
    _stopwatch.start();
    _comp();
  }

  void _comp() async {
  _sortedList = List<double>.from(_unsortedList);
  double auxX = _sortedList![0];
  double auxY = _sortedList![1];
  while(true){
    auxX = _sortedList![0];
    auxY = _sortedList![1];
    for (int k = 0; k < _sortedList!.length - 3; k += 2) {
      _sortedList![k] = (_sortedList![k] + _sortedList![k + 2]) / 2;
      _sortedList![k + 1] = (_sortedList![k + 1] + _sortedList![k + 3]) / 2;
    }
    _sortedList![_sortedList!.length - 2] = (_sortedList![_sortedList!.length - 2] + auxX) / 2;
    _sortedList![_sortedList!.length-1] = (_sortedList![_sortedList!.length-1] + auxY) / 2;
    if(_sortedList![0]==_sortedList![_sortedList!.length-2])break;
  }
  _stopwatch.stop();
}

}

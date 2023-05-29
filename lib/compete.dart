import 'package:flutter/material.dart';

class CompetSortScreen extends StatefulWidget {
  @override
  _CompetScreenState createState() => _CompetScreenState();
}

class _CompetScreenState extends State<CompetSortScreen> {
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
                  Text('Lista antes de ordenar:'),
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
    _sortedList = [];
    double sumX = 0;
    double sumY = 0;

    for (int i = 0; i < _unsortedList.length; i += 2) {
      sumX += _unsortedList[i];
      sumY += _unsortedList[i + 1];
    }

    double centroidX = sumX / (_unsortedList.length / 2);
    double centroidY = sumY / (_unsortedList.length / 2);
    _sortedList?.add(centroidX);
    _sortedList?.add(centroidY);
    _stopwatch.stop();
  }
}

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
                  CustomPaint(
                    size: Size(300, 300),
                    painter: CoordinatePainter(_unsortedList,_sortedList!),
                  ),
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

class CoordinatePainter extends CustomPainter {
  final List<double> unsortedCoordinates;
  final List<double> sortedCoordinates;

  CoordinatePainter(this.unsortedCoordinates, this.sortedCoordinates);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Dibujar unsortedCoordinates
    _drawPoints(canvas, unsortedCoordinates, centerX, centerY, paint);

    paint.color = Colors.red;

    // Dibujar sortedCoordinates
    _drawPoints(canvas, sortedCoordinates, centerX, centerY, paint);

    paint.color = Colors.green;

    // Dibujar líneas conectando los puntos de sortedCoordinates
    _drawLines(canvas, sortedCoordinates, centerX, centerY, paint);
  }

  void _drawPoints(Canvas canvas, List<double> coordinates, double centerX, double centerY, Paint paint) {
    for (int i = 0; i < coordinates.length; i += 2) {
      final x = coordinates[i];
      final y = coordinates[i + 1];
      final pointX = centerX + x * 10;
      final pointY = centerY + y * 10;
      canvas.drawCircle(Offset(pointX, pointY), 5, paint);
    }
  }

  void _drawLines(Canvas canvas, List<double> coordinates, double centerX, double centerY, Paint paint) {
    for (int i = 0; i < coordinates.length - 2; i += 2) {
      final startX = centerX + coordinates[i] * 10;
      final startY = centerY + coordinates[i + 1] * 10;
      final endX = centerX + coordinates[i + 2] * 10;
      final endY = centerY + coordinates[i + 3] * 10;
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

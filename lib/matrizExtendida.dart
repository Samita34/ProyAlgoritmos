import 'package:flutter/material.dart';

class matrizExtendida extends StatefulWidget {
  final List<List<String>> matrizAdyacencia;
  final sumt;
  const matrizExtendida(this.matrizAdyacencia, this.sumt, {Key? key})
      : super(key: key);
  @override
  State<matrizExtendida> createState() =>
      _matrizExtendidaState(matrizAdyacencia, sumt);
}

class _matrizExtendidaState extends State<matrizExtendida> {
  final List<List<String>> matrizAdyacencia;
  final sumt;
  _matrizExtendidaState(this.matrizAdyacencia, this.sumt);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Matriz de adyacencia"),
      ),
      body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFF2D2D34),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Table(
              border: TableBorder.all(color: Colors.grey),
              children: matrizAdyacencia.map((row) {
                return TableRow(
                  children: row.map((cell) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF3C3C9D),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        cell.toString(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
            Text(
              "Sumatoria: $sumt",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ])),
    );
  }
}

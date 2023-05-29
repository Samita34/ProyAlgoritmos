import 'package:flutter/material.dart';

class matnor extends StatefulWidget {
  final List<List<String>> matriznor;
  final List<List<String>> matrizini;
  final int sum;
  const matnor(this.matrizini, this.matriznor, this.sum, {Key? key})
      : super(key: key);

  @override
  State<matnor> createState() => _matnorState(matrizini, matriznor, sum);
}

class _matnorState extends State<matnor> {
  final List<List<String>> matriznor;
  final List<List<String>> matrizini;
  final int sum;
  _matnorState(this.matrizini, this.matriznor, this.sum);
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
            children: matriznor.asMap().entries.map((entry) {
              int rowIndex = entry.key;
              List<String> rowValues = entry.value;
              return TableRow(
                children: rowValues.asMap().entries.map((entry) {
                  int colIndex = entry.key;
                  String cellValue = entry.value;
                  if (colIndex == 0 || rowIndex == 0) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF3C3C9D),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        cellValue,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
// Obtener el valor correspondiente en la matrizini
                    String iniValue = matrizini[colIndex - 1][rowIndex - 1];
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF3C3C9D),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.all(4),
                      child: Stack(
                        children: [
                          Table(
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    child: SizedBox(width: 0, height: 0),
                                  ),
                                  TableCell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        iniValue,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TableCell(
                            child: Text(
                              cellValue,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }).toList(),
              );
            }).toList(),
          ),
          Text(
            "Total: ${sum}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          )
        ]),
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'arbol.dart';
import 'arbolPainter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ArbolesBinariosScreen extends StatefulWidget {
  @override
  _ArbolesBinariosScreenState createState() => _ArbolesBinariosScreenState();
}

class _ArbolesBinariosScreenState extends State<ArbolesBinariosScreen> {
  // Implementa el estado de tu pantalla aquí
  Arbol objArbol = Arbol();
  final _textFieldController = TextEditingController();
  var _dato;

  late ArbolPainter _painter;
  @override
  void initState() {
    super.initState();
    _painter = ArbolPainter(objArbol);
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(),
      appBar: AppBar(
        title: Text('Arboles Binarios Resultado'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 60,
                  width: 60,
                ),
                Center(
                  child: Text(
                    "Arboles Binarios",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 10,
                  width: 10,
                ),
                Container(
                  child: CustomPaint(
                    painter: _painter,
                    size: Size(MediaQuery.of(context).size.width, 250),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    controller: _textFieldController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Ingresa un número",
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CupertinoButton(
                            padding: EdgeInsets.all(5),
                            color: Color(0xff3282b8),
                            onPressed: () {
                              setState(() {
                                _dato = _textFieldController.text;
                                objArbol.insertarNodo(int.parse(_dato));
                                _textFieldController.text = "";
                              });
                            },
                            child: Text(
                              "Agregar",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xfffff5a5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CupertinoButton(
                            padding: EdgeInsets.all(5),
                            color: Color(0xffff6464),
                            onPressed: () {
                              setState(() {
                                // Eliminar
                              });
                            },
                            child: Text(
                              "Eliminar",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xfffff5a5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      objArbol.resetArbol();
                    });
                  },
                  child: Text(
                    "Resetear Arbol",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _ingresoListaDialog(context);
                      setState(() {});
                    });
                  },
                  child: Text(
                    "Ingrese las listas",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                ),
                SpeedDial(
                  animatedIcon: AnimatedIcons.menu_home,
                  mini: true,
                  childrenButtonSize: const Size(50.0, 50.0),
                  children: [
                    SpeedDialChild(
                      child: Icon(Icons.linear_scale),
                      label: 'PreOrder',
                      onTap: () {
                        _showDialogPre();
                      },
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.linear_scale),
                      label: 'PosOrder',
                      onTap: () {
                        _showDialogPost();
                      },
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.linear_scale),
                      label: 'InOrder',
                      onTap: () {
                        _showDialogIn();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialogIn() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('InOrder'),
          content: Text(objArbol.inOrder(objArbol.raiz)),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogPost() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('PostOrder'),
          content: Text(objArbol.postOrder(objArbol.raiz)),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogPre() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('PreOrder'),
          content: Text(objArbol.preOrder(objArbol.raiz)),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _ingresoListaDialog(context) {
    TextEditingController text1Controller = TextEditingController();
    TextEditingController text2Controller = TextEditingController();
    TextEditingController text3Controller = TextEditingController();

    int selectedOption = 1;

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setStatem) {
            return AlertDialog(
              title: const Text("Ingrese las listas (Separada por comas)"),
              content: Form(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: text1Controller,
                    decoration: const InputDecoration(
                      labelText: 'Numero de Elementos',
                    ),
                  ),
                  TextField(
                    controller: text2Controller,
                    decoration: const InputDecoration(
                      labelText: 'InOrden',
                    ),
                  ),
                  TextField(
                    controller: text3Controller,
                    decoration: const InputDecoration(
                      labelText: 'Lista a Elección',
                    ),
                  ),
                  RadioListTile(
                    title: const Text('PreOrder'),
                    value: 1,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setStatem(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('PostOrder'),
                    value: 2,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setStatem(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                ],
              )),
              actions: [
                TextButton(
                  onPressed: () {
                    String text1 = text1Controller.text;
                    text1 = text1.isEmpty ? "." : text1;

                    //listToTree(selectedOption, text1);
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: Text('Cls'),
                ),
   TextButton(
  onPressed: () {
    String text1 = text1Controller.text;
    String text2 = text2Controller.text;
    String text3 = text3Controller.text;

    text1 = text1.isEmpty ? "." : text1;

    // Convertimos los campos de texto a listas de enteros
    List<int> list2 = text2.split(',').map((str) => int.parse(str.trim())).toList();
    List<int> list3 = text3.split(',').map((str) => int.parse(str.trim())).toList();

    // Verificamos si las listas tienen el mismo número de elementos que el valor indicado en text1
    int numberOfElements = int.parse(text1);
    if (list2.length != numberOfElements || list3.length != numberOfElements) {
      print("Las listas deben tener $numberOfElements elementos cada una.");
      return;
    }

    // Verificamos si todos los elementos son únicos en las listas
    if (list2.toSet().length != list2.length || list3.toSet().length != list3.length) {
      print("Los números en las listas deben ser únicos y no deben repetirse.");
      return;
    }

    // Comprobamos si todos los elementos de list3 están presentes en list2
    if (!list2.toSet().containsAll(list3.toSet())) {
      print("Todos los elementos en 'Lista a Elección' deben estar presentes en 'InOrden'.");
      return;
    }

    listToTree(selectedOption,numberOfElements,list2,list3);
    
    setState(() {});
    Navigator.of(context).pop();
  },
  child: Text('OK'),
),
              ],
            );
          });
        });
  }

  listToTree(int order, int n, List<int> list1, List<int> list2) {
    List<int> arbolList = [];


    if (order == 1) {

  List<List<String>> matrix = List.generate(list1.length, (_) => List.filled(list2.length, "0"));

  for (int i = 0; i < list1.length; i++) {
    for (int j = 0; j < list2.length; j++) {
      if (list1[i] == list2[j]) {
        matrix[i][j] = "*";
      }
    }
  }
  for (List<String> row in matrix) {
    print(row);
  }
    }
    if (order == 2) {
      
    }

  }
}




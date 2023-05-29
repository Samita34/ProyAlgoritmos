import 'package:flutter/cupertino.dart';
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
      backgroundColor: Color(0xff071e3d),
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
                    "Arbol Binario de Busqueda",
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
                    style: TextStyle(color: Colors.white),
                    controller: _textFieldController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Ingresa un número",
                      hintStyle: TextStyle(color: Colors.white),
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
                SpeedDial(
                  animatedIcon: AnimatedIcons.menu_home,
                  mini: true,
                  childrenButtonSize: const Size(50.0, 50.0),
                  children: [
                    SpeedDialChild(
                      child: Icon(Icons.linear_scale),
                      label: 'Preorder',
                      onTap: () {},
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.linear_scale),
                      label: 'Posorder',
                      onTap: () {},
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.linear_scale),
                      label: 'Inorder',
                      onTap: () {},
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
}

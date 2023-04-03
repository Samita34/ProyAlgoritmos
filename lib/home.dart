import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'modelos.dart';
import 'figura.dart';
//import 'help.dart';
import 'matriz.dart';

class Myhome extends StatefulWidget {
  const Myhome({Key? key}) : super(key: key);

  //Nos envía a _MyhomeState
  @override
  State<Myhome> createState() => _MyhomeState();
}

class _MyhomeState extends State<Myhome> {
  //Variable que recibe el valor de los mensajes

  TextEditingController receptorMensaje = TextEditingController();
  /*Variable para controlar el modo:
  * Modo=1 : Crear Nodo
  * Modo=2 : Crear Conexión entre nodos
  * Modo=3 : Eliminar Nodo
  * Modo=4 : Mover Nodo
  * */
  int modo = -1;
  //Variable que cuenta la cantidad de nodos
  int contadorNodos = 1;
  /*
  *  Variables que almacenan la posición donde se hace un toque
  * (x,y) variables que detectan el toque
  * (xi,yi) y (xf,yf) Son variables que solo se utilizan para la creación del boceto,
  * el cual solo se utiliza en el modo 2, es la linea que une los grafos, una vez
  * termina el proceso de unión de grafos, estas variables son 0
   */
  double x = 0, y = 0, xi = 0, xf = 0, yi = 0, yf = 0;
  /*
  * Variable booleana que solo se utiliza en modo 2, nos dice si el primer toque fue realizado en un nodo,
  * True = El primer toque cae en un nodo
  * False = El primer toque no cae en un nodo
   */
  bool flagBoceto = false;
  //Variable Auxiliar que almacena un nodo
  ModeloNodo nodoAux = new ModeloNodo(0, 0, 0, "", "", false);
  //Variable Auxiliar que almacena una Linea
  late ModeloLinea lineaAux;
  //Lista de Nodos
  List<ModeloNodo> vNodo = [];
  //Lista de Lineas
  List<ModeloLinea> vLineas = [];
  //Lista auxiliar para remover lineas
  List<ModeloLinea> vLineasRemove = [];

  @override
  Widget build(BuildContext context) {
    //Aplicación
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //backgroundColor: Color.fromARGB(255, 168, 255, 251),
        backgroundColor: Color(0xFF2D2D34),
        //Pila que almacena todos los objetos
        body: Stack(
          children: [
            //Dibuja todos los bocetos
            CustomPaint(
              painter: boceto(Modeloboceto(xi, yi, xf, yf)),
            ),
            //Dibuja todas las lineas
            CustomPaint(
              painter: Lineas(vLineas),
            ),
            //Dibuja todos los Nodos
            CustomPaint(
              painter: Nodos(vNodo),
            ),
            //Detector de toques en la pantalla
            GestureDetector(
              /*
              * onPan es un atributo de GestureDetector que reconoce el moviento arrastrado, usaremos:
              * onPanStart, onPanUpdate y onPanEnd
              * onPanStart detecta donde inicio el arrastre, este dato esta almacenado en la variable pos
               */
              onPanStart: (pos) {
                // dividimos la variable pos en 2 => (x,y)
                x = pos.globalPosition.dx;
                y = pos.globalPosition.dy;
                //Si modo = 2, o sea el modo de unir dos nodos
                if (modo == 2) {
                  //forEach que recorre toda la lista de Nodos, y almancena el nodo en la variable e
                  vNodo.forEach((e) {
                    //Si la posición inicial cae en un nodo, entramos al if
                    if (x < (e.x + e.radio) &&
                        x > (e.x - e.radio) &&
                        y < (e.y + e.radio) &&
                        y > (e.y - e.radio)) {
                      //flagBoceto en true ya que reconoció un nodo inicial
                      flagBoceto = true;
                      /*
                       * Cambio de color del nodo
                       * True=Rojo
                       * False=Azul
                       */
                      e.color = true;
                      //Almancena el nodo inicial en la variable nodoAux
                      nodoAux = e;
                      //Almacena la posición inicial en (xi,yi)
                      xi = x;
                      yi = y;
                      //El metodo setState actualiza todos los valores para la pantalla
                      setState(() {});
                    }
                  });
                }
                //Si modo = 4, o sea el modo de Mover Nodo
                else if (modo == 4) {
                  //forEach que recorre toda la lista de Nodos, y almancena el nodo en la variable e
                  vNodo.forEach((e) {
                    //Si la posición inicial cae en un nodo, entramos al if
                    if (x < (e.x + e.radio) &&
                        x > (e.x - e.radio) &&
                        y < (e.y + e.radio) &&
                        y > (e.y - e.radio)) {
                      //Cambio de color del nodo
                      e.color = true;
                      //Nodo inicial almacenado en la variable e
                      nodoAux = e;
                    }
                  });
                }
              },
              //onPanEnd nos permite accionar al final de un arrastre, pero no nos da la posición de la misma
              onPanEnd: (details) {
                //Si modo = 2, o sea el modo de unir dos nodos
                if (modo == 2) {
                  //Recorre la lista de nodos para ver si la ultima posición registrada en (xf,yf) cae en un nodo
                  vNodo.forEach((e) {
                    //Si la posición final cae en un nodo, entramos al if
                    if (xf < (e.x + e.radio) &&
                        xf > (e.x - e.radio) &&
                        yf < (e.y + e.radio) &&
                        yf > (e.y - e.radio)) {
                      //Verifica si ya hubo una conexión entre los dos nodos

                      if (verificaConexion(e) == 2) {
                        //Si ya hubo una conexión vacía el receptor de mensaje
                        receptorMensaje.clear();
                        //Muestra una alerta para pedir el nuevo número que será asignado a la conexión
                        _showDialogCambio(context, e, lineaAux);
                      } else if (verificaConexion(e) == 1) {
                        vLineas.add(ModeloLinea(nodoAux, e, obtieneval(e), 1));
                      } else {
                        _showDialog(context, e);
                      }
                    }
                  });
                  //una vez terminado el proceso se restable el boceto en 0
                  eliminarBoceto();
                  //Se cambia el color del nodo inicial a azul
                  nodoAux.color = false;
                  //El metodo setState actualiza todos los valores para la pantalla
                  setState(() {});
                } else if (modo == 4) {
                  //Cambia el color del nodo Azul
                  nodoAux.color = false;
                  setState(() {});
                }
              },
              //onPanUpdate detecta la posición por la cual es arrastrado el nodo, esta se guarda en pos
              onPanUpdate: (pos) {
                //Si modo = 2
                if (modo == 2) {
                  //Si flagBoceto=true, o sea si al principio del arrastre se reconoción un nodo inicial
                  if (flagBoceto) {
                    /*
                    * Ya que reconoce la posición miestras arrastramos un nodo, necesitamos trabajar en un setState
                    * debido a que los valores siempre son actualizados
                     */
                    setState(() {
                      //posicion actual del arrastre almacenado en (x,y) y una posible posicion final en (xf,yf)
                      x = pos.globalPosition.dx;
                      y = pos.globalPosition.dy;
                      xf = x;
                      yf = y;
                      //Recorre la lista de nodos
                      vNodo.forEach((e) {
                        //Verifica si la posicion actual esta en el area de un nodo
                        if (x < (e.x + e.radio) &&
                            x > (e.x - e.radio) &&
                            y < (e.y + e.radio) &&
                            y > (e.y - e.radio)) {
                          //Si la posición cae en un nodo este nodo cambia de color a rojo
                          e.color = true;
                        } else {
                          //Aquí cambiamos el color de todos los nodos a azul menos del nodo Inicial que sigue en rojo
                          if (e != nodoAux) {
                            e.color = false;
                          }
                        }
                      });
                    });
                  }
                } else if (modo == 4) {
                  //Actualiza la posición del nodo y tambien actualiza esto en la pantalla
                  setState(() {
                    nodoAux.x = pos.globalPosition.dx;
                    nodoAux.y = pos.globalPosition.dy;
                  });
                }
              },
              //Usaremos onPanDown para registrar un toque de pantalla, la ubicación esta almacenada en la variable ubi
              onPanDown: (ubi) {
                x = ubi.globalPosition.dx;
                y = ubi.globalPosition.dy;
                setState(() {
                  //Si modo=1, o sea queremos crear un nodo
                  if (modo == 1) {
                    //Añade un nuevo nodo a la lista de nodos con los datos de su posición y su número
                    vNodo.add(ModeloNodo(
                        ubi.globalPosition.dx,
                        ubi.globalPosition.dy,
                        30,
                        "$contadorNodos",
                        "$contadorNodos",
                        false));
                    //el numero de nodos suber en 1
                    contadorNodos++;
                  }
                });
              },
              //onTapDown registra un toque en la pantalla, su posición esta almacenada en pos
              onTapDown: (pos) {
                x = pos.globalPosition.dx;
                y = pos.globalPosition.dy;
                //Si modo = 3, o sea eliminar nodo
                if (modo == 3) {
                  vNodo.forEach((e) {
                    if (x < (e.x + e.radio) &&
                        x > (e.x - e.radio) &&
                        y < (e.y + e.radio) &&
                        y > (e.y - e.radio)) {
                      //Nos envía a la función _showDialogEliminar donde nos pedirá que confirmemos la eliminación
                      _showDialogEliminar(context, e);
                    }
                  });
                } else if (modo == 5) {
                  vNodo.forEach((e) {
                    if (x < (e.x + e.radio) &&
                        x > (e.x - e.radio) &&
                        y < (e.y + e.radio) &&
                        y > (e.y - e.radio)) {
                      //Nos envía a la función _showDialogEliminar donde nos pedirá que confirmemos la eliminación
                      _showDialogtexto(context, e);
                    }
                  });
                }
              },

              /*onDoubleTap: () {
                x=pos.globalPosition.dx;
                y=pos.globalPosition.dy;
                //Si modo = 3, o sea eliminar nodo
                if(modo==3)
                  {
                    vNodo.forEach((e) {
                      if(x<(e.x+e.radio)&&x>(e.x-e.radio)&&y<(e.y+e.radio)&&y>(e.y-e.radio))
                        {
                          //Nos envía a la función _showDialogEliminar donde nos pedirá que confirmemos la eliminación
                          _showDialogEliminar(context, e);
                        }
                    });
                  }
              },*/
            )
          ],
        ),

        floatingActionButton: Padding(
          padding: EdgeInsets.only(left: 30),
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            FloatingActionButton(
              mini: true,
              onPressed: () {
                List<List<String>> matrizAdyacencia = [];
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        matriz(generaMatriz(matrizAdyacencia))));
              },
              child: const Icon(
                Icons.apps_outage,
                size: 40,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0)),
            FloatingActionButton(
              mini: true,
              onPressed: () {
                showDialog(
                    context: context,
                    //El mensaje no se puede saltear
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        //titulo del mensaje
                        title: Text("AYUDA"),
                        content: Text(
                            "La aplicación permite la graficación de grafos y obtener su matriz de adyacencia\nEl boton inferior derecho desplliega la lista de herramientas de la aplicación\n Para utilizar las herramientas se deben seleccionar de la lista\nBorrar todo: Elimina todos los nodos y conexiones actuales en el proyecto.\nEditar nodo: Permite tocar un nodo para editar su nombre/valor.\nMover nodo: Permite arrastrar los nodos en pantalla para una nueva posición.\nEliminar: Permite tocar un nodo para eliminarlo, incluyendo sus conexiones.\nCrear relación: Permite deslizar una conexión de un nodo a otro para luego darle un valor.\nCrear nodo: Permite colocar con un toque nuevos nodos en pantalla.\nFinalmente, el boton inferior izquierdo desplliega la matriz de adyacencia en base a los grafos en pantalla."),
                        actions: [
                          //Botón del mensaje de cancelar eliminación
                          TextButton(
                              onPressed: () {
                                //sale del mensaje
                                Navigator.of(context).pop();
                              },
                              //Mensaje del botón
                              child: Text("Aceptar")),
                        ],
                      );
                    });
              },
              child: const Icon(
                Icons.help,
                size: 40,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            Expanded(child: Container()),
            SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              mini: true,
              childrenButtonSize: const Size(50.0, 50.0),
              children: [
                SpeedDialChild(
                    child: Icon(Icons.add),
                    label: "Crear Nodo",
                    onTap: () => setState(() {
                          modo = 1;
                          eliminarBoceto();
                        })),
                SpeedDialChild(
                    child: Icon(Icons.line_axis),
                    label: "Crear relacion",
                    onTap: () => setState(() {
                          modo = 2;
                          eliminarBoceto();
                        })),
                SpeedDialChild(
                    child: Icon(Icons.delete),
                    label: "Eliminar",
                    onTap: () => setState(() {
                          modo = 3;
                          eliminarBoceto();
                        })),
                SpeedDialChild(
                    child: Icon(Icons.check_circle),
                    label: "Mover Nodo",
                    onTap: () => setState(() {
                          modo = 4;
                          eliminarBoceto();
                        })),
                SpeedDialChild(
                    child: Icon(Icons.edit),
                    label: "Editar Nodo",
                    onTap: () => setState(() {
                          modo = 5;
                          eliminarBoceto();
                        })),
                SpeedDialChild(
                    child: Icon(Icons.clear),
                    label: "Borrar Todo",
                    onTap: () => setState(() {
                          modo = -1;
                          vNodo.clear();
                          contadorNodos = 1;
                          vLineas.clear();
                          setState(() {
                            eliminarBoceto();
                          });
                        })),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  List<List<String>> generaMatriz(List<List<String>> matrizAdyacencia) {
    matrizAdyacencia.clear();
    List<String> v2 = [];
    v2.add(" ");
    vNodo.forEach((ele) {
      v2.add((ele.nombre));
    });
    matrizAdyacencia.add(v2);
    for (int i = 0; i < vNodo.length; i++) {
      List<String> v = [];
      v.clear();
      String vr = v2[i + 1];
      v.add(vr);
      for (int r = 0; r < vNodo.length; r++) {
        v.add("0");
      }
      matrizAdyacencia.add(v);
    }
    vLineas.forEach((linea) {
      int f = int.parse(linea.Ni.codigo);
      int c = int.parse(linea.Nf.codigo);
      int valorLinea = int.parse(linea.valor);
      if (linea.tipo == 0) {
        List<String> fila = [...matrizAdyacencia[c]];
        fila[f] = valorLinea.toString();
        matrizAdyacencia[c] = fila;

        print(fila);
      }
      List<String> fila = [...matrizAdyacencia[f]];
      fila[c] = valorLinea.toString();
      matrizAdyacencia[f] = fila;
    });
    return matrizAdyacencia;
  }

//Función eliminar lineas, llamada por la función _showDialogEliminar
  void eliminarLineas(ModeloNodo e) {
    //Recorre la lista de Lineas
    vLineas.forEach((element) {
      //Busca lineas que contenga al nodo a eliminar,
      if (element.Ni == e || element.Nf == e) {
        //Añade las lineas a ser eliminadas a la lista auxiliar
        vLineasRemove.add(element);
      }
    });
    //el metodo removeWhere elimina todos los valores de una lista según otra lista
    vLineas.removeWhere((element) => vLineasRemove.contains(element));
  }

  //Restablece los valores del boceto
  void eliminarBoceto() {
    flagBoceto = false;
    xi = 0;
    yi = 0;
    xf = 0;
    yf = 0;
  }

  //Mensaje de alerta para la eliminación de un nodo
  _showDialogEliminar(context, ModeloNodo e) {
    showDialog(
        context: context,
        //No puede ser salteado
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            //Titulo del mensaje
            title: Text("CONFIRMAR ELIMINACIÓN"),
            //Cuerpo del mensaje
            content: Text("Se eliminará el nodo y sus conexiones."),
            actions: [
              //Botón del mensaje para confirmar la eliminación
              TextButton(
                  onPressed: () {
                    //Elimina todas las lineas del nodo a eliminar
                    eliminarLineas(e);
                    //elimina al nodo
                    vNodo.remove(e);
                    setState(() {});
                    //sale del mensaje
                    Navigator.of(context).pop();
                  }, //Mensaje del botón
                  child: Text("OK")),
              //Botón del mensaje de cancelar eliminación
              TextButton(
                  onPressed: () {
                    //sale del mensaje
                    Navigator.of(context).pop();
                  },
                  //Mensaje del botón
                  child: Text("Cancel")),
            ],
          );
        });
  }

  //Mensaje de alerta para la Unir dos nodos
  _showDialog(context, ModeloNodo e) {
    bool isChecked = false;
    int tipo = 0;

    showDialog(
        context: context,
        //No puede ser salteado
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setStatem) {
            return AlertDialog(
              //Titulo del mensaje
              title: const Text("INTRODUZCA UN VALOR"),

              //TextField para recibir un valor
              content: Form(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    //Teclado solo tenga numeros
                    keyboardType: TextInputType.number,
                    //valor numerico almacenado en receptorMensaje
                    controller: receptorMensaje,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Dirigido"),
                      Checkbox(
                          value: isChecked,
                          onChanged: (checked) {
                            setStatem(() {
                              isChecked = checked!;
                            });
                          })
                    ],
                  )
                ],
              )),
              actions: [
                //Confirma la unión de nodos

                TextButton(
                    onPressed: () {
                      if (isChecked == true) {
                        tipo = 1;
                      } else {
                        tipo = 0;
                      }
                      //crea una nueva Linea entre los nodos
                      ModeloLinea h;
                      if (nodoAux == e) {
                        tipo = -1;
                        h = ModeloLinea(e, e, receptorMensaje.text, tipo);
                      } else {
                        h = ModeloLinea(nodoAux, e, receptorMensaje.text, tipo);
                      }
                      //Añade esa linea a la lista
                      vLineas.add(h);
                      //Cambia el color del nodo inicial a azul
                      e.color = false;
                      setState(() {});
                      //sale del mensaje
                      receptorMensaje.clear();
                      Navigator.of(context).pop();
                    },
                    //texto del boton
                    child: Text("OK")),
                //cancela la unión de nodos
                TextButton(
                    onPressed: () {
                      //Cambia el color del nodo inicial a azul
                      e.color = false;
                      setState(() {});
                      //sale del mensaje
                      Navigator.of(context).pop();
                    },
                    //texto del boton
                    child: Text("Cancel")),
              ],
            );
          });
        });
  }

  //Función que verifica si ya hubo conexión entre los nodos
  int verificaConexion(ModeloNodo e) {
    //resultado default false, o sea no hay conexión
    int result = 0;
    //recorre la lista de lineas
    vLineas.forEach((element) {
      //Verifica si ya hay una conexión entre el nodo inicial(nodoAux) y el nodo final (e)
      if (element.tipo == 0) {
        if ((element.Ni == nodoAux && element.Nf == e) ||
            (element.Ni == e && element.Nf == nodoAux)) {
          result = 2;
          lineaAux = element;
          //En el caso de que haya una conexión anterior, almacenamos esta conexión
          //en lineaAux para posteriormente cambiar su valor
        }
      } else if (element.tipo == 1) {
        if (existedob(e) == 1) {
          if (element.Ni == nodoAux && element.Nf == e) {
            result = 2;
            lineaAux = element;
          } else {
            result = 1;
          }

          //En el caso de que haya una conexión anterior, almacenamos esta conexión
          //en lineaAux para posteriormente cambiar su valor
        } else if (existedob(e) == 0) {
          result = 0;
        } else {
          if ((element.Ni == nodoAux && element.Nf == e)) {
            result = 2;
            lineaAux = element;
          }
        }
      } else {
        if ((element.Ni == nodoAux && element.Nf == e) ||
            (element.Ni == e && element.Nf == nodoAux)) {
          result = 2;
          lineaAux = element;
        }
      }
    });
    return result;
  }

  int existedob(ModeloNodo e) {
    int c = 0;
    for (int i = 0; i < vLineas.length; i++) {
      if (vLineas[i].Ni == e && vLineas[i].Nf == nodoAux) {
        c += 1;
      }
      if (vLineas[i].Ni == nodoAux && vLineas[i].Nf == e) {
        c += 1;
      }
    }

    return c;
  }

  String obtieneval(ModeloNodo e) {
    //resultado default false, o sea no hay conexión
    String result = "";
    //recorre la lista de lineas
    vLineas.forEach((element) {
      //Verifica si ya hay una conexión entre el nodo inicial(nodoAux) y el nodo final (e)

      if ((element.Ni == e && element.Nf == nodoAux)) {
        result = element.valor;
      }
    });
    return result;
  }

  //Mensaje para cambiar el valor de una conexión
  _showDialogCambio(context, ModeloNodo e, ModeloLinea h) {
    showDialog(
        context: context,
        //El mensaje no se puede saltear
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            //titulo del mensaje
            title: Text("CAMBIE EL VALOR"),
            content: TextField(
              //teclado solo con numeros
              keyboardType: TextInputType.number,
              //valor numerico almacenado en receptorMensaje
              controller: receptorMensaje,
            ),
            actions: [
              //Confirma el cambio
              TextButton(
                  onPressed: () {
                    //cambia el valor de la conexión por el nuevo valor
                    //if (h.tipo == 1) {
                    //  h.valor = receptorMensaje.text;
                    //  for (int i = 0; i < vLineas.length; i++) {
                    //    if ((vLineas[i].Ni == h.Nf && vLineas[i].Nf == h.Ni)) {
                    //      vLineas[i].valor = obtieneval(e);
                    //      break;
                    //    }
                    //  }
                    //} else {
                    //  h.valor = receptorMensaje.text;
                    //}

                    h.valor = receptorMensaje.text;
                    e.color = false;
                    setState(() {});
                    Navigator.of(context).pop();
                    receptorMensaje.clear();
                  },
                  child: Text("OK")),
              //cancela el cambio
              TextButton(
                  onPressed: () {
                    e.color = false;
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
            ],
          );
        });
  }

  _showDialogtexto(context, ModeloNodo e) {
    showDialog(
        context: context,
        //El mensaje no se puede saltear
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            //titulo del mensaje
            title: Text("INGRESE EL NOMBRE"),
            content: TextField(
              //teclado solo con numeros
              keyboardType: TextInputType.text,
              //valor numerico almacenado en receptorMensaje
              controller: receptorMensaje,
            ),
            actions: [
              //Confirma el cambio
              TextButton(
                  onPressed: () {
                    //cambia el valor de la conexión por el nuevo valor
                    e.nombre = receptorMensaje.text;
                    e.color = false;
                    setState(() {});
                    Navigator.of(context).pop();
                    receptorMensaje.clear();
                  },
                  child: Text("OK")),
              //cancela el cambio
              TextButton(
                  onPressed: () {
                    e.color = false;
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
            ],
          );
        });
  }

//  void _abrirDartHelp(BuildContext context) {
//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => Help()),
//    );
//  }
}

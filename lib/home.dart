import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:grafos/johnson.dart';
import 'package:grafos/norwest.dart';
import 'modelos.dart';
import 'figura.dart';
import 'selection.dart';
import 'dijkstra.dart';
import 'matriz.dart';
import 'hungarian_algorithm.dart';
import 'dbprueba.dart';
import 'norwest.dart';
import 'matnor.dart';
import 'dart:io';
import 'asignacion2.dart';
import 'mergesort.dart';
import 'insertionsort.dart';
import 'shellsort.dart';
import 'arbolesBinarios.dart';
import 'compete.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
import 'kruskal.dart';
import 'noroeste.dart';
import 'matrizExtendida.dart';

class Myhome extends StatefulWidget {
  const Myhome({Key? key}) : super(key: key);

  //Nos envía a _MyhomeState
  @override
  State<Myhome> createState() => _MyhomeState();
}

class _MyhomeState extends State<Myhome> {
  //Variable que recibe el valor de los mensajes
  List<String> _demanda = [];
  List<String> _disponibilidad = [];
  String sumaAlgor = "";

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
  bool estadoj = false;
  List<String> estj = [];
  final Random rng = Random();

  List<int> _generarArrayAleatorio(int cantidad) {
    return List<int>.generate(cantidad, (i) => rng.nextInt(100));
  }

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

  List<modelo> modeloGuardado = [];

  int cantN = 0, cantL = 0;

  TextEditingController tituloGuardado = TextEditingController();

  TextEditingController descripcionGuardada = TextEditingController();
  List<String> of = [];
  List<String> dem = [];

  late int ID;

  @override
  void initState() {
    if (!kIsWeb && !Platform.isWindows) {
      cargaModelo();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Aplicación
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        /*appBar: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: AppBar(
            backgroundColor: Color(0xFF2D2D34),
          ),
        ),*/
        //backgroundColor: Color.fromARGB(255, 168, 255, 251),
        backgroundColor: const Color(0xFF2D2D34),
        //Pila que almacena todos los objetos
        body: Stack(
          children: [
            Positioned(
              top: 50,
              left: 10,
              child: Text(
                sumaAlgor,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
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
                      } //else if (verificaConexion(e) == 1) {
                      //vLineas.add(ModeloLinea(nodoAux, e, obtieneval(e), 1));
                      //}
                      else {
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
          padding: const EdgeInsets.only(left: 30),
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            FloatingActionButton(
              mini: true,
              heroTag: "matriz",
              onPressed: () {
                List<List<String>> matrizAdyacencia = [];

                matrizAdyacencia = generaMatriz(matrizAdyacencia);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => matriz(matrizAdyacencia)));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.apps_outage,
                size: 40,
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
            FloatingActionButton(
              mini: true,
              heroTag: "cls",
              onPressed: () {
                clearLineas();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.replay,
                size: 40,
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),

            Expanded(child: Container()),
            SpeedDial(
              animatedIcon: AnimatedIcons.arrow_menu,
              mini: true,
              childrenButtonSize: const Size(50.0, 50.0),
              children: [
                SpeedDialChild(
                    child: const Icon(Icons.linear_scale),
                    label: 'Jon',
                    onTap: () => setState(() {
                          setState(() {
                            creaJon();
                            setState(() {});
                          });
                        })
                    //onTap: () {
                    //
                    //},
                    ),
                SpeedDialChild(
                  child: const Icon(Icons.mediation),
                  label: 'Asignación óptima',
                  onTap: () {
                    List<dynamic> asignacionOptimaMin =
                        calcularAsignacionOptima();
                    List<dynamic> asignacionOptimaMax =
                        calcularAsignacionOptima2();
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Asignación óptima"),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Minimización:"),
                                ...asignacionOptimaMin[1]
                                    .asMap()
                                    .entries
                                    .map((entry) => Text(
                                        "Tarea ${entry.key + 1}: ${entry.value[0]} asignada a ${entry.value[1]}"))
                                    .toList(),
                                const SizedBox(height: 16),
                                Text("Sumatoria: ${asignacionOptimaMin[0]}"),
                                const SizedBox(
                                  height: 16,
                                ),
                                const Text("Maximización:"),
                                ...asignacionOptimaMax[1]
                                    .asMap()
                                    .entries
                                    .map((entry) => Text(
                                        "Tarea ${entry.key + 1}: ${entry.value[0]} asignada a ${entry.value[1]}"))
                                    .toList(),
                                const SizedBox(height: 16),
                                Text("Sumatoria: ${asignacionOptimaMax[0]}"),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Aceptar"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                SpeedDialChild(
                  child: const Icon(Icons.north_west),
                  label: 'Norwest',
                  onTap: () {
                    //of = [];
                    //dem = [];
//
                    List<List<String>> matrizAdyacencia = [];
                    matrizAdyacencia = generaMatriz(matrizAdyacencia);
                    //continueDialogs = true;
                    List<List<String>> matcostos = [];
                    matcostos = matCostos(matrizAdyacencia);
                    _mensajeObtenerDmdDisp(context, matcostos);

                    //await _showDialogsDem(context, matrizAdyacencia, of, dem);
                    //await _showDialogsOf(context, matrizAdyacencia, of, dem);
                  },
                ),
                SpeedDialChild(
                    child: const Icon(Icons.diamond_sharp),
                    label: 'Dijkstra',
                    onTap: () => setState(() {
                          setState(() {
                            _showDijkstraDialog(context);
                            setState(() {});
                          });
                        })
                    //onTap: () {
                    //
                    //
                    //},
                    ),
                SpeedDialChild(
                    child: const Icon(Icons.category),
                    label: "Arboles Binarios",
                    onTap: () => setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArbolesBinariosScreen(),
                            ),
                          );
                        })),
                SpeedDialChild(
                    child: const Icon(Icons.cyclone),
                    label: "Compete",
                    onTap: () => setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CompeteScreen(),
                            ),
                          );
                        })),
                SpeedDialChild(
                    child: const Icon(Icons.nature_outlined),
                    label: 'Kruskal',
                    onTap: () => setState(() {
                          setState(() {
                            _showKruskalDialog(context);
                            setState(() {});
                          });
                        })
                    //onTap: () {
                    //
                    //
                    //},
                    ),
              ],
            ),
            //Expanded(child: Container()),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
            SpeedDial(
              animatedIcon: AnimatedIcons.view_list,
              mini: true,
              childrenButtonSize: const Size(50.0, 50.0),
              children: [
                SpeedDialChild(
                    child: const Icon(Icons.sort),
                    label: "Selection Sort",
                    onTap: () => setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectionSortScreen(),
                            ),
                          );
                        })),
                SpeedDialChild(
                    child: const Icon(Icons.sort_by_alpha_outlined),
                    label: "Insertion Sort",
                    onTap: () => setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InsertionSortScreen(),
                            ),
                          );
                        })),
                SpeedDialChild(
                    child: const Icon(Icons.sort_by_alpha_sharp),
                    label: "Merge Sort",
                    onTap: () => setState(() {
                          onMergeSortButtonPressed(context);
                        })),
                SpeedDialChild(
                    child: const Icon(Icons.sort_rounded),
                    label: "Shell Sort",
                    onTap: () => setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShellSortScreen(),
                            ),
                          );
                        })),
                SpeedDialChild(
                    child: const Icon(Icons.help),
                    label: "Help",
                    onTap: () => setState(() {
                          showDialog(
                              context: context,
                              //El mensaje no se puede saltear
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                  //titulo del mensaje
                                  title: const Text("AYUDA"),
                                  content: const Text(
                                      "La aplicación permite la graficación de grafos y obtener su matriz de adyacencia\nEl boton inferior derecho desplliega la lista de herramientas de la aplicación\n Para utilizar las herramientas se deben seleccionar de la lista\nBorrar todo: Elimina todos los nodos y conexiones actuales en el proyecto.\nEditar nodo: Permite tocar un nodo para editar su nombre/valor.\nMover nodo: Permite arrastrar los nodos en pantalla para una nueva posición.\nEliminar: Permite tocar un nodo para eliminarlo, incluyendo sus conexiones.\nCrear relación: Permite deslizar una conexión de un nodo a otro para luego darle un valor.\nCrear nodo: Permite colocar con un toque nuevos nodos en pantalla.\nFinalmente, el boton inferior izquierdo desplliega la matriz de adyacencia en base a los grafos en pantalla."),
                                  actions: [
                                    //Botón del mensaje de cancelar eliminación
                                    TextButton(
                                        onPressed: () {
                                          //sale del mensaje
                                          Navigator.of(context).pop();
                                        },
                                        //Mensaje del botón
                                        child: const Text("Aceptar")),
                                  ],
                                );
                              });
                        })),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
            SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              mini: true,
              childrenButtonSize: const Size(50.0, 50.0),
              children: [
                SpeedDialChild(
                    child: const Icon(Icons.add),
                    label: "Crear Nodo",
                    onTap: () => setState(() {
                          modo = 1;
                          eliminarBoceto();
                        })),
                SpeedDialChild(
                    child: const Icon(Icons.timeline),
                    label: "Crear relacion",
                    onTap: () => setState(() {
                          modo = 2;
                          eliminarBoceto();
                        })),
                SpeedDialChild(
                    child: const Icon(Icons.delete),
                    label: "Eliminar",
                    onTap: () => setState(() {
                          modo = 3;
                          eliminarBoceto();
                        })),
                SpeedDialChild(
                    child: const Icon(Icons.pan_tool),
                    label: "Mover Nodo",
                    onTap: () => setState(() {
                          modo = 4;
                          eliminarBoceto();
                        })),
                SpeedDialChild(
                    child: const Icon(Icons.edit),
                    label: "Editar Nodo",
                    onTap: () => setState(() {
                          modo = 5;
                          eliminarBoceto();
                        })),
                SpeedDialChild(
                    child: const Icon(Icons.save),
                    label: "Sobresescribir",
                    onTap: () => setState(() {
                          modo = 6;
                          setState(() {
                            cantN = 0;
                            cantL = 0;
                            String cifraNodo = cifradoNodos();
                            String cifraLinea = cifradoLineas();
                            _Sobrescribir(context, cifraNodo, cifraLinea);
                            setState(() {});
                          });
                        })),
                SpeedDialChild(
                    child: const Icon(Icons.save),
                    label: "Guardar como",
                    onTap: () => setState(() {
                          modo = 7;
                          setState(() {
                            cantN = 0;
                            cantL = 0;
                            String cifraNodo = cifradoNodos();
                            String cifraLinea = cifradoLineas();
                            _MensajeGuardado(context, cifraNodo, cifraLinea);
                            setState(() {});
                          });
                        })),
                SpeedDialChild(
                    child: const Icon(Icons.drive_folder_upload),
                    label: "Cargar",
                    onTap: () => setState(() {
                          modo = 8;
                          setState(() {
                            _MensajeCargar(context);
                            setState(() {});
                          });
                        })),
                SpeedDialChild(
                    child: const Icon(Icons.clear),
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
    for (int i = 0; i < vLineas.length; i++) {
      int f = v2.indexOf(vLineas[i].Ni.nombre);
      int c = v2.indexOf(vLineas[i].Nf.nombre);
      int valorLinea = int.parse(vLineas[i].valor);
      if (vLineas[i].tipo == 0) {
        List<String> fila = [...matrizAdyacencia[c]];
        fila[f] = valorLinea.toString();
        matrizAdyacencia[c] = fila;
      }
      List<String> fila = [...matrizAdyacencia[f]];
      fila[c] = valorLinea.toString();
      matrizAdyacencia[f] = fila;
    }
    return matrizAdyacencia;
  }

  List<dynamic> calcularAsignacionOptima() {
    List<List<String>> matrizAdyacencia = [];

    matrizAdyacencia = generaMatriz(matrizAdyacencia);

    List<List<int>> matrizAdyacenciaInt = matrizAdyacencia
        .skip(1)
        .map((fila) =>
            fila.skip(1).map((element) => int.parse(element)).toList())
        .toList();

    List<int> asignacion = hungarianAlgorithm(matrizAdyacenciaInt);

    List<List<String>> noms = [];
    int sumatoria = 0;
    for (int i = 1; i < matrizAdyacencia.length; i++) {
      if (asignacion[i - 1] != -1) {
        noms.add([
          matrizAdyacencia[0][i],
          matrizAdyacencia[0][asignacion[i - 1] + 1]
        ]);
        sumatoria += matrizAdyacenciaInt[i - 1][asignacion[i - 1]];
      }
    }
    return [sumatoria, noms];
  }

  List<dynamic> calcularAsignacionOptima2() {
    List<List<String>> matrizAdyacencia = [];

    matrizAdyacencia = generaMatriz(matrizAdyacencia);

    List<List<int>> matrizAdyacenciaInt = matrizAdyacencia
        .skip(1)
        .map((fila) =>
            fila.skip(1).map((element) => int.parse(element)).toList())
        .toList();

    List<int> asignacion = hungarianAlgorithm2(matrizAdyacenciaInt);
    List<List<String>> noms = [];
    int sumatoria = 0;
    for (int i = 1; i < matrizAdyacencia.length; i++) {
      if (asignacion[i - 1] != -1) {
        noms.add([
          matrizAdyacencia[0][i],
          matrizAdyacencia[0][asignacion[i - 1] + 1]
        ]);
        sumatoria += matrizAdyacenciaInt[i - 1][asignacion[i - 1]];
      }
    }
    return [sumatoria, noms];
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
            title: const Text("CONFIRMAR ELIMINACIÓN"),
            //Cuerpo del mensaje
            content: const Text("Se eliminará el nodo y sus conexiones."),
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
                  child: const Text("OK")),
              //Botón del mensaje de cancelar eliminación
              TextButton(
                  onPressed: () {
                    //sale del mensaje
                    Navigator.of(context).pop();
                  },
                  //Mensaje del botón
                  child: const Text("Cancel")),
            ],
          );
        });
  }

  void showDialogSequence(BuildContext context, int con,
      List<List<String>> matrizAdyacencia, List<String> of, List<String> dem,
      {bool showOferta = false}) {
    if (con < matrizAdyacencia.length) {
      if (showOferta) {
        _showDialogOf(context, con, matrizAdyacencia, of, dem).then((_) {
          showDialogSequence(context, con + 1, matrizAdyacencia, of, dem,
              showOferta: true);
        });
      } else {
        _showDialogDem(context, con, matrizAdyacencia, of, dem).then((_) {
          showDialogSequence(context, con + 1, matrizAdyacencia, of, dem);
        });
      }
    } else if (!showOferta) {
      showDialogSequence(context, 1, matrizAdyacencia, of, dem,
          showOferta: true);
    }
  }

  bool continueDialogs = true;

  Future<void> _showDialogDem(
      BuildContext context,
      int con,
      List<List<String>> matrizAdyacencia,
      List<String> of,
      List<String> dem) async {
    if (!continueDialogs) return Future.value();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text("Ingrese oferta $con"),
              content: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: receptorMensaje,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    dem.add(receptorMensaje.text);
                    receptorMensaje.clear();
                    Navigator.of(context).pop();
                    if (con + 1 < matrizAdyacencia.length) {
                      await _showDialogDem(
                          context, con + 1, matrizAdyacencia, of, dem);
                    }
                  },
                  child: const Text("OK"),
                ),
                TextButton(
                  onPressed: () {
                    continueDialogs = false;
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
    );
  }

// ...

  Future<void> _showDialogOf(
      BuildContext context,
      int con,
      List<List<String>> matrizAdyacencia,
      List<String> of,
      List<String> dem) async {
    if (!continueDialogs) return Future.value();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text("Ingrese demanda $con"),
              content: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: receptorMensaje,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    of.add(receptorMensaje.text);
                    receptorMensaje.clear();
                    Navigator.of(context).pop();
                    if (con + 1 < matrizAdyacencia.length) {
                      await _showDialogOf(
                          context, con + 1, matrizAdyacencia, of, dem);
                    } else {
                      Norwest nor = Norwest();
                      var res = nor.calcNor(matrizAdyacencia, of, dem);
                      // Navegar a la nueva página
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            matnor(res[1], matrizAdyacencia, res[0]),
                      ));
                    }
                  },
                  child: const Text("OK"),
                ),
                TextButton(
                  onPressed: () {
                    continueDialogs = false;
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showDialogsDem(
      BuildContext context,
      List<List<String>> matrizAdyacencia,
      List<String> of,
      List<String> dem) async {
    for (int con = 0; con < matrizAdyacencia.length - 1; con++) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          TextEditingController textFieldController = TextEditingController();
          return AlertDialog(
            title: Text("Ingrese oferta ${con + 1}"),
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: textFieldController,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  dem.add(textFieldController.text);
                  textFieldController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _showDialogsOf(
      BuildContext context,
      List<List<String>> matrizAdyacencia,
      List<String> of,
      List<String> dem) async {
    for (int con = 0; con < matrizAdyacencia.length - 1; con++) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          TextEditingController textFieldController = TextEditingController();
          return AlertDialog(
            title: Text("Ingrese demanda ${con + 1}"),
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: textFieldController,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  of.add(textFieldController.text);
                  textFieldController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        },
      );
    }
    Norwest nor = Norwest();
    var res = nor.calcNor(matrizAdyacencia, of, dem);
    // Navegar a la nueva página
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => matnor(res[1], matrizAdyacencia, res[0]),
    ));
  }

  _showKruskalDialog(context) {
    int selectedOption = 1;

    showDialog(
        context: context,
        //No puede ser salteado
        //barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setStatem) {
            return AlertDialog(
              //Titulo del mensaje
              title: const Text("Seleccione accion"),

              //TextField para recibir un valor
              content: Form(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(
                    title: const Text('Maximizar'),
                    value: 1,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setStatem(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('Minimizar'),
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
                    creaKruskal(selectedOption);
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            );
          });
        });
  }

  _showDijkstraDialog(context) {
    TextEditingController text1Controller = TextEditingController();
    TextEditingController text2Controller = TextEditingController();
    int selectedOption = 1;

    showDialog(
        context: context,
        //No puede ser salteado
        //barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setStatem) {
            return AlertDialog(
              //Titulo del mensaje
              title: const Text("Ingrese Rango"),

              //TextField para recibir un valor
              content: Form(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: text1Controller,
                    decoration: const InputDecoration(
                      labelText: 'Inicio',
                    ),
                  ),
                  TextField(
                    controller: text2Controller,
                    decoration: const InputDecoration(
                      labelText: 'Final',
                    ),
                  ),
                  //SizedBox(height: 16),
                  RadioListTile(
                    title: const Text('Maximizar'),
                    value: 1,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setStatem(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('Minimizar'),
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
                    String text2 = text2Controller.text;
                    text1 = text1.isEmpty ? "." : text1;
                    text2 = text2.isEmpty ? "." : text2;

                    creaDijkstra(selectedOption, text1, text2);
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            );
          });
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
                      const Text("No Dirigido"),
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
                      if (isChecked == false) {
                        tipo = 1;
                      } else {
                        tipo = 0;
                      }
                      //crea una nueva Linea entre los nodos
                      ModeloLinea h;
                      if (nodoAux == e) {
                        tipo = -1;
                        h = ModeloLinea(e, e, receptorMensaje.text, tipo, "");
                      } else {
                        h = ModeloLinea(
                            nodoAux, e, receptorMensaje.text, tipo, "");
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
                    child: const Text("OK")),
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
                    child: const Text("Cancel")),
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

  List<List<String>> getMatrizReducida(List<List<String>> matrizInicial) {
    matrizInicial = _deleteZeros(matrizInicial);
    matrizInicial = _transpose(matrizInicial);
    matrizInicial = _deleteZeros(matrizInicial);
    matrizInicial = _transpose(matrizInicial);
    return matrizInicial;
  }

  List<List<int>> getMatrizCostos(List<List<String>> matrizInicial) {
    matrizInicial.removeAt(0);
    matrizInicial = _transpose(matrizInicial);
    matrizInicial.removeAt(0);
    matrizInicial = _transpose(matrizInicial);
    return _parse(matrizInicial);
  }

  List<List<String>> equilibrarDisponibilidad(
      List<List<String>> matrizInicial) {
    matrizInicial = _transpose(matrizInicial);
    List<String> newList = List.generate(matrizInicial[0].length, (_) => '0');
    newList[0] = 'E';
    matrizInicial.add(newList);
    matrizInicial = _transpose(matrizInicial);
    return matrizInicial;
  }

  List<List<String>> equilibrarDemanda(List<List<String>> matrizInicial) {
    List<String> newList = List.generate(matrizInicial[0].length, (_) => '0');
    newList[0] = 'E';
    matrizInicial.add(newList);
    return matrizInicial;
  }

  List<List<int>> _parse(List<List<String>> matrizInicial) {
    List<List<int>> result = List.generate(matrizInicial.length,
        (_) => List.generate(matrizInicial[0].length, (_) => 0));
    for (int f = 0; f < matrizInicial.length; f++) {
      for (int c = 0; c < matrizInicial[f].length; c++) {
        result[f][c] = int.parse(matrizInicial[f][c]);
      }
    }
    return result;
  }

  List<List<String>> _deleteZeros(List<List<String>> matrizInicial) {
    List<List<String>> result = [];
    List<int> posAEliminar = [];
    result.add(matrizInicial[0]);
    for (int f = 1; f < matrizInicial.length; f++) {
      bool flag = false;
      for (int c = 1; c < matrizInicial[f].length; c++) {
        if (matrizInicial[f][c] != '0') {
          flag = true;
          break;
        }
      }
      if (flag) {
        result.add(matrizInicial[f]);
      }
    }
    posAEliminar.forEach((valor) {
      result.removeAt(valor);
    });
    return result;
  }

  List<List<String>> _transpose(List<List<String>> matrix) {
    if (matrix.isEmpty) {
      return <List<String>>[];
    }
    int numRows = matrix.length;
    int numCols = matrix[0].length;
    List<List<String>> transposed =
        List.generate(numCols, (_) => List.generate(numRows, (_) => '0'));
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < numCols; j++) {
        transposed[j][i] = matrix[i][j];
      }
    }
    //print('Matriz transpuesta: ${transposed}');
    return transposed;
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
            title: const Text("CAMBIE EL VALOR"),
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
                  child: const Text("OK")),
              //cancela el cambio
              TextButton(
                  onPressed: () {
                    e.color = false;
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
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
            title: const Text("INGRESE EL NOMBRE"),
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
                  child: const Text("OK")),
              //cancela el cambio
              TextButton(
                  onPressed: () {
                    e.color = false;
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
            ],
          );
        });
  }

  List<List<String>> matCostos(List<List<String>> matr) {
    List<List<String>> nmat = [];
    nmat.add(matr[0]);
    List<int> filasEliminar = [];
    List<int> columnasEliminar = [];

    for (int i = 1; i < matr.length; i++) {
      if (!filaCero(matr[i])) {
        nmat.add(matr[i]);
      } else {
        filasEliminar.add(i);
      }

      if (colCero(matr, i)) {
        columnasEliminar.add(i);
      }
    }

    for (int i = columnasEliminar.length - 1; i >= 0; i--) {
      int col = columnasEliminar[i];
      nmat[0].removeAt(col);
      for (int j = 1; j < nmat.length; j++) {
        nmat[j].removeAt(col);
      }
    }

    return nmat;
  }

  bool filaCero(List<String> fila) {
    for (int i = 1; i < fila.length; i++) {
      if (fila[i] != "0") {
        return false;
      }
    }
    return true;
  }

  bool colCero(List<List<String>> matr, int col) {
    for (int i = 1; i < matr.length; i++) {
      if (matr[i][col] != "0") {
        return false;
      }
    }
    return true;
  }

  _mensajeObtenerDmdDisp(context, List<List<String>> matrix) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        _demanda.clear();
        _disponibilidad.clear();
        _disponibilidad = List.generate(matrix.length - 1, (_) => "");
        _demanda = List.generate(matrix[0].length - 1, (_) => "");

        return AlertDialog(
          title: Text("Algoritmo de Asignación Extendido"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text('Matriz de Costos: '),
                for (var i = 0; i < matrix.length + 1; i++)
                  Row(
                    children: [
                      for (var j = 0; j < matrix[0].length + 1; j++)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: (i >= matrix.length || j >= matrix[i].length)
                                ? (i == 0 ||
                                        j == 0 ||
                                        (i == matrix.length &&
                                            j == matrix[0].length))
                                    ? Text('')
                                    : TextFormField(
                                        initialValue: '',
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        onChanged: (value) {
                                          setState(() {
                                            if (i == matrix.length) {
                                              _demanda[j - 1] =
                                                  value.toString();
                                            } else if (j == matrix[0].length) {
                                              _disponibilidad[i - 1] =
                                                  value.toString();
                                            }
                                          });
                                        },
                                      )
                                : Text(matrix[i][j]),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
          actions: [
            //TextButton(
            //  onPressed: () {
            //    setState(() {
            //      // Resto del código para minimizar
            //      Norwest nor = Norwest();
            //    });
            //  },
            //  child: Text("Minimizar"),
            //),
            TextButton(
              onPressed: () {
                setState(() {
                  // Resto del código para maximizar
                  Norwest nor = Norwest();
                  var muestra = nor.calcNor(matrix, _disponibilidad, _demanda);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          matrizExtendida(muestra[1], muestra[0])));
                });
              },
              child: Text("OK"),
            ),
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  _MensajeGuardado(context, String cifraNodo, String cifraLinea) {
    showDialog(
        context: context,
        //El mensaje no se puede saltear
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            //titulo del mensaje
            title: const Text("GUARDADO DE GRAFO"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  //valor numerico almacenado en receptorMensaje
                  controller: tituloGuardado,
                  decoration: const InputDecoration(
                    hintText: 'Introduzca un Nombre',
                  ),
                ),
                TextField(
                  controller: descripcionGuardada,
                  decoration: const InputDecoration(
                      hintText: 'Introduzca una descripción'),
                ),
                Text('Cantidad de Nodos: ${cantN}'),
                Text('Cantidad de Conexiones: ${cantL}')
              ],
            ),
            actions: [
              //Confirma el guardado
              TextButton(
                  onPressed: () {
                    setState(() {
                      if (modeloGuardado.isEmpty) {
                        ID = 0;
                      } else {
                        ID = modeloGuardado[modeloGuardado.length - 1].id + 1;
                      }
                      DB.insert(modelo(
                          ID,
                          tituloGuardado.text,
                          descripcionGuardada.text,
                          cifraNodo,
                          cifraLinea,
                          cantN,
                          cantL));
                      cargaModelo();
                      setState(() {});
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK")),
              //cancela el cambio
              TextButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
            ],
          );
        });
  }

  _MensajeCargar(context) {
    showDialog(
        context: context,
        //El mensaje no se puede saltear
        builder: (context) {
          return AlertDialog(
            //titulo del mensaje
            title: const Text("CARGADO DE GRAFO"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Seleccione la configuración:'),
                Container(
                  color: Colors.blue,
                  height: 300,
                  width: 250,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: modeloGuardado.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('${modeloGuardado[index].id}'),
                                const VerticalDivider(),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        '${modeloGuardado[index].Nombre}',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                        'Lineas: ${modeloGuardado[index].cantidadLineas}'),
                                    Text(
                                        'Nodos: ${modeloGuardado[index].cantidadNodos}'),
                                    const Text('Descripción:'),
                                    Container(
                                      height: 56,
                                      width: 150,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Text(
                                            '${modeloGuardado[index].Descripcion}'),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                Navigator.of(context).pop();
                                _confirmarCargado(context, index);
                              });
                            },
                            onLongPress: () {
                              setState(() {
                                Navigator.of(context).pop();
                                _confirmarEliminacion(context, index);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              //Confirma el guardado
              TextButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK")),
              //cancela el cambio
              TextButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
            ],
          );
        });
  }

  Future cargaModelo() async {
    List<modelo> auxModelo = await DB.cargarLista();
    setState(() {
      modeloGuardado = auxModelo;
    });
  }

  _confirmarEliminacion(context, int index) {
    showDialog(
        context: context,
        //No puede ser salteado
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            //Titulo del mensaje
            title: const Text("SEGURO QUE QUIERE ELIMINAR EL GRAFO?"),
            actions: [
              //Confirma la unión de nodos
              TextButton(
                  onPressed: () {
                    setState(() {
                      DB.delete(modeloGuardado[index]);
                      cargaModelo();
                      Navigator.of(context).pop();
                    });
                  },
                  //texto del boton
                  child: const Text("OK")),
              //cancela la unión de nodos
              TextButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  //texto del boton
                  child: const Text("Cancel")),
            ],
          );
        });
  }

  _confirmarCargado(context, int index) {
    showDialog(
        context: context,
        //No puede ser salteado
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            //Titulo del mensaje
            title: const Text("SEGURO QUE QUIERE CARGAR EL GRAFO?"),
            actions: [
              //Confirma la unión de nodos
              TextButton(
                  onPressed: () {
                    setState(() {
                      descrifrado(modeloGuardado[index]);
                      Navigator.of(context).pop();
                    });
                  },
                  //texto del boton
                  child: const Text("OK")),
              //cancela la unión de nodos
              TextButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  //texto del boton
                  child: const Text("Cancel")),
            ],
          );
        });
  }

  _Sobrescribir(context, String cifraNodo, String cifraLinea) {
    showDialog(
        context: context,
        //El mensaje no se puede saltear
        builder: (context) {
          return AlertDialog(
            //titulo del mensaje
            title: const Text("GRAFO A SOBRESCRIBIR"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Seleccione:'),
                Container(
                  color: Colors.blue,
                  height: 300,
                  width: 250,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: modeloGuardado.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('${modeloGuardado[index].id}'),
                                const VerticalDivider(),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        '${modeloGuardado[index].Nombre}',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                        'Lineas: ${modeloGuardado[index].cantidadLineas}'),
                                    Text(
                                        'Nodos: ${modeloGuardado[index].cantidadNodos}'),
                                    const Text('Descripción:'),
                                    Container(
                                      height: 56,
                                      width: 150,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Text(
                                            '${modeloGuardado[index].Descripcion}'),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                DB.delete(modeloGuardado[index]);
                                cargaModelo();
                                Navigator.of(context).pop();
                                ID = index + 1;
                                DB.insert(modelo(
                                    ID,
                                    tituloGuardado.text,
                                    descripcionGuardada.text,
                                    cifraNodo,
                                    cifraLinea,
                                    cantN,
                                    cantL));
                                cargaModelo();
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              //Confirma el guardado
              TextButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK")),
              //cancela el cambio
              TextButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
            ],
          );
        });
  }

  String cifradoNodos() {
    String cifrado = "";
    vNodo.forEach((Nodo) {
      cantN++;
      cifrado =
          "${"$cifrado${Nodo.x.toStringAsPrecision(7)}," + Nodo.y.toStringAsPrecision(7)},${Nodo.radio},${Nodo.codigo},${Nodo.st};";
    });
    return cifrado;
  }

  String cifradoLineas() {
    String cifrado = "";
    vLineas.forEach((Linea) {
      cantL++;
      cifrado =
          "$cifrado${Linea.Ni.codigo},${Linea.Nf.codigo},${Linea.valor},${Linea.tipo};";
    });
    return cifrado;
  }

  void descrifrado(modelo cifrado) {
    vNodo.clear();
    List<String> ListaNodos = cifrado.Nodos.split(";");
    for (int i = 0; i < cifrado.cantidadNodos; i++) {
      List<String> Nodo = ListaNodos[i].split(",");
      vNodo.add(ModeloNodo(double.parse(Nodo[0]), double.parse(Nodo[1]),
          double.parse(Nodo[2]), Nodo[3], Nodo[3], false));
    }
    vLineas.clear();
    List<String> ListaLineas = cifrado.Lineas.split(";");
    for (int i = 0; i < cifrado.cantidadLineas; i++) {
      ModeloNodo Nii = vNodo[0];
      ModeloNodo Nff = vNodo[0];
      List<String> Linea = ListaLineas[i].split(',');
      vNodo.forEach((Nodo) {
        if (Nodo.codigo == Linea[0]) {
          Nii = Nodo;
        }
        if (Nodo.codigo == Linea[1]) {
          Nff = Nodo;
        }
      });
      vLineas.add(ModeloLinea(Nii, Nff, Linea[2], int.parse(Linea[3]), ""));
    }
  }

//  void _abrirDartHelp(BuildContext context) {
//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => Help()),
//    );
//  }
  creaJon() {
    sumaAlgor = "";
    clearLineas();
    List<List<String>> matrizAdyacencia = [];
    matrizAdyacencia = generaMatriz(matrizAdyacencia);
    Johnson jon = Johnson();
    var jonson = jon.calcJon(matrizAdyacencia);
    sumaAlgor = "Suma: ${jonson[1]}";
    List<String> aux = jonson[0];

    List<int> vals = jon.mays(matrizAdyacencia);

    List<int> valsn = jon.mins(matrizAdyacencia, jonson[1]);

    var holgs = jon.sacaHolg(matrizAdyacencia, aux, jonson[1], vals, valsn);

    for (int i = 0; i < holgs.length; i++) {
      for (int j = 0; j < holgs.length; j++) {
        vLineas.forEach((linea) {
          if (linea.Ni.nombre == matrizAdyacencia[i + 1][0] &&
              linea.Nf.nombre == matrizAdyacencia[0][j + 1]) {
            linea.holg = "h: " + holgs[i][j];
          }
        });
      }
    }

    for (int i = 1; i < aux.length; i++) {
      for (int j = 0; j < vLineas.length; j++) {
        var linea = vLineas[j];
        if ((linea.Ni.nombre == aux[i - 1] && linea.Nf.nombre == aux[i]) ||
            (linea.Nf.nombre == aux[i - 1] && linea.Ni.nombre == aux[i])) {
          if (linea.tipo == 1) {
            linea.tipo = 5;
          } else if (linea.tipo == 0) {
            linea.tipo = 6;
          }
          break; // Salir del bucle interno si se encuentra la línea correspondiente
        }
      }
    }
  }

/*
  selectionSort() {
    List<List<String>> matrizAdyacencia = [];
    matrizAdyacencia = generaMatriz(matrizAdyacencia);
    Selection selec = Selection();
    return selec.selection(matrizAdyacencia);
  }
*/

  Future<void> onMergeSortButtonPressed(BuildContext context) async {
    List<int> arr = _generarArrayAleatorio(10);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MergeSortScreen(),
      ),
    );
  }

  Future<void> onShellSortButtonPressed(BuildContext context) async {
    List<int> arr = _generarArrayAleatorio(10);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShellSortScreen(),
      ),
    );
  }

  creaDijkstra(int mxmn, String txt1, String txt2) {
    sumaAlgor = "";
    clearLineas();
    List<List<String>> matrizAdyacencia = [];
    matrizAdyacencia = generaMatriz(matrizAdyacencia);
    Dijkstra dij = Dijkstra();
    List<dynamic> dijkstra =
        dij.dijkstraMax(matrizAdyacencia, inicio: txt1, fin: txt2);

    if (mxmn != 1) {
      dijkstra = dij.dijkstraMin(matrizAdyacencia, inicio: txt1, fin: txt2);
    }
    List<String> aux = dijkstra[0];
    sumaAlgor = "Suma: ${dijkstra[1]}";
    for (int i = 1; i < aux.length; i++) {
      for (int j = 0; j < vLineas.length; j++) {
        var linea = vLineas[j];
        if ((linea.Ni.nombre == aux[i - 1] && linea.Nf.nombre == aux[i]) ||
            (linea.Nf.nombre == aux[i - 1] && linea.Ni.nombre == aux[i])) {
          if (linea.tipo == 1) {
            linea.tipo = 5;
          } else if (linea.tipo == 0) {
            linea.tipo = 6;
          }
          break; // Salir del bucle interno si se encuentra la línea correspondiente
        }
      }
    }
  }

  creaKruskal(int mxmn) {
    sumaAlgor = "";
    clearLineas();
    int sum = 0;
    List<List<String>> matrizAdyacencia = [];
    matrizAdyacencia = generaMatriz(matrizAdyacencia);
    List<CaminoKrus> puentes = matrizToLista(matrizAdyacencia);
    List<String> vertices = matrizAdyacencia[0].sublist(1);
    Kruskal grafo = Kruskal(vertices, puentes);
    List<CaminoKrus> kruskal = grafo.kruskalMax();
    if (mxmn != 1) {
      kruskal = grafo.kruskalMin();
    }
    List<List<String>> aux = [];
    for (var puente in kruskal) {
      aux.add([puente.inicio, puente.destino]);
      sum += puente.peso;
    }
    sumaAlgor = "Suma: $sum";

    for (int i = 0; i < aux.length; i++) {
      for (int j = 0; j < vLineas.length; j++) {
        var linea = vLineas[j];
        if ((linea.Ni.nombre == aux[i][0] && linea.Nf.nombre == aux[i][1]) ||
            (linea.Nf.nombre == aux[i][0] && linea.Ni.nombre == aux[i][1])) {
          if (linea.tipo == 1) {
            linea.tipo = 5;
          } else if (linea.tipo == 0) {
            linea.tipo = 6;
          }
          break; // Salir del bucle interno si se encuentra la línea correspondiente
        }
      }
    }
  }

  clearLineas() {
    sumaAlgor = "";
    vLineas.forEach((linea) {
      linea.holg = "";
      if (linea.tipo == 5) {
        linea.tipo = 1;
      } else if (linea.tipo == 6) {
        linea.tipo = 0;
      }
    });
  }
}

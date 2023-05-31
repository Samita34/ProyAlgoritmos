class Dijkstra {
  List<dynamic> dijkstraMin(List<List<String>> mat,
      {String? inicio, String? fin}) {
    int n = mat.length;
    String auxin = inicio ?? mat[0][1];
    String auxfin = fin ?? mat[0][n - 1];
    int start = mat[0].contains(auxin) ? mat[0].indexOf(auxin) : 1;
    int end = mat[0].contains(auxfin) ? mat[0].indexOf(auxfin) : (n - 1);

    List<int> distancias = List.filled(n, 100000000);
    List<int> padres = List.filled(n, -1);
    distancias[start] = 0;

    Set<int> visitados = Set<int>();
    while (visitados.length < n) {
      int nodoActual = obtenerNodoConMenorDistancia(distancias, visitados);
      if (nodoActual == end) {
        break; // Se llegó al nodo de destino, se puede interrumpir el ciclo
      }

      visitados.add(nodoActual);

      for (int i = 1; i < n; i++) {
        if (mat[nodoActual][i] != "0" && !visitados.contains(i)) {
          int peso = int.parse(mat[nodoActual][i]);
          int distancia = distancias[nodoActual] + peso;
          if (distancia < distancias[i]) {
            distancias[i] = distancia;
            padres[i] = nodoActual;
          }
        }
      }
    }

    List<int> rutaIndices = construirRutaIndices(start, end, padres);
    List<String> rutaNombres =
        rutaIndices.map((index) => mat[0][index]).toList();
    int distanciaTotal = distancias[end];
    return [rutaNombres, distanciaTotal];
  }

  int obtenerNodoConMenorDistancia(List<int> distancias, Set<int> visitados) {
    int minDistancia = 100000000;
    int minNodo = -1;
    for (int i = 0; i < distancias.length; i++) {
      if (!visitados.contains(i) && distancias[i] < minDistancia) {
        minDistancia = distancias[i];
        minNodo = i;
      }
    }
    return minNodo;
  }

  List<int> construirRutaIndices(int start, int end, List<int> padres) {
    List<int> ruta = [end];
    int padreActual = padres[end];
    while (padreActual != -1 && padreActual != start) {
      ruta.insert(0, padreActual);
      padreActual = padres[padreActual];
    }
    if (padreActual == start) {
      ruta.insert(0, start);
    }
    return ruta;
  }

  List<dynamic> dijkstraMax(List<List<String>> mat,
      {String? inicio, String? fin}) {
    String auxin = inicio ?? mat[0][1];
    String auxfin = fin ?? mat[0][mat.length - 1];
    int start = mat[0].contains(auxin) ? mat[0].indexOf(auxin) : 1;
    int end =
        mat[0].contains(auxfin) ? mat[0].indexOf(auxfin) : (mat.length - 1);
    int sm = 0;
    List<String> ruta = [];
    sacarutas(int ini, sum, List<String> rut) {
      rut.add(mat[0][ini]);
      if (ini == end) {
        if (sum > sm) {
          sm = sum;
          ruta = rut.toList();
        }
        return;
      }
      if (start < end) {
        for (int i = 1; i < mat.length; i++) {
          if (mat[ini][i] != "0") {
            if (i > ini) {
              sacarutas(i, sum + int.parse(mat[ini][i]), List.from(rut));
            }
          }
        }
      } else {
        for (int i = 1; i < mat.length; i++) {
          if (mat[ini][i] != "0") {
            if (i < ini) {
              sacarutas(i, sum + int.parse(mat[ini][i]), List.from(rut));
            }
          }
        }
      }
    }

    if (start == end) {
      ruta.add(mat[0][start]);
      sm = int.parse(mat[start][end]);
    } else {
      sacarutas(start, 0, []);
    }
    return [ruta, sm];
    //print(ruta);
    //print(sm);
  }
}

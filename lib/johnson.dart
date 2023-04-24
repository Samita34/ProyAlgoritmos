class Johnson {
  calcJon(List<List<String>> mat) {
    int n = mat.length;
    int sm = 0;
    List<int> rutaMasLarga = [];
    List<String> rutaNodos = [];
    List<List<int>> todasRutas = [];

    void vuelta(int pos, int sum, List<int> ruta) {
      todasRutas.add(rutaMasLarga);
      if (sum > sm) {
        sm = sum;
        rutaMasLarga = ruta.toList();
      }

      for (int i = 1; i < n; i++) {
        if (mat[pos][i] != "0") {
          List<int> nuevaRuta = ruta.toList()..add(i);
          vuelta(i, sum + int.parse(mat[pos][i]), nuevaRuta);
        }
      }
    }

    for (int i = 1; i < n; i++) {
      vuelta(i, 0, [i]);
    }
    for (int i = 0; i < rutaMasLarga.length; i++) {
      rutaNodos.add(mat[0][rutaMasLarga[i]]);
    }

    return [rutaNodos, sm];
  }

  bool todoCero(List<String> fila) {
    for (int i = 1; i < fila.length; i++) {
      if (fila[i] != "0") {
        return false;
      }
    }
    return true;
  }

  //calcHolg(List<List<String>> mat,List<String>ruta,int sum) {
  //  int nr=ruta.length-1;
  //  int nm=mat.length;
  //  while(nr>=0){
  //    while(true){
  //      if(i)
  //    }
  //
  //  }
//
  //  return rutaNodos;
  //}

  bool unF(List<String> fila) {
    int c = 0;
    for (int i = 1; i < fila.length; i++) {
      if (fila[i] != "0") {
        c++;
      }
    }
    if (c <= 1) {
      return true;
    } else {
      return false;
    }
  }
}

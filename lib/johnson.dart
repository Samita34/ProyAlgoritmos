class Johnson {
  calcJon(List<List<String>> mat) {
    int n = mat.length;
    int sm = 0;
    List<int> rutaMasLarga = [];
    List<String> rutaNodos = [];

    void vuelta(int pos, int sum, List<int> ruta) {
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
    return [sm, rutaNodos];
  }
}

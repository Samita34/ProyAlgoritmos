class Norwest {
  //calcJon(List<List<String>> mat) {
  calcNor() {
    List<String> dem = ["300", "260", "440"];
    List<String> of = ["240", "260", "500"];
    //print(sums(dem));
    //print(sums(of));

    if (sums(dem) > sums(of)) {
      of.add((sums(dem) - sums(of)).toString());
    } else if (sums(dem) < sums(of)) {
      dem.add((sums(of) - sums(dem)).toString());
    }

    List<List<String>> mat = [
      ["20", "30", "36"],
      ["2", "10", "6"],
      ["14", "22", "18"]
    ];
    int n = mat.length;
    int m = mat[0].length;
    int s = 0;
    List<int> esq = [0, 0];
    List<List<String>> aux = List.generate(n, (_) => List.filled(m, "inf"));

    while (s < sums(dem)) {
      print(dem);
      int valof = int.parse(of[esq[0]]);
      int valdem = int.parse(dem[esq[1]]);
      if (valdem == valof) {
        aux[esq[0]][esq[1]] = valof.toString();
        s += valof;

        valof = 0;
        valdem = 0;
        of[esq[0]] = valof.toString();
        dem[esq[1]] = valdem.toString();
        esq[1] += 1;
        esq[0] += 1;
      } else if (valof > valdem) {
        aux[esq[0]][esq[1]] = valdem.toString();
        s += valdem;
        valof = valof - valdem;
        valdem = 0;
        of[esq[0]] = valof.toString();
        dem[esq[1]] = valdem.toString();
        esq[1] += 1;
      } else if (valof < valdem) {
        aux[esq[0]][esq[1]] = valof.toString();
        s += valof;
        valof = valof - valof;
        valdem = valdem - valof;
        of[esq[0]] = valof.toString();
        dem[esq[1]] = valdem.toString();
        esq[0] += 1;
      }
      //print(dem);
      //print(of);
    }
    //print(s);
    //void vuelta(int pos, int sum, List<int> ruta) {
    //  if (sum > sm) {
    //    sm = sum;
    //    rutaMasLarga = ruta.toList();
    //  }
    //  for (int i = 1; i < n; i++) {
    //    if (mat[pos][i] != "0") {
    //      List<int> nuevaRuta = ruta.toList()..add(i);
    //      vuelta(i, sum + int.parse(mat[pos][i]), nuevaRuta);
    //    }
    //  }
    //}
//
    //for (int i = 1; i < n; i++) {
    //  vuelta(i, 0, [i]);
    //}
    //for (int i = 0; i < rutaMasLarga.length; i++) {
    //  rutaNodos.add(mat[0][rutaMasLarga[i]]);
    //}
    //return [sm, rutaNodos];
  }

  int sums(List<String> vec) {
    int n = vec.length;
    int sum = 0;
    for (int i = 0; i < n; i++) {
      sum += int.parse(vec[i]);
    }
    return sum;
  }
}

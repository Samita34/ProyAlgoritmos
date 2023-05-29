class Norwest {
  calcNor(List<List<String>> mat, List<String> of, List<String> dem) {
    //calcNor() {
    //List<String> dem = ["2", "6", "5", "1"];
    //List<String> of = ["6", "5", "3"];
    //List<List<String>> mat = [
    //  ["", "a", "b", "c", "d"],
    //  ["a", "3", "2", "8", "9"],
    //  ["b", "7", "3", "2", "6"],
    //  ["c", "7", "3", "3", "3"],
    //  ["d", "0", "0", "0", "0"],
    //];
    int n = mat.length;
    int s = 0;
    List<int> esq = [1, 1];
    List<List<String>> aux =
        List.generate(n - 1, (_) => List.filled(n - 1, ""));
    while (esq[0] < n && esq[1] < n) {
      int valof = int.parse(of[esq[0] - 1]);
      int valdem = int.parse(dem[esq[1] - 1]);
      if (valdem == valof) {
        aux[esq[0] - 1][esq[1] - 1] = valof.toString();
        valof = 0;
        valdem = 0;
        of[esq[0] - 1] = valof.toString();
        dem[esq[1] - 1] = valdem.toString();
        esq[1]++;
        esq[0]++;
      } else if (valof > valdem) {
        aux[esq[0] - 1][esq[1] - 1] = valdem.toString();
        valof = valof - valdem;
        valdem = valdem - valdem;
        of[esq[0] - 1] = valof.toString();
        dem[esq[1] - 1] = valdem.toString();
        esq[1]++;
      } else if (valof < valdem) {
        aux[esq[0] - 1][esq[1] - 1] = valof.toString();

        valdem = valdem - valof;
        valof = valof - valof;

        of[esq[0] - 1] = valof.toString();
        dem[esq[1] - 1] = valdem.toString();
        esq[0]++;
      }
    }
    for (int i = 1; i < n; i++) {
      for (int j = 1; j < n; j++) {
        if (!identical("", aux[j - 1][i - 1])) {
          s += int.parse(aux[j - 1][i - 1]) * int.parse(mat[i][j]);
        }
      }
    }

    return [s, aux];
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
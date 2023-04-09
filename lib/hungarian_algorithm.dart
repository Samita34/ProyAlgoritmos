import 'dart:math';

List<int> hungarianAlgorithm(List<List<int>> matrix) {
  int n = matrix.length;
  List<int> result = List.filled(n, 0);
  List<int> u = List.filled(n + 1, 0);
  List<int> v = List.filled(n + 1, 0);
  List<int> p = List.filled(n + 1, 0);
  List<int> way = List.filled(n + 1, 0);

  for (int i = 1; i <= n; ++i) {
    p[0] = i;
    int j0 = 0;
    List<int> minv = List.filled(n + 1, 1000000000);
    List<bool> used = List.filled(n + 1, false);

    do {
      used[j0] = true;
      int i0 = p[j0];
      int delta = 1000000000;
      int j1 = -1;

      for (int j = 1; j <= n; ++j) {
        if (!used[j]) {
          int cur = matrix[i0 - 1][j - 1] - u[i0 - 1] - v[j]; // Línea corregida
          if (cur < minv[j]) {
            minv[j] = cur;
            way[j] = j0;
          }
          if (minv[j] < delta) {
            delta = minv[j];
            j1 = j;
          }
        }
      }

      for (int j = 0; j <= n; ++j) {
        if (used[j]) {
          u[p[j] - 1] += delta; // Línea corregida
          v[j] -= delta;
        } else {
          minv[j] -= delta;
        }
      }

      j0 = j1;
    } while (p[j0] != 0);

    do {
      int j1 = way[j0];
      p[j0] = p[j1];
      j0 = j1;
    } while (j0 != 0);
  }

  for (int j = 1; j <= n; ++j) {
    result[p[j] - 1] = j - 1;
  }

  return result;
}
import 'dart:math';

class Selection {
  selection(List<List<String>> matrix) {
    List<int> result = [];

    for (int i = 1; i < matrix.length; i++) {
      for (int j = 1; j < matrix.length; j++) {
        result.add(int.parse(matrix[i][j]));
      }
    }

    selectionSort(result);

    return result;
  }

  void selectionSort(List<int> arr) {
    int n = arr.length;

    for (int i = 0; i < n - 1; i++) {
      int minIndex = i;
      for (int j = i + 1; j < n; j++) {
        if (arr[j] < arr[minIndex]) {
          minIndex = j;
        }
      }

      if (minIndex != i) {
        int temp = arr[i];
        arr[i] = arr[minIndex];
        arr[minIndex] = temp;
      }
    }
  }
}

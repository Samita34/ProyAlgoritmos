import 'dart:math';

class norOst {
  List<List<int>> NorthWesth;
  int attr;

  norOst(this.NorthWesth, this.attr);
}

List<norOst> asignacionExtendida(List<List<int>> matrizDeCostos,
    List<int> demanda, List<int> disponibilidad, bool maximizar) {
  List<List<int>> result = [];
  //Valores iniciales
  print('Costos: ${matrizDeCostos}');
  print('Demanda: ${demanda}');
  print('Disponibilidad: ${disponibilidad}');
  //Solución factible inicial
  if (maximizar) {
    int maxValue = getMaxValue(matrizDeCostos);
    List<List<int>> invertedMatrix =
        invertMatrixValues(matrizDeCostos, maxValue);
    List<norOst> northWest =
        _northWest(disponibilidad, demanda, invertedMatrix);
    return northWest;
  } else {
    List<norOst> northWest =
        _northWest(disponibilidad, demanda, matrizDeCostos);
    return northWest;
  }
}

int getMaxValue(List<List<int>> matriz) {
  int maxValue = 0;
  for (final fila in matriz) {
    for (final valor in fila) {
      maxValue = max(maxValue, valor);
    }
  }
  return maxValue;
}

List<List<int>> invertMatrixValues(List<List<int>> matriz, int maxValue) {
  List<List<int>> invertedMatrix = [];
  for (final fila in matriz) {
    List<int> newRow = [];
    for (final valor in fila) {
      newRow.add(maxValue - valor);
    }
    invertedMatrix.add(newRow);
  }
  return invertedMatrix;
}

List<norOst> _northWest(
    List<int> Disponiblidad, List<int> Demanda, List<List<int>> matriz) {
  List<norOst> valores = [];
  int disp = Disponiblidad.length;
  int dmda = Demanda.length;
  List<List<int>> newMatriz = List.generate(disp, (_) => List.filled(dmda, 0));
  int i = 0, j = 0, attr = 0;
  while (i < disp && j < dmda) {
    if (Disponiblidad.isEmpty || Demanda.isEmpty) {
      break;
    }
    int cantidad = 0;
    if (Disponiblidad[i] > Demanda[j]) {
      cantidad = Demanda[j];
    } else {
      cantidad = Disponiblidad[i];
    }
    newMatriz[i][j] = cantidad;
    attr = attr + (cantidad * matriz[i][j]);
    Disponiblidad[i] -= cantidad;
    Demanda[j] -= cantidad;
    if (Disponiblidad[i] == 0) {
      i++;
    }
    if (Demanda[j] == 0) {
      j++;
    }
  }
  print('Matriz NorthWest: ${newMatriz}');
  print('Attr:${attr}');
  valores.add(norOst(newMatriz, attr));
  return valores;
}

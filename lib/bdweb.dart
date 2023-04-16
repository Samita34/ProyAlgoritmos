import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> obtenerDatos() async {
  final response = await http.get(Uri.parse('http://localhost:3000/api/mis_datos'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Error al obtener los datos');
  }
}

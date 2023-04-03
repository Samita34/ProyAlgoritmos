import 'package:flutter/material.dart';
import 'home.dart';
import 'package:flutter/rendering.dart' as rendering;

//Inicio del codigo
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Nos envía a home.dart
      home: Myhome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  final List<String> _items = [
    'Crear Nodo',
    'Crear relacion',
    'Eliminar',
    'Mover Nodo',
    'Editar Nodo',
    'Borrar Todo',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayuda'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_items[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}

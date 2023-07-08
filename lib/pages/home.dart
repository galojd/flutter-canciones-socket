import 'dart:io';

import 'package:bandas/models/Canciones.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Canciones> cancion = [
    Canciones(id: '1', nombre: 'Rule of natural', votos: 5),
    Canciones(id: '2', nombre: 'The only things', votos: 5),
    Canciones(id: '3', nombre: 'it has to be this way', votos: 5),
    Canciones(id: '4', nombre: 'Disturbet decadence', votos: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nombre de Canciones',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
          itemCount: cancion.length,
          itemBuilder: (context, i) => _CancionesTitulo(cancion[i])),
      //este es el boton para agregar nuevos elementos
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewCancion,
      ),
    );
  }

  Widget _CancionesTitulo(Canciones cancion) {
    return Dismissible(
      key: Key(cancion.id!),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        //llmar el borrado en el server
      },
      background: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Eliminar Cancion',
              style: TextStyle(color: Colors.white),
            ),
          )),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(cancion.nombre!.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(cancion.nombre!),
        trailing: Text(
          '${cancion.votos}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () {
          print(cancion.nombre);
        },
      ),
    );
  }

  addNewCancion() {
    final textController = new TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Nuevo nombre de cancion'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                  child: Text('Add'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => addCacnioneToList(textController.text))
            ],
          );
        },
      );
    }

    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text('Nuevo nombre de canción:'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('Add'),
                  onPressed: () => addCacnioneToList(textController.text)),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('dismis'),
                  onPressed: () => Navigator.pop(context))
            ],
          );
        });
  }

  void addCacnioneToList(String nombre) {
    print(nombre);
    if (nombre.length > 1) {
      //se puede agregar
      this.cancion.add(new Canciones(
          id: DateTime.now().toString(), nombre: nombre, votos: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}

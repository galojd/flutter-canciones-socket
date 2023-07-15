import 'dart:io';

import 'package:bandas/models/Canciones.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Canciones> cancion = [
    /*Canciones(id: '1', nombre: 'Rule of natural', votos: 5),
    Canciones(id: '2', nombre: 'The only things', votos: 5),
    Canciones(id: '3', nombre: 'it has to be this way', votos: 5),
    Canciones(id: '4', nombre: 'Disturbet decadence', votos: 5),*/
  ];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('bandas-activas', _AgregarCancionesNuevas);
    super.initState();
  }

  _AgregarCancionesNuevas(dynamic payload) {
    //handleActiveBands en el tutorial
    setState(() {
      this.cancion =
          (payload as List).map((cantar) => Canciones.fromMap(cantar)).toList();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('bandas-activas'); //con esto cierro el servicio
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nombre de Canciones',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.socket.connected
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: Column(
        children: [
          _Mostrargrafica(),
          Expanded(
            child: ListView.builder(
                itemCount: cancion.length,
                itemBuilder: (context, i) => _CancionesTitulo(cancion[i])),
          )
        ],
      ),
      //este es el boton para agregar nuevos elementos
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewCancion,
      ),
    );
  }

  Widget _CancionesTitulo(Canciones cancion) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(cancion.id!),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) =>
          socketService.socket.emit('eliminar-cancion', {'id': cancion.id}),
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
        onTap: () =>
            socketService.socket.emit('vota-cancion', {'id': cancion.id}),
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
    final socketService = Provider.of<SocketService>(context, listen: false);
    print(nombre);
    if (nombre.length > 1) {
      socketService.socket.emit('agregar-cancion', {'name': nombre});

      //se puede agregar
      /*this.cancion.add(new Canciones(
          id: DateTime.now().toString(), nombre: nombre, votos: 0));
      setState(() {});   esta es la forma manual es decir sin servidor*/
    }
    Navigator.pop(context);
  }

  Widget _Mostrargrafica() {
    Map<String, double> dataMap = new Map();
    cancion.forEach((canta) {
      dataMap.putIfAbsent(canta.nombre!, () => canta.votos!.toDouble());
    });

    return Container(
        padding: EdgeInsets.only(top: 10),
        width: double.infinity,
        height: 200,
        child: PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 32,
          //chartRadius: MediaQuery.of(context).size.width / 3.2,
          //colorList: colorList,
          initialAngleInDegree: 0,
          chartType: ChartType.disc,
          ringStrokeWidth: 32,
          //centerText: "HYBRID",
          legendOptions: LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            //legendShape: _BoxShape.circle,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          chartValuesOptions: ChartValuesOptions(
            showChartValueBackground: false,
            showChartValues: true,
            showChartValuesInPercentage: false,
            showChartValuesOutside: false,
            decimalPlaces: 0,
          ),
          // gradientList: ---To add gradient colors---
          // emptyColorGradient: ---Empty Color gradient---
        ));
  }
}

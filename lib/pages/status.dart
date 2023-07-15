import 'package:bandas/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('ServerStatus : ${socketService.serverStatus}')],
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.email_outlined),
        onPressed: () {
          String nombre;
          String mensaje;
          socketService.socket.emit(
              'emitir-mensaje', {'nombre': 'Jose', 'mensaje': 'Hola!!!!'});
          print('Un matrimonio africano');
        },
      ),
    );
  }
}

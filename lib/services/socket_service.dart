import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// Aquí manejo el estado, con una enumeración para manejar los estados
enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket? _socket;

  ServerStatus get serverStatus =>
      this._serverStatus; //accedo por meio de este get en vez de acerlo publico

  IO.Socket get socket => this._socket!;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    this._socket = IO.io('http://192.168.1.23:3000/', {
      'transports': ['websocket'],
      'AutoConnect': true
    });
    _socket!.on('connect', (_) {
      print('connect');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    //socket.on('event', (data) => print(data));
    _socket!.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    /*socket.on('nuevo-mensaje', (payload) {
      print('nuevo-mensaje :');
      print('nombre' + payload['nombre']);
      print('mensaje' + payload['mensaje']);
    });*/
  }
}

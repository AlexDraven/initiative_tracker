import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

class InitiativeWsService extends ChangeNotifier {
  InitiativeWsService() {
    final Socket _socket = io(
        'https://alex-initiative-tracker.herokuapp.com',
        OptionBuilder()
            .setPath('/ws/initiative')
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    print('InitiativeWsService created');
    _socket.onConnect((_) {
      print('connect');
      _socket.emit('msgToServer', 'test');
    });
    _socket.on('msgToClient', (data) => print('msgToClient: $data'));
    _socket.on('event', (data) => print(data));
    _socket.onDisconnect((_) => print('disconnect'));
    _socket.on('fromServer', (_) => print(_));
    print('InitiativeWsService connecting... ');
    _socket.on('connecting', (_) => print('connecting'));
//     const List EVENTS = [
//   'connect',
//   'connect_error',
//   'connect_timeout',
//   'connecting',
//   'disconnect',
//   'error',
//   'reconnect',
//   'reconnect_attempt',
//   'reconnect_failed',
//   'reconnect_error',
//   'reconnecting',
//   'ping',
//   'pong'
// ];
    _socket.on('connect', (data) => print('connect: $data'));
    _socket.on('connect_error', (data) => print('connect_error: $data'));
    _socket.on('connect_timeout', (data) => print('connect_timeout: $data'));
    _socket.on('connecting', (data) => print('connecting: $data'));
    _socket.on('disconnect', (data) => print('disconnect: $data'));
    _socket.on('error', (data) => print('error: $data'));
    _socket.on('reconnect', (data) => print('reconnect: $data'));
    _socket.on(
        'reconnect_attempt', (data) => print('reconnect_attempt: $data'));
    _socket.on('reconnect_failed', (data) => print('reconnect_failed: $data'));
    _socket.on('reconnect_error', (data) => print('reconnect_error: $data'));
    _socket.on('reconnecting', (data) => print('reconnecting: $data'));
    _socket.on('ping', (data) => print('ping: $data'));
    _socket.on('pong', (data) => print('pong: $data'));

    _socket.connect();
  }
}

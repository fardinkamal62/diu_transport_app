import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

socketio() {
  if (kDebugMode) {
    print("Connecting to socket.io server");
  }

  final socketUrl = dotenv.env['SOCKET_URL'] ?? '';

  if (socketUrl.isEmpty) {
    if (kDebugMode) {
      print('Error: SOCKET_URL is not set in the .env file');
    }
    return null;
  }
  // Dart client
  io.Socket socket = io.io(
    socketUrl,
    io.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build(),
  );

  socket.connect(); // manually connect the socket

  socket.onConnect((_) {
    if (kDebugMode) {
      print('Connected to socket.io server');
    }
  });

  socket.onError((error) {
    if (kDebugMode) {
      print('Error connecting to socket.io server: $error');
    }
  });

  socket.onclose((reason) {
    if (kDebugMode) {
      print('Disconnected from socket.io server');
    }
  });

  socket.onReconnect((_) {
    if (kDebugMode) {
      print('Reconnected to socket.io server');
    }
  });

  socket.onDisconnect((_) {
    if (kDebugMode) {
      print('Disconnected from socket.io server');
    }
  });

  return socket;
}

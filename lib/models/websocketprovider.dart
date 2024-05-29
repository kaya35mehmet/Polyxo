import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketProvider extends ChangeNotifier {
  WebSocketChannel? _channel;

  WebSocketChannel? get channel => _channel;

  void connect(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    notifyListeners();
  }

  void close() {
    _channel?.sink.close();
    _channel = null;
    notifyListeners();
  }
}

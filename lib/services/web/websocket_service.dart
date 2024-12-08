import 'dart:convert';

import 'package:chatapp/services/normal/auth_service.dart';
import 'package:chatapp/services/web/http_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

typedef onReceviceMessage(Map<String, dynamic> input);

class WebsocketService {
  final HttpService _httpService = HttpService();
  String Token = "";

  List<Map<String, dynamic>> totalMessages = [];
  int friendNumber = 0;

  int? Uid;
  List<Map<String, dynamic>> UserData = [];
  List<Map<String, dynamic>> roominfos = [];

  late IOWebSocketChannel channel;

  ObserverList<onReceviceMessage> observerList =
      ObserverList<onReceviceMessage>();

  Future<bool> connect(String token) async {
    print("token: $token");
    channel = IOWebSocketChannel.connect(
      'ws://8.218.213.232:9090/websocket/chat',
      headers: {
        'Authorization': token,
      },
    );

    channel.stream.listen((message) {
      debugPrint('Received: $message');
      Map<String, dynamic> jsonDate = jsonDecode(message);
      debugPrint(jsonDate.toString());
      observerList.forEach((onReceviceMessage Listener) {
        Listener(jsonDecode(message));
      });
    });
    return (channel == null) ? false : true;
  }

  disconnect() {
    channel.sink.close();
  }

  addListener(onReceviceMessage listener) {
    if (observerList.contains(listener)) return;
    observerList.add(listener);
  }

  removeListener(onReceviceMessage listener) {
    observerList.remove(listener);
  }

  Future<void> sendMessage(String content, int roomId, int type) async {
    String Type = (type == 1) ? "single" : "group";
    Map<String, dynamic> sendmessage = {
      "content": content,
      "roomId": roomId,
      "type": Type,
    };
    channel.sink.add(jsonEncode(sendmessage));
  }

  int getCurrentUserId() {
    return Uid!;
  }
}

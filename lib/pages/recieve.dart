// import 'dart:js_interop';

import 'package:chatapp/components/rec_message.dart';
import 'package:chatapp/components/room_list.dart';
import 'package:chatapp/services/normal/msg.dart';
import 'package:chatapp/services/normal/myuser_service.dart';
import 'package:chatapp/services/web/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Recieve extends StatefulWidget {
  Recieve({Key? key}) : super(key: key);

  String token = GetIt.instance<MyUserService>().token!;
  @override
  _RecieveState createState() => _RecieveState();
}

class _RecieveState extends State<Recieve> {
  List<Msg> msgList = List.empty(growable: true);

  void callback(int msgid) {
    setState(() {
      msgList.removeWhere((element) => element.applicationId == msgid);
    });
  }

  @override
  void initState() {
    super.initState();
    getFreind();
    getGroup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Email'),
      ),
      body: ListView.builder(
        itemCount: msgList.length,
        itemBuilder: (context, index) {
          return RecMessage(msg: msgList[index], back: callback);
        },
      ),
    );
  }

  getFreind() async {
    final HttpService httpService = HttpService();
    final response = await httpService.receivedFriendMsg(widget.token);

    if (response['code'] == 200) {
      var data = response['data'];
      for (var item in data) {
        Msg msg = Msg.fromjson(item);
        msg.type = 1;
        msgList.add(msg);
      }
      setState(() {
        msgList = msgList;
      });
    }
  }

  getGroup() async {
    final HttpService httpService = HttpService();
    final response = await httpService.receivedGroupMsg(widget.token);

    if (response['code'] == 200) {
      var data = response['data'];
      for (var item in data) {
        Msg msg = Msg.fromjson(item);
        msg.roomName = item['roomName'];
        msg.type = 2;
        msgList.add(msg);
      }
      setState(() {
        msgList = msgList;
      });
    }
  }
}

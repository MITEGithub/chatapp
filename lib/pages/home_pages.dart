import 'package:chatapp/components/room_list.dart';
import 'package:chatapp/components/showDialog.dart';
import 'package:chatapp/model/room.dart';
import 'package:chatapp/pages/add_room.dart';
import 'package:chatapp/components/my_drawer.dart';
import 'package:chatapp/pages/recieve.dart';
import 'package:chatapp/services/normal/myuser_service.dart';
import 'package:chatapp/services/web/http_service.dart';
import 'package:chatapp/services/web/websocket_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePages extends StatefulWidget {
  HomePages({super.key});

  String token = GetIt.instance<MyUserService>().token!;
  int myid = GetIt.instance<MyUserService>().id!;
  bool isMsg = false;

  @override
  _HomePagesState createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  List<Room> roomlist = List.empty(growable: true);

  WebsocketService? websocketService;

  @override
  void initState() {
    getChatList();

    websocketService = GetIt.instance<WebsocketService>();
    websocketService!.connect(widget.token).then((bool) {
      if (bool == true) {
        ShowDialog(context, "Connect success");
      } else {
        ShowDialog(context, "Connect failed");
      }
    });
  }

  @override
  void dispose() {
    websocketService!.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Home Page',
          style: TextStyle(fontSize: 25),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddRoom(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              onPressed: () {
                // Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Recieve(),
                  ),
                );
              },
              icon: Icon(Icons.email,
                  color: widget.isMsg ? Colors.red : Colors.grey),
            ),
          ),
        ],
      ),
      drawer: GetIt.instance<MyDrawer>(),
      body: ListView.builder(
        itemCount: roomlist.length,
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
        // physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return RoomList(roominfo: roomlist[index]);
        },
      ),
    );
  }

  Future<void> getChatList() async {
    final HttpService httpService = HttpService();
    final response = await httpService.authTotalMessage(widget.token);

    print("roomlist response: ${response}");
    if (response['code'] == 200) {
      List list = response['data'];
      list.forEach((element) {
        roomlist.add(Room.fromjson(element));
      });
    }

    await getUserIdList();
    await getEmail();
    setState(() {});
  }

  Future<void> getUserIdList() async {
    final HttpService httpService = HttpService();
    for (var element in roomlist) {
      if (element.type == 1) {
        final response =
            await httpService.roomToUser(widget.token, element.roomId);

        if (response['code'] == 200) {
          element.avatar = response['data'][0]['avatar'];
          var tmp = response['data'][0]['avatar'];
          print("nnnnn tmp: ${tmp}");
        }
      }
    }
    ;
    for (var room in roomlist) {
      print("OOAA: ${room.avatar}");
    }
  }

  Future<void> getEmail() async {
    final HttpService httpService = HttpService();
    final response1 = await httpService.receivedFriendMsg(widget.token);
    final response2 = await httpService.receivedGroupMsg(widget.token);

    if (response1['code'] == 200 && response2['code'] == 200) {
      if (response1['data'].length > 0 || response2['data'].length > 0) {
        bool flag = false;
        for (var item in response1['data']) {
          if (item['status'] == 0) {
            flag = true;
            break;
          }
        }
        for (var item in response2['data']) {
          if (item['status'] == 0) {
            flag = true;
            break;
          }
        }
        if (flag) {
          setState(() {
            widget.isMsg = true;
          });
        }
      }
    }
  }
}

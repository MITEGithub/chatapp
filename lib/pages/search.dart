import 'dart:math';

import 'package:chatapp/components/my_drawer.dart';
import 'package:chatapp/components/room_list.dart';
import 'package:chatapp/model/room.dart';
import 'package:chatapp/pages/search_result_page.dart';
import 'package:chatapp/services/normal/myuser_service.dart';
import 'package:chatapp/services/web/http_service.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:floating_tabbar/lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  String token = GetIt.instance<MyUserService>().token!;
  @override
  _SearcgPageState createState() => _SearcgPageState();
}

class _SearcgPageState extends State<SearchPage> {
  final TextEditingController _messageController = TextEditingController();
  List<Room> roomList = List.empty(growable: true);

  bool isPrivate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Search Your Want',
          style: TextStyle(fontSize: 25),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isPrivate = !isPrivate;
              });
            },
            icon: Icon(isPrivate ? Icons.person_add : Icons.group_add),
          ),
        ],
      ),
      drawer: GetIt.instance<MyDrawer>(),
      body: Center(
        child: search_input(),
      ),
    );
  }

  Widget search_input() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.025,
      ),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Theme.of(context).colorScheme.background,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: _messageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Search Something...",
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  )
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () => Search(context),
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
            shape: const CircleBorder(),
            color: Theme.of(context).colorScheme.inversePrimary,
            child: Icon(Icons.search,
                color: Theme.of(context).colorScheme.tertiary, size: 28),
          )
        ],
      ),
    );
  }

  void Search(BuildContext context) async {
    if (_messageController.text.isEmpty) return;
    roomList.clear();
    if (isPrivate) {
      final HttpService httpService = HttpService();
      final response =
          await httpService.searchUser(widget.token, _messageController.text);

      // print("search result: $response");
      if (response['code'] == 200) {
        var data = response['data'];
        await getUserIdList(roomList);
        data.forEach((element) {
          roomList.add(Room(
              roomId: element['id'], roomName: element['username'], type: 1));
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultPage(
              searchResult: roomList,
            ),
          ),
        );
      }
    } else {
      final HttpService httpService = HttpService();
      final response =
          await httpService.searchGroup(widget.token, _messageController.text);
      if (response['code'] == 200) {
        var data = response['data'];
        await getUserIdList(roomList);
        data.forEach((element) {
          roomList.add(
              Room(roomId: element['id'], roomName: element['name'], type: 2));
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultPage(
              searchResult: roomList,
            ),
          ),
        );
      }
    }
  }

  Future<void> getUserIdList(List<Room> roomlist) async {
    final HttpService httpService = HttpService();
    for (var element in roomlist) {
      if (element.type == 1) {
        final response =
            await httpService.roomToUser(widget.token, element.roomId);

        if (response['code'] == 200) {
          element.avatar = response['data'][0]['avatar'];
          var tmp = response['data'][0]['avatar'];
        }
      }
    }
  }
}

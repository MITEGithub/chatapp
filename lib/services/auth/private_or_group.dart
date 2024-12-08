import 'package:chatapp/components/my_drawer.dart';
import 'package:chatapp/components/room_list.dart';
import 'package:chatapp/model/room.dart';
import 'package:chatapp/services/normal/myuser_service.dart';
import 'package:chatapp/services/web/http_service.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:floating_tabbar/lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

class PrivateOrGroup extends StatefulWidget {
  PrivateOrGroup({super.key});

  String token = GetIt.instance<MyUserService>().token!;
  @override
  _PrivateOrGroupState createState() => _PrivateOrGroupState();
}

class _PrivateOrGroupState extends State<PrivateOrGroup> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    getFriendList();
    getGroupList();
  }

  List<Room> friendList = List.empty(growable: true);
  List<Room> groupList = List.empty(growable: true);
  List<Room> searchList = List.empty(growable: true);

  bool isSearching = false;
  bool index = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: isSearching
            ? TextField(
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Search your want!"),
                autofocus: true,
                style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                controller: _messageController,
                onChanged: (val) {
                  var list = index ? groupList : friendList;
                  searchList.clear();
                  for (var i in list) {
                    if (i.roomName.toLowerCase().contains(val.toLowerCase())) {
                      searchList.add(i);
                    }
                    setState(() {
                      searchList = searchList;
                    });
                  }
                },
              )
            : const Text(
                'ROOM LIST',
                style: TextStyle(fontSize: 25),
              ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
              });
            },
            icon: Icon(isSearching
                ? CupertinoIcons.clear_circled_solid
                : Icons.search),
          ),
        ],
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      drawer: GetIt.instance<MyDrawer>(),
      body:
          // search_input(),
          search_result(),
    );
    // return search_result();
  }

  Widget search_result() {
    return Container(
      child: ContainedTabBarView(
        tabs: const [
          Text("Firend"),
          Text("Group"),
        ],
        views: [
          PrivateList(),
          GroupList(),
        ],
        onChange: (e) {
          print("index is $e");
          setState(() {
            if (e == 0) {
              index = false;
            } else {
              index = true;
            }
            searchList.clear();
            _messageController.clear();
          });
        },
      ),
    );
  }

  Widget GroupList() {
    return ListView.builder(
      itemCount: isSearching ? searchList.length : groupList.length,
      itemBuilder: (context, index) {
        return RoomList(
            roominfo: isSearching ? searchList[index] : groupList[index]);
      },
    );
  }

  Widget PrivateList() {
    return ListView.builder(
      itemCount: isSearching ? searchList.length : friendList.length,
      itemBuilder: (context, index) {
        return RoomList(
            roominfo: isSearching ? searchList[index] : friendList[index]);
      },
    );
  }

  void getFriendList() async {
    final HttpService httpservice = HttpService();
    final response = await httpservice.authUserPrivateRoom(widget.token);
    print("user Private response: $response");

    if (response['code'] == 200) {
      var data = response['data'];
      data.forEach((user) {
        friendList.add(Room.fromjson(user));
      });
      await getUserIdList(friendList);
    }

    setState(() {});
  }

  void getGroupList() async {
    final HttpService httpservice = HttpService();
    final response = await httpservice.authUserGroupRoom(widget.token);

    if (response['code'] == 200) {
      var data = response['data'];
      data.forEach((group) {
        groupList.add(Room.fromjson(group));
      });
      await getUserIdList(groupList);
    }
    setState(() {});
  }

  void Search() {}

  Future<void> getUserIdList(List<Room> roomlist) async {
    final HttpService httpService = HttpService();
    for (var element in roomlist) {
      if (element.type == 1) {
        final response =
            await httpService.roomToUser(widget.token, element.roomId);
        print("nnnnn repsonse: ${response}");
        if (response['code'] == 200) {
          element.avatar = response['data'][0]['avatar'];
          var tmp = response['data'][0]['avatar'];
        }
      }
    }
  }
}

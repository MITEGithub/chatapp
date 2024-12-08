import 'package:chatapp/model/room.dart';
import 'package:chatapp/pages/chat_pages.dart';
import 'package:chatapp/services/normal/myuser_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RoomList extends StatefulWidget {
  final Room roominfo;
  const RoomList({
    Key? key,
    required this.roominfo,
  });

  @override
  _RoomListState createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04, vertical: 4),
      color: Theme.of(context).colorScheme.tertiary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0.5,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPages(
                token: GetIt.instance<MyUserService>().token!,
                roomId: widget.roominfo.roomId,
                roomName: widget.roominfo.roomName,
                type: widget.roominfo.type,
                myId: GetIt.instance<MyUserService>().id!,
                avatar: widget.roominfo.avatar == null
                    ? GetIt.instance<MyUserService>().avatar!
                    : widget.roominfo.avatar!,
              ),
            ),
          );
        },
        child: ListTile(
          leading: widget.roominfo.type == 1
              ? CircleAvatar(
                  // child: Icon(CupertinoIcons.person),
                  backgroundImage: NetworkImage(
                    widget.roominfo.avatar == null
                        ? GetIt.instance<MyUserService>().avatar!
                        : widget.roominfo.avatar!,
                  ),
                )
              : CircleAvatar(
                  child: Icon(Icons.group,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
          title: Text(
            widget.roominfo.roomName,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}

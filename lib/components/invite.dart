import 'package:chatapp/model/room.dart';
import 'package:chatapp/pages/invite_page.dart';
import 'package:chatapp/services/normal/myuser_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Invite extends StatefulWidget {
  final Room roominfo;
  bool isPrivate;
  Invite({
    Key? key,
    required this.roominfo,
    required this.isPrivate,
  });

  @override
  _InviteState createState() => _InviteState();
}

class _InviteState extends State<Invite> {
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
              builder: (context) => InvitePage(
                id: widget.roominfo.roomId,
                isPrivate: widget.isPrivate,
              ),
            ),
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.roominfo.avatar == null
                ? GetIt.instance<MyUserService>().avatar!
                : widget.roominfo.avatar!),
          ),
          title: Text(widget.roominfo.roomName),
          subtitle: const Text("Introduction yourserlf"),
          trailing: Icon(
            widget.isPrivate ? Icons.person_add : Icons.group_add,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
    );
  }
}

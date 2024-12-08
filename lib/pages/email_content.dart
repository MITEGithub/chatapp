import 'package:chatapp/components/showDialog.dart';
import 'package:chatapp/services/normal/msg.dart';
import 'package:chatapp/services/normal/myuser_service.dart';
import 'package:chatapp/services/web/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class EmailContent extends StatefulWidget {
  final Msg msg;
  final Function back;
  EmailContent({
    Key? key,
    required this.msg,
    required this.back,
  });

  String token = GetIt.instance<MyUserService>().token!;
  @override
  _EmailContentState createState() => _EmailContentState();
}

class _EmailContentState extends State<EmailContent> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: myTitle(),
          backgroundColor: const Color.fromARGB(0, 152, 42, 42),
          foregroundColor: Colors.grey,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: allow,
                icon: const Icon(Icons.check),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: refuse,
                icon: const Icon(Icons.close),
              ),
            ),
          ],
          // flexibleSpace: myTitle(),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Details:",
                style: TextStyle(fontSize: 20, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Container(
                child: widget.msg.type == 1
                    ? null
                    : Text(
                        "roomName:" + widget.msg.roomName!,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 350.0,
                height: 400.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.msg.applyMsg,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myTitle() {
    return Row(
      children: [
        ClipRRect(
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.height * 0.03),
          child: Padding(
            padding: const EdgeInsets.only(left: 0, top: 10, bottom: 12),
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.msg.applyUserAvatar),
              minRadius: 25,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          widget.msg.applyUserName,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void allow() async {
    HttpService httpService = HttpService();
    if (widget.msg.type == 1) {
      final response =
          await httpService.friendAllow(widget.msg.applicationId, widget.token);

      print("firend response $response");

      if (response['code'] == 200) {
        ShowDialog(context, "Invite sucessfully");
        // Navigator.pop(context);
      } else {
        ShowDialog(context, response['msg']);
        // Navigator.pop(context);
      }
    } else if (widget.msg.type == 2) {
      final response =
          await httpService.groupAllow(widget.msg.applicationId, widget.token);

      if (response['code'] == 200) {
        ShowDialog(context, "Invite sucessfully");
        // Navigator.pop(context);
      } else {
        ShowDialog(context, response['msg']);
        // Navigator.pop(context);
      }
    }
  }

  void refuse() async {
    HttpService httpService = HttpService();
    if (widget.msg.type == 1) {
      final response = await httpService.friendRefuse(
          widget.msg.applicationId, widget.token);

      print("friend allow is $response");
      if (response['code'] == 200) {
        ShowDialog(context, "Invite sucessfully");
        // Navigator.pop(context);
      } else {
        ShowDialog(context, response['msg']);
        // Navigator.pop(context);
      }
    } else if (widget.msg.type == 2) {
      final response =
          await httpService.groupRefuse(widget.msg.applicationId, widget.token);

      if (response['code'] == 200) {
        ShowDialog(context, "Invite sucessfully");
        // Navigator.pop(context);
      } else {
        ShowDialog(context, response['msg']);
        // Navigator.pop(context);
      }
    }
  }
}

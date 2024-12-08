import 'package:chatapp/components/showDialog.dart';
import 'package:chatapp/services/normal/myuser_service.dart';
import 'package:chatapp/services/web/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class InvitePage extends StatefulWidget {
  int id;
  bool isPrivate;
  InvitePage({
    Key? key,
    required this.id,
    required this.isPrivate,
  });
  String token = GetIt.instance<MyUserService>().token!;
  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  TextEditingController _usernameControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.isPrivate ? 'Add Friend' : "I Want to Join",
          style: const TextStyle(fontSize: 25),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _invite(context);
              // widget.callback();R
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
      body: bodyBuild(),
    );
  }

  Widget bodyBuild() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Transform.translate(
        offset: const Offset(0, -80),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Please write what you want to say",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Align(
                  // alignment: Alignment.center,
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter something',
                        alignLabelWithHint: true,
                      ),
                      controller: _usernameControl,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _invite(BuildContext context) async {
    HttpService httpService = HttpService();

    if (widget.isPrivate) {
      final response = await httpService.friendApplication(
          widget.token, widget.id, _usernameControl.text);

      if (response['code'] == 200) {
        ShowDialog(context, "Invite sucess");
        _usernameControl.clear();
        // Navigator.pop(context);
      } else {
        ShowDialog(context, response['msg']);
      }
    } else {
      final response = await httpService.groupApplication(
          widget.token, widget.id, _usernameControl.text);

      if (response['code'] == 200) {
        ShowDialog(context, "Invite sucess");
        _usernameControl.clear();
        // Navigator.pop(context);
      } else {
        ShowDialog(context, response['msg']);
      }
    }
  }
}

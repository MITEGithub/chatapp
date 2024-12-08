import 'package:chatapp/components/showDialog.dart';
import 'package:chatapp/services/normal/myuser_service.dart';
import 'package:chatapp/services/web/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AddRoom extends StatefulWidget {
  AddRoom({Key? key}) : super(key: key);

  String token = GetIt.instance<MyUserService>().token!;
  @override
  _AddRoomState createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  TextEditingController _nameControl = TextEditingController();
  TextEditingController _introControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Add Room',
          style: TextStyle(fontSize: 25),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => addroom(context),
            icon: const Icon(Icons.upload),
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
        // child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("RoomName:"),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _nameControl,
              decoration: const InputDecoration(
                hintText: 'Choose a name for your room',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text("RoomIntro:"),
            const SizedBox(
              height: 20,
            ),
            TextField(
              minLines: 3,
              maxLines: 5,
              controller: _introControl,
              decoration: const InputDecoration(
                hintText: 'Introduce your Room!',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        // ),
      ),
    );
  }

  void addroom(BuildContext context) async {
    HttpService httpService = HttpService();
    final response = await httpService.addRoom(
        widget.token, _nameControl.text, _introControl.text);

    _nameControl.clear();
    _introControl.clear();

    if (response['code'] == 200) {
      ShowDialog(context, "Add Room Success");
      Navigator.pop(context);
    } else {
      ShowDialog(context, "Add Room Failed");
      Navigator.pop(context);
    }
  }
}

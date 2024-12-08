import 'dart:io';
import 'dart:typed_data';

import 'package:chatapp/components/my_drawer.dart';
import 'package:chatapp/components/showDialog.dart';
import 'package:chatapp/model/user.dart';
import 'package:chatapp/services/normal/myuser_service.dart';
import 'package:chatapp/services/web/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

class UserInfo extends StatefulWidget {
  final Function callback;
  // final User user;
  UserInfo({super.key, required this.callback});
  String token = GetIt.instance<MyUserService>().token!;

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  File? selectImage;
  Uint8List? _image;
  TextEditingController _usernameControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'User Info',
          style: TextStyle(fontSize: 25),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _uploadUserInfo(context);
              // widget.callback();R
            },
            icon: const Icon(Icons.upload),
          ),
        ],
      ),
      drawer: GetIt.instance<MyDrawer>(),
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
              GestureDetector(
                onTap: () {
                  showImageOption(context);
                },
                child: _image != null
                    ? CircleAvatar(
                        radius: 150,
                        backgroundImage:
                            MemoryImage(_image!), // Replace with your image URL
                      )
                    : CircleAvatar(
                        radius: 120,
                        backgroundImage: NetworkImage(
                            GetIt.instance<MyUserService>()
                                .avatar!), // Replace with your image URL
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
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: GetIt.instance<MyUserService>().username!,
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

  void showImageOption(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.5,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickImageFromGrallery();
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 70,
                          ),
                          Text("Gallery"),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickImageFromCamera();
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(Icons.camera_alt, size: 70),
                          Text("Camera"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future _pickImageFromGrallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    setState(() {
      _image = File(pickedFile.path).readAsBytesSync();
      selectImage = File(pickedFile.path);
    });
    Navigator.of(context).pop();
  }

  Future _pickImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;
    setState(() {
      _image = File(pickedFile.path).readAsBytesSync();
      selectImage = File(pickedFile.path);
    });
    Navigator.of(context).pop();
  }

  Future<void> _uploadUserInfo(BuildContext context) async {
    final HttpService httpService = HttpService();
    if (selectImage == null) return;
    final response = await httpService.putUserInfo(
      widget.token,
      selectImage!,
      _usernameControl.text,
    );

    _usernameControl.clear();

    if (response['code'] == 200) {
      final result = await httpService.getUserInfo(widget.token);
      if (result['code'] == 200) {
        GetIt.instance<MyUserService>().username = result['data']['username'];
        GetIt.instance<MyUserService>().avatar = result['data']['avatar'];
        ShowDialog(
          context,
          "Upload success",
        );
        updateMyDrawerState();
      }
    }
  }
}

import 'package:chatapp/components/message_bubble.dart';
import 'package:chatapp/model/message.dart';
import 'package:chatapp/model/user.dart';
import 'package:chatapp/pages/detail.dart';
import 'package:chatapp/services/web/http_service.dart';
import 'package:chatapp/services/web/websocket_service.dart';
import 'package:chatapp/themes/themes_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatPages extends StatefulWidget {
  final String token;
  final String roomName;
  final int roomId;
  final int type;
  final int myId;
  final String avatar;

  ChatPages({
    super.key,
    required this.token,
    required this.roomId,
    required this.roomName,
    required this.type,
    required this.myId,
    required this.avatar,
  });

  @override
  State<ChatPages> createState() => _ChatPagesState();
}

class _ChatPagesState extends State<ChatPages> {
  final TextEditingController _messageController = TextEditingController();

  FocusNode myFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  late onReceviceMessage listener;
  bool isnull = true;

  List<Message> messageList = List.empty(growable: true);
  Set<User> userList = {};
  List<int> useridList = List.empty(growable: true);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        scrollDown();
      }
    });

    listener = (Map<String, dynamic> input) {
      if (mounted) {
        setState(() {
          print("add a message");
          if (input['code'] == 203) {
            Message newMessage = Message.fromjson(input['data']);
            if (newMessage.roomId == widget.roomId) {
              newMessage.setavatar(
                userList
                    .firstWhere(
                      (element) => element.userId == newMessage.senderUserId,
                    )
                    .avatar,
              );
              messageList.add(newMessage);
            }
          } else if (input['code'] == 202) {
            Message newMessage = Message(
              senderUserId: widget.myId,
              roomId: widget.roomId,
              message: _messageController.text,
              timestamp: DateTime.now().toString(),
            );
            messageList.add(newMessage);
            _messageController.clear();
          }
          // isnull = false;
        });
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    };

    GetIt.instance<WebsocketService>().addListener(listener);
    getChatHistory();

    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void disppose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      GetIt.instance<WebsocketService>()
          .sendMessage(_messageController.text, widget.roomId, widget.type);
      // _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: myTitle(),
          backgroundColor: const Color.fromARGB(0, 152, 42, 42),
          foregroundColor: Colors.grey,
          elevation: 0,
          // flexibleSpace: myTitle(),
        ),
        body: Column(
          children: [
            Expanded(
              child: _buildMessagesList(),
            ),
            buildUserInput(context),
          ],
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
            child: GestureDetector(
              onTap: () {
                if (widget.type != 1) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Detail(
                      user: User(
                        avatar: widget.avatar,
                        userId: -1,
                        userName: widget.roomName,
                      ),
                    ),
                  ),
                );
              },
              child: widget.type == 1
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(widget.avatar),
                      minRadius: 25,
                    )
                  : CircleAvatar(
                      minRadius: 25,
                      child: Icon(Icons.group,
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          widget.roomName,
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMessagesList() {
    return isnull
        ? Center(
            child: Text(
              "Let Begin!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 30,
              ),
            ),
          )
        : ListView.builder(
            controller: _scrollController,
            itemCount: messageList.length,
            itemBuilder: (context, index) {
              return _buildMessagesItem(messageList[index]);
            },
          );
  }

  Widget _buildMessagesItem(Message oneMessage) {
    bool isCurrentUser = oneMessage.senderUserId == widget.myId;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    User user = isCurrentUser
        ? User(avatar: "", userId: 0, userName: "")
        : userList.firstWhere(
            (element) => element.userId == oneMessage.senderUserId,
            orElse: () => User(avatar: "", userId: 0, userName: ""),
          );

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          MessageBubble(
            message: oneMessage,
            isCurrentUser: isCurrentUser,
            user: user,
          ),
        ],
      ),
    );
  }

  Widget buildUserInput(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemesProvider>(context, listen: false).isDarkMode;
    Color color = isDarkMode ? Colors.blue.shade800 : Colors.grey.shade500;

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
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.emoji_emotions, color: color, size: 25)),
                  Expanded(
                    child: TextField(
                      onTap: scrollDown,
                      controller: _messageController,
                      focusNode: myFocusNode,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Type Something...",
                        hintStyle: TextStyle(color: color),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: _pickImageFromGrallery,
                      icon: Icon(Icons.image, color: color, size: 26)),
                  IconButton(
                      onPressed: _pickImageFromCamera,
                      icon: Icon(Icons.camera_alt, color: color, size: 26)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  )
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: sendMessage,
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: color,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }

  getChatHistory() async {
    final HttpService httpService = HttpService();
    final response =
        await httpService.authRoomMessage(widget.token, widget.roomId);

    if (response['code'] == 200) {
      var RoomDate = response['data'];
      messageList.clear();

      RoomDate?.forEach((roomMessage) {
        messageList.add(Message.fromjson(roomMessage));
        useridList.add(roomMessage['sendUserId']);
      });
    }

    await updataUserList();

    setState(() {
      isnull = messageList.isEmpty;
    });
    scrollDown();
  }

  Future<void> updataUserList() async {
    final HttpService httpService = HttpService();

    final response =
        await httpService.getUserInfoList(widget.token, useridList);

    if (response['code'] == 200) {
      List list = response['data'];
      list.forEach((element) {
        messageList.forEach((message) {
          message.setavatar(element['avatar']);
          userList.add(User.fromjson(element));
        });
      });
    }
    userList.forEach((element) {});
    return Future.value();
  }

  Future _pickImageFromGrallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  Future _pickImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
  }
}

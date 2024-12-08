import 'package:chatapp/model/message.dart';
import 'package:chatapp/model/user.dart';
import 'package:chatapp/pages/detail.dart';
import 'package:chatapp/themes/themes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatefulWidget {
  final Message message;
  final User user;
  final bool isCurrentUser;
  const MessageBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.user,
  });

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return widget.isCurrentUser ? _currentUserMessage() : _othersMessage();
  }

  Widget _othersMessage() {
    bool isDarkMode = Provider.of<ThemesProvider>(context).isDarkMode;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.01,
                top: MediaQuery.of(context).size.height * 0.04,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Detail(user: widget.user),
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.message.avatar!),
                  minRadius: 19,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.04),
              child: Text(
                formatTime(widget.message.timestamp),
                style: TextStyle(
                  fontSize: 13,
                  color: isDarkMode ? Colors.white60 : Colors.black54,
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                  vertical: MediaQuery.of(context).size.height * 0.001,
                ),
                decoration: BoxDecoration(
                  color:
                      isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                  border: Border.all(color: Colors.blue),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Text(
                  widget.message.message,
                  style: TextStyle(
                    fontSize: 15,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _currentUserMessage() {
    bool isDarkMode = Provider.of<ThemesProvider>(context).isDarkMode;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                const Icon(Icons.done_all_rounded,
                    color: Colors.blue, size: 20),
                const SizedBox(
                  width: 2,
                ),
                Text(
                  formatTime(widget.message.timestamp),
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
            Flexible(
              child: Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                  vertical: MediaQuery.of(context).size.height * 0.01,
                ),
                decoration: BoxDecoration(
                  color:
                      isDarkMode ? Colors.blue.shade800 : Colors.grey.shade500,
                  border: Border.all(color: Colors.blue),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
                child: Text(
                  widget.message.message,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String formatTime(String input) {
    // 解析输入的时间字符串
    DateTime dateTime = DateTime.parse(input);

    // 格式化时间为 "HH:mm AM/PM"
    String hour = dateTime.hour > 12
        ? (dateTime.hour - 12).toString().padLeft(2, '0')
        : dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }
}

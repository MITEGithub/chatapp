import 'package:chatapp/themes/themes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String url;
  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemesProvider>(context).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser
            ? (isDarkMode ? Colors.blue.shade800 : Colors.grey.shade500)
            : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 25),
      child: ListTile(
        leading: isCurrentUser
            ? null
            : CircleAvatar(
                backgroundImage: NetworkImage(url),
              ),
        title: Text(
          message,
          style: TextStyle(
            color: isCurrentUser
                ? Colors.white
                : (isDarkMode ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}

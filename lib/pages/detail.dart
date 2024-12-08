import 'package:chatapp/model/user.dart';
import 'package:chatapp/pages/invite_page.dart';
import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  final User user;
  const Detail({
    super.key,
    required this.user,
  });

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Maybe Firend',
          style: TextStyle(fontSize: 25),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.user.userId == -1
                ? null
                : IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InvitePage(
                              id: widget.user.userId, isPrivate: true),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                  ),
          ),
        ],
      ),
      body: _buildbody(),
    );
  }

  Widget _buildbody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 150,
            backgroundImage: NetworkImage(widget.user.avatar),
          ),
          const SizedBox(height: 40),
          Text(
            widget.user.userName,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

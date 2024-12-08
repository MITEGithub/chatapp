import 'package:chatapp/pages/email_content.dart';
import 'package:chatapp/services/normal/msg.dart';
import 'package:flutter/material.dart';

class RecMessage extends StatefulWidget {
  final Msg msg;
  final Function back;
  RecMessage({
    Key? key,
    required this.msg,
    required this.back,
  });

  @override
  _RecMessageState createState() => _RecMessageState();
}

class _RecMessageState extends State<RecMessage> {
  late Color status_color;

  @override
  void initState() {
    super.initState();
    status_color = Color(0xFF000000);
    if (widget.msg.status == 0) {
      status_color = Colors.black54;
    } else if (widget.msg.status == 1) {
      status_color = Colors.green;
    } else if (widget.msg.status == -1) {
      status_color = Colors.red;
    }
  }

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
              builder: (context) =>
                  EmailContent(msg: widget.msg, back: widget.back),
            ),
          );
        },
        child: ListTile(
          textColor: status_color,
          leading: CircleAvatar(
            // child: Icon(CupertinoIcons.person),
            backgroundImage: NetworkImage(widget.msg.applyUserAvatar),
          ),
          title: Text(widget.msg.applyUserName),
          subtitle: Text(widget.msg.applyMsg),
          trailing: Text(
            formatTime(widget.msg.applyTime),
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
      ),
    );
  }

  String formatTime(String input) {
    DateTime dateTime = DateTime.parse(input);

    String hour = dateTime.hour > 12
        ? (dateTime.hour - 12).toString().padLeft(2, '0')
        : dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }
}

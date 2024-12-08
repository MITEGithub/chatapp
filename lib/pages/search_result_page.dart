import 'package:chatapp/components/invite.dart';
import 'package:chatapp/components/room_list.dart';
import 'package:chatapp/model/room.dart';
import 'package:flutter/material.dart';

class SearchResultPage extends StatefulWidget {
  List<Room> searchResult;
  SearchResultPage({
    Key? key,
    required this.searchResult,
  });

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Result'),
      ),
      body: ListView.builder(
        itemCount: widget.searchResult.length,
        itemBuilder: (context, index) {
          return Invite(
            roominfo: widget.searchResult[index],
            isPrivate: widget.searchResult[index].type == 1 ? true : false,
          );
        },
      ),
    );
  }
}

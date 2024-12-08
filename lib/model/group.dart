import 'package:chatapp/model/room.dart';

class Group extends Room {
  String groupName;
  int groupId;
  String? avatar;

  Group({
    required this.groupName,
    required this.groupId,
    required super.roomId,
    required super.roomName,
    required super.type,
  });

  Group.fromjson(Map<String, dynamic> data)
      : groupName = data['roomName'],
        groupId = data['roomId'],
        super(
          roomId: data['roomId'],
          roomName: data['roomName'],
          type: data['type'],
        );
}

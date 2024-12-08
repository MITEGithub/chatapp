class Room {
  int roomId;
  String roomName;
  String? Introduce;
  String? avatar;
  int type;

  Room({
    required this.roomId,
    required this.roomName,
    required this.type,
  });

  Room.fromjson(Map<String, dynamic> json)
      : roomId = json['roomId'],
        roomName = json['roomName'],
        type = json['type'];
}

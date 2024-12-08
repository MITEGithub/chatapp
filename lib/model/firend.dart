import 'package:chatapp/model/room.dart';

class Firend extends Room {
  final String name;
  final String imageUrl;

  Firend({
    required this.name,
    required this.imageUrl,
    required super.roomId,
    required super.roomName,
    required super.type,
  });

  Firend.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        imageUrl = json['imageUrl'],
        super(
          roomId: json['roomId'],
          roomName: json['roomName'],
          type: json['type'],
        );
}

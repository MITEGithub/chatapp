import 'package:flutter/material.dart';

class User {
  String userName;
  int userId;
  String avatar;
  User({
    required this.userName,
    required this.userId,
    required this.avatar,
  });

  User.fromjson(Map<String, dynamic> data)
      : userName = data['username'],
        userId = data['id'],
        avatar = data['avatar'];
}

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class HttpService {
  Dio dio = Dio();
  final String ip = 'http://8.218.213.232:9090';
  // final String ip = 'http://192.168.1.197:9090';
  int? friendNumber;

  Future<Map<String, dynamic>> authLogout(String token) async {
    String url = ip + '/user/logout';
    final response = await dio.post(
      url,
      data: jsonEncode({
        'Authorization': token,
      }),
    );
    return response.data;
  }

  Future<Map<String, dynamic>> authLogin(String email, String password) async {
    String url = ip + '/user/login';
    final response = await dio.post(url, data: {
      'email': email,
      'password': password,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> authRegister(String email, String password,
      String name, String verificationCode) async {
    String url = ip + '/email/register';
    final response = await dio.post(url, data: {
      'email': email,
      'password': password,
      'username': name,
      'verificationCode': verificationCode,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> authVerificationCode(String email) async {
    String url = ip + '/email/verificationCode';
    final response = await dio.get(url, queryParameters: {
      'email': email,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> authTotalMessage(String token) async {
    String url = ip + '/room/list';
    Options opt = Options(
      headers: {
        'Authorization': token,
      },
    );
    final response = await dio.get(
      url,
      options: opt,
      queryParameters: {
        "type": 3,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> authRoomMessage(String token, int roomId) async {
    String url = ip + '/room-message/list';
    Options opt = Options(
      headers: {
        'Authorization': token,
      },
    );
    final response = await dio.get(
      url,
      queryParameters: {
        'roomId': roomId,
      },
      options: opt,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> authUserinfo(
      List<int> usesid, String token) async {
    String url = ip + '/user/info-list';
    Options opt = Options(
      headers: {
        'Authorization': token,
      },
    );
    final response = await dio.get(
      url,
      queryParameters: {
        'userIds': usesid,
      },
      options: opt,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> authUserGroupRoom(String token) async {
    String url = ip + '/room/list';
    Options opt = Options(
      headers: {
        'Authorization': token,
      },
    );
    final response = await dio.get(
      url,
      options: opt,
      queryParameters: {
        'type': 2,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> authUserPrivateRoom(String token) async {
    String url = ip + '/room/list';
    Options opt = Options(
      headers: {
        'Authorization': token,
      },
    );
    final response = await dio.get(
      url,
      options: opt,
      queryParameters: {
        'type': 1,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getUserInfo(String token) async {
    String url = ip + '/user/info';
    Options opt = Options(
      headers: {
        'Authorization': token,
      },
    );
    final response = await dio.get(url, options: opt);
    return response.data;
  }

  Future<Map<String, dynamic>> putUserInfo(
    String token,
    File imageFile,
    String username,
  ) async {
    String url = ip + '/user/info';
    // print("imageFile: $imageFile");
    print("imageFile.path: ${imageFile.path}");
    print(
        "imageFile.uri.pathSegments.last: ${imageFile.uri.pathSegments.last}");
    FormData formData = FormData.fromMap({
      "avatarFile": await MultipartFile.fromFile(imageFile.path,
          filename: imageFile.uri.pathSegments.last),
    });
    // formData.files.add(MapEntry(
    //     'file':
    //     await MultipartFile.fromFile(imageFile.path,
    //         filename: imageFile.uri.pathSegments.last)));

    Options opt = Options(
      headers: {
        'Authorization': token,
        // 'Content-Type': 'multipart/form-data',
      },
    );

    final response =
        await dio.put(url, data: formData, options: opt, queryParameters: {
      'username': username,
    });

    return response.data;
  }

  Future<Map<String, dynamic>> getUserInfoList(
      String token, List<int> useridlist) async {
    String url = ip + '/user/info-list';
    Options opt = Options(
      headers: {
        'Authorization': token,
      },
    );
    print("useridlist: $useridlist");
    final response = await dio.get(
      url,
      options: opt,
      queryParameters: {
        "userIds": useridlist,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> roomToUser(String token, int roomId) async {
    String url = ip + '/room/';
    url = url + roomId.toString() + '/member/list';

    Options opt = Options(
      headers: {
        'Authorization': token,
      },
    );
    final response = await dio.get(
      url,
      options: opt,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> searchUser(String token, String name) async {
    String url = ip + '/user/search';
    Options opt = Options(
      headers: {
        'Authorization': token,
      },
    );
    final response = await dio.get(
      url,
      options: opt,
      queryParameters: {
        'searchKey': name,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> searchGroup(String token, String name) async {
    String url = ip + '/group-room/search';
    Options opt = Options(
      headers: {
        'Authorization': token,
      },
    );
    final response = await dio.get(
      url,
      options: opt,
      queryParameters: {
        'name': name,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> friendApplication(
      String token, int userId, String applyMsg) async {
    String url = ip + '/friend-application';
    Options opt = Options(
      headers: {
        'Authorization': token,
      },
    );
    final response = await dio.post(
      url,
      options: opt,
      queryParameters: {
        'userId': userId,
        'applyMsg': applyMsg,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> groupApplication(
      String token, int roomId, String applyMsg) async {
    String url = ip + '/group-application';
    Options opt = Options(
      headers: {
        'Authorization': token,
      },
    );
    final response = await dio.post(
      url,
      options: opt,
      queryParameters: {
        'roomId': roomId,
        'applyMsg': applyMsg,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> receivedFriendMsg(String token) async {
    String url = ip + '/friend-application/receive';
    Options opt = Options(
      headers: {
        'Authorization': token,
      },
    );
    final response = await dio.get(
      url,
      options: opt,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> receivedGroupMsg(String token) async {
    String url = ip + '/group-application/receive';
    Options opt = Options(
      headers: {
        'Authorization': token,
      },
    );
    final response = await dio.get(
      url,
      options: opt,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> groupAllow(
      int applicationid, String token) async {
    String path = ip + '/group-application/';
    path = path + applicationid.toString();
    Options opt = Options(
      headers: {
        'Authorization': token,
      },
    );
    final response = await dio.put(
      path,
      options: opt,
      queryParameters: {"status": 1},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> groupRefuse(
      int applicationid, String token) async {
    String path = ip + '/group-application/';
    path = path + applicationid.toString();
    Options opt = Options(
      headers: {
        'Authorization': token,
      },
    );
    final response = await dio.put(
      path,
      options: opt,
      queryParameters: {"status": -1},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> friendAllow(
      int applicationid, String token) async {
    String path = ip + '/friend-application/';
    path = path + applicationid.toString();
    Options opt = Options(
      headers: {
        'Authorization': token,
      },
    );
    final response = await dio.put(
      path,
      options: opt,
      queryParameters: {"status": 1},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> friendRefuse(
      int applicationid, String token) async {
    String path = ip + '/friend-application/';
    path = path + applicationid.toString();
    print("path: $path");
    Options opt = Options(
      headers: {
        'Authorization': token,
      },
    );
    final response = await dio.put(
      path,
      options: opt,
      queryParameters: {"status": -1},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> addRoom(
      String token, String name, String introduce) async {
    String url = ip + "/group-room";
    Options opt = Options(
      headers: {
        'Authorization': token,
      },
    );
    final response = await dio.post(
      url,
      options: opt,
      queryParameters: {
        'name': name,
        'introduce': introduce,
      },
    );
    return response.data;
  }
}

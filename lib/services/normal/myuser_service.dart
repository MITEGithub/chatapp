class MyUserService {
  int? id;
  String? username;
  String? avatar;
  String? token;

  MyUserService();

  init(int id, String username, String? avatar, String token) {
    this.id = id;
    this.username = username;
    this.avatar = avatar;
    this.token = token;
  }
}

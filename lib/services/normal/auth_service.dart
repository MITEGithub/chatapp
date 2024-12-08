import 'package:chatapp/services/web/http_service.dart';

class AuthService {
  AuthService._internal();
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  final HttpService _httpService = HttpService();
  String? token;
  String? verificationCode;
  int? userId;

  String? email;
  String? password;
  String? name;

  Future<Map<String, dynamic>> handleLogin() async {
    return _httpService.authLogin(email!, password!);
  }

  void LoginEmailPassword(String? email, String? password) {
    this.email = email;
    this.password = password;
  }

  Future<Map<String, dynamic>> HandleverificationCode(String email) async {
    return _httpService.authVerificationCode(email);
  }

  Future<Map<String, dynamic>> HandleReigster(
      String name, String email, String password, String verification) async {
    return _httpService.authRegister(email, password, name, verification);
  }

  Future<Map<String, dynamic>> HandleLogout() async {
    return _httpService.authLogout(token!);
  }
}

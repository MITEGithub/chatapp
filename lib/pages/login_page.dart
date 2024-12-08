import 'package:chatapp/components/showDialog.dart';
import 'package:chatapp/pages/home_pages.dart';
import 'package:chatapp/services/normal/myuser_service.dart';
import 'package:chatapp/services/web/http_service.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/components/my_textfield.dart';
import 'package:chatapp/components/my_button.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final void Function()? onTap;
  // final Function updateData;
  LoginPage({super.key, required this.onTap});

  void login(BuildContext context) async {
    final HttpService httpService = HttpService();
    final response = await httpService.authLogin(
        _emailController.text, _passwordController.text);
    // print(response['data']['token']);
    print(response);
    if (response['code'] == 200) {
      await getUserInfo(response['data']['token']);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePages(),
        ),
      );
    } else {
      return ShowDialog(context, "Login failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 50),
            Text(
              "Welcome back, you've been released!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),
            MyTextField(
              onTap: null,
              hintText: "Enter your email",
              obscureText: false,
              controller: _emailController,
              focusNode: _emailFocusNode,
              isshow: false,
            ),
            const SizedBox(height: 15),
            MyTextField(
              onTap: null,
              hintText: "Enter your password",
              obscureText: true,
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              isshow: false,
            ),
            const SizedBox(height: 25),
            MyButton(
              text: "Login",
              onTap: () => login(context),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member?  ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Register now!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  getUserInfo(String token) async {
    final HttpService httpService = HttpService();
    final response = await httpService.getUserInfo(token);

    MyUserService myuserservice = GetIt.instance<MyUserService>();
    myuserservice.init(response['data']['id'], response['data']['username'],
        response['data']['avatar'], token);
  }
}

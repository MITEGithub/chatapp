import 'package:chatapp/services/auth/login_or_register.dart';
import 'package:chatapp/components/my_button.dart';
import 'package:chatapp/components/my_textfield.dart';
import 'package:chatapp/services/web/http_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _comfirmpasController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _verificationCode = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _comfirmpasFocusNode = FocusNode();
  final FocusNode _verificationFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();

  void register(BuildContext context) async {
    final HttpService httpService = HttpService();
    if (_passwordController.text != _comfirmpasController.text) {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text("Password not match"),
              ));
      return;
    }

    final response = await httpService.authRegister(
      _emailController.text,
      _passwordController.text,
      _nameController.text,
      _verificationCode.text,
    );

    if (response['code'] == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginOrRegister(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Register failed"),
        ),
      );
    }
  }

  final void Function()? onTap;
  // final Function updateData;

  RegisterPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            Text(
              "Let's create an account for you!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 15),
            MyTextField(
              onTap: null,
              hintText: "Enter your name",
              obscureText: false,
              controller: _nameController,
              focusNode: _nameFocusNode,
              isshow: false,
            ),
            const SizedBox(height: 15),
            MyTextField(
              onTap: null,
              hintText: "Enter your email",
              obscureText: false,
              controller: _emailController,
              focusNode: _emailFocusNode,
              isshow: true,
            ),
            const SizedBox(height: 15),
            MyTextField(
              onTap: null,
              hintText: "Enter your verification code",
              obscureText: false,
              controller: _verificationCode,
              focusNode: _verificationFocusNode,
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
            const SizedBox(height: 15),
            MyTextField(
              onTap: null,
              hintText: "Comfirm your password",
              obscureText: true,
              controller: _comfirmpasController,
              focusNode: _comfirmpasFocusNode,
              isshow: false,
            ),
            const SizedBox(height: 15),
            MyButton(
              text: "Register",
              onTap: () => register(context),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?  ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Login now!",
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
}

import 'package:chatapp/services/normal/auth_service.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool? isshow;
  final Function()? onTap;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    required this.focusNode,
    required this.isshow,
    required this.onTap,
  });

  void sendVerificationCode(BuildContext context) async {
    final AuthService authService = AuthService();
    final response = await authService.HandleverificationCode(controller.text);

    if (response['code'] == 200) {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text("Verification code sent"),
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text("Failed to send verification code"),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            obscureText: obscureText,
            controller: controller,
            focusNode: focusNode,
            onTap: onTap,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.tertiary),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              fillColor: Theme.of(context).colorScheme.secondary,
              filled: true,
              hintText: hintText,
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          if (isshow == true)
            Positioned(
              right: 10,
              child: ElevatedButton(
                onPressed: () => sendVerificationCode(context),
                child: Text('获取验证码'),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:chatapp/pages/home_pages.dart';
import 'package:chatapp/pages/recieve.dart';
import 'package:chatapp/pages/search.dart';
import 'package:chatapp/pages/user_info.dart';
import 'package:chatapp/services/auth/login_or_register.dart';
import 'package:chatapp/services/auth/private_or_group.dart';
import 'package:chatapp/services/normal/auth_service.dart';
import 'package:chatapp/pages/setting_pages.dart';
import 'package:chatapp/services/normal/myuser_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  void logout(BuildContext context) {
    final AuthService authService = AuthService();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginOrRegister(),
      ),
    );
  }

  void callback(String name, String url) {
    setState(() {
      GetIt.instance<MyUserService>().username = name;
      GetIt.instance<MyUserService>().avatar = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      backgroundColor: Theme.of(context).colorScheme.background,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            drawerHeader(context),
            const SizedBox(height: 25),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: const Text("H O M E"),
                    leading: const Icon(Icons.home),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePages(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: const Text("S E T T I N G S"),
                    leading: const Icon(Icons.settings),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPages(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: const Text("R O O M L I S T"),
                    leading: const Icon(Icons.list),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrivateOrGroup(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: const Text("P E R S O N A L"),
                    leading: const Icon(Icons.person),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserInfo(
                            callback: callback,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: const Text("S E A R C H"),
                    leading: const Icon(Icons.search),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPage(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: const Text("R E C I E V E D"),
                    leading: const Icon(Icons.email),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Recieve(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Divider(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, bottom: 25),
              child: ListTile(
                title: const Text("L O G O U T"),
                leading: const Icon(Icons.logout),
                onTap: () {
                  Navigator.pop(context);
                  logout(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget drawerHeader(BuildContext context) => Material(
        color: Theme.of(context).colorScheme.inversePrimary,
        child: InkWell(
          onTap: () {},
          child: Container(
            color: Theme.of(context).colorScheme.inversePrimary,
            padding: EdgeInsets.only(
              top: 24 + MediaQuery.of(context).padding.top,
              bottom: 24,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundImage:
                      NetworkImage(GetIt.instance<MyUserService>().avatar!),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  GetIt.instance<MyUserService>().username!,
                  style: TextStyle(
                      fontSize: 28,
                      color: Theme.of(context).colorScheme.primary),
                )
              ],
            ),
          ),
        ),
      );
}

void updateMyDrawerState() {
  final drawerKey = GetIt.instance<GlobalKey<_MyDrawerState>>();
  if (drawerKey.currentState?.mounted ?? false) {
    drawerKey.currentState?.setState(() {});
  }
}

void registerState() {
  GetIt.instance.registerSingleton<GlobalKey<_MyDrawerState>>(
      GlobalKey<_MyDrawerState>());
}

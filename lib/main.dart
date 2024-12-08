import 'package:chatapp/components/my_drawer.dart';
import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/services/auth/login_or_register.dart';
import 'package:chatapp/services/normal/myuser_service.dart';
import 'package:chatapp/services/web/websocket_service.dart';
import 'package:chatapp/themes/themes_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.instance.registerSingleton<WebsocketService>(WebsocketService());
  GetIt.instance.registerSingleton<MyUserService>(MyUserService());
  GetIt.instance.registerSingleton<MyDrawer>(const MyDrawer());
  registerState();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemesProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginOrRegister(),
      theme: Provider.of<ThemesProvider>(context).themeData,
    );
  }
}

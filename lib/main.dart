// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:clone_instagram/firebase_options.dart';
import 'package:clone_instagram/services/local_noticfication_service.dart';
import 'package:clone_instagram/views/camera_page.dart';
import 'package:clone_instagram/views/home_page.dart';
import 'package:clone_instagram/views/messenger_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'views/auth/login.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    LocalNotificaionServie.initailize(context);
    FirebaseMessaging.instance.getInitialMessage().then((message) {});

    // Forground
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificaionServie.display(message);
    });
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox.expand(
                child: PageView(
                  controller: _pageController,
                  children: <Widget>[
                    CameraPage(),
                    HomePage(
                      currentUser: snapshot.data,
                    ),
                    MessengerPage(),
                  ],
                ),
              );
            } else {
              return Login();
            }
          },
        ),
      ),
    );
  }
}

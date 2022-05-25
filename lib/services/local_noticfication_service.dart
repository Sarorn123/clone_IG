// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:clone_instagram/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class LocalNotificaionServie {
  static final FlutterLocalNotificationsPlugin _localNotificaionPlugin =
      FlutterLocalNotificationsPlugin();

  static void initailize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _localNotificaionPlugin.initialize(initializationSettings,
        onSelectNotification: (String? rout) async {
      if (rout != null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MyApp()));
      }
    });
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "igCloneNotice",
          "igCloneNotice channel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );
      await _localNotificaionPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['rout'],
      );
    } on Exception catch (e) {
      print("Erorr => ");
      print(e.toString());
    }
  }

  // Onlike Post event

  static void onLikePostNoticfication(
    String userID,
    String ownerID,
    String postID,
  ) async {
    var resUser = await FirebaseFirestore.instance
        .collection("userInfo")
        .doc(userID)
        .get();
    var resOwner = await FirebaseFirestore.instance
        .collection("userInfo")
        .doc(ownerID)
        .get();
    var resPost =
        await FirebaseFirestore.instance.collection("post").doc(postID).get();
    dynamic post = resPost.data();
    dynamic user = resUser.data();
    dynamic owner = resOwner.data();

    // save notification
    var storeNotice = {
      "userID": ownerID,
      "noticOwner": userID,
      "title": user['displayName'],
      "body": user['displayName'] + ' Like Your Post ' + post['caption'],
      "date": Timestamp.now(),
      "postID": postID,
      "clicked": false,
      "type": "POST"
    };
    FirebaseFirestore.instance
        .collection("noticfication")
        .add(storeNotice)
        .then((value) {}, onError: (e) => print(e.toString()));

    // sent noticfication
    var data = {
      "to": owner['token'],
      "rout": "post",
      "notification": {
        "title": user['displayName'],
        "body": user['displayName'] + ' Like Your Post ' + post['caption'],
      },
    };

    const serverKey =
        "key=AAAA4Ud0OYI:APA91bEEIOz8ABBULIPKGAMmGobl_BuP_xk-89RbcrcsrH5C1Wx2tboNhew9gISCrIxypHNCDvw4xjgvAxggE0aQQG8p98NueJN8is8ZrZhBY5mOKOULCazGpPh60JUdf9wrJ6Lp6ZFf";
    final uri = Uri.parse("https://fcm.googleapis.com/fcm/send");
    final header = {
      "Authorization": serverKey,
      "Content-Type": "application/json",
    };

    http.post(uri, headers: header, body: jsonEncode(data)).then((response) {
      print("success");
      print(response.statusCode);
    }, onError: (e) {
      print("ot Success");
    });
  }

  static void onCommentPostNoticfication(
    String userID,
    String ownerID,
    String postID,
    String comment,
  ) async {
    var resUser = await FirebaseFirestore.instance
        .collection("userInfo")
        .doc(userID)
        .get();
    var resOwner = await FirebaseFirestore.instance
        .collection("userInfo")
        .doc(ownerID)
        .get();
    dynamic user = resUser.data();
    dynamic owner = resOwner.data();
    // store notification

    var storeNotice = {
      "userID": ownerID,
      "noticOwner": userID,
      "title": user['displayName'],
      "body": user['displayName'] + ' Comment On Your Post : ' + comment,
      "date": Timestamp.now(),
      "postID": postID,
      "clicked": false,
      "type": "POST"
    };
    FirebaseFirestore.instance
        .collection("noticfication")
        .add(storeNotice)
        .then((value) {}, onError: (e) => print(e.toString()));

    // sent notification

    var data = {
      "to": owner['token'],
      "rout": "post",
      "notification": {
        "title": user['displayName'],
        "body": user['displayName'] + ' Comment On Your Post : ' + comment,
      },
    };

    const serverKey =
        "key=AAAA4Ud0OYI:APA91bEEIOz8ABBULIPKGAMmGobl_BuP_xk-89RbcrcsrH5C1Wx2tboNhew9gISCrIxypHNCDvw4xjgvAxggE0aQQG8p98NueJN8is8ZrZhBY5mOKOULCazGpPh60JUdf9wrJ6Lp6ZFf";
    final uri = Uri.parse("https://fcm.googleapis.com/fcm/send");
    final header = {
      "Authorization": serverKey,
      "Content-Type": "application/json",
    };
    http.post(uri, headers: header, body: jsonEncode(data)).then((response) {
      print("success");
    }, onError: (e) {
      print("ot Success");
    });
  }

  static void onFollowNoticfication(
    String targetuserID,
    String currentUserID,
  ) async {
    var targetuserRes = await FirebaseFirestore.instance
        .collection("userInfo")
        .doc(targetuserID)
        .get();
    var resOwner = await FirebaseFirestore.instance
        .collection("userInfo")
        .doc(currentUserID)
        .get();
    dynamic targetuser = targetuserRes.data();
    dynamic currentUser = resOwner.data();
    // store notification

    var storeNotice = {
      "userID": targetuserID,
      "noticOwner": currentUserID,
      "title": currentUser['displayName'],
      "body": currentUser['displayName'] + ' Started Following You',
      "date": Timestamp.now(),
      "postID": "",
      "clicked": false,
      "type": "FOLLOW"
    };
    FirebaseFirestore.instance
        .collection("noticfication")
        .add(storeNotice)
        .then((value) {}, onError: (e) => print(e.toString()));

    // sent notification

    var data = {
      "to": targetuser['token'],
      "rout": "follow",
      "notification": {
        "title": currentUser['displayName'],
        "body": currentUser['displayName'] + ' Started Following You',
      },
    };

    const serverKey =
        "key=AAAA4Ud0OYI:APA91bEEIOz8ABBULIPKGAMmGobl_BuP_xk-89RbcrcsrH5C1Wx2tboNhew9gISCrIxypHNCDvw4xjgvAxggE0aQQG8p98NueJN8is8ZrZhBY5mOKOULCazGpPh60JUdf9wrJ6Lp6ZFf";
    final uri = Uri.parse("https://fcm.googleapis.com/fcm/send");
    final header = {
      "Authorization": serverKey,
      "Content-Type": "application/json",
    };
    http.post(uri, headers: header, body: jsonEncode(data)).then((response) {
      print("success");
    }, onError: (e) {
      print("ot Success");
    });
  }
}

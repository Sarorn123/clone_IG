// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, empty_catches

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './noticfition_card.dart';

class NotificationPage extends StatefulWidget {
  final dynamic currentUserInnfo;

  const NotificationPage({Key? key, required this.currentUserInnfo})
      : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List allNotifications = [];
  late String userID;
  bool _isLoading = true;

  Future<void> getAllNotifications() async {
    var response = await FirebaseFirestore.instance
        .collection("noticfication")
        .where("userID", isEqualTo: userID)
        .limit(10)
        .get();
    var noticeData = [];
    for (var doc in response.docs) {
      var resOwnerUser = await FirebaseFirestore.instance
          .collection("userInfo")
          .doc(doc.data()['noticOwner'])
          .get();
      bool followed = false;
      try {
        List follower = resOwnerUser.data()!["follower"];
        follower.firstWhere((id) => id == userID);
        setState(() {
          followed = !followed;
        });
      } catch (e) {}

      noticeData.add(
        {
          ...doc.data(),
          "id": doc.id,
          "photoURL": resOwnerUser.data()!['photoURL'],
          "follow": followed,
        },
      );
    }
    setState(() {
      allNotifications.addAll(noticeData);
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    userID = widget.currentUserInnfo['id'];
    getAllNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Activity",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                Text(
                  "Filter",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                  ),
                )
              ],
            ),
          ),
          // -> End Top Bar

          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "All Notification",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),

          _isLoading
              ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : allNotifications.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: allNotifications.length,
                        itemBuilder: (context, index) {
                          var notice = allNotifications[index];
                          return NotificationCard(
                            photoURL: notice['photoURL'],
                            title: notice['title'],
                            body: notice['body'],
                            follow: notice['follow'],
                            clicked: notice['clicked'],
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: Center(
                        child: Text("Wellcome To Instagram Clone"),
                      ),
                    )
        ],
      ),
    );
  }
}

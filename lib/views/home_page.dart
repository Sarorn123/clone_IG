// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:clone_instagram/views/home/add_new_post.dart';
import 'package:clone_instagram/views/home/home.dart';
import 'package:clone_instagram/views/home/notification_page.dart';
import 'package:clone_instagram/views/home/profile.dart';
import 'package:clone_instagram/views/home/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final dynamic currentUser;
  const HomePage({
    required this.currentUser,
  });
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  dynamic currentUserInfo = [];

  getUserInfo() async {
    FirebaseFirestore.instance
        .collection("userInfo")
        .where("userID", isEqualTo: widget.currentUser.uid)
        .limit(1)
        .get()
        .then(
      (res) async {
        // save token
        final token = await FirebaseMessaging.instance.getToken();
        FirebaseFirestore.instance
            .collection("userInfo")
            .doc(res.docs[0].id)
            .set(
          {"token": token},
          SetOptions(merge: true),
        );
        setState(() {
          currentUserInfo = {...res.docs[0].data(), "id": res.docs[0].id};
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();

    getUserInfo();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void setIndex() {
    setState(() {
      _currentIndex = 0;
      _pageController.jumpToPage(0);
    });
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    var pages = [
      Home(
        currentUserInfo: currentUserInfo,
      ),
      Search(),
      AddNewPost(
        currentUserInfo: currentUserInfo,
        setIndex: setIndex,
      ),
      NotificationPage(currentUserInnfo: currentUserInfo),
      Profile(
        currentUserInfo: currentUserInfo,
      ),
    ];

    var pageView = PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: pages,
    );

    var bottomNav = BottomNavigationBar(
      onTap: (tabIndex) {
        setState(() {
          _currentIndex = tabIndex;
        });
        _pageController.jumpToPage(tabIndex);
      },
      currentIndex: _currentIndex,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: SizedBox(
            height: 22,
            child: Image.asset(
              "assets/home.png",
            ),
          ),
          label: "home",
        ),
        BottomNavigationBarItem(
          icon: SizedBox(
            height: 22,
            child: Image.asset(
              "assets/search.png",
            ),
          ),
          label: "home",
        ),
        BottomNavigationBarItem(
          icon: SizedBox(
            height: 25,
            child: Image.asset(
              "assets/add_more.png",
            ),
          ),
          label: "home",
        ),
        BottomNavigationBarItem(
          icon: SizedBox(
            height: 22,
            child: Image.asset(
              "assets/heart.png",
            ),
          ),
          label: "home",
        ),
        BottomNavigationBarItem(
          icon: SizedBox(
            height: 22,
            child: Image.asset(
              "assets/person.png",
            ),
          ),
          label: "home",
        ),
      ],
    );

    return currentUserInfo.length == 0
        ? Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            // backgroundColor: Colors.black,
            body: pageView,
            bottomNavigationBar: bottomNav,
          );
  }
}

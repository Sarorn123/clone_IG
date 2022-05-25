// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:clone_instagram/views/auth/login.dart';
import 'package:clone_instagram/views/home/edit_profile.dart';
import 'package:clone_instagram/views/home/follower_following.dart';
import 'package:clone_instagram/views/home/list_own_photo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './recommentd_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  final dynamic currentUserInfo;
  const Profile({required this.currentUserInfo});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  dynamic userInfo = [];
  List userPosts = [];
  bool _isLoading = false;

  Future getUserInfo() async {
    FirebaseFirestore.instance
        .collection("userInfo")
        .doc(widget.currentUserInfo['id'])
        .snapshots()
        .listen(
      (event) {
        setState(() {
          userInfo = event.data();
        });
      },
    );
  }

  Future getAllUserPostImage() async {
    setState(() {
      _isLoading = !_isLoading;
    });
    FirebaseFirestore.instance
        .collection("post")
        .where("userID", isEqualTo: widget.currentUserInfo['id'])
        .get()
        .then((res) {
      List posts = [];
      for (var doc in res.docs) {
        posts.add(doc.data()['image']);
      }
      setState(() {
        userPosts.addAll(posts);
        _isLoading = !_isLoading;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    getAllUserPostImage();
  }

  @override
  Widget build(BuildContext context) {
    return userInfo.length == 0
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          userInfo["displayName"] ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 22,
                          child: Image.asset("assets/add_more.png"),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            FirebaseAuth.instance.signOut();
                          },
                          child: Icon(
                            Icons.logout,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                userInfo.length == 0
                                    ? Text("")
                                    : userInfo["photoURL"] != ""
                                        ? CircleAvatar(
                                            radius: 40,
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                userInfo["photoURL"],
                                              ),
                                              radius: 40,
                                            ),
                                          )
                                        : CircleAvatar(
                                            radius: 40,
                                            child: CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  "profile_no_img.png"),
                                              radius: 40,
                                            ),
                                          ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "0",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text("Posts"),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FollowerFollowing(
                                      userID: widget.currentUserInfo['id'],
                                      displayName:
                                          widget.currentUserInfo['displayName'],
                                      cuurentUserID:
                                          widget.currentUserInfo['id'],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                color: Colors.transparent,
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Text(
                                      userInfo.length == 0
                                          ? "--"
                                          : userInfo['follower']
                                              .length
                                              .toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text("Followers"),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FollowerFollowing(
                                      userID: widget.currentUserInfo['id'],
                                      displayName:
                                          widget.currentUserInfo['displayName'],
                                      cuurentUserID:
                                          widget.currentUserInfo['id'],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                color: Colors.transparent,
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Text(
                                      userInfo.length == 0
                                          ? "--"
                                          : userInfo['following']
                                              .length
                                              .toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text("Following"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // => bio

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          userInfo.length == 0 ? "--" : userInfo['bio'],
                        ),
                      ),

                      // -> edit profile

                      SizedBox(
                        height: 10,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfile(
                                        photoURL: userInfo['photoURL'],
                                        displayName: userInfo['displayName'],
                                        bio: userInfo['bio'],
                                        userID: widget.currentUserInfo['id'],
                                      ),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "Edit profile",
                                  // style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: OutlinedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                                child: Icon(Icons.person_add),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // => Discover People

                      SizedBox(
                        height: 10,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Discover people",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "See All",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 230,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  RecommendCard(),
                                  RecommendCard(),
                                  RecommendCard(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 15,
                      ),

                      // => photo section

                      TabBar(
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(width: 1.0),
                        ),
                        tabs: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.grid_view,
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 15,
                      ),

                      _isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : userPosts.isEmpty
                              ? Center(
                                  child: Text("No Post"),
                                )
                              : SizedBox(
                                  height: 300,
                                  child: TabBarView(
                                    children: [
                                      ListGridPhoto(allPosts: userPosts),
                                      ListGridPhoto(
                                        allPosts: [],
                                      ),
                                    ],
                                  ),
                                ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}

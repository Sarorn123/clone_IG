// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, use_key_in_widget_constructors

import 'package:clone_instagram/services/local_noticfication_service.dart';
import 'package:clone_instagram/views/home/follower_following.dart';
import 'package:clone_instagram/views/home/list_own_photo.dart';
import 'package:flutter/material.dart';
import './recommentd_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile extends StatefulWidget {
  final String userID;
  final String currentUserID;
  const UserProfile({required this.userID, required this.currentUserID});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  dynamic userInfo = [];
  bool followed = false;
  List userPosts = [];
  bool _isLoading = false;

  Future getUserInfo() async {
    FirebaseFirestore.instance
        .collection("userInfo")
        .doc(widget.userID)
        .snapshots()
        .listen(
      (res) {
        try {
          dynamic userInfoData = res.data();
          List follower = userInfoData["follower"];
          follower.firstWhere((id) => id == widget.currentUserID);
          setState(() {
            followed = true;
          });
        } catch (e) {
          followed = false;
        }

        setState(() {
          userInfo = {...?res.data(), "id": res.id};
        });

        // print(userInfo);
      },
    );
  }

  Future getAllUserPostImage() async {
    setState(() {
      _isLoading = !_isLoading;
    });
    FirebaseFirestore.instance
        .collection("post")
        .where("userID", isEqualTo: widget.userID)
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

  Future followUnfollowUser() async {
    setState(() {
      followed = !followed;
    });
    FirebaseFirestore.instance
        .collection("userInfo")
        .doc(userInfo['id'])
        .get()
        .then((res) {
      List follower = res.data()!["follower"];
      try {
        follower.firstWhere((id) => id == widget.currentUserID);
        follower.removeWhere(
          (id) => id == widget.currentUserID,
        );
      } catch (e) {
        follower.add(widget.currentUserID);
        if (userInfo['id'] != widget.currentUserID) {
          LocalNotificaionServie.onFollowNoticfication(
            userInfo['id'],
            widget.currentUserID,
          );
        }
      }

      FirebaseFirestore.instance
          .collection("userInfo")
          .doc(userInfo['id'])
          .set({"follower": follower}, SetOptions(merge: true)).then(
        (snapshot) {},
        onError: (e) => print(
          e.toString(),
        ),
      );
    }).whenComplete(() {
      FirebaseFirestore.instance
          .collection("userInfo")
          .doc(widget.currentUserID)
          .get()
          .then((res) {
        List following = res.data()!['following'];
        try {
          following.firstWhere((id) => id == widget.userID);
          following.removeWhere(
            (id) => id == widget.userID,
          );
        } catch (e) {
          following.add(widget.userID);
        }

        FirebaseFirestore.instance
            .collection("userInfo")
            .doc(widget.currentUserID)
            .set({"following": following}, SetOptions(merge: true));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    LocalNotificaionServie.initailize(context);
    getUserInfo();
    getAllUserPostImage();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: userInfo.length == 0
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
                              userInfo["displayName"],
                              // "hello",
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
                        // Row(
                        //   children: [
                        //     SizedBox(
                        //       height: 22,
                        //       child: Image.asset("assets/add_more.png"),
                        //     ),
                        //     SizedBox(
                        //       width: 15,
                        //     ),
                        //     GestureDetector(
                        //       onTap: () {
                        //         FirebaseAuth.instance.signOut();
                        //         Navigator.of(context).push(
                        //           MaterialPageRoute(
                        //             builder: ((context) => Login()),
                        //           ),
                        //         );
                        //       },
                        //       child: Icon(
                        //         Icons.logout,
                        //       ),
                        //     ),
                        //   ],
                        // ),
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
                                          builder: (context) =>
                                              FollowerFollowing(
                                                userID: widget.userID,
                                                displayName:
                                                    userInfo['displayName'],
                                                cuurentUserID:
                                                    widget.currentUserID,
                                              )),
                                    );
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    padding: EdgeInsets.all(5),
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
                                          builder: (context) =>
                                              FollowerFollowing(
                                                userID: widget.userID,
                                                displayName:
                                                    userInfo['displayName'],
                                                cuurentUserID:
                                                    widget.currentUserID,
                                              )),
                                    );
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    padding: EdgeInsets.all(5),
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
                                followed
                                    ? Expanded(
                                        child: OutlinedButton(
                                          onPressed: followUnfollowUser,
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                          ),
                                          child: Text("Followed"),
                                        ),
                                      )
                                    : Expanded(
                                        child: RaisedButton(
                                          onPressed: followUnfollowUser,
                                          color: Colors.blue[400],
                                          child: Text(
                                            "Follow",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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

                          SizedBox(
                            height: 300,
                            child: TabBarView(
                              children: [
                                ListGridPhoto(
                                  allPosts: [],
                                ),
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
              ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, empty_catches

import 'package:clone_instagram/services/local_noticfication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  final dynamic currentUserInfo;
  const Search({Key? key, required this.currentUserInfo}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List allUsers = [];
  final TextEditingController _keywordController = TextEditingController();

  Future getAllUser() async {
    allUsers = [];
    var response = await FirebaseFirestore.instance
        .collection("userInfo")
        .orderBy('displayName', descending: false)
        .startAt([_keywordController.text]).endAt(
            [_keywordController.text + "\uf8ff"]).get();
    var allUserData = [];
    for (var user in response.docs) {
      bool followed = false;
      try {
        List follower = user.data()["follower"];
        follower.firstWhere((id) => id == widget.currentUserInfo['id']);
        setState(() {
          followed = !followed;
        });
      } catch (e) {}

      allUserData.add(
        {
          ...user.data(),
          "id": user.id,
          "follow": followed,
        },
      );
    }
    setState(() {
      allUsers.addAll(allUserData);
    });
  }

  Future followUnfollowUser(String userID) async {
    var userInfo = allUsers.firstWhere((user) => user['id'] == userID);
    userInfo['follow'] = !userInfo['follow'];

    setState(() {
      allUsers.removeWhere((user) => user['id'] == userID);
      allUsers.add(userInfo);
    });

    /////////////

    FirebaseFirestore.instance
        .collection("userInfo")
        .doc(userID)
        .get()
        .then((res) {
      List follower = res.data()!["follower"];
      print("==>");
      print(follower);
      try {
        follower.firstWhere((id) => id == widget.currentUserInfo['id']);
        follower.removeWhere(
          (id) => id == widget.currentUserInfo['id'],
        );
      } catch (e) {
        follower.add(widget.currentUserInfo['id']);
        if (userID != widget.currentUserInfo['id']) {
          LocalNotificaionServie.onFollowNoticfication(
            userID,
            widget.currentUserInfo['id'],
          );
        }
      }

      FirebaseFirestore.instance
          .collection("userInfo")
          .doc(userID)
          .set({"follower": follower}, SetOptions(merge: true)).then(
        (snapshot) {},
        onError: (e) => print(
          e.toString(),
        ),
      );
    }).whenComplete(() {
      FirebaseFirestore.instance
          .collection("userInfo")
          .doc(widget.currentUserInfo['id'])
          .get()
          .then((res) {
        List following = res.data()!['following'];
        try {
          following.firstWhere((id) => id == userID);
          following.removeWhere(
            (id) => id == userID,
          );
        } catch (e) {
          following.add(userID);
        }

        FirebaseFirestore.instance
            .collection("userInfo")
            .doc(widget.currentUserInfo['id'])
            .set(
          {"following": following},
          SetOptions(merge: true),
        );
      });
    });
  }

  @override
  void initState() {
    super.initState();
    LocalNotificaionServie.initailize(context);
    getAllUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Search User")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  onSubmitted: (value) {
                    getAllUser();
                  },
                  style: TextStyle(color: Colors.white),
                  controller: _keywordController,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 15, color: Colors.white70),
                    hintText: 'Find More Friends ...',
                    border: InputBorder.none,
                    suffixIcon: GestureDetector(
                      onTap: getAllUser,
                      child: Icon(Icons.search),
                    ),
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ListView.builder(
                    itemCount: allUsers.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black12,
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                allUsers[index]['photoURL'] == ""
                                    ? CircleAvatar(
                                        backgroundImage:
                                            AssetImage("profile_no_img.png"),
                                        radius: 25,
                                      )
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            allUsers[index]['photoURL']),
                                        radius: 25,
                                      ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        allUsers[index]['displayName'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              allUsers[index]['follower']
                                                      .length
                                                      .toString() +
                                                  " Follower",
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Flexible(
                                            child: Text(
                                              allUsers[index]['following']
                                                      .length
                                                      .toString() +
                                                  " Following",
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(),
                                    ],
                                  ),
                                ),
                                allUsers[index]['follow']
                                    ? OutlinedButton(
                                        onPressed: () {
                                          followUnfollowUser(
                                            allUsers[index]['id'],
                                          );
                                        },
                                        child: Text(
                                          "Followed",
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                        // color: Colors.blueGrey,
                                      )
                                    : RaisedButton(
                                        onPressed: () {
                                          followUnfollowUser(
                                            allUsers[index]['id'],
                                          );
                                        },
                                        child: Text(
                                          "Follow",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        color: Colors.blue,
                                      )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

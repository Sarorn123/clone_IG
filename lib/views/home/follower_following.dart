// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:clone_instagram/views/home/folllowing_follower_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FollowerFollowing extends StatefulWidget {
  final String displayName;
  final String userID;
  final String cuurentUserID;
  FollowerFollowing({
    required this.userID,
    required this.displayName,
    required this.cuurentUserID,
  });

  @override
  State<FollowerFollowing> createState() => _FollowerFollowingState();
}

class _FollowerFollowingState extends State<FollowerFollowing> {
  List allUserFollower = [];
  List allUserFollowing = [];
  bool _isFollowerLoading = true;
  bool _isFollowingLoading = true;

  getUserInfoFollow() async {
    FirebaseFirestore.instance
        .collection("userInfo")
        .doc(widget.userID)
        .get()
        .then((res) async {
      List follower = res.data()!['follower'];
      List following = res.data()!['following'];

      if (follower.isNotEmpty) {
        var allUserFollowerData = [];
        for (String id in follower) {
          var res = await FirebaseFirestore.instance
              .collection("userInfo")
              .doc(id)
              .get();

          dynamic user = res.data();
          List follower = user['follower'];
          bool _isFollowed = false;
          try {
            follower.firstWhere((id) => id == widget.cuurentUserID);
            _isFollowed = true;
          } catch (e) {
            _isFollowed = false;
          }
          dynamic _lastUserResultFollower = {
            ...user,
            "id": res.id,
            "follow": _isFollowed
          };
          allUserFollowerData.add(_lastUserResultFollower);
        }

        setState(() {
          allUserFollower.addAll(allUserFollowerData);
          _isFollowerLoading = false;
        });
      } else {
        setState(() {
          _isFollowerLoading = false;
        });
      }

      if (following.isNotEmpty) {
        var allUserFollowingData = [];
        for (String id in following) {
          var res = await FirebaseFirestore.instance
              .collection("userInfo")
              .doc(id)
              .get();
          dynamic user = res.data();
          List following = user['following'];
          bool _isFollowed = false;
          try {
            following.firstWhere((id) => id == widget.cuurentUserID);
            _isFollowed = true;
          } catch (e) {
            _isFollowed = false;
          }
          dynamic _lastUserResultFollowing = {
            ...user,
            "id": res.id,
            "follow": _isFollowed
          };

          allUserFollowingData.add(_lastUserResultFollowing);
        }
        setState(() {
          allUserFollowing.addAll(allUserFollowingData);
          _isFollowingLoading = false;
        });
      } else {
        setState(() {
          _isFollowingLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfoFollow();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: SizedBox(
                height: 40,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      widget.displayName,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            DefaultTabController(
              length: 2,
              child: Expanded(
                child: Column(
                  children: [
                    TabBar(
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(width: 1.0),
                      ),
                      tabs: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            allUserFollower.length.toString() + " followers",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            allUserFollowing.length.toString() + " following",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    // Start Item

                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 500,
                            child: TabBarView(
                              children: [
                                _isFollowerLoading
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : allUserFollower.isEmpty
                                        ? Center(
                                            child: Text("No Follower Yet !"),
                                          )
                                        : Column(
                                            children: List.generate(
                                              allUserFollower.length,
                                              (index) => FollowingFollowerCard(
                                                displayName:
                                                    allUserFollower[index]
                                                        ['displayName'],
                                                photoURL: allUserFollower[index]
                                                    ['photoURL'],
                                                followed: allUserFollower[index]
                                                    ['follow'],
                                              ),
                                            ).toList(),
                                          ),
                                _isFollowingLoading
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : allUserFollowing.isEmpty
                                        ? Center(
                                            child: Text("No Following Yet !"),
                                          )
                                        : Column(
                                            children: List.generate(
                                              allUserFollowing.length,
                                              (index) => FollowingFollowerCard(
                                                displayName:
                                                    allUserFollowing[index]
                                                        ['displayName'],
                                                photoURL:
                                                    allUserFollowing[index]
                                                        ['photoURL'],
                                                followed:
                                                    allUserFollowing[index]
                                                        ['follow'],
                                              ),
                                            ).toList(),
                                          ),
                              ],
                            ),
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

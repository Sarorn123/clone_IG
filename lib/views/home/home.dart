// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:clone_instagram/services/local_noticfication_service.dart';
import 'package:clone_instagram/views/home/post_card.dart';
import 'package:clone_instagram/views/home/story_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Home extends StatefulWidget {
  final dynamic currentUserInfo;
  Home({required this.currentUserInfo});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  dynamic posts = [];
  bool _isLoading = true;

  Future getAllPosts() async {
    // get All Post by following user
    try {
      FirebaseFirestore.instance
          .collection("post")
          .where("userID", whereIn: widget.currentUserInfo['following'])
          .orderBy("created_at", descending: true)
          .snapshots()
          .listen((event) {
        final postData = [];
        for (var doc in event.docs) {
          postData.add({...doc.data(), "id": doc.id});
        }

        setState(() {
          _isLoading = false;
          posts = postData;
        });
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
    print("current_user");
    print(widget.currentUserInfo);
  }

  Future deletePost(String postID, String imageURL) async {
    try {
      FirebaseStorage.instance.refFromURL(imageURL).delete();
      FirebaseFirestore.instance.collection("post").doc(postID).delete();
    } on Exception catch (e) {
      print("delete image ");
      print(e.toString());
    }
    FirebaseFirestore.instance
        .collection("comment")
        .where("postID", isEqualTo: postID)
        .get()
        .then(
      (response) {
        for (var comment in response.docs) {
          FirebaseFirestore.instance
              .collection("comment")
              .doc(comment.id)
              .delete();
        }
      },
    );
  }

  Future likePost(String postID, String ownerID, String currentUserID) async {
    FirebaseFirestore.instance.collection("post").doc(postID).get().then((res) {
      List likes = res.data()!["like"];
      int noticCount = res.data()!["likeNoticficationCount"];
      try {
        likes.firstWhere((id) => id == currentUserID);
        likes.removeWhere(
          (id) => id == currentUserID,
        );
      } catch (e) {
        likes.add(currentUserID);

        if (currentUserID != ownerID) {
          if (noticCount <= 10) {
            LocalNotificaionServie.onLikePostNoticfication(
              currentUserID,
              ownerID,
              postID,
            );
          }
        }
      }

      FirebaseFirestore.instance.collection("post").doc(postID).set(
        {"like": likes, "likeNoticficationCount": noticCount + 1},
        SetOptions(merge: true),
      ).then(
        (snapshot) {},
        onError: (e) => print(
          e.toString(),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getAllPosts();
    LocalNotificaionServie.initailize(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 25,
              child: Image.asset("assets/camera.png"),
            ),
            SizedBox(
              height: 45,
              child: Image.asset(
                "assets/logo_text.png",
              ),
            ),
            SizedBox(
              height: 25,
              child: Image.asset("assets/messenger.jpg"),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Stories",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),

              // ->End Header

              Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        StoryCard(
                          isAlreadySee: false,
                          isYour: true,
                        ),
                        StoryCard(
                          isAlreadySee: true,
                          isYour: false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    color: Colors.black26,
                    height: 1,
                  ),

                  // -> Start New Feed

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : posts.length == 0
                            ? Center(child: Text("U dont't follow to anyone !"))
                            : Column(
                                children: List.generate(
                                  posts.length,
                                  (index) => PostCard(
                                    post: posts[index],
                                    currentUserInfo: widget.currentUserInfo,
                                    likePost: likePost,
                                    deletePost: deletePost,
                                  ),
                                ).toList(),
                              ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

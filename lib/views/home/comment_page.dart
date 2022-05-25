// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new

import 'package:clone_instagram/services/local_noticfication_service.dart';
import 'package:clone_instagram/views/home/circle_profile_picture.dart';
import 'package:clone_instagram/views/home/comment_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentPage extends StatefulWidget {
  final String photoURL;
  final String displayName;
  final String caption;
  final String postID;
  final dynamic currentUser;

  CommentPage({
    required this.photoURL,
    required this.displayName,
    required this.caption,
    required this.postID,
    required this.currentUser,
  });

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  dynamic comments = [];
  bool _isLoading = true;
  bool _editing = false;
  late String commentEditingID;
  var commentController = TextEditingController();

  Future getAllComments() async {
    FirebaseFirestore.instance
        .collection("comment")
        .where("postID", isEqualTo: widget.postID)
        .orderBy("created_at", descending: true)
        .snapshots()
        .listen(
      (event) {
        final commentData = [];
        for (var doc in event.docs) {
          commentData.add({...doc.data(), "id": doc.id});
        }
        setState(() {
          comments = commentData;
          _isLoading = false;
        });
      },
    );
  }

  Future addComment() async {
    if (commentController.text != "") {
      var data = {
        "comment": commentController.text,
        "created_at": Timestamp.now(),
        "userID": widget.currentUser['id'],
        "photoURL": widget.currentUser['photoURL'] ?? "",
        "displayName": widget.currentUser['displayName'],
        "like": 0,
        "postID": widget.postID,
      };

      FirebaseFirestore.instance.collection("comment").add(data).then(
        (snapshot) async {
          var data = await snapshot.get();
          var comment = data.data()!['comment'];
          var response = await FirebaseFirestore.instance
              .collection("post")
              .doc(widget.postID)
              .get();

          int commentNoticficationCount =
              response.data()!['commentNoticficationCount'];
          String ownerID = response.data()!['userID'];

          if (widget.currentUser['id'] != ownerID) {
            if (commentNoticficationCount <= 10) {
              LocalNotificaionServie.onCommentPostNoticfication(
                widget.currentUser['id'],
                ownerID,
                widget.postID,
                comment,
              );
            }
          }
        },
        onError: (e) => print(
          e.toString(),
        ),
      );

      FirebaseFirestore.instance
          .collection("post")
          .doc(widget.postID)
          .get()
          .then(
        (res) {
          var comment = res.data()!['comment'];
          var commentNoticficationCount =
              res.data()!['commentNoticficationCount'];
          FirebaseFirestore.instance.collection("post").doc(widget.postID).set({
            "comment": comment + 1,
            "commentNoticficationCount": commentNoticficationCount + 1
          }, SetOptions(merge: true)).then(
            (snapshot) {},
            onError: (e) => print(
              e.toString(),
            ),
          );
        },
        onError: (e) => print(
          e.toString(),
        ),
      );

      commentController.text = "";
    }
  }

  Future editComment() async {
    var data = {
      "comment": commentController.text,
    };

    FirebaseFirestore.instance
        .collection("comment")
        .doc(commentEditingID)
        .set(data, SetOptions(merge: true))
        .then(
          (snapshot) {},
          onError: (e) => print(
            e.toString(),
          ),
        );

    commentController.text = "";
    _editing = false;
  }

  Future onClickEdit(String defaultValue, String commentEditID) async {
    _editing = true;
    setState(() {
      commentEditingID = commentEditID;
    });
    commentController.text = defaultValue;
  }

  Future deleteComment(String id) async {
    FirebaseFirestore.instance.collection("comment").doc(id).delete();
    FirebaseFirestore.instance.collection("post").doc(widget.postID).get().then(
      (res) {
        var comment = res.data()!['comment'];
        FirebaseFirestore.instance
            .collection("post")
            .doc(widget.postID)
            .set({"comment": comment - 1}, SetOptions(merge: true)).then(
          (snapshot) {},
          onError: (e) => print(
            e.toString(),
          ),
        );
      },
      onError: (e) => print(
        e.toString(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    LocalNotificaionServie.initailize(context);
    getAllComments();
  }

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Comments",
        ),
        actions: [Icon(Icons.share)],
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleProfilePicture(
                      isYour: false,
                      isAlreadySee: false,
                      image: widget.photoURL,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.displayName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(widget.caption)
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 40,
              ),
              // => All comments go

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: _isLoading
                    ? Text("Loading...")
                    : comments.length == 0
                        ? Center(child: Text("No Comment Yet"))
                        : Column(
                            children: List.generate(
                              comments.length,
                              (index) => CommentCard(
                                photoURL: comments[index]['photoURL'],
                                displayName: comments[index]['displayName'],
                                comment: comments[index]['comment'],
                                date: comments[index]['created_at'],
                                currentUserID: widget.currentUser['id'],
                                userID: comments[index]['userID'],
                                onClickEdit: onClickEdit,
                                deleteComment: deleteComment,
                                id: comments[index]['id'],
                              ),
                            ).toList(),
                          ),
              )
            ],
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            height: 100.0,
            bottom: 0,
            child: Column(
              children: [
                Container(
                  height: 40,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      GestureDetector(
                        child: Text("😍"),
                        onTap: () {},
                      ),
                      GestureDetector(
                        child: Text("😋"),
                        onTap: () {},
                      ),
                      GestureDetector(
                        child: Text("😂"),
                        onTap: () {},
                      ),
                      GestureDetector(
                        child: Text("🤩"),
                        onTap: () {},
                      ),
                      GestureDetector(
                        child: Text("😥"),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.black,
                ),
                Container(
                  height: 59,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      // CircleProfilePicture(isYour: false, isAlreadySee: false),
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          onSubmitted: (value) {
                            if (_editing) {
                              editComment();
                            } else {
                              addComment();
                            }
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Add a comment ...',
                            hintStyle: TextStyle(color: Colors.black38),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_const, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'circle_profile_picture.dart';

class CommentCard extends StatefulWidget {
  final String photoURL;
  final String displayName;
  final String comment;
  final Timestamp date;
  final String currentUserID;
  final String userID;
  final Function onClickEdit;
  final Function deleteComment;
  final String id;

  CommentCard({
    required this.photoURL,
    required this.displayName,
    required this.comment,
    required this.date,
    required this.currentUserID,
    required this.userID,
    required this.onClickEdit,
    required this.deleteComment,
    required this.id,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.photoURL != ""
                  ? CircleProfilePicture(
                      isYour: false,
                      isAlreadySee: false,
                      image: widget.photoURL,
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: CircleAvatar(
                        radius: 22,
                        child: CircleAvatar(
                          backgroundImage: AssetImage("profile_no_img.png"),
                          radius: 22,
                        ),
                      ),
                    ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.comment,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          // DateTime.parse(widget.date.toDate().toString())
                          //     .toString(),
                          "7:00am",
                          style: TextStyle(color: Colors.black45),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Reply",
                          style: TextStyle(color: Colors.black45),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        widget.currentUserID == widget.userID
                            ? GestureDetector(
                                onTap: () {
                                  widget.onClickEdit(widget.comment, widget.id);
                                },
                                child: Text(
                                  "edit",
                                  style: TextStyle(color: Colors.black45),
                                ),
                              )
                            : Text(""),
                        SizedBox(
                          width: 10,
                        ),
                        widget.currentUserID == widget.userID
                            ? GestureDetector(
                                onTap: () {
                                  widget.deleteComment(widget.id);
                                },
                                child: Text(
                                  "delete",
                                  style: TextStyle(color: Colors.black45),
                                ),
                              )
                            : Text(""),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.favorite_border,
                size: 20,
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:clone_instagram/views/home/circle_profile_picture.dart';
import 'package:clone_instagram/views/home/comment_page.dart';
import 'package:clone_instagram/views/home/user_profile.dart';
import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final dynamic post;
  final dynamic currentUserInfo;
  final Function likePost;
  final Function deletePost;
  const PostCard({
    required this.post,
    required this.currentUserInfo,
    required this.likePost,
    required this.deletePost,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLiked = false;

  checkIfLike() {
    List likes = widget.post['like'];
    try {
      likes.firstWhere((id) => id == widget.currentUserInfo['id']);
      setState(() {
        _isLiked = true;
      });
    } catch (e) {
      setState(() {
        _isLiked = false;
      });
    }
  }

  void handleClick(String value) {
    switch (value) {
      case 'Edit':
        print("edit");
        break;
      case 'Delete':
        widget.deletePost(widget.post['id'], widget.post['image']);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfLike();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UserProfile(
                        userID: widget.post['userID'],
                        currentUserID: widget.currentUserInfo['id'],
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    CircleProfilePicture(
                      isYour: false,
                      isAlreadySee: false,
                      image: widget.post['photoURL'],
                    ),
                    Text(
                      widget.post['displayName'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              widget.currentUserInfo['id'] == widget.post['userID']
                  ? PopupMenuButton<String>(
                      onSelected: handleClick,
                      itemBuilder: (BuildContext context) {
                        return {'Edit', 'Delete'}.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    )
                  : PopupMenuButton<String>(
                      onSelected: handleClick,
                      itemBuilder: (BuildContext context) {
                        return {'Block'}.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
            ],
          ),

          SizedBox(
            height: 15,
          ),

          // => Slider here

          GestureDetector(
            onDoubleTap: () {
              widget.likePost(
                widget.post['id'],
                widget.post['userID'],
                widget.currentUserInfo['id'],
              );
              setState(() {
                _isLiked = !_isLiked;
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.post['image'],
                fit: BoxFit.cover,
              ),
            ),
          ),

          // => End Slider here

          SizedBox(
            height: 15,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        widget.likePost(
                          widget.post['id'],
                          widget.post['userID'],
                          widget.currentUserInfo.id,
                        );
                        setState(() {
                          _isLiked = !_isLiked;
                        });
                      },
                      child: _isLiked
                          ? Icon(
                              Icons.favorite,
                              color: Colors.pink,
                            )
                          : Icon(
                              Icons.favorite_border,
                              size: 27,
                            ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentPage(
                              photoURL: widget.post['photoURL'],
                              displayName: widget.post['displayName'],
                              caption: widget.post['caption'],
                              postID: widget.post['id'],
                              currentUser: widget.currentUserInfo,
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.circle_outlined,
                        size: 27,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.share,
                      size: 27,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.bookmark_add_outlined,
                size: 27,
              ),
            ],
          ),

          SizedBox(
            height: 10,
          ),
          Text(
            widget.post['like'].length.toString() + " likes",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          Text(
            widget.post['displayName'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommentPage(
                    photoURL: widget.post['photoURL'],
                    displayName: widget.post['displayName'],
                    caption: widget.post['caption'],
                    postID: widget.post['id'],
                    currentUser: widget.currentUserInfo,
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post['caption'],
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Text(
                  "View all " + widget.post['comment'].toString() + " comments",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 20,
          ),

          Container(
            height: 1,
            color: Colors.blueGrey,
          ),
        ],
      ),
    );
  }
}

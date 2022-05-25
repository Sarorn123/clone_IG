// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class FollowingFollowerCard extends StatelessWidget {
  final String displayName;
  final String photoURL;
  final bool followed;
  FollowingFollowerCard({
    required this.displayName,
    required this.photoURL,
    required this.followed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          photoURL != ""
              ? CircleAvatar(
                  radius: 25,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(photoURL),
                    radius: 25,
                  ),
                )
              : CircleAvatar(
                  radius: 25,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("profile_no_img.png"),
                    radius: 25,
                  ),
                ),
          SizedBox(
            width: 15,
          ),
          Text(displayName),
          SizedBox(
            width: 10,
          ),
          followed
              ? Text(
                  "Followed",
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                )
              : Text(
                  "Follow",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
        ],
      ),
    );
  }
}

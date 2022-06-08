// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class NotificationCard extends StatefulWidget {
  final String photoURL;
  final String title;
  final String body;
  final bool follow;
  final bool clicked;
  const NotificationCard({
    Key? key,
    required this.photoURL,
    required this.title,
    required this.body,
    required this.follow,
    required this.clicked,
  }) : super(key: key);

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.clicked ? Colors.white : Colors.black12,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.photoURL),
                radius: 25,
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(child: Text(widget.body + "2d")),
                      ],
                    ),
                    SizedBox(),
                  ],
                ),
              ),
              widget.follow
                  ? OutlinedButton(
                      onPressed: () {},
                      child: Text(
                        "Followed",
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      // color: Colors.blueGrey,
                    )
                  : RaisedButton(
                      onPressed: () {},
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
  }
}

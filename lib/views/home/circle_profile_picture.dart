// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class CircleProfilePicture extends StatelessWidget {
  final bool isAlreadySee;
  final bool isYour;
  final String image;

  CircleProfilePicture(
      {required this.isYour, required this.isAlreadySee, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                backgroundColor: Colors.orange,
                radius: 22,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    image,
                  ),
                  radius: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

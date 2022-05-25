// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class StoryCard extends StatelessWidget {
  final bool isAlreadySee;
  final bool isYour;

  StoryCard({required this.isYour, required this.isAlreadySee});

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
                radius: 32,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    "https://thumbs.dreamstime.com/b/cute-fgirl-bike-feeling-good-smiling-mood-231298207.jpg",
                  ),
                  radius: 30,
                ),
              ),
              isYour
                  ? Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 3),
                          color: Colors.blue,
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            isYour ? "Your Story" : "Jonh",
            style: TextStyle(
              color: isAlreadySee ? Colors.black45 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

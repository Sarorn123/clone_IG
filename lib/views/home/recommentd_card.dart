import 'package:flutter/material.dart';

class RecommendCard extends StatefulWidget {
  const RecommendCard({Key? key}) : super(key: key);

  @override
  State<RecommendCard> createState() => _RecommendCardState();
}

class _RecommendCardState extends State<RecommendCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Stack(
        children: [
          SizedBox(
            width: 200,
            child: OutlinedButton(
              onPressed: () {},
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            "https://thumbs.dreamstime.com/b/cute-fgirl-bike-feeling-good-smiling-mood-231298207.jpg",
                          ),
                          radius: 40,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Json Statham",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Followed by sad and 212 other",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        color: Colors.blue[400],
                        onPressed: () {},
                        child: Text(
                          "Follow",
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            child: Icon(
              Icons.highlight_off_outlined,
              color: Colors.black26,
            ),
            right: 2,
            top: 2,
          ),
        ],
      ),
    );
  }
}

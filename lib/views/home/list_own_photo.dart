// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ListGridPhoto extends StatefulWidget {
  final List allPosts;
  ListGridPhoto({required this.allPosts});

  @override
  State<ListGridPhoto> createState() => _ListGridPhotoState();
}

class _ListGridPhotoState extends State<ListGridPhoto> {
  List<dynamic> myProducts = [
    {
      "id": 1,
      "name": "test",
    },
    {
      "id": 2,
      "name": "test1",
    },
    {
      "id": 3,
      "name": "test2",
    },
    {
      "id": 4,
      "name": "test3",
    }
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        childAspectRatio: 4 / 3,
      ),
      itemCount: widget.allPosts.length,
      itemBuilder: (BuildContext ctx, index) {
        return Container(
          alignment: Alignment.center,
          child: Image.network(widget.allPosts[index]),
          // decoration: BoxDecoration(
          //   color: Colors.amber,
          // ),
        );
      },
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class AddNewPost extends StatefulWidget {
  final dynamic currentUserInfo;
  Function setIndex;
  AddNewPost({
    required this.currentUserInfo,
    required this.setIndex,
  });

  @override
  State<AddNewPost> createState() => _AddNewPostState();
}

class _AddNewPostState extends State<AddNewPost> {
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = Uuid();
  late File _image;
  bool _isPicked = false;
  bool _isLoading = false;
  final captionController = TextEditingController();

  Future<void> loadAssets() async {
    final img = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(img!.path);
      _isPicked = true;
    });
  }

  Future uploadPicture() async {
    setState(() {
      _isLoading = true;
    });
    if (_isPicked) {
      FirebaseFirestore.instance
          .collection("userInfo")
          .doc(widget.currentUserInfo['id'])
          .get()
          .then((res) async {
        dynamic userInfo = {...?res.data(), "id": res.id};

        var ref = FirebaseStorage.instance.ref().child('images/' + _uuid.v1());
        await ref.putFile(_image).whenComplete(() async {
          await ref.getDownloadURL().then((url) {
            var data = {
              "caption": captionController.text,
              "comment": 0,
              "image": url,
              "share": 0,
              "like": [],
              "userID": userInfo['id'],
              "photoURL": userInfo['photoURL'] ?? "",
              "displayName": userInfo['displayName'],
              "likeNoticficationCount": 0,
              "commentNoticficationCount": 0,
              "created_at": Timestamp.now(),
            };

            FirebaseFirestore.instance
                .collection("post")
                .add(data)
                .then((value) {
              setState(() {
                _isLoading = false;
              });
              widget.setIndex();
            });
          });
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Post",
        ),
        actions: [
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : IconButton(
                  onPressed: () {
                    uploadPicture();
                  },
                  icon: Icon(Icons.upload),
                ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: captionController,
                    onSubmitted: (value) {},
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Caption...',
                      hintStyle: TextStyle(color: Colors.black38),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 400,
                  width: 400,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _isPicked
                        ? Image.file(
                            _image,
                            fit: BoxFit.contain,
                          )
                        : Text(""),
                  ),
                ),
                RaisedButton(
                  onPressed: loadAssets,
                  child: Text("Change Image"),
                )
              ],
            ),
    );
  }
}

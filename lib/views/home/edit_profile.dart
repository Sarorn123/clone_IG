// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class EditProfile extends StatefulWidget {
  final String photoURL;
  final String displayName;
  final String bio;
  final String userID;

  EditProfile({
    required this.photoURL,
    required this.displayName,
    required this.bio,
    required this.userID,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  final ImagePicker _picker = ImagePicker();
  late File _image;
  bool _isPicked = false;
  bool _isLoading = false;
  final Uuid _uuid = Uuid();

  Future pickImage() async {
    final img = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(img!.path);
      _isPicked = true;
    });
  }

  Future editUser() async {
    setState(() {
      _isLoading = true;
    });
    if (_isPicked) {
      var ref = FirebaseStorage.instance.ref().child('profiles/' + _uuid.v1());
      await ref.putFile(_image).whenComplete(() async {
        await ref.getDownloadURL().then((url) {
          dynamic data = {
            "displayName": _nameController.text,
            "bio": _bioController.text,
            "photoURL": url,
          };

          FirebaseFirestore.instance
              .collection("userInfo")
              .doc(widget.userID)
              .set(data, SetOptions(merge: true))
              .then((value) {
            try {
              FirebaseStorage.instance.refFromURL(widget.photoURL).delete();
            } catch (e) {}
            Navigator.pop(context);
          });
        });
      });
    } else {
      dynamic data = {
        "displayName": _nameController.text,
        "bio": _bioController.text,
      };

      FirebaseFirestore.instance
          .collection("userInfo")
          .doc(widget.userID)
          .set(data, SetOptions(merge: true))
          .then((value) {
        Navigator.pop(context);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.displayName);
    _bioController = TextEditingController(text: widget.bio);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.blue,
                  ),
                  onPressed: editUser,
                )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              child: _isPicked
                  ? CircleAvatar(
                      backgroundImage: FileImage(_image),
                      radius: 40,
                    )
                  : widget.photoURL != ""
                      ? CircleAvatar(
                          radius: 40,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(widget.photoURL),
                            radius: 40,
                          ),
                        )
                      : CircleAvatar(
                          radius: 40,
                          child: CircleAvatar(
                            backgroundImage: AssetImage("profile_no_img.png"),
                            radius: 40,
                          ),
                        ),
            ),
            TextButton(
              onPressed: pickImage,
              child: Text(
                "Change Profile Photo",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: _nameController,
              style: TextStyle(fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                labelText: "Name",
                fillColor: Colors.black,
                focusedBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              style: TextStyle(fontWeight: FontWeight.w600),
              controller: _bioController,
              decoration: InputDecoration(
                fillColor: Colors.black,
                labelText: "Bio",
                focusedBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

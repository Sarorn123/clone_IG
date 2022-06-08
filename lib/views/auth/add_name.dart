// ignore_for_file: prefer_const_constructors

import 'package:clone_instagram/views/auth/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddName extends StatefulWidget {
  final String userID;
  AddName({required this.userID});

  @override
  State<AddName> createState() => _AddNameState();
}

class _AddNameState extends State<AddName> {
  final _nameController = TextEditingController();
  bool _isError = false;
  bool _isLoading = false;
  String _msg = "";

  Future addName() async {
    if (_nameController.text != "") {
      setState(() {
        _isLoading = true;
      });
      FirebaseFirestore.instance.collection("userInfo").doc(widget.userID).set({
        "displayName": _nameController.text
      }, SetOptions(merge: true)).then(
          (value) => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Login())),
          onError: (e) {
        setState(() {
          _msg = e.message.toString();
          _isError = true;
        });
      });
    } else {
      setState(() {
        _msg = "Please Input Your name.";
        _isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isError
                ? Text(
                    _msg,
                    style: TextStyle(color: Colors.red),
                  )
                : Text(""),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    onSubmitted: (value) {
                      addName();
                    },
                    style: TextStyle(color: Colors.white),
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 15, color: Colors.white70),
                      hintText: 'Add Your Name',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: addName,
                child: _isLoading
                    ? Container(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "Next",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

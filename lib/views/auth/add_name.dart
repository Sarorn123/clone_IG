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

  Future addName() async {
    if (_nameController.text != "") {
      FirebaseFirestore.instance.collection("userInfo").doc(widget.userID).set(
          {"displayName": _nameController.text}, SetOptions(merge: true)).then(
        (value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: TextField(
            onSubmitted: (value) {
              addName();
            },
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3, color: Colors.blue),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3, color: Colors.red),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

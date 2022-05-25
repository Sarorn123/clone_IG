// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:clone_instagram/views/auth/add_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late String name;

  Future _signUp() async {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    )
        .then((res) {
      var data = {
        "bio": "",
        "displayName": "",
        "photoURL": "",
        "follower": [],
        "following": [],
        "posts": 0,
        "userID": res.user!.uid,
      };

      FirebaseFirestore.instance.collection("userInfo").add(data).then(
        (res) {
          print("===>");
          print(res.id);
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => AddName(
                      userID: res.id,
                    )),
          );
        },
      );
    });

    _emailController.text = "";
    _passwordController.text = "";
    _confirmPasswordController.text = "";
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
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
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
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
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
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
          SizedBox(
            height: 20,
          ),
          OutlinedButton(
            onPressed: _signUp,
            child: Text("Sing Up"),
          ),
        ],
      ),
    ));
  }
}

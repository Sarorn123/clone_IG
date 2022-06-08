// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:clone_instagram/views/auth/add_name.dart';
import 'package:clone_instagram/views/auth/login.dart';
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
  String _msg = "";
  bool _isLoading = false;
  bool _isError = false;

  Future _signUp() async {
    if (_emailController.text != "" &&
        _passwordController.text != "" &&
        _confirmPasswordController.text != "") {
      if (_passwordController.text == _confirmPasswordController.text) {
        setState(() {
          _isLoading = true;
        });
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
                  ),
                ),
              );
            },
          );
        }, onError: (e) {
          setState(() {
            _msg = e.message.toString();
            _isError = true;
            _isLoading = false;
          });
          print(e.message.toString());
        });

        _emailController.text = "";
        _passwordController.text = "";
        _confirmPasswordController.text = "";
      } else {
        setState(() {
          _msg = "Confirm Password Not Same As Password !";
          _isError = true;
        });
      }
    } else {
      setState(() {
        _msg = "All Field Can not Empty !";
        _isError = true;
      });
    }
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
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 50, child: Image.asset("assets/logo_text.png")),
                SizedBox(
                  height: 20,
                ),
                _isError
                    ? Column(
                        children: [
                          Text(
                            _msg,
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      )
                    : Text(""),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 15, color: Colors.white70),
                      hintText: 'Email',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 15, color: Colors.white70),
                      hintText: 'Password',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 15, color: Colors.white70),
                      hintText: 'Confirm password',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: _signUp,
                    child: _isLoading
                        ? SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 15),
                          ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60.0,
              decoration: BoxDecoration(color: Colors.blueGrey),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already Have An Account ? ",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Text("Log in"))
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

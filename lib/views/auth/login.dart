// ignore_for_file: prefer_const_constructors

import 'package:clone_instagram/views/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future _singIn() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        )
        .then(
          (result) => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MyApp()),
          ),
        )
        .catchError((error) {
      print(error.message.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50, child: Image.asset("assets/logo_text.png")),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email...',
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
            OutlinedButton(
              onPressed: _singIn,
              child: Text("Login"),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SignUp()),
                );
              },
              child: Text("Sing Up"),
            ),
          ],
        ),
      ),
    );
  }
}

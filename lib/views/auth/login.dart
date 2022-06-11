// ignore_for_file: prefer_const_constructors, unnecessary_new
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
  bool _isLoading = false;
  bool _isFieldEmpty = false;
  String msg = "";

  Future _singIn() async {
    if (_emailController.text != "" && _passwordController.text != "") {
      setState(() {
        _isLoading = true;
      });
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
        setState(() {
          msg = error.message.toString();
          _isFieldEmpty = true;
          _isLoading = false;
        });
        print(error.message.toString());
      });
    } else {
      setState(() {
        msg = "Both field can not empty !";
        _isFieldEmpty = true;
      });
    }
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
      body: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60.0,
              decoration: new BoxDecoration(color: Colors.blueGrey),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't Have An Account ? ",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text("Sing Up"))
                ],
              ),
            ),
          ),
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
                _isFieldEmpty
                    ? Column(
                        children: [
                          Text(
                            msg,
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(
                            height: 10,
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
                      hintText: 'Phone number, Email or username',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
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
                      hintText: 'password',
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.remove_red_eye),
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: _singIn,
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
                            "Log in",
                            style: TextStyle(fontSize: 15),
                          ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Forgot Your Login Detail ? "),
                    TextButton(
                        onPressed: () {}, child: Text("Get Help Logging In."))
                  ],
                ),
                Container(
                  child: Row(children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        height: 2,
                        width: 50,
                        color: Colors.black38,
                      ),
                    ),
                    Text(
                      " Or ",
                      style: TextStyle(),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        height: 2,
                        width: 50,
                        color: Colors.black38,
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {},
                    icon: Icon(
                      Icons.facebook,
                      size: 30.0,
                    ),
                    label: Text('Continue as Facebook'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

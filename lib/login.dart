import 'package:chatapp/input_decoration.dart';
import 'package:chatapp/messagescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final loginKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showPassword = true;
  bool isLogin = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          key: loginKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 90,
              ),
              const Text(
                "Hello Again!",
                style: TextStyle(fontSize: 40),
              ),
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Text(
                  "Welcome back you've been missed!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                child: TextFormField(
                    controller: emailController,
                    validator: (email) {
                      if (email != null &&
                          RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(email)) {
                        return null;
                      }
                      return "Enter valid email";
                    },
                    decoration:
                        inputDecoration("Email", Icons.alternate_email)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: showPassword,
                  validator: (password) {
                    if (password != null && password.length < 6) {
                      return "Enter password";
                    }
                  },
                  decoration: inputDecoration(
                    "Password",
                    Icons.key,
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      icon: Icon(
                        showPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              isLogin
                  ? CircularProgressIndicator()
                  : SizedBox(
                      height: 60,
                      width: 180,
                      child: ElevatedButton(
                        onPressed: () {
                          login();
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    try {
      loginKey.currentState?.save();
      if (!loginKey.currentState!.validate()) {
        return;
      }
      setState(() {
        isLogin = true;
      });
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User? user = credential.user;
      setState(() {
        isLogin = false;
      });
      if (user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MessageScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLogin = false;
      });
      print(e.message);
    }
  }
}

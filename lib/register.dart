import 'package:chatapp/messagescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'input_decoration.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final registerKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showPassword = true;
  bool isSigningUp = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          key: registerKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 80,
              ),
              const Text(
                "Hello ",
                style: TextStyle(fontSize: 50),
              ),
              const Text(
                "Get Started",
                style: TextStyle(fontSize: 50),
              ),
              const SizedBox(
                height: 60,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null) {
                        return "Enter name";
                      }
                      return null;
                    },
                    decoration: inputDecoration("Name", Icons.person)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: TextFormField(
                  controller: emailController,
                  validator: (email) {
                    if (email != null &&
                        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(email)) {
                      return null ;
                    }
                    return "Enter valid email";
                  },
                  decoration: inputDecoration("Email", Icons.alternate_email),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 30,
                ),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: showPassword,
                  validator: (password) {
                    if (password!= null && password.length<6) {
                      return "Enter password";
                    }
                    return null;
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
              isSigningUp
                  ? CircularProgressIndicator()
                  : SizedBox(
                      height: 65,
                      width: 180,
                      child: ElevatedButton(
                        onPressed: () {
                          signup();
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signup() async {
    try {

      registerKey.currentState?.save();
      if (!registerKey.currentState!.validate()) {
        return;
      }
      setState(() {
        isSigningUp = true;
      });

      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User? user = credential.user;
     setState(() {
       isSigningUp = false;
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
       isSigningUp=false;
     });
      print(e.message);
    }
  }
}

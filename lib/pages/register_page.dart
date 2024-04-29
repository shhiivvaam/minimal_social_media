import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimal_social_media/components/my_button.dart';
import 'package:minimal_social_media/components/my_textfield.dart';
import 'package:minimal_social_media/helper/helper_functions.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  // register method
  void registerUser() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // make sure that the password and confirm password matches
    if (passwordController.text != confirmPwController.text) {
      // pop loading circle
      Navigator.pop(context);

      // show error message to the user
      displayMessageToUser("Passwords do not match!", context);
    } else {
      // if the passwords do match

      // try creating the user
      try {
        // create the user
        UserCredential? userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // firebase cloud store data updation
        // create a user document and add to the firestore
        createUserDocument(userCredential);

        // pop the loading circle
        if (context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // pop loading circle
        Navigator.pop(context);

        // display the error message to user
        displayMessageToUser(e.code, context);
      }
    }

    // TODO : check out the below code
    // if (passwordController.text != confirmPwController.text) {
    //   // show error message
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text("Passwords do not match!"),
    //     ),
    //   );

    //   // close the loading circle
    //   Navigator.pop(context);

    //   return;
    // }
  }

  // create a user document and collect them in firestore
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set(
        {
          "email": userCredential.user!.email,
          "username": usernameController.text,
          // "uid": userCredential.user!.uid,
          // "photoUrl": userCredential.user!.photoURL,
          // "displayName": userCredential.user!.displayName,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(height: 25),

              // app name
              const Text(
                "M I N I M A L     M E D I A",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 50),

              // username textfield
              MyTextField(
                hintText: "Username!",
                obscureText: false,
                controller: usernameController,
              ),
              const SizedBox(height: 10),

              // email textfield
              MyTextField(
                hintText: "Email!",
                obscureText: false,
                controller: emailController,
              ),
              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                hintText: "Password!",
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 10),

              // confirm password textfield
              MyTextField(
                hintText: "Confirm Password!",
                obscureText: true,
                controller: confirmPwController,
              ),
              const SizedBox(height: 10),

              // forgot password
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Text(
              //       "Forgot Password",
              //       style: TextStyle(
              //         color: Theme.of(context).colorScheme.secondary,
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 25),
              const SizedBox(height: 25),

              // Register button
              MyButton(text: "Register", onTap: registerUser),
              const SizedBox(height: 25),

              // don't have an account? Register here
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      " Login Here",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

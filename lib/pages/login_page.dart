import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:minimal_social_media/components/my_button.dart';
import 'package:minimal_social_media/components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  // text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  // login method
  void login() {}

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
              Text(
                "M I N I M A L     M E D I A",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 50),

              // email textfield
              MyTextField(
                hintText: "Email!",
                obscureText: false,
                controller: emailController,
              ),

              // password textfield
              const SizedBox(height: 10),
              MyTextField(
                hintText: "Password!",
                obscureText: true,
                controller: passwordController,
              ),

              // forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot Password",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // sign in button
              MyButton(text: "Login", onTap: login),
              // TODO: causing overflow -> handle
              // const SizedBox(height: 25),

              // don't have an account? Register here
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: (){},
                    child: Text(
                      "Register Here",
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

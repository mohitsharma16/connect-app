import 'package:connect/components/my_button.dart';
import 'package:connect/components/my_textfield.dart';
import 'package:connect/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final void Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  //register function
  void register(BuildContext context) {
    //get auth service
    final _auth = AuthService();
    //if passwords match
    if (passwordController.text == confirmPasswordController.text) {
      try {
        _auth.signUpWithEmailAndPassword(
            emailController.text, passwordController.text);
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(title: Text(e.toString()));
            });
      }
    }
    //if passwords do not match
    else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(title: Text("Passwords do not match"));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text(
              "Connect",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 36,
              ),
            ),

            const SizedBox(height: 50),
            //welcome text
            Text(
              "Welcome , Lets create your account!!!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),
            //email field
            MyTextfield(
                hintText: "Email",
                obscureText: false,
                controller: emailController),
            const SizedBox(height: 10),
            //password field
            MyTextfield(
                hintText: "Password",
                obscureText: true,
                controller: passwordController),
            const SizedBox(height: 10),
            //confirm password field
            MyTextfield(
                hintText: "Confirm Password",
                obscureText: true,
                controller: confirmPasswordController),

            //login button
            const SizedBox(height: 25),
            MyButton(buttonText: "Register", onTap: () => register(context)),
            const SizedBox(height: 25),
            //register text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Login now",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

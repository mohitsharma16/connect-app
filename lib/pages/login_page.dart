import 'package:connect/components/my_button.dart';
import 'package:connect/components/my_textfield.dart';
import 'package:connect/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final void Function() onTap;

  LoginPage({super.key, required this.onTap});
  //login function
  void login(BuildContext context) async {
    //auth service instance
    final authService = AuthService();
    try {
      await authService.signInWithEmailAndPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(title: Text(e.toString()));
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
              "Welcome back , we missed you!!!",
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

            //login button
            const SizedBox(height: 25),
            MyButton(buttonText: "Login", onTap: () => login(context)),
            const SizedBox(height: 25),
            //register text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Register now",
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

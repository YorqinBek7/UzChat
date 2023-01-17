// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uzchat/data/api_service.dart';
import 'package:uzchat/screens/auth_screen/widgets/auth_buttons.dart';
import 'package:uzchat/screens/auth_screen/widgets/sign_google_button.dart';
import 'package:uzchat/utils/colors/colors.dart';
import 'package:uzchat/utils/constanst/constants.dart';
import 'package:uzchat/utils/icons/icons.dart';
import 'package:uzchat/utils/style/style.dart';
import 'package:uzchat/widgets/global_buttons.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final ApiService apiService = ApiService();
  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign in", style: UzchatStyle.w600),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50.0,
            ),
            Image.asset(
              UzchatIcons.chatImage,
              width: 130,
              height: 130,
            ),
            Text(
              "Hey👋\n",
              style: UzchatStyle.w600.copyWith(
                fontSize: 35.0,
                color: UzchatColors.colorBlue,
              ),
              textAlign: TextAlign.center,
            ),
            AuthFields(
              controller: emailController,
              hintText: 'Email',
            ),
            AuthFields(
              controller: passWordController,
              hintText: 'Password',
            ),
            SizedBox(
              height: 10.0,
            ),
            GlobalButton(
              buttonText: 'Sign In',
              color: UzchatColors.colorBlue,
              onTap: () async {
                await signIn(
                  email: emailController.text,
                  password: passWordController.text,
                  context: context,
                ).then(
                  (value) => Navigator.pushReplacementNamed(
                      context, Constants.selectChatScreen),
                );
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(
                  context, Constants.signUpScreen),
              child: Text("Don't have an account?"),
            ),
            SignGoogleButton(apiService: apiService)
          ],
        ),
      ),
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
      throw Exception();
    }
  }
}

// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uzchat/data/api_service.dart';
import 'package:uzchat/screens/auth_screen/widgets/auth_buttons.dart';
import 'package:uzchat/screens/auth_screen/widgets/sign_google_button.dart';
import 'package:uzchat/utils/colors/colors.dart';
import 'package:uzchat/utils/constanst/constants.dart';
import 'package:uzchat/utils/icons/icons.dart';
import 'package:uzchat/utils/style/style.dart';
import 'package:uzchat/widgets/global_buttons.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final ApiService apiService = ApiService();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up", style: UzchatStyle.w600),
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
            SizedBox(
              height: 30.0,
            ),
            Text(
              "What's Up 👋\n",
              style: UzchatStyle.w600.copyWith(
                fontSize: 35.0,
                color: UzchatColors.colorBlue,
              ),
              textAlign: TextAlign.center,
            ),
            AuthFields(
              controller: nameController,
              hintText: 'Name',
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
              buttonText: 'Sign Up',
              color: UzchatColors.colorBlue,
              onTap: () async {
                if (nameController.text.isEmpty ||
                    emailController.text.isEmpty ||
                    passWordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }
                var s = await signUp(
                  email: emailController.text,
                  password: passWordController.text,
                  name: nameController.text,
                  context: context,
                ).then(
                  (value) => Navigator.pushReplacementNamed(
                      context, Constants.selectChatScreen),
                );
                print(s.toString());
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(
                  context, Constants.signInScreen),
              child: Text("Do you have already an account?"),
            ),
            SignGoogleButton(
              apiService: apiService,
            )
          ],
        ),
      ),
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    ApiService apiService = ApiService();
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await apiService.addUser(
        name: name,
        uid: FirebaseAuth.instance.currentUser!.uid,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
      throw Exception();
    }
  }
}

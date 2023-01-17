import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uzchat/screens/no_internet.dart';

import 'package:uzchat/utils/colors/colors.dart';
import 'package:uzchat/utils/constanst/constants.dart';
import 'package:uzchat/utils/icons/icons.dart';
import 'package:uzchat/utils/style/style.dart';
import 'package:uzchat/widgets/global_buttons.dart';

class SelectChatScreen extends StatelessWidget {
  const SelectChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser!.displayName);
    print(FirebaseAuth.instance.currentUser!.email);
    print(FirebaseAuth.instance.currentUser!.uid);
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        if (ConnectivityResult.none == snapshot.data) {
          return NoInternetScreen();
        } else {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  UzchatIcons.chatImage,
                  width: 130.0,
                  height: 130.0,
                ),
                SizedBox(
                  height: 20.0,
                ),
                AnimatedTextKit(
                  totalRepeatCount: 1,
                  animatedTexts: [
                    TyperAnimatedText("Welcome to UzChat",
                        textStyle: UzchatStyle.w600,
                        speed: const Duration(milliseconds: 60)),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                GlobalButton(
                  buttonText: "UzChat Group",
                  color: UzchatColors.colorBlue,
                  onTap: () {
                    Navigator.pushNamed(context, Constants.groupChatScreen);
                  },
                ),
                SizedBox(
                  height: 5.0,
                ),
                GlobalButton(
                  buttonText: "UzChat Users",
                  color: UzchatColors.colorBlue,
                  onTap: () {
                    Navigator.pushNamed(context, Constants.uzchatUsersScreen);
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uzchat/data/api_service.dart';
import 'package:uzchat/data/helper.dart';
import 'package:uzchat/utils/colors/colors.dart';
import 'package:uzchat/utils/constanst/constants.dart';
import 'package:uzchat/utils/icons/icons.dart';
import 'package:uzchat/utils/style/style.dart';

class SignGoogleButton extends StatelessWidget {
  const SignGoogleButton({
    required this.apiService,
    Key? key,
  }) : super(key: key);
  final ApiService apiService;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Helper.instance.signWithGoogle().then((value) async {
          if (FirebaseAuth.instance.currentUser != null) {
            var user = FirebaseAuth.instance.currentUser!;
            apiService.addUser(name: user.displayName!, uid: user.uid);

            return Navigator.pushReplacementNamed(
                context, Constants.selectChatScreen);
          }
        });
      },
      child: Container(
        height: 60,
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
            color: UzchatColors.colorGoogleButton,
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              UzchatIcons.googleLogo,
              width: 40,
              height: 40,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Sign with Google",
              style: UzchatStyle.w600
                  .copyWith(color: UzchatColors.colorMilk, fontSize: 16.0),
            )
          ],
        ),
      ),
    );
  }
}

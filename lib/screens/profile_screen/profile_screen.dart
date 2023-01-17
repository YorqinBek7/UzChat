import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uzchat/data/api_service.dart';
import 'package:uzchat/data/helper.dart';
import 'package:uzchat/screens/auth_screen/sign_in_screen.dart';
import 'package:uzchat/screens/no_internet.dart';
import 'package:uzchat/screens/profile_screen/widgets/edit_fields.dart';
import 'package:uzchat/screens/profile_screen/widgets/user_info_frame.dart';
import 'package:uzchat/utils/colors/colors.dart';
import 'package:uzchat/utils/style/style.dart';
import 'package:uzchat/widgets/global_buttons.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  User user = FirebaseAuth.instance.currentUser!;
  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        if (snapshot.data == ConnectivityResult.none) {
          return NoInternetScreen();
        }
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Profile",
              style: UzchatStyle.w600,
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    var pickedImage =
                        await Helper.instance.pickImage(fromCamera: false);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Wait, Profile photo is updating!')));
                    await Helper.instance.uploadImage(
                      filePath: pickedImage!.path,
                      fileName: user.displayName!,
                    );
                    var imageUrl = await Helper.instance
                        .getUrlImage(imageName: user.displayName!);
                    await user.updatePhotoURL(imageUrl);
                    user = FirebaseAuth.instance.currentUser!;
                    await apiService.updateUserImage(
                        docId: user.uid, image: imageUrl);
                    setState(() {});
                  },
                  child: UserInfoFrame(
                    user: user,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                EditFields(
                  icon: Icons.edit,
                  text: 'Edit your name',
                  controller: nameController,
                ),
                SizedBox(
                  height: 15.0,
                ),
                GlobalButton(
                  buttonText: "Edit name",
                  color: UzchatColors.colorBlue,
                  onTap: () async {
                    if (nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Your name is empty')));
                      return;
                    }
                    await user.updateDisplayName(nameController.text);
                    user = FirebaseAuth.instance.currentUser!;
                    setState(() {});
                  },
                ),
                Spacer(),
                GlobalButton(
                  buttonText: 'Log Out',
                  color: UzchatColors.colorRed,
                  onTap: () async {
                    await Helper.instance.signOutGoogle();
                    await FirebaseAuth.instance.signOut().then(
                          (value) => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ),
                              (route) => false),
                        );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

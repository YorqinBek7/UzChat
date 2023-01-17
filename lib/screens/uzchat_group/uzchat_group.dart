// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uzchat/data/api_service.dart';
import 'package:uzchat/data/helper.dart';
import 'package:uzchat/screens/no_internet.dart';
import 'package:uzchat/screens/uzchat_group/widgets/message_text_item.dart';
import 'package:uzchat/screens/uzchat_group/widgets/send_field.dart';
import 'package:uzchat/utils/colors/colors.dart';
import 'package:uzchat/utils/constanst/constants.dart';
import 'package:uzchat/utils/style/style.dart';

class UzChatGroupScreen extends StatelessWidget {
  UzChatGroupScreen({super.key});

  final TextEditingController textController = TextEditingController();

  final TextEditingController imageTextController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  final ApiService apiService = ApiService();

  final User user = FirebaseAuth.instance.currentUser!;

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        if (ConnectivityResult.none == snapshot.data) return NoInternetScreen();
        return Scaffold(
          appBar: AppBar(
            title: const Text("UzChat"),
            centerTitle: true,
            leading: GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(
                  context, Constants.profileScreen),
              child: Icon(
                Icons.person,
                color: UzchatColors.colorBlack,
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              StreamBuilder(
                stream: apiService.getGroupChats(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return LinearProgressIndicator();
                  var messages = snapshot.data!;
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    scrollController
                        .jumpTo(scrollController.position.maxScrollExtent);
                  });
                  return Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return MessegeItem(
                          messages: messages,
                          index: index,
                          isMe: user.uid == messages[index].id,
                          user: user,
                        );
                      },
                    ),
                  );
                },
              ),
              SendField(
                textController: textController,
                onTap: () {
                  if (textController.text.isEmpty) return;
                  var message = textController.text;
                  textController.clear();
                  apiService
                      .addMessageToGroup(
                        uid: FirebaseAuth.instance.currentUser!.uid,
                        message: message,
                        name: user.displayName!,
                        imageUrl: '',
                        profilePhoto: user.photoURL ?? '',
                      )
                      .then(
                        (value) => scrollController
                            .jumpTo(scrollController.position.maxScrollExtent),
                      );
                },
                imagePicker: () async {
                  await selectPhotoDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  selectPhotoDialog(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 150.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    await sendPhotoDialog(context, true);
                  },
                  child: Icon(
                    Icons.photo_camera_outlined,
                    size: 50.0,
                  ),
                ),
                Text(
                  "Take Photo",
                  style: UzchatStyle.w500,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    await sendPhotoDialog(context, false);
                  },
                  child: Icon(
                    Icons.image_outlined,
                    size: 50.0,
                  ),
                ),
                Text(
                  'Choose from gallery',
                  style: UzchatStyle.w500,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendPhotoDialog(BuildContext context, bool fromCamera) async {
    var file = await Helper.instance.pickImage(fromCamera: fromCamera);
    var dialogImage = File(file!.path);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .2,
              width: MediaQuery.of(context).size.width * .3,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Image.file(
                    dialogImage,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            TextField(
              controller: imageTextController,
              maxLength: null,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Add a caption',
                suffixIcon: GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    await Helper.instance.uploadImage(
                      filePath: file.path,
                      fileName: file.name,
                    );
                    imageUrl =
                        await Helper.instance.getUrlImage(imageName: file.name);
                    apiService
                        .addMessageToGroup(
                            uid: FirebaseAuth.instance.currentUser!.uid,
                            message: imageTextController.text,
                            name: user.displayName!,
                            imageUrl: imageUrl,
                            profilePhoto: user.photoURL ?? '')
                        .then(
                          (value) => scrollController.jumpTo(
                              scrollController.position.maxScrollExtent),
                        );
                    imageTextController.clear();
                  },
                  child: Icon(Icons.send),
                ),
              ),
            )
          ],
        ),
      ),
    ).then((value) {
      Navigator.pop(context);
    });
  }
}

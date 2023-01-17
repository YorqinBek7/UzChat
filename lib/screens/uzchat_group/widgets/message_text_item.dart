import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uzchat/data/helper.dart';
import 'package:uzchat/models/chat_model.dart';
import 'package:uzchat/screens/uzchat_group/widgets/messages_profile_photo.dart';
import 'package:uzchat/utils/colors/colors.dart';
import 'package:uzchat/utils/style/style.dart';

class MessegeItem extends StatefulWidget {
  const MessegeItem({
    Key? key,
    required this.messages,
    required this.index,
    required this.isMe,
    required this.user,
  }) : super(key: key);

  final List<ChatModel> messages;
  final int index;
  final bool isMe;
  final User user;

  @override
  State<MessegeItem> createState() => _MessegeItemState();
}

class _MessegeItemState extends State<MessegeItem> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        openWithLongPress: true,
        items: [
          ...MenuItems.firstItems.map(
            (item) {
              return DropdownMenuItem<MenuItem>(
                value: item,
                child: MenuItems.buildItem(item),
              );
            },
          ),
        ],
        dropdownOverButton: true,
        itemHeight: 48,
        itemPadding: const EdgeInsets.only(left: 16, right: 16),
        dropdownWidth: 160,
        dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.redAccent,
        ),
        dropdownElevation: 8,
        offset: const Offset(40, -4),
        onChanged: (value) => {
          if (widget.messages[widget.index].imageUrl.isEmpty)
            {
              log('Photo not found'),
            }
          else
            {
              MenuItems.onChanged(
                  context, value!, widget.messages[widget.index].imageUrl),
            }
        },
        customButton: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            widget.isMe
                ? SizedBox()
                : MessageProfilPhoto(
                    isMe: widget.isMe,
                    user: widget.user,
                    photo: widget.messages[widget.index].profilePhoto,
                  ),
            Flexible(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: BoxDecoration(
                  borderRadius: widget.index == widget.messages.length - 1
                      ? BorderRadius.only(topLeft: Radius.circular(8.0))
                      : BorderRadius.only(bottomLeft: Radius.circular(8.0)),
                  color: widget.isMe
                      ? UzchatColors.colorSendMessage
                      : UzchatColors.colorRecieveMessage,
                ),
                child: Column(
                  crossAxisAlignment: widget.isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.messages[widget.index].name,
                      style: UzchatStyle.w500.copyWith(
                        color: !widget.isMe ? Colors.orange : Color(0xff083552),
                      ),
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    widget.messages[widget.index].imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            imageUrl: widget.messages[widget.index].imageUrl,
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 3.0,
                    ),
                    Text(
                      widget.messages[widget.index].messages,
                      style: UzchatStyle.w500.copyWith(
                        fontWeight: FontWeight.normal,
                        color: UzchatColors.colorWhite,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    Text(
                      DateFormat("hh:mm a").format(
                          DateTime.parse(widget.messages[widget.index].date)),
                      style: UzchatStyle.w500.copyWith(
                        color: widget.isMe
                            ? UzchatColors.colorBlack.withOpacity(.65)
                            : Colors.orange,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ),
            ),
            widget.isMe
                ? MessageProfilPhoto(
                    isMe: widget.isMe,
                    user: widget.user,
                    photo: widget.user.photoURL ?? '',
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [
    savePhoto,
    editMessage,
    deleteMessage
  ];
  static const savePhoto = MenuItem(
    text: 'Save Photo',
    icon: Icons.save_alt_outlined,
  );
  static const editMessage = MenuItem(
    text: 'Edit',
    icon: Icons.edit_outlined,
  );
  static const deleteMessage = MenuItem(
    text: 'Delete',
    icon: Icons.delete_outline_outlined,
  );

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(
          item.icon,
          color: Colors.white,
          size: 22,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item, String imageUrl) async {
    switch (item) {
      case MenuItems.savePhoto:
        if (Platform.isAndroid) {
          PermissionStatus permission = await Permission.storage.status;

          if (permission != PermissionStatus.granted) {
            await Permission.storage.request();
          }
        }
        await Helper.instance.saveFileToDownloadFolder(imageUrl, context);
        break;
      case MenuItems.editMessage:
        //Do something
        break;
      case MenuItems.deleteMessage:
        //Do something
        break;
    }
  }
}

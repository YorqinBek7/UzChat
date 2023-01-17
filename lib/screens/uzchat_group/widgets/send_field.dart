// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:uzchat/utils/colors/colors.dart';

class SendField extends StatelessWidget {
  const SendField({
    Key? key,
    required this.textController,
    required this.onTap,
    required this.imagePicker,
  }) : super(key: key);

  final TextEditingController textController;
  final VoidCallback onTap;
  final VoidCallback imagePicker;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: UzchatColors.colorBlue,
      child: TextField(
        maxLines: null,
        style: null,
        controller: textController,
        cursorColor: UzchatColors.colorWhite,
        decoration: InputDecoration(
          prefixIcon: GestureDetector(
            onTap: imagePicker,
            child: Icon(
              Icons.image,
              color: UzchatColors.colorWhite,
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: onTap,
            child: Icon(Icons.send_outlined, color: UzchatColors.colorWhite),
          ),
          hintText: "Write something",
          border: OutlineInputBorder(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}

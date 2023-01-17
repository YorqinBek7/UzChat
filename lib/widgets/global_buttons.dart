import 'package:flutter/material.dart';
import 'package:uzchat/utils/colors/colors.dart';
import 'package:uzchat/utils/style/style.dart';

class GlobalButton extends StatelessWidget {
  const GlobalButton({
    Key? key,
    required this.buttonText,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  final String buttonText;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5.0),
        ),
        width: double.infinity,
        child: Center(
          child: Text(
            buttonText,
            style: UzchatStyle.w600.copyWith(
              color: UzchatColors.colorWhite,
            ),
          ),
        ),
      ),
    );
  }
}

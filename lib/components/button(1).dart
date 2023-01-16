import 'package:courses/constants.dart';
import 'package:flutter/material.dart';

class StarterButton extends StatelessWidget {
  String text = "Get Started";
  Color btnColor = Colors.white, textColor = Colors.black;
  Function onPressed;
  double textSize = 19;

  StarterButton.name(
      {this.text,
      this.btnColor,
      this.textColor,
      this.onPressed,
      this.textSize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: btnColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.3),
              blurRadius: 3.0,
              offset: Offset(
                0.0,
                3.0,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text.toUpperCase(),
            style: kBaseFont.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
              fontSize: textSize,
            ),
          ),
        ),
      ),
    );
  }
}

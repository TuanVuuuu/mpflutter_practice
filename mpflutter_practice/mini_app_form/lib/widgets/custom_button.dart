// custom button widget

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double fontSize;

  const CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.color = Colors.blue,
      this.textColor = Colors.white,
      this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child:
            Text(text, style: TextStyle(color: textColor, fontSize: fontSize)),
      ),
    );
  }
}

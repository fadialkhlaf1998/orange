import 'package:flutter/material.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/helper/app.dart';

class PrimaryBottun extends StatefulWidget {
  final double width;
  final double height;
  final double radiuce;
  final double fontSize;
  final FontWeight fontWeight;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final String text;
  final LinearGradient? linearGradient;
  final Border? border;

  PrimaryBottun({
    required this.width,
    required this.height,
    required this.onPressed,
    required this.color,
    required this.text,
    this.linearGradient,
    this.radiuce = 10,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
    this.textColor = Colors.white,
    this.border,
  });

  @override
  State<PrimaryBottun> createState() => _MyBottunState();
}

class _MyBottunState extends State<PrimaryBottun> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.radiuce),
          gradient: widget.linearGradient,
          border: widget.border
        ),
        child: Center(
          child: Center(
            child: Text(App_Localization.of(context).translate(widget.text),
                style: TextStyle(fontSize: widget.fontSize,fontWeight:widget.fontWeight ,color: widget.textColor),
            ),
          ),
        ),
      ),
    );
  }
}

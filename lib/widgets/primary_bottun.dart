import 'package:flutter/material.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/helper/app.dart';

class PrimaryBottun extends StatefulWidget {
  final double width;
  final double height;
  final VoidCallback onPressed;
  final Color color;
  final String text;
  final LinearGradient? linearGradient;

  PrimaryBottun({
    required this.width,
    required this.height,
    required this.onPressed,
    required this.color,
    required this.text,
    this.linearGradient
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
          borderRadius: BorderRadius.circular(10),
          gradient: widget.linearGradient,
        ),
        child: Center(
          child: Center(
            child: Text(App_Localization.of(context).translate(widget.text),
                style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

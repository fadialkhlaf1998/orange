import 'package:flutter/material.dart';
import 'package:orange/helper/app.dart';

class Logo extends StatelessWidget {
  final double size;

  Logo(this.size);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/logo.png")),
          ),
        ),
        SizedBox(height: 10,),
        Text("ORANGE",style: TextStyle(letterSpacing: 1.5,color: App.primary,fontWeight: FontWeight.bold,fontSize: size/(4.5)),)
      ],
    );
  }
}

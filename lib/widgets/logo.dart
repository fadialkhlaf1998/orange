import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/helper/app.dart';

class Logo extends StatelessWidget {
  final double size;
  final bool withText;

  Logo(this.size,this.withText);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,

          child: SvgPicture.asset(this.withText?"assets/icons/logo_text.svg":"assets/icons/logo.svg",width: size,),
        ),
      ],
    );
  }
}

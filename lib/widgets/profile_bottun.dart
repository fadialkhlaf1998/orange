import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/helper/app.dart';

class ProfileBtn extends StatelessWidget {

  final VoidCallback onPressed;
  final Widget icon;
  final String text;
  final bool withIcon;
  final bool withDivider;


  ProfileBtn({
    required this.onPressed,required this.icon,required this.text,this.withIcon = true,this.withDivider = true
  });

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onPressed,
      child:  Container(
          width: Get.width,
          height: withDivider?55:55-15,
          decoration: BoxDecoration(
              color: App.greyF5,
          ),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 10,),
                      icon,

                      SizedBox(width: 10,),
                      Text(App_Localization.of(context).translate(text),style: TextStyle(fontSize: 13,color: Colors.black),)
                    ],
                  ),

                  withIcon
                      ?Icon(Icons.arrow_forward_ios,color: App.dark_grey,size: 17,)
                      :Center()
                ],
              ),
              SizedBox(height: 8,),
              withDivider?Row(
                children: [
                  Expanded(child: Container(height: 1.5,color: Colors.black.withOpacity(0.2),))
                ],
              ):Center(),
              withDivider?SizedBox(height: 10,):Center()
            ],
          )
      ),
    );
  }
}

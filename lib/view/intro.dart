import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange/controller/home_controller.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/view/pdf_viewer.dart';
import 'package:orange/widgets/logo.dart';

class Intro extends StatelessWidget {
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: App.primary_mid,
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/intro.png"),fit: BoxFit.cover)
        ),
        // child: Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Logo(150,false),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}

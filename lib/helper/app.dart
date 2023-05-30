import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:orange/model/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/view/login.dart';
import 'package:orange/view/sign_up.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class App{
  // static Color primary = Color(0xfff37335);
  // static Color primary = Colors.orange;
  static const Color primary = Color(0xfffe7902);
  static const Color primary_mid = Color(0xfffda018);
  static const Color primary_light = Color(0xffEEA427);
  static const Color background = Colors.white;
  // static Color primary_light = Colors.orange.withOpacity(0.5);
  static const Color grey = Color(0xffededef);
  static const Color dark_grey = Color(0xffACBAC3);
  static const Color white_1 = Color(0xffE9E28c);
  static const Color white_2 = Color(0xfff0f0f0);
  static const Color dark_blue = Color(0xff0f3047);

  static const Color text_color = Color(0xff022B3A);
  static const Color red = Color(0xffc63a32);
  static const Color green = Color(0xff43BD47);


  static const Color greyCCC = Color(0xffcccccc);
  static const Color greyF2 = Color(0xfff2f2f2);
  static const Color greyF5 = Color(0xfff5f5f5);
  static const Color grey95 = Color(0xff959595);
  static const Color greyC5 = Color(0xffc5c5c5);
  static const Color greyFE = Color(0xfffefefe);
  static const Color grey6b = Color(0xff6B6B6B);


  static succMsg(BuildContext context , String title , String msg){
    return Get.snackbar(App_Localization.of(context).translate(title)
    , App_Localization.of(context).translate(msg),colorText: Colors.white,backgroundColor: primary,backgroundGradient:linearGradient);
  }

  static errMsg(BuildContext context , String title , String msg){
    return Get.snackbar(App_Localization.of(context).translate(title)
        , App_Localization.of(context).translate(msg),colorText: Colors.white,backgroundColor: red);
  }

  static LinearGradient linearGradient =  LinearGradient(colors: [primary_light,primary],begin: Alignment.centerLeft ,end: Alignment.centerRight);
  static LinearGradient linearGradientWithOpacity =  LinearGradient(colors: [primary_light.withOpacity(0.5),primary.withOpacity(0.5)],begin: Alignment.centerLeft ,end: Alignment.centerRight);

  static BoxShadow darkBottomShadow = const BoxShadow(
    color: Color(0x33000000),
    offset: Offset(0, 2),
    blurRadius: 8,
    spreadRadius: 5,
  );

  static price(BuildContext context,double? old,double newPrice,{bool space = true}){
    if(old!=null && old > newPrice){
      return Row(
        mainAxisAlignment: space?MainAxisAlignment.spaceBetween:MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(newPrice.toString(),style: TextStyle(fontSize: 16,color: App.primary,fontWeight: FontWeight.bold),),
            ],
          ),
          Text(" "+App_Localization.of(context).translate("aed"),style: TextStyle(fontSize: 10,color: App.primary,fontWeight: FontWeight.bold),),
          space?Center():SizedBox(width: 20,),
          Text(old.toString(),style: TextStyle(fontSize: 12,color: Colors.grey,decoration: TextDecoration.lineThrough,decorationThickness: 2),),
        ],
      );
    }else{
      return  Row(
        children: [
          Text(newPrice.toString(),style: TextStyle(fontSize: 14,color: App.primary,fontWeight: FontWeight.bold),),
          Text(" "+App_Localization.of(context).translate("aed"),style: TextStyle(fontSize: 10,color: App.primary,fontWeight: FontWeight.bold),),
        ],
      );
    }
  }

  static productCard(BuildContext context , Product product){
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200],

          borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        children: [
          Container(
            height: Get.width*0.45,
            width: Get.width*0.45,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(Api.media_url+product.image),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(15),bottomLeft: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33000000),
                    offset: Offset(0, 5),
                    blurRadius: 3,
                    spreadRadius: 0,
                  )
                ]
            ),
          ),
          Container(
            height: Get.width*0.15,
            width: Get.width*0.45,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(product.title,maxLines: 2,
                  style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,),
                ),
                App.price(context,product.oldPrice,product.price),
              ],
            ),
          )
        ],
      ),
    );
  }

  static noResult(BuildContext context){
    return Center(
      child: Text(App_Localization.of(context).translate("no_results_found"),textAlign: TextAlign.center),
    );
  }

  static notLogin(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (){
            Get.to(()=>Login());
          },
          child: Text(App_Localization.of(context).translate("login"),style: TextStyle(color: App.primary,fontSize: 18,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
        ),
        SizedBox(width: 10,),
        Text(App_Localization.of(context).translate("or")),
        SizedBox(width: 10,),
        GestureDetector(
          onTap: (){
            Get.to(()=>SignUp());
          },
          child: Text(App_Localization.of(context).translate("sign_up"),style: TextStyle(color: App.primary,fontSize: 18,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
        ),
      ],
    );
  }

  static loading(BuildContext context){
    return Center(
      child: Container(
        width: 150,
        child: Center(
          child:
          Platform.isAndroid
          ?CircularProgressIndicator()
          :CupertinoActivityIndicator(color: App.primary,radius: 15,),
        ),
      ),
    );
  }

  static String getDate(DateTime date){
    String pattern = 'yyyy-MM-dd';
    String formatted = DateFormat(pattern).format(date);
    return formatted;
  }

  static shimmerLoading({double radius = 20}){
    return Shimmer.fromColors(
        baseColor: Colors.white,
        highlightColor:Colors.black.withOpacity(0.7),
        child:  Container(
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(radius)
          ),
        )
    );
  }

  static backBtn(BuildContext context){
    return Navigator.of(context).canPop()?BackButton(
        color: Colors.white
    ):null;
  }

  static myHeader(BuildContext context,{required double height , required Widget child}){
    return AppBar(
      centerTitle: true,
      // leading: App.backBtn(context),
      automaticallyImplyLeading: false,
      toolbarHeight: height,
      title: child,

      backgroundColor: Colors.transparent,
      elevation: 0,

    );
  }
}
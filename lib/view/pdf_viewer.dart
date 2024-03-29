import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:webview_flutter/webview_flutter.dart';


class MyPDFViewer extends StatelessWidget {
  String url;

  MyPDFViewer(this.url);

  RxBool loading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: App.primary_mid,
      appBar: App.myHeader(context, height: 60, child: Center(
            child:  Container(
              width: Get.width*0.9,
              child: Row(
                children: [
                  GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        child: Icon(Icons.arrow_back_ios,color: App.primary,size: 23),
                      )
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                      },
                      child: Container(
                        height: 40,

                        decoration: BoxDecoration(
                          // color: App.grey,
                            borderRadius: BorderRadius.circular(25)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(App_Localization.of(context).translate("invoice"),style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20,),
                  GestureDetector(
                      onTap: (){

                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        child: SvgPicture.asset("assets/icons/stroke/Bag_orange.svg",color: Colors.transparent,),
                      )
                  )
                ],
              ),
            )
        ),),
//todo pdf
      body: Container(
        color: Colors.white,
        child: WebView(
          // initialUrl: "https://docs.google.com/viewer?url="+Api.media_url+url,
          initialUrl: 'https://docs.google.com/gview?embedded=true&url='+Api.media_url+url,
          // initialUrl: Api.media_url+url,
          javascriptMode: JavascriptMode.unrestricted,
          // allowsInlineMediaPlayback: true,
        ),
      )
    );

  }
}

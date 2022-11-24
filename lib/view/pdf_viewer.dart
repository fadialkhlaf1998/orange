import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MyPDFViewer extends StatelessWidget {
  String url;

  MyPDFViewer(this.url);

  RxBool loading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: App.primary_mid,
      appBar: AppBar(
        title: Text(App_Localization.of(context).translate("invoice"),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        leading: App.backBtn(context),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              gradient: App.linearGradient,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:  Radius.circular(20)),
              boxShadow: [
                // App.darkBottomShadow,
              ]
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SfPdfViewer.network(Api.media_url+url,),
      )
    );
  }
}

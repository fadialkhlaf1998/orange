import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange/controller/verification_code_controller.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/widgets/primary_bottun.dart';
import '../app_localization.dart';
import 'package:orange/widgets/text_field.dart';

class VerificationCode extends StatelessWidget {
  VerificationCodeController verificationCodeController = Get.put(VerificationCodeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: App.primary_mid,
      appBar: AppBar(
        title: Text(App_Localization.of(context).translate("verification_code"),
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
                App.darkBottomShadow,
              ]
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          child: Center(
            child: Container(
              width: Get.width*0.9,
              child:Obx(() {
                return verificationCodeController.loading.value
                    ?App.loading(context)
                    :Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    verificationCodeController.fake.value?Center():Center(),

                    MyTextField(
                      width: Get.width,
                      height: 50,
                      controller: verificationCodeController.code,
                      validate: (verificationCodeController.code.text.isEmpty&&verificationCodeController.validate.value).obs,
                      label: "code",
                      onChanged: (value){
                        verificationCodeController.fake.value = !verificationCodeController.fake.value;
                      },
                    ),
                    SizedBox(height: 30,),
                    PrimaryBottun(
                      width: Get.width/2,
                      height: 50,
                      onPressed: (){
                        verificationCodeController.verificationCode(context);
                      },
                      color: App.primary,
                      text: "verification_code",
                      linearGradient: App.linearGradient,
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            verificationCodeController.resendCode(context);
                          },
                          child: Text(App_Localization.of(context).translate("resend"),
                            style: TextStyle(color: App.primary,decoration: TextDecoration.underline,fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:orange/controller/verification_code_controller.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/view/main.dart';
import 'package:orange/widgets/logo.dart';
import 'package:orange/widgets/primary_bottun.dart';
import '../app_localization.dart';
import 'package:orange/widgets/text_field.dart';

class VerificationCode extends StatelessWidget {
  VerificationCodeController verificationCodeController = Get.put(VerificationCodeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: App.background,
   
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
                      child: Icon(Icons.arrow_back_ios,color: App.primary),
                    )
                ),
                SizedBox(width: 20,),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                         Text(App_Localization.of(context).translate("verification_code"),style: TextStyle(color: App.primary,fontWeight: FontWeight.bold),)
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
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          child: Center(
            child: Container(
              width: Get.width*0.8,
              child:Obx(() {
                return verificationCodeController.loading.value
                    ?App.loading(context)
                    :SingleChildScrollView(
                      child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                      verificationCodeController.fake.value?Center():Center(),
                      Logo(70),
                      SizedBox(height: 80,),
                      MyTextField(
                        width: Get.width,
                        height: 50,
                        controller: verificationCodeController.code,
                        validate: (verificationCodeController.code.text.isEmpty&&verificationCodeController.validate.value).obs,
                        label: "code",
                        onChanged: (value){
                          verificationCodeController.fake.value = !verificationCodeController.fake.value;
                        },
                        errText: (verificationCodeController.code.text.isEmpty&&verificationCodeController.validate.value)?"verification_code_is_required":null,
                      ),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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
                      ),
                      SizedBox(height: 20,),
                      PrimaryBottun(
                        width: Get.width*0.8,
                        radiuce: 25,
                        height: 50,
                        onPressed: (){
                          verificationCodeController.verificationCode(context);
                        },
                        color: App.dark_grey,
                        text: "verification_code",
                        // linearGradient: App.linearGradient,
                      ),

                      SizedBox(height: 20,),
                      PrimaryBottun(
                        width: Get.width*0.8,
                        height: 50,
                        onPressed: (){
                          verificationCodeController.homeController.refreshData();
                          Get.off(()=>Main());
                        },
                        text: "visit_as_guest",
                        color: App.dark_grey,
                        radiuce: 25,
                      ),

                  ],
                ),
                    );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

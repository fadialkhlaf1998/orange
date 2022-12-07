import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orange/controller/home_controller.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/view/home.dart';
import 'package:orange/view/main.dart';

class VerificationCodeController extends GetxController{
  TextEditingController code = TextEditingController();
  HomeController homeController = Get.find();

  RxBool validate = false.obs;
  RxBool loading = false.obs;
  RxBool fake = false.obs;

  verificationCode(BuildContext context)async{
    validate.value = true;
    if(code.text.isNotEmpty ){
      if(Global.loginInfo !=null){
        await Api.hasInternet();
        loading.value = true;
        bool succ = await Api.verivicationCode(code.text, Global.loginInfo!.email);
        if(succ){
          homeController.refreshData();
          Get.offAll(()=>Main());
          App.succMsg(context, "verification_code", "verification_code_successfully");
        }else{
          App.errMsg(context, "verification_code", "wrong");
        }
        loading.value = false;
      }else{
        App.errMsg(context, "verification_code", "wrong");
      }

    }
  }

  resendCode(BuildContext context)async{
    validate.value = true;
    if(Global.loginInfo !=null){
      await Api.hasInternet();
      loading.value = true;
      bool succ = await Api.resendCode(Global.loginInfo!.email);
      if(succ){
        App.succMsg(context, "resend", "resend_code_successfully");
      }else{
        App.errMsg(context, "resend", "wrong");
      }
      loading.value = false;
    }else{
      App.errMsg(context, "resend", "wrong");
    }
  }

}
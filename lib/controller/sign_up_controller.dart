import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/view/verification_code.dart';

class SignupController extends GetxController{
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  RxBool validate = false.obs;
  RxBool loading = false.obs;
  RxBool fake = false.obs;
  RxBool hidePassword = false.obs;

  signup(BuildContext context)async{
    validate.value = true;
    if(email.text.isNotEmpty && email.text.isEmail
        && password.text.isNotEmpty && password.text.length >= 6 && name.text.isNotEmpty){
      await Api.hasInternet();
      loading.value = true;
      bool succ = await Api.signup(name.text, email.text, password.text, 0);
      if(succ){
        Get.off(()=>VerificationCode());
        App.succMsg(context, "sign_up", "sign_up_successfully");
      }else{
        App.errMsg(context, "sign_up", "wrong");
      }
      loading.value = false;
    }
  }

}
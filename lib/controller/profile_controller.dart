import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orange/controller/home_controller.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/helper/store.dart';
import 'package:orange/main.dart';
import 'package:orange/view/intro.dart';
import 'package:orange/view/main.dart';

class ProfileController extends GetxController{
  HomeController homeController = Get.find();
  RxBool loading = false.obs;
  RxBool showPhotoPicker = false.obs;
  final ImagePicker _picker = ImagePicker();

  ///change password
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  RxBool fake = false.obs;
  RxBool validate = false.obs;
  RxBool changePasswordLoading = false.obs;

  logout(){
    Store.logout();
    Get.offAll(()=>Intro());
    homeController.initApp();
  }

  pickCamera(BuildContext context)async{
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    showPhotoPicker.value = false;
    if(image != null){
      uploadImage(image,context);
    }
  }

  pickGallery(BuildContext context)async{
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    showPhotoPicker.value = false;
    if(image != null){
      uploadImage(image,context);
    }
  }

  deletePhoto(BuildContext context)async{
    loading.value = true;
    showPhotoPicker.value = false;
    var succ = await Api.deletePhoto();
    if(succ){
      await Api.login(Global.loginInfo!.email, Global.loginInfo!.password);
    }else{
      App.errMsg(context, "profile", "wrong");
    }
    loading.value = false;
  }

  deleteAccount(BuildContext context)async{
    loading.value = true;
    var succ = await Api.deleteAccount();
    if(succ){
      logout();
    }else{
      App.errMsg(context, "profile", "wrong");
    }
    loading.value = false;
  }

  uploadImage(XFile image,BuildContext context)async{
    loading.value = true;
    var succ = await Api.selectImage(image);
    if(succ){
      await Api.login(Global.loginInfo!.email, Global.loginInfo!.password);
    }else{
      App.errMsg(context, "profile", "wrong");
    }
    loading.value = false;
  }

  changePassword(BuildContext context)async{
    validate.value = true;
    if(oldPassword.text != Global.customer!.password){
      App.errMsg(context, "change_password", "old_password_is_wrong");
    }else if(newPassword.text != confirmPassword.text){
      App.errMsg(context, "change_password", "confirm_password_not_same_new_password");
    }else if(newPassword.text.length < 6){
      App.errMsg(context, "change_password", "password_must_be_more_than_6");
    }else if(newPassword.text.isNotEmpty && oldPassword.text.isNotEmpty && confirmPassword.text.isNotEmpty){
      changePasswordLoading.value = true;
      bool succ = await Api.changePassword(newPassword.text);
      changePasswordLoading.value = false;
      if(succ){
        oldPassword.clear();
        newPassword.clear();
        confirmPassword.clear();
        App.succMsg(context, "change_password", "password_changed_successfully");
        validate.value = false;
        // await Future.delayed(Duration(milliseconds: 1500));
        // Get.back();

      }else{
        App.errMsg(context, "change_password", "wrong");
      }
    }
  }

  changeLanguage(BuildContext context){
    String lang = "en";
    if(Global.locale == "en"){
      lang = "ar";
    }
    MyApp.set_locale(context, Locale(lang));
    Get.updateLocale(Locale(lang));
    Global.locale = lang;
    Store.saveLanguage(lang);
    homeController.refreshData();
    Get.to(()=>Main());

  }

}
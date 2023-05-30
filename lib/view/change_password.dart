import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/profile_controller.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/widgets/logo.dart';
import 'package:orange/widgets/primary_bottun.dart';
import 'package:orange/widgets/text_field.dart';

class ChangePassword extends StatelessWidget {

  ProfileController profileController = Get.find();

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
                      child: Icon(Icons.arrow_back_ios,color: App.primary),
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
                          Text(App_Localization.of(context).translate("change_password"),style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),)
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
      body: SingleChildScrollView(
        child: Obx(() => profileController.changePasswordLoading.value?
        Container(
          width: Get.width,
          height: Get.height * 0.7,
          child: Center(
            child: App.loading(context),
          ),
        )
            :Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profileController.fake.value?Center():Center(),

            SizedBox(height: Get.height*0.1 ,),
            Logo(70,false),
            SizedBox(height: Get.height*0.1,),
            MyTextField(
                width: Get.width*0.8,
                height: 50,
                controller: profileController.oldPassword,
                validate: (profileController.oldPassword.text.isEmpty && profileController.validate.value).obs,
                label: "old_password",
                onChanged: (value){
                  profileController.fake.value = !profileController.fake.value;
                },
              errText: (profileController.oldPassword.text.isEmpty && profileController.validate.value)?"old_password_is_required":null,
            ),
            SizedBox(height: 15,),
            MyTextField(
                width: Get.width*0.8,
                height: 50,
                controller: profileController.newPassword,
                validate: ((profileController.newPassword.text.isEmpty||profileController.newPassword.text.length < 6) && profileController.validate.value).obs,
                label: "new_password",
                onChanged: (value){
                  profileController.fake.value = !profileController.fake.value;
                },
              errText: (profileController.oldPassword.text.isEmpty && profileController.validate.value)?"new_password_is_required":null,
            ),
            SizedBox(height: 15,),
            MyTextField(
                width: Get.width*0.8,
                height: 50,
                controller: profileController.confirmPassword,
                validate: ((profileController.confirmPassword.text.isEmpty||profileController.confirmPassword.text.length < 6) && profileController.validate.value).obs,
                label: "confirm_password",
                onChanged: (value){
                  profileController.fake.value = !profileController.fake.value;
                },
              errText: (profileController.oldPassword.text.isEmpty && profileController.validate.value)?"confirm_password_is_required":null,
            ),
            SizedBox(height: 15,),
            PrimaryBottun(width: Get.width*0.8, height: 40,radiuce: 10, onPressed: (){
              profileController.changePassword(context);
            }, color: App.primary, text: "submit",)
          ],
        )),
      ),
    );
  }
}
 
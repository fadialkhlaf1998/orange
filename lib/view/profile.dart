import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/profile_controller.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/view/address.dart';
import 'package:orange/view/change_password.dart';
import 'package:orange/view/main.dart';
import 'package:orange/view/orders.dart';
import 'package:orange/widgets/primary_bottun.dart';
import 'package:orange/widgets/profile_bottun.dart';

class Profile extends StatelessWidget {

  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: App.primary_mid,
      appBar: AppBar(
        title: Text(App_Localization.of(context).translate("profile"),
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
      body: Obx(() => Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Global.customer == null
                  ?Container(
                width: Get.width,
                height: Get.height * 0.7,
                child: Center(
                  child: App.notLogin(context),
                ),
              )
                  :
              Column(
                children: [
                 // Spacer(),
                  SizedBox(height: 30,),
                  _profileDetails(context),

                  SizedBox(height: Get.height*0.15,),

                  ProfileBtn(onPressed: (){
                    Get.to(()=>Orders());
                  }, icon: Icon(Icons.shop_2_outlined,color: Colors.black,), text: "orders"),
                  SizedBox(height: 20,),

                  ProfileBtn(onPressed: (){
                    Get.to(()=>Address());
                  }, icon: Icon(Icons.location_on_outlined,color: Colors.black,), text: "address"),
                  SizedBox(height: 20,),

                  GestureDetector(
                    onTap: (){
                      profileController.changeLanguage(context);
                    },
                    child: Stack(
                      children: [
                        ProfileBtn(onPressed: (){
                          profileController.changeLanguage(context);
                        }, icon: Icon(Icons.language,color: Colors.black), text: "change_language"),
                        Global.locale=="en"?Positioned(
                          right: 30,
                            child: Container(
                              height: 30,
                          child: Center(
                            child: Text("العربية",style: TextStyle(fontSize: 16),),
                          ),
                        )):Center(),
                        Global.locale=="ar"?Positioned(
                            left: 30,
                            child: Container(
                              height: 30,
                              child: Center(
                                child: Text("English",style: TextStyle(fontSize: 16),),
                              ),
                            )):Center(),
                      ],
                    ),
                  ),

                  SizedBox(height: 20,),
                  ProfileBtn(onPressed: (){
                    Get.to(()=>ChangePassword());
                  }, icon: Icon(Icons.password,color: Colors.black), text: "change_password"),
                  SizedBox(height: 20,),
                  ProfileBtn(onPressed: (){
                    profileController.deleteAccount(context);
                  }, icon: Icon(Icons.delete,color: Colors.black), text: "delete_account"),
                  SizedBox(height: 20,),
                  ProfileBtn(onPressed: (){
                    profileController.logout();
                  }, icon: Icon(Icons.logout,color: Colors.black), text: "logout"),
                  SizedBox(height: 20,),
                ],

              ),
            ),
          ),
          profileController.showPhotoPicker.value?Positioned(
              child: GestureDetector(
                onTap: (){
                  profileController.showPhotoPicker.value = false;
                },
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  color: Colors.white.withOpacity(0.5),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                profileController.pickCamera(context);
                              },
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                    gradient: App.linearGradient,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Center(
                                  child: Icon(Icons.camera_alt,color: Colors.white,size: 40),
                                ),
                              ),
                            ),
                            SizedBox(width: 30,),
                            GestureDetector(
                              onTap: (){
                                profileController.pickGallery(context);
                              },
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                    gradient: App.linearGradient,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Center(
                                  child: Icon(Icons.photo,color: Colors.white,size: 40),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Global.customer!.image.isEmpty?Center():PrimaryBottun(
                            width: Get.width*0.4,
                            height: 40,
                            onPressed: (){
                              profileController.deletePhoto(context);
                            },
                            color: App.red,
                            text: "delete_photo"),
                      ],
                    ),
                  ),
                ),
              )
          ):Center(),

          profileController.loading.value?Container(
            width: Get.width,
            height: Get.height,
            color: Colors.white.withOpacity(0.5),
            child: Center(
              child: App.loading(context),
            ),
          ):Center(),
        ],
      )),
    );
  }
  _profileDetails(BuildContext context){
    return Container(
      width: Get.width,
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: Get.width * 0.15 ,
                height: Get.width * 0.15,
                decoration: BoxDecoration(
                  color: App.primary,
                  shape: BoxShape.circle,
                  image: Global.customer!.image.isEmpty?null
                      :DecorationImage(
                      image: NetworkImage(Api.media_url+Global.customer!.image),
                    fit: BoxFit.cover
                  )
                ),
                child: Global.customer!.image.isEmpty
                ?Icon(Icons.person,size: Get.width * 0.1,color: Colors.white,)
                    :Center(),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                    onTap: (){
                      profileController.showPhotoPicker.value = true;
                    },
                    child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2
                            )
                          ]
                        ),
                        child: Icon(Icons.edit,color: App.primary,size: 15,)),
                ),
              ),
            ],
          ),
          Container(
            width: Get.width * 0.85 - 20,
            height: Get.width * 0.15,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(App_Localization.of(context).translate("hello")+", ",style: TextStyle(fontWeight: FontWeight.bold , ),),
                    Text(Global.customer!.name,),
                  ],
                ),
                Text(Global.customer!.email,),
              ],
            ),
          )
        ],
      ),
    );
  }
}

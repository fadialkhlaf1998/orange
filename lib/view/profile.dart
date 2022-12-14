import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:orange/view/returns.dart';
import 'package:orange/widgets/primary_bottun.dart';
import 'package:orange/widgets/profile_bottun.dart';

class Profile extends StatelessWidget {

  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: App.background,
      appBar: App.myHeader(context, height: 60, child: Center(
          child:  Container(
            width: Get.width*0.9,
            child: Center(
              child: Text(App_Localization.of(context).translate("profile"),style: TextStyle(color: App.primary,fontWeight: FontWeight.bold),),
            )
          )
      ),),

      body: Obx(() => Stack(
        children: [
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Global.customer == null
                  ?Container(
                width: Get.width,
                height: Get.height * 0.7,
                child: Center(
                  child: App.notLogin(context),
                ),
              )
                  :
              Container(
                height: Get.height,
                child: Column(
                  children: [
                   // Spacer(),
                    SizedBox(height: 10,),
                    _profileDetails(context),
                    SizedBox(height: 20,),

                   Expanded(
                       child:Container(
                         padding: EdgeInsets.symmetric(horizontal: 10),
                         decoration: BoxDecoration(
                           color: Color(0xffE7E8EA),
                           borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                         ),
                         child: SingleChildScrollView(
                           child: Column(
                     children: [
                        SizedBox(height: 30,),
                           ProfileBtn(onPressed: (){
                             Get.to(()=>Orders());
                           }, icon: SvgPicture.asset("assets/icons/Bag_order.svg",color: App.dark_grey,), text: "orders"),
                           SizedBox(height: 20,),

                           ProfileBtn(onPressed: (){
                             Get.to(()=>Returns());
                           }, icon: SvgPicture.asset("assets/icons/Bag_return.svg",), text: "returns"),
                           SizedBox(height: 20,),

                           ProfileBtn(onPressed: (){
                             Get.to(()=>Address());
                           }, icon:  SvgPicture.asset("assets/icons/address.svg",), text: "address"),
                           SizedBox(height: 20,),

                           GestureDetector(
                             onTap: (){
                               profileController.changeLanguage(context);
                             },
                             child: Stack(
                               children: [
                                 ProfileBtn(onPressed: (){
                                   profileController.changeLanguage(context);
                                 }, icon: SvgPicture.asset("assets/icons/language.svg",), text: "change_language"),
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
                           }, icon: SvgPicture.asset("assets/icons/change_password.svg",), text: "change_password"),
                           SizedBox(height: 20,),
                           ProfileBtn(onPressed: (){
                             // profileController.deleteAccount(context);
                             _confirmDialog(context,"delete_account");
                           }, icon: SvgPicture.asset("assets/icons/delete.svg",), text: "delete_account"),
                           SizedBox(height: 20,),
                           ProfileBtn(onPressed: (){
                             // profileController.logout();
                             _confirmDialog(context,"logout");
                           }, icon: SvgPicture.asset("assets/icons/logout.svg",), text: "logout"),
                           SizedBox(height: 40,),
                     ],
                   ),
                         ),
                       ),
                   )
                  ],

                ),
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

  _confirmDialog(BuildContext context,String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(App_Localization.of(context).translate("confirm_dialog")),
        content: Text(
          App_Localization.of(context).translate("are_u_want_to")+
          " "+ App_Localization.of(context).translate(title)+" ?",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: App.dark_grey
                  ),
                  child: Center(
                    child: Text(App_Localization.of(context).translate("cancel"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  if(title == "logout"){
                    profileController.logout();
                  }else{
                    profileController.deleteAccount(context);
                  }
                },
                child: Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: App.primary
                  ),
                  child: Center(
                    child: Text(App_Localization.of(context).translate("submit"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _profileDetails(BuildContext context){
    return Container(
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: Get.width * 0.2 ,
                height: Get.width * 0.2,
                decoration: BoxDecoration(
                  color: Color(0xffE7E8EA),
                  shape: BoxShape.circle,
                  image: Global.customer!.image.isEmpty?null
                      :DecorationImage(
                      image: NetworkImage(Api.media_url+Global.customer!.image),
                    fit: BoxFit.cover
                  )
                ),
                child: Global.customer!.image.isEmpty
                ?Icon(Icons.person,size: Get.width * 0.15,color: Colors.white,)
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
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: App.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2
                            )
                          ]
                        ),
                        child: Icon(Icons.edit_outlined,color: Colors.white,size: 15,)),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(App_Localization.of(context).translate("hello")+", ",style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 18 ,color: App.dark_blue),),
                    Text(Global.customer!.name,style: TextStyle(fontSize: 18,color: App.dark_blue),),
                  ],
                ),
                Text(Global.customer!.email,style: TextStyle(color: App.dark_blue),),
              ],
            ),
          )
        ],
      ),
    );
  }
}

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

      body: Obx(() => SafeArea(
        child: Stack(
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
                      Row(
                        children: [
                          SizedBox(width: 20,),
                          Text(App_Localization.of(context).translate("profile"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                        ],
                      ),
                      SizedBox(height: 10,),
                     Expanded(
                         child:Container(

                           child: SingleChildScrollView(
                             child: Column(
                       children: [


                             Container(
                               color: App.greyF5,
                               padding: EdgeInsets.symmetric(horizontal: 10),
                               child: Column(
                                 children: [
                                   ProfileBtn(onPressed: (){
                                     Get.to(()=>Orders());
                                   }, icon: SvgPicture.asset("assets/profile/my_order.svg",), text: "orders"),


                                   ProfileBtn(onPressed: (){
                                     Get.to(()=>Returns());
                                   }, icon: SvgPicture.asset("assets/profile/returns.svg",), text: "returns"),


                                   ProfileBtn(onPressed: (){
                                     Get.to(()=>Address());
                                   }, icon:  SvgPicture.asset("assets/profile/address.svg",), text: "address"),


                                   GestureDetector(
                                     onTap: (){
                                       profileController.changeLanguage(context);
                                     },
                                     child: Stack(
                                       children: [
                                         ProfileBtn(onPressed: (){
                                           profileController.changeLanguage(context);
                                         }, icon: SvgPicture.asset("assets/profile/language.svg",), text: "change_language",withIcon: false),
                                         Global.locale=="en"?Positioned(
                                             right: 5,
                                             child: Container(
                                               height: 40,
                                               child: Center(
                                                 child: Text("العربية",style: TextStyle(fontSize: 16),),
                                               ),
                                             )):Center(),
                                         Global.locale=="ar"?Positioned(
                                             left: 5,
                                             child: Container(
                                               height: 40,
                                               child: Center(
                                                 child: Text("English",style: TextStyle(fontSize: 16),),
                                               ),
                                             )):Center(),
                                       ],
                                     ),
                                   ),


                                   ProfileBtn(onPressed: (){
                                     Get.to(()=>ChangePassword());
                                   }, icon: SvgPicture.asset("assets/profile/change_password.svg",), text: "change_password"),

                                   ProfileBtn(onPressed: (){
                                     profileController.deleteAccount(context);
                                     _confirmDialog(context,"delete_account");
                                   }, icon: SvgPicture.asset("assets/profile/delete_account.svg",), text: "delete_account",withDivider: false,withIcon: false),
                                 ],
                               ),
                             ),
                             SizedBox(height: 10,),
                             GestureDetector(
                               onTap: (){
                                 profileController.logout();
                               },
                               child: Container(
                                 padding: EdgeInsets.symmetric(horizontal: 10),
                                 child: Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     SvgPicture.asset("assets/profile/logout.svg",),
                                     SizedBox(width: 10,),
                                     Text(App_Localization.of(context).translate("logout"),style: TextStyle(fontSize: 13,color: Colors.black.withOpacity(0.5)),)
                                   ],
                                 ),
                               ),
                             ),
                             SizedBox(height: 15),
                             Padding(
                               padding: const EdgeInsets.all(5),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   //todo icons here
                                   SvgPicture.asset("assets/profile/youtube.svg"),
                                   SizedBox(width: 15,),
                                   SvgPicture.asset("assets/profile/facebook.svg"),
                                   SizedBox(width: 15,),
                                   SvgPicture.asset("assets/profile/inestagram.svg"),
                                   SizedBox(width: 15,),
                                   SvgPicture.asset("assets/profile/twitter.svg"),
                                 ],
                               ),
                             ),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Text(App_Localization.of(context).translate("privacy_policy"),style: TextStyle(color: App.greyC5,fontSize: 11),),
                                 Padding(
                                   padding: const EdgeInsets.all(5),
                                   child: Text(".",style: TextStyle(color: App.greyC5,fontSize: 11),),
                                 ),
                                 Text(App_Localization.of(context).translate("terms_of_sale"),style: TextStyle(color: App.greyC5,fontSize: 11),),
                                 Padding(
                                   padding: const EdgeInsets.all(5),
                                   child: Text(".",style: TextStyle(color: App.greyC5,fontSize: 11),),
                                 ),
                                 Text(App_Localization.of(context).translate("terms_of_use"),style: TextStyle(color: App.greyC5,fontSize: 11),),
                               ],
                             ),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text(App_Localization.of(context).translate("return_policy"),style: TextStyle(color: App.greyC5,fontSize: 11),),
                             Padding(
                               padding: const EdgeInsets.all(5),
                               child: Text(".",style: TextStyle(color: App.greyC5,fontSize: 11),),
                             ),
                             Text(App_Localization.of(context).translate("warranty_policy"),style: TextStyle(color: App.greyC5,fontSize: 11),),
                           ],
                         ),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Padding(
                               padding: const EdgeInsets.all(5),
                               child: Text("@ 2023 Developed By Maxart",style: TextStyle(color: App.greyC5,fontSize: 11),),
                             ),
                           ],
                         ),
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
        ),
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
              ),

            ],
          )
        ],
      ),
    );
  }

  _profileDetails(BuildContext context){
    return Container(
      width: Get.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 20,),
          Stack(
            children: [
              Container(
                height: 65 + 8,
              ),
              Container(
                width: 65,
                height: 65,
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
                ?Icon(Icons.person,size: 45,color: Colors.white,)
                    :Center(),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 65,
                  child: Center(
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
                          child: Icon(Icons.edit_outlined,color: Colors.white,size: 12,)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(App_Localization.of(context).translate("hello")+", ",style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 16 ,color: App.dark_blue),),
                    Text(Global.customer!.name,style: TextStyle(fontSize: 16,color: App.dark_blue),),
                  ],
                ),
                Text(Global.customer!.email,style: TextStyle(color: App.dark_blue,fontSize: 12),),
              ],
            ),
          )
        ],
      ),
    );
  }
}

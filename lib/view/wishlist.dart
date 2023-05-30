import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/wishlist_controller.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/view/main.dart';
import 'package:orange/widgets/logo.dart';
import 'package:orange/widgets/product_card.dart';
import 'package:orange/widgets/searchDelgate.dart';
import 'package:get/get.dart';

class Wishlist extends StatelessWidget {

  WishlistController wishlistController = Get.find();

  // Wishlist(){
  //   wishlistController.getData();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: App.primary_mid,
      appBar:App.myHeader(context, height: 60, child: Center(
          child:  Container(
              width: Get.width*0.9,
              child: Row(
                children: [
                  GestureDetector(
                      onTap: (){
                        wishlistController.homeController.pageController.jumpToTab(0);
                        wishlistController.homeController.selectedPage(0);
                      },
                      child: Logo(30, false),
                  ),
                  SizedBox(width: 10,),
                  Text(App_Localization.of(context).translate("wishlist"),style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                ],
              )
          )
      ),),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Obx(() => Column(
          children: [
            wishlistController.fake.value ?Center():Center(),
            Container(
              width: Get.width,
              child:  Global.customer == null?
              Container(
                height: Get.height*0.7,
                width: Get.width,
                child: App.notLogin(context),
              )
                  :wishlistController.loading.value ?Container(
                height: Get.height*0.6,
                child: App.loading(context),
              )
                  :
                 wishlistController.wishlist.isEmpty?
              Container(
                  height: Get.height*0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 40,),
                      Icon(Icons.heart_broken,color: App.primary,size: 35 ,),
                      SizedBox(height: 15,),
                      Text(App_Localization.of(context).translate("your_wishlist_is_empty"),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black.withOpacity(0.5),fontSize: 12),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(App_Localization.of(context).translate("what_you_are_waiting_for"),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black.withOpacity(0.5),fontSize: 12),),
                          SizedBox(width: 5,),
                          GestureDetector(
                            onTap: (){
                              wishlistController.homeController.pageController.jumpToTab(0);
                              wishlistController.homeController.selectedPage(0);
                            },
                            child: Text(App_Localization.of(context).translate("continue_shopping"),style: TextStyle(fontWeight: FontWeight.bold,color: App.primary,fontSize: 12),),
                          )
                        ],
                      )
                    ],
                  ),
                ):
              GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                    Get.width > 600 ? 3 : 2,
                    childAspectRatio: 0.65,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: wishlistController.wishlist.length,
                  itemBuilder: (context,index){
                    return ProductCard(wishlistController.wishlist[index],false);
                  }
              ),
            )
          ],
        ),)
      ),
    );
  }
}

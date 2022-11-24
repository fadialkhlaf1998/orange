import 'package:flutter/material.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/wishlist_controller.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/widgets/product_card.dart';
import 'package:orange/widgets/searchDelgate.dart';
import 'package:get/get.dart';

class Wishlist extends StatelessWidget {

  WishlistController wishlistController = Get.find();

  Wishlist(){
    wishlistController.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: App.primary_mid,
      appBar: AppBar(
        title: Text(App_Localization.of(context).translate("wishlist"),
          style: TextStyle(
            fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        leading: App.backBtn(context),
        actions: [
          IconButton(onPressed: (){
            showSearch(context: context, delegate: SearchTextField());
          }, icon: Icon(Icons.search,color: Colors.white))
        ],
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
                  child: App.noResult(context),
                ):
              GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 45/60,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: wishlistController.wishlist.length,
                  itemBuilder: (context,index){
                    return ProductCard(wishlistController.wishlist[index]);
                  }
              ),
            )
          ],
        ),)
      ),
    );
  }
}

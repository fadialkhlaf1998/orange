import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orange/controller/home_controller.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/model/product.dart';

class WishlistController extends GetxController{

  RxBool loading = false.obs;
  RxBool fake = false.obs;
  List<Product> wishlist = <Product>[];
  HomeController homeController = Get.find();

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  getData()async{
    loading.value = true;
    wishlist = await Api.getWishlist();
    loading.value = false;
  }

  wishlistFunction(BuildContext context,Product product){
    if(product.wishlist.value == 1){
      deleteFromWishlist(context, product);
    }else{
      addToWishlist(context, product);
    }
  }

  addToWishlist(BuildContext context,Product product){
    if(Global.customer == null){
      App.errMsg(context, "wishlist", "please_login_first");
    }else{
      product.wishlist.value = 1;
      homeController.wishlistEvent(product.languageParent, 1);
      Api.addToWishlist(product.languageParent);
    }
  }

  deleteFromWishlist(BuildContext context,Product product){
    if(Global.customer == null){
      App.errMsg(context, "wishlist", "please_login_first");
    }else{
      product.wishlist.value = 0;
      homeController.wishlistEvent(product.languageParent, 0);
      Api.deleteFromWishlist(product.languageParent);
    }
  }


}
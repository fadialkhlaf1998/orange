import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/model/cart.dart';
import 'package:orange/model/product.dart';
import 'package:orange/model/result.dart';

class CartController extends GetxController{
  TextEditingController code = TextEditingController();
  CartModel? cartModel;

  RxBool loading = false.obs;
  RxBool detailsLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    getData();
  }

  getData()async{
    loading.value = true;
    cartModel = await Api.getCart();
    addDiscountCode();
    loading.value = false;
  }

  getDataAfterUpdateCart(int index)async{
    cartModel = await Api.getCart();
    addDiscountCode();
    loadingIndex(index,false);
  }
  addDiscountCode(){
    if(cartModel != null){
      code.text = cartModel!.discountCode;
    }
  }
  loadingIndex(int index,bool value){
    try{
      detailsLoading.value = value;
      cartModel!.cart[index].loading.value = value;
    }catch(e){

    }
  }

  Future<bool> addToCart(BuildContext context,int option_id,int count)async{
    if(Global.customer == null){
      App.errMsg(context, "cart", "please_login_first");
      return false;
    }else{
      if(option_id == -1){
        App.errMsg(context, "cart", "out_of_stock");
        return false;
      }else{
        // loading.value = true;
        loadingIndex(getCartIndex(option_id),true);
        bool succ = await Api.addToCart(option_id, count);
        if(succ){
          if(count>0){
            App.succMsg(context, "cart", "product_added_to_cart_successfully");
          }
          getDataAfterUpdateCart(getCartIndex(option_id));
          // loading.value = false;
          return true;
        }else{
          App.errMsg(context, "cart", "out_of_stock");
          // loading.value = false;
          loadingIndex(getCartIndex(option_id),false);
          return false;
        }
      }
    }
  }
  
  getCartIndex(int option_id){
    try{
      for(var elm in cartModel!.cart){
        if(option_id == elm.optionId){
          return cartModel!.cart.indexOf(elm);
        }
      }
    }catch(e){
      return 0;
    }
    return 0;
  }

  Future<bool> deleteFromCart(BuildContext context,index)async{
    if(Global.customer == null){
      App.errMsg(context, "cart", "please_login_first");
      return false;
    }else{
      // loading.value = true;
      loadingIndex(index,true);
      bool succ = await Api.deleteFromCart(cartModel!.cart[index].cartId);
      if(succ){
        App.succMsg(context, "cart", "product_deleted_to_cart_successfully");
        getDataAfterUpdateCart(index);
        return true;
      }else{
        App.errMsg(context, "cart", "wrong");
        // loading.value = false;
        loadingIndex(index,false);
        return false;
      }
    }
  }

  increase(BuildContext context ,int index)async{
    cartModel!.cart[index].loading.value = true;
    var succ = await addToCart(context, cartModel!.cart[index].optionId, 1);
    // if(succ){
    //   cartModel!.cart[index].count ++ ;
    // }
    cartModel!.cart[index].loading.value = false;
  }

  decrease(BuildContext context ,int index)async{
    cartModel!.cart[index].loading.value = true;
    if(cartModel!.cart[index].count > 1){
      var succ = await addToCart(context, cartModel!.cart[index].optionId, -1);
      // if(succ){
      //   cartModel!.cart[index].count -- ;
      // }
    }else{
      cartModel!.cart.removeAt(index);
      var succ = await deleteFromCart(context, index);
      // if(succ){
      //   cartModel!.cart.removeAt(index);
      // }
    }
    cartModel!.cart[index].loading.value = false;
  }

  activateCode(BuildContext context)async{
    if(code.text.isNotEmpty){
      loading.value = true;
      Result result = await Api.activateCode(code.text);
      if(result.code == 1){
        App.succMsg(context, "discount_code", result.message);
        getData();
      }else{
        print(result.message);
        App.errMsg(context, "discount_code", result.message);
        loading.value = false;
      }
    }
  }

}
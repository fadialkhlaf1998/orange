import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange/controller/cart_controller.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/model/address.dart';
import 'package:orange/view/home.dart';
import 'package:orange/view/main.dart';

class CheckoutController extends GetxController{

  RxInt selectedPayment = 0.obs;
  RxInt selectedAddress = (-1).obs;
  int selectedAddressId = -1;
  RxBool loadind = false.obs;
  CartController cartController = Get.find();

  init(List<Address> address){
    for(int i=0;i<address.length;i++){
      if(address[i].isDefault == 1 ){
        selectedAddress.value = i;
        selectedAddressId = address[i].id;
      }
    }
  }

  addOrder(BuildContext context){
    if(selectedAddressId == -1){
      App.errMsg(context, "checkout", "please_add_address");
    }else{
      if(selectedPayment.value == 1){
        //todo push Payment
      }else{
        addOrderForCOD(context);
      }
    }
  }

  addOrderForCOD(BuildContext context)async{
    loadind.value = true;
    bool succ = await Api.addOrder(selectedAddressId, 0);
    if(succ){
      Get.offAll(()=>Main());
      cartController.getData();
      App.succMsg(context, "checkout", "your_order_placed_successfully");
    }else{
      App.errMsg(context, "checkout", "wrong");
    }
    loadind.value = false;
  }

  addOrderForPayment(BuildContext context)async{
    loadind.value = true;
    bool succ = await Api.addOrder(selectedAddressId, 1);
    if(succ){
      loadind.value = false;
      Get.offAll(()=>Main());
      cartController.getData();
      App.succMsg(context, "checkout", "your_order_placed_successfully");
    }else{
      addOrderForPayment(context);
    }

  }

}
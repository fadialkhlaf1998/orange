import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/model/line_items.dart';

class ReturnController extends GetxController{
  List<LineItem> returns = <LineItem>[];
  RxBool loading = false.obs;
  RxBool openCart = false.obs;
  RxInt returnCount = 1.obs;
  RxInt selectedIndex = (-1).obs;

  select(int index){
    openCart.value = true;
    selectedIndex.value = index;
  }

  increase(){
    if(returnCount.value < returns[selectedIndex.value].count){
      returnCount.value++;
    }
  }

  decrease(){
    if(returnCount.value > 1){
      returnCount.value--;
    }
  }

  getData()async{
    loading.value = true;
    returns = await Api.getReturns();
    loading.value = false;
  }

  returnProduct(BuildContext context)async{
    openCart.value = false;
    loading.value = true;
    bool succ = await Api.returnProduct(returns[selectedIndex.value].orderId, returns[selectedIndex.value].lineItemsId, returnCount.value);
    if(succ){
      App.succMsg(context, "returns", "success_return");
      getData();
    }else{
      App.succMsg(context, "returns", "wrong");
      loading.value = false;
    }

  }
}
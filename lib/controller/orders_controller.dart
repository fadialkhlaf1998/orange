import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/model/order.dart';

class OrdersController extends GetxController{

  RxBool loading = false.obs;
  List<Order> orders = <Order>[];

  getData()async{
    loading.value = true;
    orders = await Api.getCustomerOrders();
    loading.value = false;
  }

  cancelOrder(BuildContext context , int index)async{
    orders[index].loading.value = true;
    bool succ = await Api.cancelOrder(orders[index].id);
    if(succ){
      getData();
      App.succMsg(context, "orders", "order_canceled");
    }else{
      App.errMsg(context, "orders", "wrong");
    }
    orders[index].loading.value = false;
  }

}
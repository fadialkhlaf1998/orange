import 'package:get/get.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/model/order.dart';

class OrderDetailsController extends GetxController{

  Order? order;
  RxBool loading = false.obs;

  getData(int order_id)async{
    loading.value = true;
    order = await Api.getOrderDetails(order_id);
    if(order == null){
      Get.back();
    }
    loading.value = false;
  }

}
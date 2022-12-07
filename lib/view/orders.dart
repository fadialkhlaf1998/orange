import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/orders_controller.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/view/order_details.dart';
import 'package:orange/view/pdf_viewer.dart';

class Orders extends StatelessWidget {

  OrdersController ordersController = Get.find();

  Orders(){
    ordersController.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: App.primary_mid,
      appBar: App.myHeader(context, height: 60, child: Center(
          child:  Container(
            width: Get.width*0.9,
            child: Row(
              children: [
                GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      child: Icon(Icons.arrow_back_ios,color: App.primary),
                    )
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                    },
                    child: Container(
                      height: 40,

                      decoration: BoxDecoration(
                        // color: App.grey,
                          borderRadius: BorderRadius.circular(25)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(App_Localization.of(context).translate("orders"),style: TextStyle(color: App.primary,fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                GestureDetector(
                    onTap: (){

                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      child: SvgPicture.asset("assets/icons/stroke/Bag_orange.svg",color: Colors.transparent,),
                    )
                )
              ],
            ),
          )
      ),),
      body: Obx(() => Column(
        children: [
          SizedBox(height: 20,),
          Expanded(
              child: SingleChildScrollView(

                child: ordersController.loading.value
                    ?App.loading(context)
                    :ordersController.orders.isEmpty
                    ?App.noResult(context)
                    :ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: ordersController.orders.length,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: GestureDetector(
                            onTap: (){
                              Get.to(()=>OrderDetails(ordersController.orders[index].id));
                            },
                            child: Container(
                              width: Get.width * 0.9,
                              height: 168,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),

                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 2,
                                      spreadRadius: 1
                                  )
                                ],
                              ),
                              child: Obx(() => ordersController.orders[index].loading.value
                                  ? App.shimmerLoading(radius: 10)
                                  :Column(
                                children: [
                                  Center(
                                    child: Container(
                                      width: Get.width * 0.9,
                                      height: 128,
                                      padding: EdgeInsets.symmetric(horizontal: 10),

                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              Text("#"+ordersController.orders[index].id.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                            ],
                                          ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(App_Localization.of(context).translate("placed_at")+":",style: TextStyle(fontWeight: FontWeight.bold),),
                                                  SizedBox(width: 5,),
                                                  Text(App.getDate(ordersController.orders[index].placedAt),),
                                                ],
                                              ),
                                              getState(context, ordersController.orders[index].state),
                                            ],
                                          ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              itemPrice(context,"sub_total",ordersController.orders[index].subTotal),
                                              itemPrice(context,"shipping",ordersController.orders[index].shipping),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              itemPrice(context,"discount",ordersController.orders[index].discount),
                                              itemPrice(context,"vat",ordersController.orders[index].vat),
                                            ],
                                          ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              itemPrice(context,"total",ordersController.orders[index].total),
                                              getPaid(context, ordersController.orders[index].isPaid),
                                            ],
                                          ),



                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    height: 30,
                                    child:
                                    ordersController.orders[index].def <= 15 && ordersController.orders[index].state == 0
                                        ?
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [

                                        Expanded(
                                            child: GestureDetector(
                                              onTap: (){
                                                Get.to(()=>MyPDFViewer(ordersController.orders[index].invoice));
                                              },
                                              child: Container(
                                                height: 30,
                                                // width: Get.width*0.5,
                                                decoration: BoxDecoration(
                                                  color: App.green,
                                                  borderRadius: Global.locale=="en"
                                                      ?BorderRadius.only(bottomLeft: Radius.circular(10))
                                                      :BorderRadius.only(bottomRight: Radius.circular(10)),
                                                ),
                                                child: Center(
                                                  child: Text(App_Localization.of(context).translate("invoice"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                ),
                                              ),
                                            )
                                        ),
                                        Expanded(
                                            child: GestureDetector(
                                              onTap: (){
                                                Get.to(()=>OrderDetails(ordersController.orders[index].id));
                                              },
                                              child: Container(
                                                height: 30,
                                                // width: Get.width*0.5,
                                                decoration: BoxDecoration(
                                                  gradient: App.linearGradient,
                                                  // borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
                                                ),
                                                child: Center(
                                                  child: Text(App_Localization.of(context).translate("view_order"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                ),
                                              ),
                                            )
                                        ),
                                        Expanded(
                                            child: GestureDetector(
                                              onTap: (){
                                                ordersController.cancelOrder(context, index);
                                              },
                                              child: Container(
                                                height: 30,
                                                // width: Get.width*0.5,
                                                decoration: BoxDecoration(
                                                  color: App.red,
                                                  borderRadius: Global.locale=="en"
                                                      ? BorderRadius.only(bottomRight: Radius.circular(10))
                                                      : BorderRadius.only(bottomLeft: Radius.circular(10))
                                                ),
                                                child: Center(
                                                  child: Text(App_Localization.of(context).translate("cancel_order"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                ),
                                              ),
                                            )
                                        ),

                                      ],
                                    )
                                    :Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: GestureDetector(
                                              onTap: (){
                                                Get.to(()=>MyPDFViewer(ordersController.orders[index].invoice));
                                              },
                                              child: Container(
                                                height: 30,
                                                width: Get.width*0.5,
                                                decoration: BoxDecoration(
                                                  color: App.green,
                                                  borderRadius: Global.locale=="en"
                                                      ? BorderRadius.only(bottomLeft: Radius.circular(10))
                                                      : BorderRadius.only(bottomRight: Radius.circular(10)),
                                                ),
                                                child: Center(
                                                  child: Text(App_Localization.of(context).translate("invoice"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                ),
                                              ),
                                            )
                                        ),
                                        Expanded(
                                            child: GestureDetector(
                                              onTap: (){
                                                Get.to(()=>OrderDetails(ordersController.orders[index].id));
                                              },
                                              child: Container(
                                                height: 30,
                                                width: Get.width*0.5,
                                                decoration: BoxDecoration(
                                                  gradient: App.linearGradient,
                                                  borderRadius: Global.locale=="en"
                                                      ? BorderRadius.only(bottomRight: Radius.circular(10))
                                                      : BorderRadius.only(bottomLeft: Radius.circular(10)),
                                                ),
                                                child: Center(
                                                  child: Text(App_Localization.of(context).translate("view_order"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                ),
                                              ),
                                            )
                                        ),
                                      ],
                                    )
                                    ,
                                  ),
                                ],
                              ),)
                            ),
                          ),
                        ),
                      );
                    }
                ),
              )
          ),
          SizedBox(height: 20,),
        ],
      )),
    );
  }

  getState(BuildContext context , int state){
    if(state == 1){
      return Text(App_Localization.of(context).translate("delivered"),style: TextStyle(color: App.green,fontWeight: FontWeight.bold),);
    }else if(state == 0){
      return Text(App_Localization.of(context).translate("pending"),style: TextStyle(color: App.primary,fontWeight: FontWeight.bold),);
    }else{
      return Text(App_Localization.of(context).translate("canceled"),style: TextStyle(color: App.red,fontWeight: FontWeight.bold),);
    }
  }

  getPaid(BuildContext context , int paid){
    if(paid == 1){
      return Text(App_Localization.of(context).translate("paid"),style: TextStyle(color: App.primary,fontWeight: FontWeight.bold),);
    }else{
      return Text(App_Localization.of(context).translate("cod_shortcut"),style: TextStyle(color: App.primary,fontWeight: FontWeight.bold),);
    }
  }

  itemPrice(BuildContext context,String title,double amount){
    return Row(
      children: [
        Text(App_Localization.of(context).translate(title)+":",style: TextStyle(fontWeight: FontWeight.bold),),
        SizedBox(width: 5,),
        Text(amount.toStringAsFixed(2)+" "+App_Localization.of(context).translate("aed"))
      ],
    );
  }
}

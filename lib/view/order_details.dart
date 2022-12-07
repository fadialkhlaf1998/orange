import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/order_details_controller.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:get/get.dart';
import 'package:orange/widgets/my_separator.dart';

class OrderDetails extends StatelessWidget {

  int order_id;
  OrderDetails(this.order_id){
    orderDetailsController.getData(order_id);
  }

  OrderDetailsController orderDetailsController = Get.put(OrderDetailsController());

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
      body: Obx(() => SingleChildScrollView(
        child: orderDetailsController.loading.value?
            Container(height: Get.height*0.5, child: App.loading(context),)
            :
        Center(
          child: Container(
            width: Get.width*0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30,),
                Text("#"+orderDetailsController.order!.id.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                Text(App.getDate(orderDetailsController.order!.placedAt),style: TextStyle(fontWeight: FontWeight.bold),),

                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(App_Localization.of(context).translate("payment_method")+":",style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(width: 5,),
                        getPaid(context, orderDetailsController.order!.isPaid),
                      ],
                    ),
                    getState(context, orderDetailsController.order!.state),
                  ],
                ),

                SizedBox(height: 15,),
                Text(App_Localization.of(context).translate("shipping_info"),style: TextStyle(fontWeight: FontWeight.bold)),
                Text(orderDetailsController.order!.addressInfo,),

                SizedBox(height: 15,),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: orderDetailsController.order!.lineItems.length,
                  shrinkWrap: true,
                  itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        width: Get.width,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(image: NetworkImage(Api.media_url+orderDetailsController.order!.lineItems[index].image)),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      orderDetailsController.order!.lineItems[index].title +
                                          (orderDetailsController.order!.lineItems[index].hard == "" ?"":" "+orderDetailsController.order!.lineItems[index].hard)+
                                          (orderDetailsController.order!.lineItems[index].ram == "" ?"":" "+orderDetailsController.order!.lineItems[index].ram)+
                                          (orderDetailsController.order!.lineItems[index].color == "" ?"":" "+orderDetailsController.order!.lineItems[index].color)+
                                          (orderDetailsController.order!.lineItems[index].additionatlOption == "" ?"":" "+orderDetailsController.order!.lineItems[index].additionatlOption)+
                                          (" X "+orderDetailsController.order!.lineItems[index].count.toString()),
                                      style: TextStyle(fontWeight: FontWeight.normal,color: App.grey),),
                                    Row(
                                      children: [
                                        Text(App_Localization.of(context).translate("price_one_piece")+":",style: TextStyle(fontWeight: FontWeight.bold),),
                                        SizedBox(width: 5,),
                                        Text(orderDetailsController.order!.lineItems[index].priceOnePiece.toString()+" "+App_Localization.of(context).translate("aed")),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(App_Localization.of(context).translate("total")+":",style: TextStyle(fontWeight: FontWeight.bold),),
                                        SizedBox(width: 5,),
                                        Text((orderDetailsController.order!.lineItems[index].priceOnePiece * orderDetailsController.order!.lineItems[index].count).toStringAsFixed(2)+" "+App_Localization.of(context).translate("aed")),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        orderDetailsController.order!.lineItems[index].returned>0?
                                        Text( orderDetailsController.order!.lineItems[index].returned.toString() +" "+ App_Localization.of(context).translate("items")+" "+App_Localization.of(context).translate("returned"),style: TextStyle(color: App.red,fontWeight: FontWeight.bold),)
                                            :Center()
                                      ],
                                    )
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                ),
                SizedBox(height: 20,),
                Container(
                  child: Column(
                    children: [
                      itemDetails(context,"sub_total",orderDetailsController.order!.subTotal),
                      itemDetails(context,"shipping",orderDetailsController.order!.shipping),
                      orderDetailsController.order!.discount>0?itemDetails(context,"discount",orderDetailsController.order!.discount):Center(),
                      itemDetails(context,"vat",orderDetailsController.order!.vat),
                      itemDetails(context,"total",orderDetailsController.order!.total),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      )),
    );
  }

  itemDetails(BuildContext context,String title,double amount){
    return Row(
      children: [
        Text(App_Localization.of(context).translate(title)),
        SizedBox(width: 15,),
        Expanded(
            child: MySeparator()
        ),
        SizedBox(width: 15,),
        Text(amount.toStringAsFixed(2)+" "+App_Localization.of(context).translate("aed"))
      ],
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

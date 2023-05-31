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
      backgroundColor: App.background,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(App_Localization.of(context).translate("orders"),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),)
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
                SizedBox(height: 7,),
                Text(App.getDate(orderDetailsController.order!.placedAt),style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.black.withOpacity(0.5)),),
                SizedBox(height: 7,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("#"+orderDetailsController.order!.id.toString(),style: TextStyle(fontSize: 15,letterSpacing: 0.6,fontWeight: FontWeight.bold,color: Colors.black),),
                    getState(context, orderDetailsController.order!.state),
                  ],
                ),
                SizedBox(height: 7,),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: orderDetailsController.order!.lineItems.length,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: App.greyF5
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              width: Get.width,
                              height: 107,
                              child: Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 105,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(image: NetworkImage(Api.media_url+(orderDetailsController.order!.lineItems[index].colorImage.isNotEmpty
                                          ?orderDetailsController.order!.lineItems[index].colorImage
                                          :orderDetailsController.order!.lineItems[index].image
                                      ))),
                                    ),
                                  ),
                                  SizedBox(width: 3,),
                                  Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(child: Text(orderDetailsController.order!.lineItems[index].title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),overflow: TextOverflow.ellipsis),)
                                            ],
                                          ),
                                          Text(
                                                (orderDetailsController.order!.lineItems[index].hard == "" ?"":" "+orderDetailsController.order!.lineItems[index].hard)+
                                                (orderDetailsController.order!.lineItems[index].ram == "" ?"":" "+orderDetailsController.order!.lineItems[index].ram)+
                                                (orderDetailsController.order!.lineItems[index].color == "" ?"":" "+orderDetailsController.order!.lineItems[index].color)+
                                                (orderDetailsController.order!.lineItems[index].additionatlOption == "" ?"":" "+orderDetailsController.order!.lineItems[index].additionatlOption),
                                            style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black.withOpacity(0.5),fontSize: 12),),
                                          Row(
                                            children: [
                                              Text(App_Localization.of(context).translate("price_one_piece")+":",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 11),),
                                              SizedBox(width: 5,),
                                              Text(orderDetailsController.order!.lineItems[index].priceOnePiece.toString()+" "+App_Localization.of(context).translate("aed"),style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 11),),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(App_Localization.of(context).translate("total")+":",style: TextStyle(color: App.primary,fontSize: 12),),
                                                  SizedBox(width: 5,),
                                                  Text((orderDetailsController.order!.lineItems[index].priceOnePiece * orderDetailsController.order!.lineItems[index].count).toStringAsFixed(2)+" "+App_Localization.of(context).translate("aed"),style: TextStyle(color: App.primary,fontSize: 12),),
                                                ],
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(vertical: 2,horizontal: 15),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(5)
                                                ),
                                                child: Text(   orderDetailsController.order!.lineItems[index].count.toString(),style: TextStyle(fontSize: 12),),
                                              )
                                            ],
                                          ),
                                       
                                          Row(
                                            children: [
                                              orderDetailsController.order!.lineItems[index].returned>0?
                                              Text( orderDetailsController.order!.lineItems[index].returned.toString() +" "+ App_Localization.of(context).translate("items")+" "+App_Localization.of(context).translate("returned"),style: TextStyle(color: App.red,fontWeight: FontWeight.bold,fontSize: 12),)
                                                  :Center()
                                            ],
                                          )
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                ),

                SizedBox(height: 7,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(App_Localization.of(context).translate("payment_method")+":",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 12),),
                        SizedBox(width: 5,),
                        getPaid(context, orderDetailsController.order!.isPaid),
                      ],
                    ),

                  ],
                ),

                SizedBox(height: 15,),

                Text(App_Localization.of(context).translate("shipping_info"),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 12)),
                Text(orderDetailsController.order!.addressInfo,style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 11),),
                SizedBox(height: 7,),
                Divider(height: 20,color: Colors.black.withOpacity(0.2),thickness:1),

                Container(
                  child: Column(
                    children: [
                      itemDetails(context,"sub_total",orderDetailsController.order!.subTotal),
                      itemDetails(context,"shipping",orderDetailsController.order!.shipping),
                      orderDetailsController.order!.discount>0?itemDetails(context,"discount",orderDetailsController.order!.discount):Center(),
                      itemDetails(context,"vat",orderDetailsController.order!.vat),
                      Divider(height: 20,color: Colors.black.withOpacity(0.2),thickness:1),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(App_Localization.of(context).translate("total"),style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 18,)),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(App_Localization.of(context).translate("aed"),style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold)),
                              SizedBox(width: 3,),
                              Text(orderDetailsController.order!.total.toStringAsFixed(2),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18)),
                            ],
                          )
                        ],
                      )
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(App_Localization.of(context).translate(title),style: TextStyle(color: Colors.black,fontSize: 12)),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(App_Localization.of(context).translate("aed"),style: TextStyle(fontSize: 12,color: Colors.black)),
              SizedBox(width: 3,),
              Text(amount.toStringAsFixed(2),style: TextStyle(color: Colors.black,fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }


  getState(BuildContext context , int state){
    if(state == 1){
      return Container(
          child: Row(
            children: [
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                    color: App.green,
                    shape: BoxShape.circle
                ),
              ),
              SizedBox(width: 8,),
              Text(App_Localization.of(context).translate("delivered"),style: TextStyle(color: App.green,fontWeight: FontWeight.bold,fontSize: 12),),
            ],
          )
      );
    }else if(state == 0){
      return Container(
          child: Row(
            children: [
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                    color: App.primary,
                    shape: BoxShape.circle
                ),
              ),
              SizedBox(width: 8,),
              Text(App_Localization.of(context).translate("pending"),style: TextStyle(color: App.primary,fontWeight: FontWeight.bold,fontSize: 12),),
            ],
          )
      );
    }else{
      return Container(
          child: Row(
            children: [
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                    color: App.red,
                    shape: BoxShape.circle
                ),
              ),
              SizedBox(width: 8,),
              Text(App_Localization.of(context).translate("canceled"),style: TextStyle(color: App.red,fontWeight: FontWeight.bold,fontSize: 12),),
            ],
          )
      );

    }
  }

  getPaid(BuildContext context , int paid){
    if(paid == 1){
      return Text(App_Localization.of(context).translate("paid"),style: TextStyle(color: Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold,fontSize: 12),);
    }else{
      return Text(App_Localization.of(context).translate("cod_shortcut"),style: TextStyle(color: Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold,fontSize: 12),);
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

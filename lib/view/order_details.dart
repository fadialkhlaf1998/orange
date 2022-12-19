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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getState(context, orderDetailsController.order!.state),
                    Text(App.getDate(orderDetailsController.order!.placedAt),style: TextStyle(fontWeight: FontWeight.bold,color: App.dark_grey),),
                  ],
                ),
                SizedBox(height: 15,),
                Text("#"+orderDetailsController.order!.id.toString(),style: TextStyle(fontWeight: FontWeight.bold,color: App.dark_blue),),


                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(App_Localization.of(context).translate("payment_method")+":",style: TextStyle(fontWeight: FontWeight.bold,color: App.dark_blue),),
                        SizedBox(width: 5,),
                        getPaid(context, orderDetailsController.order!.isPaid),
                      ],
                    ),

                  ],
                ),

                SizedBox(height: 15,),
                Text(App_Localization.of(context).translate("shipping_info"),style: TextStyle(fontWeight: FontWeight.bold,color: App.dark_blue)),
                Text(orderDetailsController.order!.addressInfo,style: TextStyle(color: App.dark_blue,fontSize: 11),),

                SizedBox(height: 15,),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: orderDetailsController.order!.lineItems.length,
                  shrinkWrap: true,
                  itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xffE7E8EA)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            width: Get.width,
                            height: 107,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xffE7E8EA)
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 105,
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
                                          style: TextStyle(fontWeight: FontWeight.normal,color: App.dark_blue),),
                                        Row(
                                          children: [
                                            Text(App_Localization.of(context).translate("price_one_piece")+":",style: TextStyle(fontWeight: FontWeight.bold,color: App.dark_blue),),
                                            SizedBox(width: 5,),
                                            Text(orderDetailsController.order!.lineItems[index].priceOnePiece.toString()+" "+App_Localization.of(context).translate("aed"),style: TextStyle(color: App.dark_blue),),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(App_Localization.of(context).translate("total")+":",style: TextStyle(fontWeight: FontWeight.bold,color: App.dark_blue),),
                                            SizedBox(width: 5,),
                                            Text((orderDetailsController.order!.lineItems[index].priceOnePiece * orderDetailsController.order!.lineItems[index].count).toStringAsFixed(2)+" "+App_Localization.of(context).translate("aed"),style: TextStyle(color: App.dark_blue),),
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
                      Divider(height: 10,color: App.dark_blue.withOpacity(0.2),thickness:1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(App_Localization.of(context).translate("total"),style: TextStyle(color: App.dark_blue,fontWeight: FontWeight.bold)),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(orderDetailsController.order!.total.toStringAsFixed(2),style: TextStyle(color: App.dark_blue,fontWeight: FontWeight.bold,fontSize: 18)),
                              SizedBox(width: 3,),
                              Text(App_Localization.of(context).translate("aed"),style: TextStyle(fontSize: 12,color: App.dark_blue,fontWeight: FontWeight.bold)),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(App_Localization.of(context).translate(title),style: TextStyle(color: App.dark_blue,fontWeight: FontWeight.bold)),

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(amount.toStringAsFixed(2),style: TextStyle(color: App.dark_blue,fontWeight: FontWeight.bold)),
            SizedBox(width: 3,),
            Text(App_Localization.of(context).translate("aed"),style: TextStyle(fontSize: 10,color: App.dark_blue,fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }


  getState(BuildContext context , int state){
    if(state == 1){
      return Container(
          decoration: BoxDecoration(
              color: App.green,
              borderRadius: BorderRadius.circular(25)
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 1),
            child: Text(App_Localization.of(context).translate("delivered"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          )
      );
    }else if(state == 0){
      return Container(
        decoration: BoxDecoration(
          color: App.primary,
          borderRadius: BorderRadius.circular(25)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 1),
          child: Text(App_Localization.of(context).translate("pending"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        )
      );
    }else{
      return Container(
          decoration: BoxDecoration(
              color: App.red,
              borderRadius: BorderRadius.circular(25)
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 1),
            child: Text(App_Localization.of(context).translate("canceled"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          )
      );
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

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/address_controller.dart';
import 'package:orange/controller/checkout_controller.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/view/add_address.dart';
import 'package:orange/widgets/primary_bottun.dart';

class Checkout extends StatelessWidget {

  CheckoutController checkoutController = Get.put(CheckoutController());
  AddressController addressController = Get.find();

  Checkout(){
    checkoutController.init(addressController.address);
  }
  
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
                Text(App_Localization.of(context).translate("checkout"),
                  style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
              ],
            ),
          )
      ),),

      body: Obx(() => Container(
        width: Get.width,
        child: checkoutController.loadind.value
            ? Container(
              width: Get.width * 0.9,
              height: Get.height * 0.6,
              child: App.loading(context),
            )
        :Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              Container(
                height: Get.height,
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(App_Localization.of(context).translate("payment_method"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                      ],
                    ),
                    SizedBox(height: 20,),
                    Container(
                      decoration: BoxDecoration(
                          color: App.greyF5,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: (){
                              checkoutController.selectedPayment.value = 0;
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              width: Get.width * 0.9,
                              child: Center(
                                child: Container(
                                  width: Get.width * 0.8,
                                  child: Row(
                                    children: [
                                      //todo change icon
                                      SvgPicture.asset("assets/images/cod.svg",width: 17,),
                                      SizedBox(width: 10,),
                                      Text(App_Localization.of(context).translate("cod"),style: TextStyle(fontSize: 12),),
                                      Spacer(),
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: App.primary)
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: checkoutController.selectedPayment.value == 0
                                                    ? App.linearGradient
                                                    : null
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Divider(),
                          GestureDetector(
                            onTap: (){
                              checkoutController.selectedPayment.value = 1;
                            },
                            child: Container(
                              width: Get.width * 0.9,
                              height: 40,
                              child: Center(
                                child: Container(
                                  width: Get.width * 0.8,
                                  child: Row(
                                    children: [
                                      //todo change icon
                                      SvgPicture.asset("assets/images/credit.svg",width: 17,),
                                      SizedBox(width: 10,),
                                      Text(App_Localization.of(context).translate("credit"),style: TextStyle(fontSize: 12),),
                                      Spacer(),
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: App.primary)
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: checkoutController.selectedPayment.value == 1
                                                    ? App.linearGradient
                                                    : null
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(App_Localization.of(context).translate("shipping_info"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                        GestureDetector(
                          onTap: (){
                            Get.to(()=>AddAddress());
                          },
                          child: Row(
                            children: [
                              Icon(Icons.add,color: App.grey95,),
                              SizedBox(width: 2,),
                              Text(App_Localization.of(context).translate("add_address"),style: TextStyle(fontSize: 12,color: App.grey95,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    addressController.loading.value?
                    Container(
                      width: Get.width,
                      height: Get.width,
                      child: Center(
                        child: App.loading(context),
                      ),
                    )

                        :Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(bottom: 20),
                            itemCount: addressController.address.length,
                            itemBuilder: (context , index){
                              return Obx(() => GestureDetector(
                                onTap: (){
                                  checkoutController.selectedAddress.value = index;
                                  checkoutController.selectedAddressId = addressController.address[index].id;
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3 ),
                                  child: Column(

                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(addressController.address[index].nickName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                              Icon(checkoutController.selectedAddress.value == index
                                                  ?Icons.arrow_drop_down
                                                  :Icons.arrow_drop_up,color: Colors.grey,)
                                            ],
                                          ),
                                          Container(
                                            width: 16,
                                            height: 16,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(color: App.primary)
                                            ),
                                            child: Center(
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    gradient: checkoutController.selectedAddress.value == index
                                                        ? App.linearGradient
                                                        : null
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8,),
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        height: checkoutController.selectedAddress.value == index?128:0,
                                        width: Get.width,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: App.greyF5,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: SingleChildScrollView(
                                          physics: NeverScrollableScrollPhysics(),
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  //todo change icon
                                                  SvgPicture.asset("assets/images/delivery-address.svg",width: 17,),
                                                  SizedBox(width: 8,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(App_Localization.of(context).translate("shipping_address"),style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.bold),),
                                                      Text(addressController.address[index].stretName+" "+addressController.address[index].building,style: TextStyle(fontSize: 12,color: Colors.black.withOpacity(0.5)),),
                                                      Text(App_Localization.of(context).translate("flat")+":"+addressController.address[index].flat.toString()+"   "+App_Localization.of(context).translate("floor")+":"+addressController.address[index].floor.toString(),style: TextStyle(fontSize: 12,color: Colors.black.withOpacity(0.5)),),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Divider(),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  //todo change icon
                                                  SvgPicture.asset("assets/images/call.svg",width: 16.39,),
                                                  SizedBox(width: 8,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(App_Localization.of(context).translate("mobile_number"),style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.bold),),
                                                      Text(addressController.address[index].dailCode+"-"+addressController.address[index].phone,style: TextStyle(fontSize: 12,color: Colors.black.withOpacity(0.5)),),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                            })
                    ),
                    SizedBox(height: 10,),

                    SizedBox(height: 60,)
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child:  Container(
                width: Get.width,
                height: 60,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    PrimaryBottun(width: Get.width * 0.9, height: 40, onPressed: (){
                      checkoutController.addOrder(context);
                    }, color: App.primary, text: "submit",radiuce: 8),

                  ],
                ),
              ),)
            ],
          ),
        )
      )),
    );
  }

  _addAddress(BuildContext context){
    return Container(
      width: Get.width * 0.9 ,
      height: 70,
      child: Center(
        child: PrimaryBottun(width: Get.width * 0.4, height: 40, onPressed: (){
          Get.to(()=>AddAddress());
        }, color: Colors.white, text: "add_address",linearGradient: App.linearGradient),
      ),
    );
  }

  item(BuildContext context , String key , String value){
    return Row(
      children: [
        Column(
          children: [
            key==""?Center():Text(App_Localization.of(context).translate(key)+": ",style: TextStyle(fontWeight: FontWeight.bold),),
          ],
        ),
        Column(
          children: [
            value==""?Center():Text(value,overflow: TextOverflow.ellipsis,),
          ],
        )
      ],
    );
  }
}

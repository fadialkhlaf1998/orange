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
                          Text(App_Localization.of(context).translate("checkout"),style: TextStyle(color: App.primary,fontWeight: FontWeight.bold),)
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

      body: Obx(() => Container(
        width: Get.width,
        child: checkoutController.loadind.value
            ? Container(
              width: Get.width * 0.9,
              height: Get.height * 0.6,
              child: App.loading(context),
            )
        :Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(App_Localization.of(context).translate("payment_method"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
              ],
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                checkoutController.selectedPayment.value = 0;
              },
              child: Container(
                width: Get.width * 0.9,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2
                      )
                    ]
                ),
                child: Center(
                  child: Container(
                    width: Get.width * 0.8,
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey)
                          ),
                          child: Center(
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: checkoutController.selectedPayment.value == 0
                                      ? App.linearGradient
                                      : null
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text(App_Localization.of(context).translate("cod"),style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            GestureDetector(
              onTap: (){
                checkoutController.selectedPayment.value = 1;
              },
              child: Container(
                width: Get.width * 0.9,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2
                      )
                    ]
                ),
                child: Center(
                  child: Container(
                    width: Get.width * 0.8,
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey)
                          ),
                          child: Center(
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: checkoutController.selectedPayment.value == 1
                                      ? App.linearGradient
                                      : null
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text(App_Localization.of(context).translate("credit"),style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Divider(height: 1.5,color: Colors.black),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(App_Localization.of(context).translate("shipping_info"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
              ],
            ),
            SizedBox(height: 20,),
            addressController.loading.value?
                Expanded(
                  child: Center(
                    child: App.loading(context),
                  ),
                )

                :Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 20),
                    itemCount: addressController.address.length,
                    itemBuilder: (context , index){
                  return Center(
                    child: GestureDetector(
                      onTap: (){
                        checkoutController.selectedAddress.value = index;
                        checkoutController.selectedAddressId = addressController.address[index].id;
                      },
                      child: Padding(padding: EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            // height: 170,
                            width: Get.width*0.9,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 4,
                                      spreadRadius: 2
                                  ),
                                ]
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [

                                    Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.grey)
                                          ),
                                          child: Center(
                                            child: Obx(() => Container(
                                              width: 15,
                                              height: 15,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: checkoutController.selectedAddress.value == index
                                                      ? App.linearGradient
                                                      : null
                                              ),
                                            ),)
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Text(addressController.address[index].nickName,style: TextStyle(color: App.primary,fontWeight: FontWeight.bold,fontSize: 16),),
                                      ],
                                    ),
                                    item(context,"phone",addressController.address[index].dailCode+addressController.address[index].phone),
                                    item(context,"stret_name",addressController.address[index].stretName),
                                    item(context,"building",addressController.address[index].building),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        item(context,"floor",addressController.address[index].floor.toString()),
                                        item(context,"flat",addressController.address[index].flat.toString()),
                                      ],
                                    ),
                                    Text(addressController.address[index].addetionalDescription,overflow: TextOverflow.ellipsis,),

                                  ],
                                ),
                                addressController.address[index].isDefault == 1?Positioned(
                                    top: 0,
                                    left: Global.locale == "ar"?0:null,
                                    right: Global.locale == "en"?0:null,
                                    child: Container(
                                      width: 70,
                                      height: 27,
                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                      decoration: BoxDecoration(
                                          gradient: App.linearGradient,
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Center(
                                        child: Text(App_Localization.of(context).translate("default"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),),
                                      ),
                                    )):Center(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  );
                })
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PrimaryBottun(width: Get.width * 0.4, height: 40, onPressed: (){
                  Get.to(()=>AddAddress());
                }, color: App.primary, text: "add_address",radiuce: 20),


                PrimaryBottun(width: Get.width * 0.4, height: 40, onPressed: (){
                  checkoutController.addOrder(context);
                }, color: App.primary, text: "submit",radiuce: 20),

              ],
            ),
            SizedBox(height: 20,)
          ],
        ),
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

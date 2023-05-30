import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/address_controller.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/view/add_address.dart';

class Address extends StatelessWidget {
  AddressController addressController = Get.find();
  Address(){
    addressController.getData();
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
                          Text(App_Localization.of(context).translate("address"),style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),)
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
                ),
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
          )
      ),),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     Get.to(()=>AddAddress());
      //   },
      //   child: Container(
      //     width: 100,
      //     height: 100,
      //     decoration: BoxDecoration(
      //       gradient: App.linearGradient,
      //       shape: BoxShape.circle,
      //     ),
      //     child: Icon(Icons.add,color: Colors.white,size: 35,),
      //   ),
      // ),
      body: Obx(() =>
      addressController.loading.value?
          App.loading(context)
          :
          addressController.address.length == 0 ?
              Container(
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(App_Localization.of(context).translate("no_address_please_add_yours"),style: TextStyle(color: App.dark_blue,fontSize: 14,fontWeight: FontWeight.bold),)
                  ],
                ),
              )
              :
          ListView.builder(
            itemCount: addressController.address.length,
          padding: EdgeInsets.only(top: 0,bottom: 70),
          itemBuilder: (context,index){
            return Padding(padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 170,
                  width: Get.width*0.9,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              addressController.setDefault(index);
                            },
                            child: Container(
                              width: 17,
                              height: 17,
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
                                      color:  addressController.address[index].isDefault == 1?App.primary:Colors.transparent
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Text(addressController.address[index].nickName,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
                          Spacer(),
                          GestureDetector(
                              onTap: (){
                                Get.to(()=>AddAddress(address: addressController.address[index],));
                              },
                              child: Icon(Icons.edit,color: App.greyC5,size: 18,),
                          ),
                          SizedBox(width: 8,),
                          GestureDetector(
                            onTap: (){
                              addressController.deleteAddress(index);
                            },
                            child: Icon(Icons.delete,color: App.greyC5,size: 18,),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Container(
                        height: 128,
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                ),
              ),
            );
          })),
    );
  }

  item(BuildContext context , String key , String value){
    return Row(
      children: [
        Column(
          children: [
            key==""?Center():Text(App_Localization.of(context).translate(key)+": ",style: TextStyle(fontWeight: FontWeight.bold,color: App.dark_blue),),
          ],
        ),
        Column(
          children: [
            value==""?Center():Text(value,overflow: TextOverflow.ellipsis,style: TextStyle(color: App.dark_blue),),
          ],
        )
      ],
    );
  }
}

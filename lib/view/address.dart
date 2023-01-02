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
                          Text(App_Localization.of(context).translate("address"),style: TextStyle(color: App.primary,fontWeight: FontWeight.bold),)
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Get.to(()=>AddAddress());
        },
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: App.linearGradient,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.add,color: Colors.white,size: 35,),
        ),
      ),
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
                  padding: EdgeInsets.all(10),
                  height: 216,
                  width: Get.width*0.9,
                  decoration: BoxDecoration(
                      color: App.grey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // item(context,"",addressController.address[index].nickName),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(addressController.address[index].nickName,style: TextStyle(color: App.dark_blue,fontWeight: FontWeight.bold,fontSize: 18),),
                              addressController.address[index].isDefault == 1?Container(
                                width: 70,
                                height: 30,
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                decoration: BoxDecoration(
                                  // gradient: App.linearGradient,
                                    color: App.primary,
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Center(
                                  child: Text(App_Localization.of(context).translate("default"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),),
                                ),
                              ):Center()
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
                          Text(addressController.address[index].addetionalDescription,overflow: TextOverflow.ellipsis,style: TextStyle(color: App.dark_blue),),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              addressController.address[index].isDefault == 1?Center(): Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                child: GestureDetector(
                                  onTap: (){
                                    addressController.setDefault(index);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: App.primary,
                                      // gradient: App.linearGradient
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Text(App_Localization.of(context).translate("set_default"),style: TextStyle(color: Colors.white),),
                                      )
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15,),
                              GestureDetector(
                                onTap: (){
                                  Get.to(()=>AddAddress(address: addressController.address[index],));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: App.dark_grey)
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(3),
                                    child: Icon(Icons.edit_outlined,color: App.dark_grey,),
                                  )
                                ),
                              ),
                              SizedBox(width: 15,),
                              GestureDetector(
                                onTap: (){
                                  addressController.deleteAddress(index);
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: App.dark_grey)
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(3),
                                      child: Icon(Icons.delete_outline,color: App.dark_grey,),
                                    )
                                ),
                              ),


                            ],
                          )
                        ],
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

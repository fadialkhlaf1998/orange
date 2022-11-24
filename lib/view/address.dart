import 'package:flutter/material.dart';
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
      // backgroundColor: App.primary_mid,
      appBar: AppBar(
        title: Text(App_Localization.of(context).translate("address"),
          style: TextStyle(
            fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        leading: App.backBtn(context),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              gradient: App.linearGradient,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:  Radius.circular(20)),
              boxShadow: [
                App.darkBottomShadow,
              ]
          ),
        ),
      ),
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
          ListView.builder(
            itemCount: addressController.address.length,
          padding: EdgeInsets.only(top: 20,bottom: 40),
          itemBuilder: (context,index){
            return Padding(padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 200,
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
                          // item(context,"",addressController.address[index].nickName),
                          Text(addressController.address[index].nickName,style: TextStyle(color: App.primary,fontWeight: FontWeight.bold,fontSize: 16),),
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

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              addressController.address[index].isDefault == 1?Center(): Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                      child: Text(App_Localization.of(context).translate("set_default"),style: TextStyle(color: Colors.white),),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(onPressed: (){
                                Get.to(()=>AddAddress(address: addressController.address[index],));
                              }, icon: Icon(Icons.edit,color: App.primary,)),
                              IconButton(onPressed: (){
                                addressController.deleteAddress(index);
                              }, icon: Icon(Icons.delete,color: App.red,)),

                            ],
                          )
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
                          child: Text(App_Localization.of(context).translate("default"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                        ),
                      )):Center(),
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

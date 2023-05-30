import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/return_comtroller.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/view/main.dart';
import 'package:orange/widgets/primary_bottun.dart';


class Returns extends StatelessWidget {
  
  ReturnController returnController = Get.put(ReturnController());
  
  Returns(){
    returnController.getData();
    returnController.returnCount.value = 1;
    returnController.openCart.value = false;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                            Text(App_Localization.of(context).translate("returns"),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),)
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

      body:
      Obx(() => returnController.loading.value
          ?Container(
        width: Get.width,
        height: Get.width,
        child: Center(
          child: App.loading(context),
        ),
      ):
      returnController.returns.isEmpty?Container(
        width: Get.width,
        height: Get.width,
        child: Center(
          child: App.noResult(context),
        ),
      ): Center(
            child: Stack(
              children: [
                ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 0),
                itemCount: returnController.returns.length,
                itemBuilder: (context , index){
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        width: Get.width*0.9,
                        height: 206,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(App_Localization.of(context).translate("order")+" "+returnController.returns[index].orderId.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: (){
                                    returnController.select(index);
                                    sortBottomSheet(context);
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset("assets/profile/returns.svg",color: App.primary,),
                                      SizedBox(width: 3,),
                                      Text(App_Localization.of(context).translate("return"),style: TextStyle(color: App.primary),)
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Padding(
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
                                            image: DecorationImage(image: NetworkImage(Api.media_url+returnController.returns[index].image)),
                                          ),
                                        ),
                                        SizedBox(width: 3,),
                                        Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(returnController.returns[index].title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
                                                Text(
                                                  (returnController.returns[index].hard == "" ?"":" "+returnController.returns[index].hard)+
                                                      (returnController.returns[index].ram == "" ?"":" "+returnController.returns[index].ram)+
                                                      (returnController.returns[index].color == "" ?"":" "+returnController.returns[index].color)+
                                                      (returnController.returns[index].additionatlOption == "" ?"":" "+returnController.returns[index].additionatlOption),
                                                  style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black.withOpacity(0.5),fontSize: 12),),
                                                Row(
                                                  children: [
                                                    Text(App_Localization.of(context).translate("price_one_piece")+":",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 11),),
                                                    SizedBox(width: 5,),
                                                    Text(returnController.returns[index].priceOnePiece.toString()+" "+App_Localization.of(context).translate("aed"),style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 11),),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(App_Localization.of(context).translate("total")+":",style: TextStyle(color: App.primary,fontSize: 12),),
                                                        SizedBox(width: 5,),
                                                        Text((returnController.returns[index].priceOnePiece * returnController.returns[index].count).toStringAsFixed(2)+" "+App_Localization.of(context).translate("aed"),style: TextStyle(color: App.primary,fontSize: 12),),
                                                      ],
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(vertical: 2,horizontal: 15),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(5)
                                                      ),
                                                      child: Text(   returnController.returns[index].count.toString(),style: TextStyle(fontSize: 12),),
                                                    )
                                                  ],
                                                ),

                                                Row(
                                                  children: [
                                                    returnController.returns[index].returned>0?
                                                    Text( returnController.returns[index].returned.toString() +" "+ App_Localization.of(context).translate("items")+" "+App_Localization.of(context).translate("returned"),style: TextStyle(color: App.red,fontWeight: FontWeight.bold,fontSize: 12),)
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
                            ),
                            Divider()
                          ],
                        ),
                      ),
                    ),
                  );
                }
      ),

                !returnController.openCart.value?Center():
                GestureDetector(
                  onTap: (){
                    returnController.openCart.value = false;
                  },
                  child: Container(
                    width: Get.width,
                    height: Get.height,
                    color: Colors.black.withOpacity(0.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: Get.width * 0.7,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(App_Localization.of(context).translate("your_order")+" "+
                                  returnController.returns[returnController.selectedIndex.value].count.toString()+" "+
                                  App_Localization.of(context).translate("items"),
                              ),
                              Text(App_Localization.of(context).translate("how_many_items_you_want_to_return")),
                              Container(
                                width: Get.width*0.4,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                      )
                                    ]
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                        onTap: (){
                                         returnController.decrease();
                                        },
                                        child: Icon(Icons.exposure_minus_1,color: Colors.black,)),
                                    Text(returnController.returnCount.toString(),style: TextStyle(color: App.primary,fontWeight: FontWeight.bold,fontSize: 25),),
                                    GestureDetector(
                                        onTap: (){
                                          returnController.increase();
                                        },
                                        child: Icon(Icons.exposure_plus_1,color: Colors.black)),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      // Get.back();
                                      returnController.openCart(false);
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: App.dark_grey
                                      ),
                                      child: Center(
                                        child: Text(App_Localization.of(context).translate("cancel"),style:
                                        TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                  PrimaryBottun(
                                    width: 100,
                                    height: 30,
                                    onPressed: (){
                                      returnController.returnProduct(context);
                                    },
                                    color: App.primary,
                                    text: "submit",
                                    linearGradient: App.linearGradient,
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),)
    );
  }

  sortBottomSheet(BuildContext context) {

    showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Stack(
        children: [
          SizedBox(
            height: 250 + 27 / 2,
            width: 2,
          ),
          Positioned(
            top: 27 / 2,
            child: Container(
              width: Get.width,
              height: 250,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
              child: Obx(() => Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Container(
                          width: Get.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: Get.width,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text(App_Localization.of(context).translate("your_order")+" "+
                                            returnController.returns[returnController.selectedIndex.value].count.toString()+" "+
                                            App_Localization.of(context).translate("items"),
                                          style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 12),
                                        ),
                                        SizedBox(height: 8,),
                                        Text(App_Localization.of(context).translate("how_many_items_you_want_to_return"),style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 12),),

                                      ],
                                    ),
                                    Container(
                                      width: Get.width*0.4,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.grey.withOpacity(0.2),

                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                              onTap: (){
                                                returnController.decrease();
                                              },
                                              child: Text("-",style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),)),
                                          Text(returnController.returnCount.toString(),style: TextStyle(color: App.primary,fontWeight: FontWeight.bold,fontSize: 25),),
                                          GestureDetector(
                                              onTap: (){
                                                returnController.increase();
                                              },
                                              child: Icon(Icons.add,color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        PrimaryBottun(
                                          width: Get.width * 0.7,
                                          height: 30,
                                          onPressed: (){
                                            returnController.returnProduct(context);
                                          },
                                          color: App.primary,
                                          text: "submit",
                                          radiuce: 5,

                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )),
            ),
          ),
          Positioned(
              top: 0,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  width: 27,
                  height: 27,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          spreadRadius: 0.5,
                          blurRadius: 1,
                        )
                      ]),
                  child: Center(
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 15,
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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
                            Text(App_Localization.of(context).translate("returns"),style: TextStyle(color: App.primary,fontWeight: FontWeight.bold),)
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
                  padding: EdgeInsets.symmetric(vertical: 20),
                itemCount: returnController.returns.length,
                itemBuilder: (context , index){
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        width: Get.width*0.9,
                        height: 170,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2
                            )
                          ],
                        ),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Text(App_Localization.of(context).translate("order")+":",style: TextStyle(fontWeight: FontWeight.bold),),
                                Text("#"+returnController.returns[index].orderId.toString(),),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(Api.media_url+returnController.returns[index].image)
                                    )
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Container(
                                    height: 100,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(returnController.returns[index].title +
                                            (returnController.returns[index].color.isEmpty?"":" "+returnController.returns[index].color)+
                                            (returnController.returns[index].hard.isEmpty?"":" "+returnController.returns[index].hard)+
                                            (returnController.returns[index].ram.isEmpty?"":" "+returnController.returns[index].ram)+
                                            (returnController.returns[index].additionatlOption.isEmpty?"":" "+returnController.returns[index].additionatlOption),
                                        ),
                                        Text(returnController.returns[index].priceOnePiece.toString() + " X " + returnController.returns[index].count.toString()),
                                        Row(
                                          children: [
                                            Text(App_Localization.of(context).translate("total")+":",style: TextStyle(fontWeight: FontWeight.bold),),
                                            Text((returnController.returns[index].priceOnePiece*returnController.returns[index].count).toStringAsFixed(2)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PrimaryBottun(
                                    width: Get.width * 0.4,
                                    height: 30,
                                    onPressed: (){
                                      returnController.select(index);
                                    },
                                    color: App.primary,
                                    text: "return",
                                    linearGradient: App.linearGradient,
                                )
                              ],
                            )
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
                              PrimaryBottun(
                                  width: Get.width * 0.4,
                                  height: 35,
                                  onPressed: (){
                                    returnController.returnProduct(context);
                                  },
                                  color: App.primary,
                                  text: "submit",
                                  linearGradient: App.linearGradient,
                              )
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
}

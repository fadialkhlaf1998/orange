import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/cart_controller.dart';
import 'package:orange/controller/home_controller.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/view/checkout.dart';
import 'package:orange/widgets/my_separator.dart';
import 'package:orange/widgets/primary_bottun.dart';
import 'package:shimmer/shimmer.dart';

class Cart extends StatelessWidget {

  // Cart(){
  //   cartController.getData();
  // }

  CartController cartController = Get.find();
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: App.background,
        appBar:App.myHeader(context, height: 60, child: Center(
            child:  Container(
                width: Get.width*0.9,
                child: Center(
                  child: Text(App_Localization.of(context).translate("cart"),style: TextStyle(color: App.primary,fontWeight: FontWeight.bold),),
                )
            )
        ),),
      body: Obx(() => Global.customer == null && !cartController.loading.value?
      Container(
        width: Get.width,
        height: Get.height*0.7,
        child: Center(
          child: App.notLogin(context),
        ),
      )
          : (cartController.loading.value && cartController.cartModel == null)||cartController.cartModel == null
          ?Container(
            width: Get.width,
            height: Get.height*0.7,
            child: App.loading(context),
          )
          :Container(
            child: Stack(
        children: [
            cartController.cartModel!.cart.isEmpty?
              Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 40,),
                Icon(Icons.remove_shopping_cart_outlined,color: App.primary,size: 50,),
                SizedBox(height: 20,),
                Text(App_Localization.of(context).translate("your_cart_is_empty"),style: TextStyle(fontWeight: FontWeight.bold,color: App.dark_grey),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(App_Localization.of(context).translate("what_you_are_waiting_for"),style: TextStyle(fontWeight: FontWeight.bold,color: App.dark_grey),),
                    SizedBox(width: 5,),
                    GestureDetector(
                      onTap: (){
                        homeController.pageController.jumpToTab(0);
                        homeController.selectedPage(0);
                      },
                      child: Text(App_Localization.of(context).translate("continue_shopping"),style: TextStyle(fontWeight: FontWeight.bold,color: App.primary),),
                    )
                  ],
                )
              ],
            )
            :ListView.builder(
              padding: EdgeInsets.only(top: 20,bottom: 260),
                itemCount: cartController.cartModel!.cart.length,
                itemBuilder: (context,index){
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        width: Get.width*0.9,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xffE7E8EA),
                        ),
                        child: cartController.loading.value
                        ?App.shimmerLoading(radius: 15)
                        :Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 100,
                              width: Get.width * 0.9 -20,
                              child: Row(
                                children: [
                                  Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                            image: NetworkImage(Api.media_url+cartController.cartModel!.cart[index].image),
                                            fit: BoxFit.contain
                                        )
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Container(
                                    height: 100,
                                    width: Get.width*0.9 - 120,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [

                                        Text(cartController.cartModel!.cart[index].title +" "+cartController.cartModel!.cart[index].hard +" "+ cartController.cartModel!.cart[index].ram +" "+ cartController.cartModel!.cart[index].color +" "+ cartController.cartModel!.cart[index].additionatlOption),
                                        
                                        Divider(height: 2,),
                                        App.price(context,
                                            cartController.cartModel!.cart[index].oldPrice!=null?
                                            cartController.cartModel!.cart[index].oldPrice!+cartController.cartModel!.cart[index].addetionalPrice
                                                :cartController.cartModel!.cart[index].oldPrice, cartController.cartModel!.cart[index].price+cartController.cartModel!.cart[index].addetionalPrice,space: false),


                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            cartController.cartModel!.cart[index].loading.value
                                ?Container(
                              height: 30,
                              width: Get.width * 0.9 -20,
                              child: App.shimmerLoading(),
                            )
                                : Container(
                              height: 30,
                              width: Get.width * 0.9 -20,
                                  child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                  cartController.cartModel!.cart[index].count>0?
                                  Container(
                                    width: 100,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: App.dark_grey)
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                            onTap: (){
                                              cartController.decrease(context, index);
                                            },
                                            child: Container(
                                              width: 25,
                                              child: Center(
                                                child: Container(
                                                  height: 2,
                                                  width: 13,
                                                  decoration: BoxDecoration(
                                                    color: App.dark_grey,
                                                  ),
                                                ),
                                              ),
                                            )
                                        ),
                                        Text(cartController.cartModel!.cart[index].count.toString(),style: TextStyle(color: App.dark_blue,fontWeight: FontWeight.bold,fontSize: 16),),
                                        GestureDetector(
                                            onTap: (){
                                              cartController.increase(context, index);
                                            },
                                            child: Icon(Icons.add,color: App.dark_grey)),
                                      ],
                                    ),
                                  )
                                      :Container(
                                      width: 100,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.white,
                                          border: Border.all(color: App.red),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.3),
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                            )
                                          ]
                                      ),
                                      child:Center(
                                        child: Text(App_Localization.of(context).translate("out_of_stock"),style: TextStyle(color: App.red,fontSize: 12),),
                                      )
                                  ),

                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text((cartController.cartModel!.cart[index].addetionalPrice+cartController.cartModel!.cart[index].price).toString() ,style: TextStyle(color: App.dark_blue,fontSize: 18,fontWeight: FontWeight.bold),),
                                      Text(" X "+cartController.cartModel!.cart[index].count.toString() ,style: TextStyle(color: App.dark_blue,fontSize: 12),),
                                    ],
                                  ),

                                GestureDetector(
                                  onTap: (){
                                    cartController.deleteFromCart(context, index);
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: App.dark_grey)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.delete_outline,color: App.dark_grey,),
                                        Text(App_Localization.of(context).translate("remove"),style: TextStyle(color: App.dark_grey,fontSize: 12),)
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                                ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            ),

            Positioned(
                bottom: EdgeInsets.fromWindowPadding(WidgetsBinding.instance.window.viewInsets,WidgetsBinding.instance.window.devicePixelRatio).bottom,
                child: Container(
              width: Get.width,
              height: 255,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 4,
                    spreadRadius: 2,
                  ),
                ],
                // borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25)),
              ),
              child: cartController.loading.value || cartController.detailsLoading.value
                  ?App.shimmerLoading()
                  :Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 10,),

                    Container(
                      height: 50,
                      width: Get.width - 22,
                      decoration: BoxDecoration(
                        border: Border.all(color: App.dark_grey,),
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: Get.width * 0.7 - 5,
                            child: TextField(
                              controller: cartController.code,
                              decoration: InputDecoration(
                                hintText: App_Localization.of(context).translate("discount_code"),
                                hintStyle: TextStyle(fontSize: 12,color: App.dark_grey),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent)
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              cartController.activateCode(context);
                            },
                            child: Container(
                              height: 40,
                              width: Get.width * 0.3 - 22.5 ,
                              decoration: BoxDecoration(
                                color: App.primary,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(App_Localization.of(context).translate("apply"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    itemDetails(context,"sub_total",cartController.cartModel!.subTotal),
                    itemDetails(context,"shipping",cartController.cartModel!.shipping),
                    cartController.cartModel!.discount>0?itemDetails(context,"discount",cartController.cartModel!.discount):Center(),
                    itemDetails(context,"vat",cartController.cartModel!.vat),
                    // itemDetails(context,"",),


                    GestureDetector(
                      onTap: (){
                        if(cartController.cartModel!.cart.isNotEmpty){
                          Get.to(()=>Checkout());
                        }
                      },
                      child: Container(
                        height: 60,
                        width: Get.width - 20,
                        decoration: BoxDecoration(
                          color: App.dark_blue,
                          borderRadius: BorderRadius.circular(30)
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(App_Localization.of(context).translate("total"),style: TextStyle(color: Colors.white.withOpacity(0.5),fontSize: 12),),

                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(cartController.cartModel!.total.toStringAsFixed(2),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                                          SizedBox(width: 3,),
                                          Text(App_Localization.of(context).translate("aed"),style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.bold)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                
                                Container(
                                  width: 150,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: App.primary,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(App_Localization.of(context).translate("checkout"),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.white),),
                                      SizedBox(width: 5,),
                                      Icon(Icons.arrow_circle_right_outlined,color: Colors.white,)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,)
                  ],
                ),
              )

            ))

        ],
      ),
          ),)
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
}

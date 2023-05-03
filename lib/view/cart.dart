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
import 'package:orange/widgets/logo.dart';
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
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: (){
                          homeController.pageController.jumpToTab(0);
                          homeController.selectedPage(0);
                        },
                        child: Logo(30, false),
                    ),
                    SizedBox(width: 10,),
                    Text(App_Localization.of(context).translate("cart"),style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                  ],
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
            :GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                Get.width > 600 ? 2 : 1,
                childAspectRatio: 3/1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              padding: EdgeInsets.only(top: 0,bottom: 260),
                itemCount: cartController.cartModel!.cart.length,
                itemBuilder: (context,index){
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: App.greyF5
                      ),
                      child: cartController.loading.value
                          ?App.shimmerLoading(radius: 5)
                          :Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                        image: NetworkImage(Api.media_url+cartController.cartModel!.cart[index].image),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),
                            ),
                          ),
                          Expanded(flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(cartController.cartModel!.cart[index].title , style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                        GestureDetector(
                                          onTap: (){
                                            cartController.deleteFromCart(context, index);
                                          },
                                          child: Icon(Icons.delete_outline,color: App.grey95.withOpacity(0.8),size: 21),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(cartController.cartModel!.cart[index].hard ,style: TextStyle(color: App.grey95,fontSize: 12),),
                                        cartController.cartModel!.cart[index].ram.isNotEmpty?Text(" | " ,style: TextStyle(color: App.grey95,fontSize: 12),):Center(),
                                        Text(cartController.cartModel!.cart[index].ram ,style: TextStyle(color: App.grey95,fontSize: 12),),
                                        cartController.cartModel!.cart[index].color.isNotEmpty?Text(" | " ,style: TextStyle(color: App.grey95,fontSize: 12),):Center(),
                                        Text(cartController.cartModel!.cart[index].color ,style: TextStyle(color: App.grey95,fontSize: 12),),
                                        cartController.cartModel!.cart[index].additionatlOption.isNotEmpty?Text(" | " ,style: TextStyle(color: App.grey95,fontSize: 12),):Center(),
                                        Text(cartController.cartModel!.cart[index].additionatlOption ,style: TextStyle(color: App.grey95,fontSize: 12),),
                                      ],
                                    ),
                                    (cartController.cartModel!.cart[index].oldPrice!=null &&
                                        cartController.cartModel!.cart[index].oldPrice! > cartController.cartModel!.cart[index].price)?
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(App_Localization.of(context).translate("aed")+" "+cartController.cartModel!.cart[index].oldPrice!.toStringAsFixed(2),style: TextStyle(fontSize: 12,color: App.grey95 , decoration: TextDecoration.lineThrough),),
                                        Text(App_Localization.of(context).translate("save_off")+" "+(100 - (cartController.cartModel!.cart[index].price * 100 / cartController.cartModel!.cart[index].oldPrice!)).toStringAsFixed(0)+"%",
                                          style: TextStyle(fontSize: 12,color: Color(0xff48D66B),fontWeight: FontWeight.bold),),
                                      ],
                                    ):Center(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(App_Localization.of(context).translate("aed")+" "+cartController.cartModel!.cart[index].price.toStringAsFixed(2),style: TextStyle(color: App.primary , fontWeight: FontWeight.bold,),),
                                        cartController.cartModel!.cart[index].loading.value
                                            ?Container(
                                          height: 25,
                                          width: 75,
                                          child: App.shimmerLoading(radius: 5),
                                        )
                                            : Container(
                                          height: 25,
                                          width: 75,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              cartController.cartModel!.cart[index].count>0?
                                              Container(
                                                width: 75,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                  color: Colors.white
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
                                                          height: 25,
                                                          color: Colors.white,
                                                          child: Center(
                                                            child: Container(
                                                              height: 2,
                                                              width: 10,
                                                              decoration: BoxDecoration(
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ),
                                                    Text(cartController.cartModel!.cart[index].count.toString(),style: TextStyle(color: App.dark_blue,fontWeight: FontWeight.bold,fontSize: 14),),
                                                    GestureDetector(
                                                        onTap: (){
                                                          cartController.increase(context, index);
                                                        },
                                                        child: Icon(Icons.add,color: Colors.black,size: 20,)),
                                                  ],
                                                ),
                                              )
                                                  :Container(
                                                  width: 75,
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
                                                    child: Text(App_Localization.of(context).translate("out_of_stock"),style: TextStyle(color: App.red,fontSize: 11),),
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ],
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 0.5,
                  ),
                ],
              ),
              child: cartController.loading.value || cartController.detailsLoading.value
                  ?App.shimmerLoading(radius: 0)
                  :Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 10,),

                    Container(
                      height: 40,
                      width: Get.width - 22,
                      decoration: BoxDecoration(
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40,
                            width: Get.width * 0.7 - 8,
                            decoration: BoxDecoration(
                              color: App.greyF5,
                              borderRadius: BorderRadius.circular(5)
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                controller: cartController.code,
                                textAlignVertical: TextAlignVertical.top,
                                style:  TextStyle(color: Colors.black,fontSize: 13,height: 1.6),
                                decoration: InputDecoration(
                                  hintText: App_Localization.of(context).translate("discount_code"),
                                  hintStyle: TextStyle(color: App.grey95,fontSize: 13,height: 1.6),
                                  border: InputBorder.none,
                                ),
                              ),
                            )
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
                                borderRadius: BorderRadius.circular(5)
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

                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          itemDetails(context,"sub_total",cartController.cartModel!.subTotal),
                          itemDetails(context,"shipping",cartController.cartModel!.shipping),
                          cartController.cartModel!.discount>0?itemDetails(context,"discount",cartController.cartModel!.discount):Center(),
                          itemDetails(context,"vat",cartController.cartModel!.vat),
                        ],
                      ),
                    ),
                    // itemDetails(context,"",),


                    GestureDetector(
                      onTap: (){
                        if(cartController.cartModel!.cart.isNotEmpty){
                          Get.to(()=>Checkout());
                        }
                      },
                      child: Container(
                        height: 63,
                        width: Get.width - 20,
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
                                      Text(App_Localization.of(context).translate("total"),style: TextStyle(color: App.grey95,fontSize: 12),),
                                      Text(App_Localization.of(context).translate("aed") +" "+ cartController.cartModel!.total.toStringAsFixed(2),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                
                                Container(
                                  width: 120,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: App.primary,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(App_Localization.of(context).translate("checkout"),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.white),),
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
        Text(App_Localization.of(context).translate(title),style: TextStyle(color: App.dark_blue,fontSize: 13)),

        Text(App_Localization.of(context).translate("aed") + " " +amount.toStringAsFixed(2),style: TextStyle(color: App.dark_blue,fontSize: 13)),

      ],
    );
  }
}

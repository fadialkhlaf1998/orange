import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/cart_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: App.primary_mid,
        appBar: AppBar(
          leading: App.backBtn(context),
        title: Text(App_Localization.of(context).translate("cart"),
          style: TextStyle(
            fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
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

            ListView.builder(
              padding: EdgeInsets.only(top: 20,bottom: 220),
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
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 2,
                              spreadRadius: 2
                            )
                          ]
                        ),
                        child: cartController.loading.value
                        ?App.shimmerLoading(radius: 15)
                        :Row(
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(Api.media_url+cartController.cartModel!.cart[index].image),
                                  fit: BoxFit.contain
                                )
                              ),
                            ),
                            Container(
                              height: 150,
                              width: Get.width*0.9 - 160,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [

                                  Text(cartController.cartModel!.cart[index].title +" "+cartController.cartModel!.cart[index].hard +" "+ cartController.cartModel!.cart[index].ram +" "+ cartController.cartModel!.cart[index].color +" "+ cartController.cartModel!.cart[index].additionatlOption),
                                  App.price(context,
                                      cartController.cartModel!.cart[index].oldPrice!=null?
                                      cartController.cartModel!.cart[index].oldPrice!+cartController.cartModel!.cart[index].addetionalPrice
                                          :cartController.cartModel!.cart[index].oldPrice, cartController.cartModel!.cart[index].price+cartController.cartModel!.cart[index].addetionalPrice,space: false),
                                  Text((cartController.cartModel!.cart[index].addetionalPrice+cartController.cartModel!.cart[index].price).toString() +" X "+cartController.cartModel!.cart[index].count.toString() ),

                                  cartController.cartModel!.cart[index].loading.value
                                      ?Container(
                                    height: 48,
                                    child: App.shimmerLoading(),
                                  )
                                      : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 30,
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
                                                  cartController.decrease(context, index);
                                                },
                                                child: Icon(Icons.exposure_minus_1,color: Colors.black,)),
                                            Text(cartController.cartModel!.cart[index].count.toString(),style: TextStyle(color: App.primary,fontWeight: FontWeight.bold,fontSize: 16),),
                                            GestureDetector(
                                                onTap: (){
                                                  cartController.increase(context, index);
                                                },
                                                child: Icon(Icons.exposure_plus_1,color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                      IconButton(onPressed: (){
                                        cartController.deleteFromCart(context, index);
                                      }, icon: Icon(Icons.delete,color: App.red,))
                                    ],
                                  ),
                                ],
                              ),
                            )
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
              height: 225,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 2,
                    spreadRadius: 2,
                  ),
                ],
                borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25)),
              ),
              child: cartController.loading.value || cartController.detailsLoading.value
                  ?App.shimmerLoading()
                  :Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 25,),

                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: Get.width * 0.7,
                          child: TextField(
                            controller: cartController.code,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            cartController.activateCode(context);
                          },
                          child: Container(
                            height: 40,
                            width: Get.width * 0.3 - 20 ,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(App_Localization.of(context).translate("activate"),style: TextStyle(color: App.primary,fontWeight: FontWeight.bold,fontSize: 12),),
                                Text(App_Localization.of(context).translate("code"),style: TextStyle(color: App.primary,fontWeight: FontWeight.bold,fontSize: 12)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),

                    itemDetails(context,"sub_total",cartController.cartModel!.subTotal),
                    itemDetails(context,"shipping",cartController.cartModel!.shipping),
                    cartController.cartModel!.discount>0?itemDetails(context,"discount",cartController.cartModel!.discount):Center(),
                    itemDetails(context,"vat",cartController.cartModel!.vat),
                    itemDetails(context,"total",cartController.cartModel!.total),
                    PrimaryBottun(width: Get.width*0.5, height: 40, onPressed: (){
                      if(cartController.cartModel!.cart.isNotEmpty){
                        Get.to(()=>Checkout());
                      }
                    }, color: Colors.white, text: "checkout",linearGradient: App.linearGradient,)
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
      children: [
        Text(App_Localization.of(context).translate(title)),
        SizedBox(width: 15,),
        Expanded(
          child: MySeparator()
        ),
        SizedBox(width: 15,),
        Text(amount.toStringAsFixed(2)+" "+App_Localization.of(context).translate("aed"))
      ],
    );
  }
}

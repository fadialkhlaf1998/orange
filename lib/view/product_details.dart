import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/cart_controller.dart';
import 'package:orange/controller/home_controller.dart';
import 'package:orange/controller/product_details_controller.dart';
import 'package:orange/controller/wishlist_controller.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/widgets/primary_bottun.dart';

class ProductDetails extends StatelessWidget {

  ProductDetailsController productDetailsController = Get.put(ProductDetailsController());
  WishlistController wishlistController = Get.find();
  HomeController homeController = Get.find();
  CartController cartController = Get.find();

  ProductDetails(String slug,int selectedOptionId){
    productDetailsController.getData(slug,selectedOptionId);
  }


  GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: App.greyFE,
      // appBar: App.myHeader(context, height: 60, child: Center(
      //     child:  Container(
      //       width: Get.width*0.9,
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           GestureDetector(
      //               onTap: (){
      //                 Get.back();
      //               },
      //               child: Container(
      //                 width: 25,
      //                 height: 25,
      //                 child: Icon(Icons.arrow_back_ios,color: App.primary,),
      //               )
      //           ),
      //           GestureDetector(
      //               onTap: (){
      //                 Get.back();
      //                 Get.back();
      //                 homeController.pageController.jumpToTab(3);
      //                 homeController.selectedPage.value = 3;
      //               },
      //               child: Container(
      //                 width: 25,
      //                 height: 25,
      //                 child: SvgPicture.asset("assets/icons/stroke/Bag_orange.svg",),
      //               )
      //           )
      //         ],
      //       ),
      //     )
      // ),),
      body: SafeArea(child: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: productDetailsController.loading.value?
            Container(
              width: Get.width,
              height: Get.height*0.6,
              child: App.loading(context),
            )
                : Container(
              width: Get.width,
              color: App.greyFE,
              child: Column(
                children: [
                  _slider(context,
                      productDetailsController.product!.option !=null
                          && productDetailsController.product!.option!.images.length > 0
                          ?productDetailsController.product!.option!.images:productDetailsController.product!.images
                  ),

                  Container(
                    width: Get.width,

                    decoration: BoxDecoration(
                        color: Color(0xfff6f6f6),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff000000).withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius: 0,
                              offset: Offset(0,-4)
                          )
                        ]
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(productDetailsController.product!.title,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                  Container(
                                      child: Align(
                                        alignment: Global.locale=="ar"?Alignment.centerLeft:Alignment.centerRight,
                                        child: Container(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 2),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(productDetailsController.product!.rate.toStringAsFixed(1),style: TextStyle(fontSize: 12,color: App.grey95),),
                                                SizedBox(width: 2,),
                                                Icon(Icons.star,color: Colors.amber,size: 16,),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                ],
                              ),
                              (productDetailsController.product!.oldPrice!=null &&
                                  productDetailsController.product!.oldPrice! > productDetailsController.product!.price)?SizedBox(height: 5,):Center(),
                              (productDetailsController.product!.oldPrice!=null &&
                                  productDetailsController.product!.oldPrice! > productDetailsController.product!.price)?Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(App_Localization.of(context).translate("aed")+" "+(productDetailsController.product!.oldPrice!+productDetailsController.product!.option!.addetionalPrice).toStringAsFixed(2),style: TextStyle(fontSize: 12,color: App.grey95 , decoration: TextDecoration.lineThrough),),
                                  Text(App_Localization.of(context).translate("save_off")+" "+(100 - ((productDetailsController.product!.price+productDetailsController.product!.option!.addetionalPrice) * 100 / (productDetailsController.product!.oldPrice!+productDetailsController.product!.option!.addetionalPrice))).toStringAsFixed(0)+"%",
                                    style: TextStyle(fontSize: 12,color: Color(0xff48D66B),fontWeight: FontWeight.bold),),
                                ],
                              ):Center(),
                              SizedBox(height: 5,),
                              Text(App_Localization.of(context).translate("aed")+" "+(productDetailsController.product!.price+productDetailsController.product!.option!.addetionalPrice).toStringAsFixed(2),style: TextStyle(color: App.primary , fontWeight: FontWeight.bold,),),
                              SizedBox(height: 5,),
                              Divider(
                                color: App.dark_grey,
                                height: 1,
                                thickness: 0.5,
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            Column(
                              children: [
                                productDetailsController.product!.colors.isEmpty?Center():_colorsList(context),
                                productDetailsController.product!.rams.isEmpty?Center():_ramsList(context),
                                productDetailsController.product!.hards.isEmpty?Center():_hardsList(context),
                                productDetailsController.product!.additionatlOptions.isEmpty?Center():_additionalOptionList(context),
                              ],
                            ),
                            productDetailsController.optionLoading.value?
                            Positioned.fill(child: Container(
                              width: Get.width,
                              color: Colors.white.withOpacity(0.5),
                              child: App.loading(context),
                            )):Center()
                          ],
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
                          child: Row(
                            children: [
                              Text(App_Localization.of(context).translate("description"),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: AnimatedContainer(
                            color: Color(0xfff6f6f6),
                            key: _key,
                            duration: Duration(milliseconds: 700),
                            height:
                            productDetailsController.veiwMore.value
                                ?null
                                :120,
                            child: Html(data: productDetailsController.product!.description,style: {
                              "*":Style(color: App.grey95,fontSize: FontSize(12),fontFamily: "Poppins")
                            }),
                          ),
                        ),
                        //todo check height of description _key.currentContext!.size.height
                        SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                productDetailsController.veiwMore.value
                                = !productDetailsController.veiwMore.value;
                              },
                              child: Container(
                                width: Get.width*0.85,
                                decoration: BoxDecoration(
                                  // color: App.grey,
                                  // border: Border.all(color: App.primary),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    productDetailsController.veiwMore.value
                                        ?App_Localization.of(context).translate("view_less")
                                        :App_Localization.of(context).translate("view_more"),
                                    style: TextStyle(color: App.primary,fontWeight: FontWeight.bold,fontSize: 16),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        _rateReview(context),
                      ],
                    ),
                  ),
                  productDetailsController.product!.rateReview.isEmpty
                      ?SizedBox(height: 70,)
                      :Container(
                    width: Get.width,
                    padding: EdgeInsets.only(top: 20,bottom: 70),
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: productDetailsController.product!.rateReview.length,
                        itemBuilder: (context,index){
                          return Center(
                            child: Container(
                                width: Get.width*0.9,
                                // height: 60,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Obx(() => productDetailsController.reviewLoading.value
                                    ?App.shimmerLoading()
                                    :Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: productDetailsController.product!.rateReview[index].review.isEmpty
                                      ?CrossAxisAlignment.center
                                      :CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),
                                      child: CircleAvatar(
                                          backgroundColor: App.primary,
                                          radius: 45/2,
                                          child: productDetailsController.product!.rateReview[index].image == null
                                              || productDetailsController.product!.rateReview[index].image!.isEmpty
                                              ?Icon(Icons.person,size: 30,):
                                          Container(
                                            width: 45,
                                            height: 45,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(image: NetworkImage(Api.media_url+productDetailsController.product!.rateReview[index].image!),fit: BoxFit.cover)
                                            ),
                                          )
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Container(
                                        width: Get.width*0.9-70,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(productDetailsController.product!.rateReview[index].name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                                productDetailsController.product!.rateReview[index].rate>0?RatingBar.builder(
                                                  initialRating: productDetailsController.product!.rateReview[index].rate,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemSize: 15,
                                                  ignoreGestures: true,
                                                  itemPadding: EdgeInsets.zero,
                                                  itemBuilder: (context, _) => Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  onRatingUpdate: (rating) {
                                                    print(rating);
                                                  },
                                                ):Center(),
                                              ],
                                            ),
                                            productDetailsController.product!.rateReview[index].review.isEmpty
                                                ?Center()
                                                :Text(productDetailsController.product!.rateReview[index].review,style: TextStyle(fontSize: 12,color: App.grey95,overflow: TextOverflow.ellipsis),maxLines: 20,),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),)
                            ),
                          );
                        }),
                  ),


                ],
              ),
            ),
          ),
          productDetailsController.loading.value?Center():
          Positioned(bottom:0,
            child: Column(
              children: [
                Container(
                  width: Get.width,
                  height: 60,
                  decoration: BoxDecoration(
                      color: App.greyFE,
                      // color: Colors.red,
                      boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 9,
                        spreadRadius: 2,
                        offset: Offset(0,-2)
                      )
                    ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 120,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffE7E8EA),

                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: GestureDetector(
                                    onTap: (){
                                      if(productDetailsController.cartCounter.value > 1){
                                        productDetailsController.cartCounter.value -- ;
                                      }
                                    },
                                    child:Text("-",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                              ),
                              Text(productDetailsController.cartCounter.toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: GestureDetector(
                                  onTap: (){
                                    if(productDetailsController.product!.option!.stock >  productDetailsController.cartCounter.value){
                                      productDetailsController.cartCounter.value ++ ;
                                    }
                                  },
                                  child: Text("+",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                ),
                              )
                            ],
                          ),
                        ),
                        productDetailsController.cartLoading.value?
                        _cartBtnLoading()
                            :productDetailsController.product!.option !=null
                            &&productDetailsController.product!.option!.stock ==0?
                        PrimaryBottun(
                          width: Get.width*0.5,
                          height: 40,
                          onPressed: ()async{
                            // print(_key.currentContext!.size!.height);
                            // productDetailsController.cartLoading.value = true;
                            // await cartController.addToCart(context, productDetailsController.product!.option!.id, productDetailsController.cartCounter.value);
                            // productDetailsController.cartLoading.value = false;
                          },
                          color: Colors.red,
                          text: "out_of_stock",
                          radiuce: 5,
                          fontSize: 14,
                          // linearGradient: App.linearGradient,
                        )
                            :PrimaryBottun(
                          width: Get.width*0.5,
                          height: 40,
                          onPressed: ()async{
                            // print(_key.currentContext!.size!.height);
                            productDetailsController.cartLoading.value = true;
                            await cartController.addToCart(context, productDetailsController.product!.option!.id, productDetailsController.cartCounter.value);
                            productDetailsController.cartLoading.value = false;
                          },
                          color: App.primary,
                          text: "add_to_cart",
                          fontSize: 16,
                          radiuce: 5,
                          fontWeight: FontWeight.w500,
                          // linearGradient: App.linearGradient,
                        )
                      ],
                    ),
                  ),
                ),
                Platform.isAndroid?Center():Container(
                  width: Get.width,
                  height: 20,
                  color: Colors.white,
                )
              ],
            ),
          )
        ],
      )),
    ));
  }

  _slider(BuildContext context,String images){
    return Container(
      width: Get.width,
      height: Get.width*0.7,
      color: Colors.white,
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: Get.width*0.7,
              aspectRatio: 2/1,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,

              onPageChanged: (index,controller){
                productDetailsController.activeSlider.value = index;
              },
              scrollDirection: Axis.horizontal,
            ),
            items: images.split(",").map((elm) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: Get.width*0.6,
                    height: Get.width*0.6,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        image: DecorationImage(
                            image: NetworkImage(Api.media_url+elm),
                            fit: BoxFit.contain
                        )
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Positioned(
              bottom: 0,
              child:  Container(
                width: Get.width,
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListView.builder(
                        itemCount: images.split(",").length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context,index){
                          return Obx(() => Center(
                            child:Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.5),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                height: 6,
                                width: productDetailsController.activeSlider.value==index?20:6,
                                decoration: BoxDecoration(
                                    color: productDetailsController.activeSlider.value==index?App.primary:App.primary.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(3)
                                  // shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ));
                        })
                  ],
                ),
              )),
          Positioned(
            top: 15,
            
            child:Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back_ios,color: App.primary,size: 22,),
                  ),
                  GestureDetector(
                    onTap: () {
                      wishlistController.wishlistFunction(context, productDetailsController.product!);
                    },
                    child: Obx(() => Icon(productDetailsController.product!.wishlist.value>0?Icons.favorite:Icons.favorite_border,color: App.primary,size: 22)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  _colorsList(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8,),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
          child: Text(App_Localization.of(context).translate("colors"),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
        ),
        Container(
          width: Get.width,
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: productDetailsController.product!.colors.length,
              itemBuilder: (context , index){
            return Center(
              child: GestureDetector(
                onTap: (){
                  productDetailsController.selectColor(productDetailsController.product!.colors[index].id);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: App.greyF5,
                        border: Border.all(color: productDetailsController.product!.colors[index].selected.value ?App.primary:Colors.grey),
                        image: DecorationImage(
                            image: NetworkImage(Api.media_url + productDetailsController.product!.colors[index].image),
                            fit: BoxFit.contain
                        ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
  _ramsList(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8,),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
          child: Text(App_Localization.of(context).translate("rams"),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
        ),
        Container(
          width: Get.width ,
          height: 30,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: productDetailsController.product!.rams.length,
              itemBuilder: (context , index){
                return Center(
                  child: GestureDetector(
                    onTap: (){
                      productDetailsController.selectRam(productDetailsController.product!.rams[index].ram);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Container(
                        // width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: productDetailsController.product!.rams[index].selected.value ?Colors.black:Colors.white,
                          border: Border.all(color: productDetailsController.product!.rams[index].selected.value ?Colors.white:Colors.black),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                            child: Text(productDetailsController.product!.rams[index].ram,style: TextStyle(fontSize: 12,color: productDetailsController.product!.rams[index].selected.value ?Colors.white:Colors.black),),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
  _hardsList(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8,),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
          child: Text(App_Localization.of(context).translate("hards"),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
        ),
        Container(
          width: Get.width,
          height: 30,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: productDetailsController.product!.hards.length,
              itemBuilder: (context , index){
                return Center(
                  child: GestureDetector(
                    onTap: (){
                      productDetailsController.selectHard(productDetailsController.product!.hards[index].hard);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Container(
                        // width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                            color: productDetailsController.product!.hards[index].selected.value ?Colors.black:Colors.white,
                          border: Border.all(color: productDetailsController.product!.hards[index].selected.value ?Colors.white:Colors.black),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                            child: Text(productDetailsController.product!.hards[index].hard,style: TextStyle(fontSize: 12,color: productDetailsController.product!.hards[index].selected.value ?Colors.white:Colors.black),),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
  _additionalOptionList(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8,),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
          child: Text(App_Localization.of(context).translate("additional_option"),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
        ),
        Container(
          width: Get.width,
          height: 30,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: productDetailsController.product!.additionatlOptions.length,
              itemBuilder: (context , index){
                return Center(
                  child: GestureDetector(
                    onTap: (){
                      productDetailsController.selectAdditionalOption(productDetailsController.product!.additionatlOptions[index].additionatlOption);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Container(
                        // width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: productDetailsController.product!.additionatlOptions[index].selected.value ?Colors.black:Colors.white,
                          border: Border.all(color: productDetailsController.product!.additionatlOptions[index].selected.value ?Colors.white:Colors.black),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                            child: Text(productDetailsController.product!.additionatlOptions[index].additionatlOption,style: TextStyle(fontSize: 12,color: productDetailsController.product!.additionatlOptions[index].selected.value ?Colors.white:Colors.black),),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
  _rateReview(BuildContext context){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8,),
          productDetailsController.product!.checkout==0?Center():Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(App_Localization.of(context).translate("rate"),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
          ),
          productDetailsController.product!.checkout==0?Center():
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RatingBar.builder(
                initialRating: productDetailsController.product!.myRate,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 18,

                itemBuilder: (context, _) => Padding(padding: EdgeInsets.only(right: Global.locale=="en"?3:0,left: Global.locale=="ar"?3:0),child:Icon(
                  Icons.star,
                  color: Colors.amber,
                )),
                onRatingUpdate: (rating) async{
                  print(rating);
                  await Api.hasInternet();
                  var succ = await Api.addRate(rating, productDetailsController.product!.languageParent);
                  if(succ){
                    productDetailsController.product!.myRate = rating;
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 8,),
          productDetailsController.product!.rateReview.isNotEmpty||productDetailsController.product!.checkout!=0?Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(App_Localization.of(context).translate("review"),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
          ):Center(),
          productDetailsController.product!.checkout==0?Center():
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 37,
                width: Get.width - 30 - 50,
                decoration: BoxDecoration(
                  color: Color(0xffece9e9),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: TextField(
                  controller: productDetailsController.review,
                  textAlignVertical: TextAlignVertical.bottom,
                  style: TextStyle(fontSize: 12,height: 1),
                  decoration: InputDecoration(
                    hintText: App_Localization.of(context).translate("write_you_comment"),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5)
                    ),
                  ),
                ),
              ),
              Container(
                height: 37,
                width: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        productDetailsController.addReview(context);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: App.primary,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Center(
                          child: CircleAvatar(
                            radius: 13,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.check,color: App.primary,size: 17,),
                          ),
                        )
                      ),
                    )
                  ],
                )
              )
            ],
          ),
          SizedBox(height: 10,),

        ],
      ),
    );
  }

  _cartBtnLoading(){
    return Container(
      width: Get.width*0.4,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        // gradient: App.linearGradient,
        color: App.primary
      ),
      child: App.shimmerLoading(radius: 5)
    );
  }
}
 
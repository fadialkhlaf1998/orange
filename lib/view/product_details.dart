import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/cart_controller.dart';
import 'package:orange/controller/product_details_controller.dart';
import 'package:orange/controller/wishlist_controller.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/widgets/primary_bottun.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetails extends StatelessWidget {

  ProductDetailsController productDetailsController = Get.put(ProductDetailsController());
  WishlistController wishlistController = Get.find();
  CartController cartController = Get.find();

  ProductDetails(String slug){
    productDetailsController.getData(slug);
  }


  GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      // backgroundColor: App.primary_mid,
      appBar: AppBar(
        title: Text(productDetailsController.title.value,
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
      body: Stack(
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
              child: Column(
                children: [
                  _slider(context,
                      productDetailsController.product!.option !=null
                          && productDetailsController.product!.option!.images.length > 0
                          ?productDetailsController.product!.option!.images:productDetailsController.product!.images
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: Get.width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(productDetailsController.product!.title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Container(
                                width: Get.width*0.5-10,
                                child: App.price(context,
                                    productDetailsController.product!.oldPrice!=null?
                                    productDetailsController.product!.oldPrice!+productDetailsController.product!.option!.addetionalPrice
                                        :productDetailsController.product!.oldPrice, productDetailsController.product!.price+productDetailsController.product!.option!.addetionalPrice,space: false),
                              ),
                              Container(
                                  width: Get.width*0.5-10,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      width: 60,
                                      decoration: BoxDecoration(
                                          color: App.primary,
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 2),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.star,color: Colors.white,),
                                            Text(productDetailsController.product!.rate.toStringAsFixed(1),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),)
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
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
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(App_Localization.of(context).translate("description"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          ),
                          AnimatedContainer(
                            key: _key,
                            duration: Duration(milliseconds: 700),
                            height:
                            productDetailsController.veiwMore.value
                                ?null
                                :Get.width* 0.5 ,
                            child: Html(data: productDetailsController.product!.description,),
                          ),
                          //todo check height of description _key.currentContext!.size.height
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  productDetailsController.veiwMore.value
                                  = !productDetailsController.veiwMore.value;
                                },
                                child: Container(
                                  width: Get.width*0.4,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: App.primary),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Center(
                                    child: Text(
                                      productDetailsController.veiwMore.value
                                          ?App_Localization.of(context).translate("view_less")
                                          :App_Localization.of(context).translate("view_more"),
                                      style: TextStyle(color: App.primary,fontWeight: FontWeight.bold,fontSize: 18),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          _rateReview(context),


                          SizedBox(height: 100,)
                        ],
                      ),
                    ),
                  )

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
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: Get.width*0.4,
                        height: 50,
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
                                  if(productDetailsController.cartCounter.value > 1){
                                    productDetailsController.cartCounter.value -- ;
                                  }
                                },
                                child: Icon(Icons.exposure_minus_1,color: Colors.black,)),
                            Text(productDetailsController.cartCounter.toString(),style: TextStyle(color: App.primary,fontWeight: FontWeight.bold,fontSize: 25),),
                            GestureDetector(
                                onTap: (){
                                  if(productDetailsController.product!.option!.stock >  productDetailsController.cartCounter.value){
                                    productDetailsController.cartCounter.value ++ ;
                                  }
                                },
                                child: Icon(Icons.exposure_plus_1,color: Colors.black)),
                          ],
                        ),
                      ),
                      productDetailsController.cartLoading.value?
                      _cartBtnLoading()
                          :PrimaryBottun(
                          width: Get.width*0.4,
                          height: 50,
                          onPressed: ()async{
                            // print(_key.currentContext!.size!.height);
                            productDetailsController.cartLoading.value = true;
                            await cartController.addToCart(context, productDetailsController.product!.option!.id, productDetailsController.cartCounter.value);
                            productDetailsController.cartLoading.value = false;
                          },
                          color: App.primary,
                          text: "add_to_cart",
                          linearGradient: App.linearGradient,
                      )
                    ],
                  ),
                ),
                SizedBox(height: Get.bottomBarHeight,)
              ],
            ),
          )
        ],
      ),
    ));
  }

  _slider(BuildContext context,String images){
    return Container(
      width: Get.width,
      height: Get.width*0.7,

      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          App.darkBottomShadow
        ],
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25))
      ),
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
                    width: Get.width*0.9,
                    height: Get.width*0.45,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
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
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 10),
                            child: Obx(() => Center(
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                height: 5,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: productDetailsController.activeSlider.value==index?App.primary:Colors.grey,
                                    borderRadius: BorderRadius.circular(2.5)
                                  // shape: BoxShape.circle,
                                ),
                              ),
                            )),
                          );
                        })
                  ],
                ),
              )),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                wishlistController.wishlistFunction(context, productDetailsController.product!);
              },
              child: Obx(() => Icon(productDetailsController.product!.wishlist.value>0?Icons.favorite:Icons.favorite_border,color: App.primary)),
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
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(App_Localization.of(context).translate("colors"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
        ),
        Container(
          width: Get.width - 20,
          height: 120,
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
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
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
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(App_Localization.of(context).translate("rams"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
        ),
        Container(
          width: Get.width - 20,
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
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        // width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(color: productDetailsController.product!.rams[index].selected.value ?App.primary:Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                            child: Text(productDetailsController.product!.rams[index].ram,),
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
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(App_Localization.of(context).translate("hards"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
        ),
        Container(
          width: Get.width - 20,
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
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        // width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(color: productDetailsController.product!.hards[index].selected.value ?App.primary:Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                            child: Text(productDetailsController.product!.hards[index].hard,),
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
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(App_Localization.of(context).translate("additional_option"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
        ),
        Container(
          width: Get.width - 20,
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
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        // width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(color: productDetailsController.product!.additionatlOptions[index].selected.value ?App.primary:Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                            child: Text(productDetailsController.product!.additionatlOptions[index].additionatlOption,),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        productDetailsController.product!.checkout==0?Center():Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(App_Localization.of(context).translate("rate"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
        ),
        productDetailsController.product!.checkout==0?Center():
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RatingBar.builder(
              initialRating: productDetailsController.product!.myRate,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) async{
                print(rating);
                var succ = await Api.addRate(rating, productDetailsController.product!.languageParent);
                if(succ){
                  productDetailsController.product!.myRate = rating;
                }
              },
            ),
          ],
        ),

        productDetailsController.product!.rateReview.isNotEmpty||productDetailsController.product!.checkout!=0?Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(App_Localization.of(context).translate("review"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
        ):Center(),
        productDetailsController.product!.checkout==0?Center():
        Row(
          children: [
            Container(
              height: 55,
              width: Get.width - 20 - 100,
              child: TextField(
                controller: productDetailsController.review,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                productDetailsController.addReview(context);
              },
              child: Container(
                height: 55,
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Post",style: TextStyle(color: App.primary,fontWeight: FontWeight.bold),),
                      Text("Review",style: TextStyle(color: App.primary,fontWeight: FontWeight.bold),),
                    ],
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 10,),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: productDetailsController.product!.rateReview.length,
            itemBuilder: (context,index){
          return Center(
            child: Container(
              width: Get.width*0.8,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 2,
                    spreadRadius: 2,
                  ),
                ]
              ),
              child: Obx(() => productDetailsController.reviewLoading.value
                  ?App.shimmerLoading()
                  :Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: CircleAvatar(
                        backgroundColor: App.primary,
                        radius: 25,
                        child: productDetailsController.product!.rateReview[index].image == null
                            || productDetailsController.product!.rateReview[index].image!.isEmpty
                            ?Icon(Icons.person,size: 30,):
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: NetworkImage(Api.media_url+productDetailsController.product!.rateReview[index].image!))
                          ),
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5,top: 5,bottom: 5),
                    child: Container(
                      width: Get.width*0.8-70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(productDetailsController.product!.rateReview[index].name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              RatingBar.builder(
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
                              ),
                            ],
                          ),
                          productDetailsController.product!.rateReview[index].review.isEmpty
                              ?Center()
                              :Text(productDetailsController.product!.rateReview[index].review,style: TextStyle(fontSize: 13,overflow: TextOverflow.ellipsis),maxLines: 2,),
                        ],
                      ),
                    ),
                  )
                ],
              ),)
            ),
          );
        })
      ],
    );
  }

  _cartBtnLoading(){
    return Container(
      width: Get.width*0.4,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: App.linearGradient,
      ),
      child: App.shimmerLoading(radius: 10)
    );
  }
}
 
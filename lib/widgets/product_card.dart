import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/wishlist_controller.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/model/product.dart';
import 'package:orange/view/product_details.dart';

class ProductCard extends StatelessWidget {

  final Product product;
  final bool withOptions;


  ProductCard(this.product,this.withOptions);

  WishlistController wishlistController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to((()=>ProductDetails(product.ProductSlug,product.selected_option_id)));
      },
      child: Padding(

          padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                    decoration: BoxDecoration(
                      color: App.greyF5,
                      image: DecorationImage(
                        image: NetworkImage(Api.media_url+(product.color_image.isNotEmpty?product.color_image:product.image)),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(15),

                    ),
                  ),),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(product.title,maxLines: 1,
                            style: const TextStyle(fontSize: 13,height: 1,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,),
                          ),

                         SizedBox(
                           height: this.withOptions?null:0,
                           child:  Text(
                               product.color_name +(product.color_name.isNotEmpty?" ":"")+
                                   product.hard + (product.hard.isNotEmpty?" ":"")+
                                   product.ram + (product.ram.isNotEmpty?" ":"")+
                                   product.additionatl_option,style: TextStyle(color: App.grey95,fontSize: 12),overflow: TextOverflow.ellipsis,maxLines: 1),
                         ),
                          Text(App_Localization.of(context).translate("aed")+" "+(product.price+product.addetional_price).toStringAsFixed(2),maxLines: 2,
                            style: const TextStyle(fontSize: 13,height: 1,overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold,color: App.primary),
                          ),
                          (product.oldPrice!=null && product.oldPrice! > product.price)?Text(App_Localization.of(context).translate("aed")+" "+(product.oldPrice!+product.addetional_price).toStringAsFixed(2),maxLines: 2,
                            style: const TextStyle(fontSize: 11,height: 1,overflow: TextOverflow.ellipsis,fontWeight: FontWeight.w500,color: App.grey95,decoration: TextDecoration.lineThrough),
                          ):Center(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 38,
                                height: 20,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(product.rate.toStringAsFixed(1),style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: App.grey95),),
                                    SvgPicture.asset("assets/icons/fill/stare_gold.svg",width: 13,height: 13,)
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  wishlistController.wishlistFunction(context, product);
                                },
                                child: Obx(() => Icon(product.wishlist.value>0?Icons.favorite:Icons.favorite_border,color: App.primary)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
                left: 0,
                child: (product.oldPrice!=null && product.oldPrice! > product.price)?Container(
              width: 79,
              height: 65,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/images/green_triangle.png"),fit: BoxFit.fill),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: Global.locale == "en"
                  ?CrossAxisAlignment.start
                  :CrossAxisAlignment.end,
                  children: [
                    Text(App_Localization.of(context).translate("save_off"),style: TextStyle(fontSize: 8,color: Colors.white),),
                    Text((100 - (product.price * 100 / product.oldPrice!)).toStringAsFixed(0)+"%",style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),),
                  ],
                ),
              )
            ):Center())
          ],
        ),
      ),
    );
  }
}

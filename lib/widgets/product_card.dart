import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:orange/controller/wishlist_controller.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/model/product.dart';
import 'package:orange/view/product_details.dart';

class ProductCard extends StatelessWidget {

  final Product product;

  ProductCard(this.product);

  WishlistController wishlistController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to((()=>ProductDetails(product.ProductSlug)));
      },
      child: Padding(

          padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Stack(
          children: [
            Container(
              height: Get.width*0.6,
              // width: Get.width*0.45,
              decoration: BoxDecoration(
                  color: App.grey,
                  borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Container(
                    height: Get.width*0.45-16,
                    width: Get.width*0.45-16,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                        image: DecorationImage(
                          image: NetworkImage(Api.media_url+product.image),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(15),

                    ),
                  ),
                  Container(
                    height: Get.width*0.15,
                    width: Get.width*0.45,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(product.title,maxLines: 2,
                          style: const TextStyle(fontSize: 13,height: 1,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,),
                        ),
                        App.price(context,product.oldPrice,product.price),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.all(8),
                width: Get.width * 0.45-16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 35,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Color(0xff022B3A),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(product.rate.toStringAsFixed(1),style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.bold),),
                          SvgPicture.asset("assets/icons/fill/stare_gold.svg",width: 10,height: 10,)
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
              ),
            )
          ],
        ),
      ),
    );
  }
}

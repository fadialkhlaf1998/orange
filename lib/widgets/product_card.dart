import 'package:flutter/material.dart';
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
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                children: [
                  Container(
                    height: Get.width*0.45,
                    width: Get.width*0.45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                        image: DecorationImage(
                          image: NetworkImage(Api.media_url+product.image),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(15),bottomLeft: Radius.circular(15)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            offset: Offset(0, 5),
                            blurRadius: 3,
                            spreadRadius: 0,
                          )
                        ]
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
                          style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,),
                        ),
                        App.price(context,product.oldPrice,product.price),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  wishlistController.wishlistFunction(context, product);
                },
                child: Obx(() => Icon(product.wishlist.value>0?Icons.favorite:Icons.favorite_border,color: App.primary)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

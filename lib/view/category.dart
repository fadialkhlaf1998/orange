import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/category_controller.dart';
import 'package:orange/controller/home_controller.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/view/product_details.dart';
import 'package:orange/widgets/searchDelgate.dart';

class Category extends StatelessWidget {

  HomeController homeController = Get.find();
  CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: App.background,
      appBar:App.myHeader(context, height: 60, child: Center(
          child:  Container(
              width: Get.width*0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(App_Localization.of(context).translate("category"),style: TextStyle(color: App.primary,fontWeight: FontWeight.bold),),
                  GestureDetector(
                    onTap: (){
                      showSearch(context: context, delegate: SearchTextField());
                    },
                    child: SvgPicture.asset("assets/icons/stroke/search.svg",color: App.primary),
                  )
                ],
              )
          )
      ),),
      body: Obx(() => Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _category(context),
          SizedBox(height: 10,),
          Expanded(
            child: Container(
              width: Get.width,
              child: Row(
                children: [
                  Expanded(flex: 1,
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: App.grey,
                          ),
                          child:  categoryController.subCategory.isEmpty
                              ?Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                                child: App.noResult(context),
                              )
                              :ListView.builder(
                              itemCount: categoryController.subCategory.length,
                              itemBuilder: (context,index){
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: GestureDetector(
                                    onTap: (){
                                      categoryController.selectProduct(index);
                                    },
                                    child: Container(
                                      width: Get.width*0.2,
                                      height: Get.width*0.2 + 30,
                                      margin: EdgeInsets.symmetric(horizontal: 10),

                                      child: Column(
                                        children: [
                                          Container(
                                            width: Get.width*0.2,
                                            height: Get.width*0.2,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(color: categoryController.selectedSubCategory.value == index ?App.primary:Colors.transparent),
                                                // color: Colors.white,
                                                image: DecorationImage(
                                                    image: NetworkImage(Api.media_url+categoryController.subCategory[index].image),
                                                  fit: BoxFit.fill
                                                )
                                            ),
                                          ),
                                          Container(
                                            width: Get.width*0.2 ,
                                            height: 30,
                                            // color: Colors.red,
                                            child: Center(child: Text(
                                              categoryController.subCategory[index].title,
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: categoryController.selectedSubCategory.value == index?App.primary:Colors.black,
                                              ),
                                            )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                        categoryController.subCategoryLoading.value?
                            Container(color: Colors.white.withOpacity(0.5),child: App.loading(context)):Center()
                      ],
                    ),
                  ),
                  Expanded(flex: 3,child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: categoryController.products.isEmpty
                        ?App.noResult(context)
                        :GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 8,
                            childAspectRatio: 4/6
                          ),
                            itemCount: categoryController.products.length,
                            itemBuilder: (context,index){
                              return GestureDetector(
                                onTap: (){
                                  Get.to((()=>ProductDetails(categoryController.products[index].ProductSlug)));
                                },
                                child: Container(
                                  width: Get.width/4 - 20,
                                  height: Get.width*0.35,
                                  margin: EdgeInsets.symmetric(horizontal: 10),

                                  child: Column(
                                    children: [
                                      Container(
                                        width:  Get.width*0.25,
                                        height: Get.width*0.25,
                                        decoration: BoxDecoration(
                                          color: App.grey,
                                          borderRadius: BorderRadius.circular(15)
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Container(


                                              decoration: BoxDecoration(
                                                  color: App.background,
                                                  borderRadius: BorderRadius.circular(15),
                                                  image: DecorationImage(
                                                      image: NetworkImage(Api.media_url+categoryController.products[index].image),
                                                      fit: BoxFit.cover
                                                  )
                                              ),
                                            ),
                                          )
                                        ),
                                      ),
                                      Container(
                                        width: Get.width*0.25 ,
                                        height: Get.width*0.1,
                                        child: Center(child: Text(
                                          categoryController.products[index].title,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold
                                          ),
                                        )),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      categoryController.productLoading.value?
                      Container(color: Colors.white.withOpacity(0.5),child: App.loading(context)):Center()
                    ],
                  )),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
  _category(BuildContext context){
    return Container(
      width: Get.width * 0.9,
      height: 30,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: homeController.categories.length,
          itemBuilder: (context,index){
            return GestureDetector(
              onTap: (){
                  categoryController.selectSubCategory(homeController.categories[index].categorySlug, index);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: 30,
                margin: EdgeInsets.only(left: index==0?0:8),
                decoration: BoxDecoration(
                    border: Border.all(color: categoryController.selectedCategory==index?App.primary:App.dark_grey),
                    color: categoryController.selectedCategory==index?App.primary:Colors.transparent,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(homeController.categories[index].title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: categoryController.selectedCategory==index?Colors.white:Colors.black),maxLines: 1,),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

import 'package:flutter/material.dart';
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
      // backgroundColor: App.primary_mid,
      appBar: AppBar(
        title: Text(App_Localization.of(context).translate("category"),
          style: TextStyle(
            fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        leading: App.backBtn(context),
        actions: [
          IconButton(onPressed: (){
            showSearch(context: context, delegate: SearchTextField());
          }, icon: Icon(Icons.search,color: Colors.white))
        ],
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
      body: Obx(() => Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
          _category(context),
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
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(3,3)
                              ),
                            ]
                          ),
                          child:  categoryController.subCategory.isEmpty
                              ?Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                                child: App.noResult(context),
                              )
                              :ListView.builder(
                              itemCount: categoryController.subCategory.length,
                              itemBuilder: (context,index){
                                return GestureDetector(
                                  onTap: (){
                                    categoryController.selectProduct(index);
                                  },
                                  child: Container(
                                    width: Get.width*0.25,
                                    height: Get.width*0.35,
                                    margin: EdgeInsets.symmetric(horizontal: 10),

                                    child: Column(
                                      children: [
                                        Container(
                                          width: Get.width*0.25,
                                          height: Get.width*0.25,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: categoryController.selectedSubCategory.value == index ?App.primary:Colors.transparent),
                                              image: DecorationImage(
                                                  image: NetworkImage(Api.media_url+categoryController.subCategory[index].image),
                                                fit: BoxFit.contain
                                              )
                                          ),
                                        ),
                                        Container(
                                          width: Get.width*0.25 ,
                                          height: Get.width*0.1,
                                          child: Center(child: Text(
                                            categoryController.subCategory[index].title,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: categoryController.selectedSubCategory.value == index?App.primary:Colors.black,

                                            ),
                                          )),
                                        )
                                      ],
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
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 4/6
                          ),
                            itemCount: categoryController.products.length,
                            itemBuilder: (context,index){
                              return GestureDetector(
                                onTap: (){
                                  Get.to((()=>ProductDetails(categoryController.products[index].ProductSlug)));
                                },
                                child: Container(
                                  width: Get.width*0.25,
                                  height: Get.width*0.35,
                                  margin: EdgeInsets.symmetric(horizontal: 10),

                                  child: Column(
                                    children: [
                                      Container(
                                        width: Get.width*0.25,
                                        height: Get.width*0.25,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(Api.media_url+categoryController.products[index].image),
                                                fit: BoxFit.contain
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
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: categoryController.selectedCategory==index?App.primary:Colors.transparent,width: 2)
                    )
                ),
                child: Column(
                  children: [
                    Text(homeController.categories[index].title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),maxLines: 1,),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

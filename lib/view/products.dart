import 'dart:io';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/home_controller.dart';
import 'package:orange/controller/products_controller.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/view/main.dart';
import 'package:orange/widgets/logo.dart';
import 'package:orange/widgets/product_card.dart';
import 'package:orange/widgets/searchDelgate.dart';

class Products extends StatelessWidget {
  String title;

  List<String> categories;
  List<String> brands;
  List<String> sub_categories;
  List<String> products;
  int? sort;
  int? lazy_load;
  int? limit;
  double? min_price;
  double? max_price;
  String option;

  ProductsController productsController = Get.put(ProductsController());
  HomeController homeController = Get.find();

  Products(
      {required this.title,
      this.categories = const [],
      this.brands = const [],
      this.sub_categories = const [],
      this.products = const [],
      this.sort = null,
      this.lazy_load = 0,
      this.min_price = null,
      this.max_price = null,
      this.limit = null,
      this.option = "and"}) {
    productsController.getData(categories, brands, sub_categories, products,
        sort, lazy_load, limit, option, min_price, max_price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: App.background,
      appBar: App.myHeader(
        context,
        height: 60,
        child: Center(
            child: Container(
                width: Get.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(Icons.arrow_back_ios,
                              color: App.primary, size: 20),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        showSearch(
                            context: context, delegate: SearchTextField());
                      },
                      child: Icon(Icons.search),
                    ),
                  ],
                ))),
      ),
      body: Obx(() => Column(
            children: [
              Expanded(
                  child: productsController.loading.value
                      ? App.loading(context)
                      :  Stack(
                              children: [
                                productsController.filterResult == null ||
                                    productsController.filterResult!.products.isEmpty
                                    ? App.noResult(context)
                                    :
                                LazyLoadScrollView(
                                  isLoading:
                                      productsController.lazyLoading.value,
                                  onEndOfPage: () =>
                                      productsController.loadMore(),
                                  child: Scrollbar(
                                    child: ListView(
                                      physics: BouncingScrollPhysics(),
                                      children: [
                                        GridView.builder(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  Get.width > 600 ? 3 : 2,
                                              childAspectRatio: 0.6,
                                              mainAxisSpacing: 0,
                                              crossAxisSpacing: 0,
                                            ),
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: productsController
                                                .filterResult!.products.length,
                                            itemBuilder: (context, index) {
                                              return ProductCard(
                                                  productsController
                                                      .filterResult!
                                                      .products[index],true);
                                            }),
                                        productsController.lazyLoading.value
                                            ? Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15),
                                                child: App.loading(context),
                                              )
                                            : Center()
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                    left: Get.width / 2 - 75,
                                    bottom: 20,
                                    child: Container(
                                      width: 150,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          color: App.primary,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              sortBottomSheet(context);
                                            },
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/icons/sort.svg",
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  App_Localization.of(context)
                                                      .translate("sort"),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 1.5,
                                            height: 25,
                                            color: Colors.white,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              filterSortBottomSheet(context);
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  App_Localization.of(context)
                                                      .translate("filter"),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                SvgPicture.asset(
                                                  "assets/icons/filter.svg",
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            ))
            ],
          )),
    );
  }

  filterSortBottomSheet(BuildContext context) {
    if (productsController.filterResult == null) {
      return;
    }
    showMaterialModalBottomSheet(
      useRootNavigator: true,
      context: context,
      // shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(15),
      //       topRight: Radius.circular(15),
      //     )
      // ),
      builder: (context) => SafeArea(
        child: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
              // gradient: App.linearGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: Colors.white),
          child: _filterList(context),
        ),
      ),
    );
  }

  sortBottomSheet(BuildContext context) {
    if (productsController.filterResult == null) {
      return;
    }
    showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Stack(
        children: [
          SizedBox(
            height: 250 + 27 / 2,
            width: 2,
          ),
          Positioned(
            top: 27 / 2,
            child: Container(
              width: Get.width,
              height: 250,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
              child: Obx(() => Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            App_Localization.of(context).translate("sort"),
                            style: TextStyle(color: App.grey95),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 1,
                        width: Get.width * 0.95,
                        color: App.grey95.withOpacity(0.2),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      productsController.fake.value ? Center() : Center(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                productsController.filterResult!.filter.sort =
                                    null;
                                productsController.apply();
                                productsController.updateFake();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    App_Localization.of(context)
                                        .translate("newest"),
                                    style: TextStyle(
                                        fontWeight: productsController
                                                        .filterResult!
                                                        .filter
                                                        .sort !=
                                                    0 &&
                                                productsController.filterResult!
                                                        .filter.sort !=
                                                    1 &&
                                                productsController.filterResult!
                                                        .filter.sort !=
                                                    2
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: App.greyC5),
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: productsController
                                                            .filterResult!
                                                            .filter
                                                            .sort !=
                                                        0 &&
                                                    productsController
                                                            .filterResult!
                                                            .filter
                                                            .sort !=
                                                        1 &&
                                                    productsController
                                                            .filterResult!
                                                            .filter
                                                            .sort !=
                                                        2
                                                ? App.primary
                                                : Colors.transparent,
                                            shape: BoxShape.circle),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                productsController.filterResult!.filter.sort =
                                    2;
                                productsController.apply();
                                productsController.updateFake();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    App_Localization.of(context)
                                        .translate("top_rated"),
                                    style: TextStyle(
                                        fontWeight: productsController
                                                    .filterResult!
                                                    .filter
                                                    .sort ==
                                                2
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: App.greyC5),
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: productsController
                                                        .filterResult!
                                                        .filter
                                                        .sort ==
                                                    2
                                                ? App.primary
                                                : Colors.transparent,
                                            shape: BoxShape.circle),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                productsController.filterResult!.filter.sort =
                                    0;
                                productsController.apply();
                                productsController.updateFake();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    App_Localization.of(context)
                                        .translate("lower_price"),
                                    style: TextStyle(
                                        fontWeight: productsController
                                                    .filterResult!
                                                    .filter
                                                    .sort ==
                                                0
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: App.greyC5),
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: productsController
                                                        .filterResult!
                                                        .filter
                                                        .sort ==
                                                    0
                                                ? App.primary
                                                : Colors.transparent,
                                            shape: BoxShape.circle),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                productsController.filterResult!.filter.sort =
                                    1;
                                productsController.apply();
                                productsController.updateFake();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    App_Localization.of(context)
                                        .translate("higher_price"),
                                    style: TextStyle(
                                        fontWeight: productsController
                                                    .filterResult!
                                                    .filter
                                                    .sort ==
                                                1
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: App.greyC5),
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: productsController
                                                        .filterResult!
                                                        .filter
                                                        .sort ==
                                                    1
                                                ? App.primary
                                                : Colors.transparent,
                                            shape: BoxShape.circle),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          Positioned(
              top: 0,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  width: 27,
                  height: 27,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          spreadRadius: 0.5,
                          blurRadius: 1,
                        )
                      ]),
                  child: Center(
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 15,
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  _filterList(BuildContext context) {
    return Obx(() => Container(
          height: Get.height,
          color: Colors.white,
          child: Stack(
            children: [
             Container(
               height: Get.height - 50 ,
               child:  ListView(
                 physics: BouncingScrollPhysics(),
                 // padding: EdgeInsets.only(bottom: 60),
                 shrinkWrap: true,
                 children: [
                   productsController.fake.value ? Center() : Center(),
                   SizedBox(
                     height: 15,
                   ),
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 15),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Row(
                           children: [
                             Logo(30, false),
                             SizedBox(
                               width: 8,
                             ),
                             Text(
                               App_Localization.of(context).translate("filter"),
                               style: TextStyle(fontWeight: FontWeight.bold),
                             ),
                           ],
                         ),
                         GestureDetector(
                           onTap: () {
                             Get.back();
                           },
                           child: Text(
                             App_Localization.of(context).translate("cancel"),
                             style: TextStyle(color: App.grey95, fontSize: 12),
                           ),
                         )
                       ],
                     ),
                   ),
                   SizedBox(
                     height: 20,
                   ),
                   Padding(
                       padding: EdgeInsets.symmetric(horizontal: 15),
                       child: GestureDetector(
                         onTap: () {
                           productsController.openFilterCategory.value =
                           productsController.openFilterCategory.value == 0
                               ? 1
                               : 0;
                         },
                         child: Container(
                           height: 40,
                           decoration: BoxDecoration(
                               border: Border(
                                   bottom: BorderSide(
                                       color: App.greyC5.withOpacity(0.5)))),
                           child: Row(
                             children: [
                               Text(
                                 App_Localization.of(context)
                                     .translate("category"),
                                 style: TextStyle(
                                     fontSize: 14, fontWeight: FontWeight.bold),
                               ),
                               Spacer(),
                               Center(
                                 child: AnimatedSwitcher(
                                     duration: const Duration(milliseconds: 350),
                                     transitionBuilder: (child, anim) =>
                                         RotationTransition(
                                           turns: child.key == ValueKey('icon1')
                                               ? Tween<double>(begin: 1, end: 0)
                                               .animate(anim)
                                               : Tween<double>(begin: 0, end: 1)
                                               .animate(anim),
                                           child: ScaleTransition(
                                               scale: anim, child: child),
                                         ),
                                     child: productsController
                                         .openFilterCategory.value ==
                                         0
                                         ? Icon(Icons.keyboard_arrow_right,
                                         size: 25,
                                         color: App.grey95,
                                         key: const ValueKey('icon1'))
                                         : Icon(
                                       Icons.keyboard_arrow_down,
                                       size: 25,
                                       color: App.grey95,
                                       key: const ValueKey('icon2'),
                                     )),
                               ),
                             ],
                           ),
                         ),
                       )),
                   AnimatedSize(
                     duration: Duration(milliseconds: 350),
                     curve: Curves.ease,
                     child: productsController.openFilterCategory.value == 0
                         ? Center()
                         : ListView.builder(
                         physics: NeverScrollableScrollPhysics(),
                         itemCount: homeController.categories.length,
                         shrinkWrap: true,
                         itemBuilder: (context, index) {
                           return Container(
                             child: Padding(
                               padding: EdgeInsets.symmetric(horizontal: 20),
                               child: Column(
                                 children: [
                                   Row(
                                     mainAxisAlignment:
                                     MainAxisAlignment.spaceBetween,
                                     children: [
                                       GestureDetector(
                                         onTap: () {
                                           if (!homeController
                                               .categories[index]
                                               .isCheckedFilter(
                                               productsController
                                                   .filterResult!
                                                   .filter
                                                   .categories)) {
                                             productsController.addCategory(
                                                 homeController
                                                     .categories[index]
                                                     .categorySlug);
                                           } else {
                                             productsController
                                                 .removeCategory(
                                                 homeController
                                                     .categories[index]
                                                     .categorySlug,
                                                 homeController
                                                     .categories[index]);
                                           }
                                         },
                                         child: Row(
                                           children: [
                                             Container(
                                               height: 15,
                                               width: 15,
                                               decoration: BoxDecoration(
                                                   border: Border.all(
                                                       color: App.greyC5)),
                                               child: Center(
                                                 child: homeController
                                                     .categories[index]
                                                     .isCheckedFilter(
                                                     productsController
                                                         .filterResult!
                                                         .filter
                                                         .categories)
                                                     ? Text(
                                                   "-",
                                                   style: TextStyle(
                                                       color:
                                                       App.primary,
                                                       fontSize: 10,
                                                       fontWeight:
                                                       FontWeight
                                                           .bold),
                                                 )
                                                     : Text(
                                                   "+",
                                                   style: TextStyle(
                                                       color:
                                                       App.primary,
                                                       fontSize: 10,
                                                       fontWeight:
                                                       FontWeight
                                                           .bold),
                                                 ),
                                               ),
                                             ),
                                             SizedBox(
                                               width: 10,
                                             ),
                                             Text(homeController
                                                 .categories[index].title),
                                           ],
                                         ),
                                       ),
                                       Transform.scale(
                                         scale: 0.75,
                                         child: Checkbox(
                                             value: homeController
                                                 .categories[index]
                                                 .isCheckedFilter(
                                                 productsController
                                                     .filterResult!
                                                     .filter
                                                     .categories),
                                             onChanged: (value) {
                                               if (value!) {
                                                 productsController
                                                     .addCategory(
                                                     homeController
                                                         .categories[
                                                     index]
                                                         .categorySlug);
                                               } else {
                                                 productsController
                                                     .removeCategory(
                                                     homeController
                                                         .categories[
                                                     index]
                                                         .categorySlug,
                                                     homeController
                                                         .categories[
                                                     index]);
                                               }
                                             }),
                                       )
                                     ],
                                   ),
                                   AnimatedSize(
                                     duration: Duration(milliseconds: 350),
                                     curve: Curves.ease,
                                     child: homeController.categories[index]
                                         .isCheckedFilter(
                                         productsController
                                             .filterResult!
                                             .filter
                                             .categories)
                                         ? ListView.builder(
                                         physics:
                                         NeverScrollableScrollPhysics(),
                                         itemCount: homeController
                                             .categories[index]
                                             .subCategories
                                             .length,
                                         shrinkWrap: true,
                                         itemBuilder:
                                             (context, subIndex) {
                                           return Container(
                                             child: Padding(
                                               padding:
                                               EdgeInsets.symmetric(
                                                   horizontal: 0,
                                                   vertical: 8),
                                               child: Row(
                                                 mainAxisAlignment:
                                                 MainAxisAlignment
                                                     .spaceBetween,
                                                 children: [
                                                   GestureDetector(
                                                     onTap: () {
                                                       if (!homeController
                                                           .categories[
                                                       index]
                                                           .subCategories[
                                                       subIndex]
                                                           .isCheckedFilter(
                                                           productsController
                                                               .filterResult!
                                                               .filter
                                                               .subCategories)) {
                                                         productsController.addSubCategory(homeController
                                                             .categories[
                                                         index]
                                                             .subCategories[
                                                         subIndex]
                                                             .subCategorySlug);
                                                       } else {
                                                         productsController.removeSubCategory(homeController
                                                             .categories[
                                                         index]
                                                             .subCategories[
                                                         subIndex]
                                                             .subCategorySlug);
                                                       }
                                                     },
                                                     child: Row(
                                                       children: [
                                                         Container(
                                                           height: 15,
                                                           width: 15,
                                                         ),
                                                         SizedBox(
                                                           width: 10,
                                                         ),
                                                         Container(
                                                           height: 14,
                                                           width: 14,
                                                           decoration: BoxDecoration(
                                                               border: Border.all(
                                                                   color: App
                                                                       .greyC5),
                                                               shape: BoxShape
                                                                   .circle),
                                                           child:
                                                           Padding(
                                                             padding:
                                                             EdgeInsets
                                                                 .all(2),
                                                             child:
                                                             Container(
                                                               decoration: BoxDecoration(
                                                                   color: homeController.categories[index].subCategories[subIndex].isCheckedFilter(productsController.filterResult!.filter.subCategories)
                                                                       ? App.primary
                                                                       : Colors.transparent,
                                                                   shape: BoxShape.circle),
                                                             ),
                                                           ),
                                                         ),
                                                         SizedBox(
                                                           width: 10,
                                                         ),
                                                         Text(
                                                           homeController
                                                               .categories[
                                                           index]
                                                               .subCategories[
                                                           subIndex]
                                                               .title,
                                                           style: TextStyle(
                                                               color: App
                                                                   .grey6b,
                                                               fontSize:
                                                               12),
                                                         ),
                                                       ],
                                                     ),
                                                   ),
                                                 ],
                                               ),
                                             ),
                                           );
                                         })
                                         : Center(),
                                   )
                                 ],
                               ),
                             ),
                           );
                         }),
                   ),
                   SizedBox(
                     height: 20,
                   ),
                   Padding(
                       padding: EdgeInsets.symmetric(horizontal: 15),
                       child: GestureDetector(
                         onTap: () {
                           productsController.openFilterBrand.value =
                           productsController.openFilterBrand.value == 0
                               ? 1
                               : 0;
                         },
                         child: Container(
                           height: 40,
                           decoration: BoxDecoration(
                               border: Border(
                                   bottom: BorderSide(
                                       color: App.greyC5.withOpacity(0.5)))),
                           child: Row(
                             children: [
                               Text(
                                 App_Localization.of(context)
                                     .translate("brands"),
                                 style: TextStyle(
                                     fontSize: 14, fontWeight: FontWeight.bold),
                               ),
                               Spacer(),
                               Center(
                                 child: AnimatedSwitcher(
                                     duration: const Duration(milliseconds: 350),
                                     transitionBuilder: (child, anim) =>
                                         RotationTransition(
                                           turns: child.key == ValueKey('icon1')
                                               ? Tween<double>(begin: 1, end: 0)
                                               .animate(anim)
                                               : Tween<double>(begin: 0, end: 1)
                                               .animate(anim),
                                           child: ScaleTransition(
                                               scale: anim, child: child),
                                         ),
                                     child: productsController
                                         .openFilterBrand.value ==
                                         0
                                         ? Icon(Icons.keyboard_arrow_right,
                                         size: 25,
                                         color: App.grey95,
                                         key: const ValueKey('icon1'))
                                         : Icon(
                                       Icons.keyboard_arrow_down,
                                       size: 25,
                                       color: App.grey95,
                                       key: const ValueKey('icon2'),
                                     )),
                               ),
                             ],
                           ),
                         ),
                       )),
                   SizedBox(
                     height: 10,
                   ),
                   Padding(
                     padding: EdgeInsets.symmetric(horizontal: 15),
                     child: AnimatedSize(
                       duration: Duration(milliseconds: 350),
                       child: productsController.openFilterBrand.value == 0
                           ? Center()
                           : GridView.builder(
                           gridDelegate:
                           SliverGridDelegateWithFixedCrossAxisCount(
                               crossAxisCount: 5,
                               crossAxisSpacing: 8,
                               mainAxisSpacing: 8,
                               childAspectRatio: 1),
                           physics: NeverScrollableScrollPhysics(),
                           itemCount: homeController.brands.length,
                           shrinkWrap: true,
                           itemBuilder: (context, index) {
                             return Container(
                               child: Padding(
                                   padding: EdgeInsets.all(5),
                                   child: Stack(
                                     children: [
                                       Container(
                                         decoration: BoxDecoration(
                                             borderRadius:
                                             BorderRadius.circular(10),
                                             border: Border.all(
                                                 color: Colors.grey
                                                     .withOpacity(0.5)),
                                             color: Colors.white,
                                             image: DecorationImage(
                                                 image: NetworkImage(
                                                     Api.media_url +
                                                         homeController
                                                             .brands[index]
                                                             .image))),
                                       ),
                                       GestureDetector(
                                         onTap: () {
                                           if (homeController.brands[index]
                                               .isCheckedFilter(
                                               productsController
                                                   .filterResult!
                                                   .filter
                                                   .brands)) {
                                             productsController.removeBrand(
                                                 homeController.brands[index]
                                                     .brandSlug);
                                           } else {
                                             productsController.addBrand(
                                                 homeController.brands[index]
                                                     .brandSlug);
                                           }
                                         },
                                         child: AnimatedContainer(
                                           duration:
                                           Duration(milliseconds: 350),
                                           decoration: BoxDecoration(
                                             borderRadius:
                                             BorderRadius.circular(10),
                                             border: Border.all(
                                                 color: Colors.grey
                                                     .withOpacity(0.5)),
                                             // color: App.primary.withOpacity(0.5),
                                           ),
                                           child: Align(
                                               alignment: Alignment.topRight,
                                               child: Padding(
                                                 padding:
                                                 EdgeInsets.all(1.5),
                                                 child: Icon(
                                                     Icons.check_circle,
                                                     size: 15,
                                                     color: homeController
                                                         .brands[index]
                                                         .isCheckedFilter(
                                                         productsController
                                                             .filterResult!
                                                             .filter
                                                             .brands)
                                                         ? App.primary
                                                         : Colors
                                                         .transparent),
                                               )),
                                         ),
                                       )
                                     ],
                                   )),
                             );
                           }),
                     ),
                   ),
                   SizedBox(
                     height: 10,
                   ),
                   productsController.max != null && productsController.min != null?
                   Column(
                     children: [
                       Padding(
                           padding: EdgeInsets.symmetric(horizontal: 15),
                           child: GestureDetector(
                             onTap: () {
                               productsController.openFilterBrand.value =
                               productsController.openFilterBrand.value == 0
                                   ? 1
                                   : 0;
                             },
                             child: Container(
                               height: 40,
                               decoration: BoxDecoration(
                                   border: Border(
                                       bottom: BorderSide(
                                           color: App.greyC5.withOpacity(0.5)))),
                               child: Row(
                                 children: [
                                   Text(
                                     App_Localization.of(context).translate("price"),
                                     style: TextStyle(
                                         fontSize: 14, fontWeight: FontWeight.bold),
                                   ),
                                   Spacer(),
                                   Center(
                                     child: AnimatedSwitcher(
                                         duration: const Duration(milliseconds: 350),
                                         transitionBuilder: (child, anim) =>
                                             RotationTransition(
                                               turns: child.key == ValueKey('icon1')
                                                   ? Tween<double>(begin: 1, end: 0)
                                                   .animate(anim)
                                                   : Tween<double>(begin: 0, end: 1)
                                                   .animate(anim),
                                               child: ScaleTransition(
                                                   scale: anim, child: child),
                                             ),
                                         child: productsController
                                             .openFilterBrand.value ==
                                             0
                                             ? Icon(Icons.keyboard_arrow_right,
                                             size: 25,
                                             color: App.grey95,
                                             key: const ValueKey('icon1'))
                                             : Icon(
                                           Icons.keyboard_arrow_down,
                                           size: 25,
                                           color: App.grey95,
                                           key: const ValueKey('icon2'),
                                         )),
                                   ),
                                 ],
                               ),
                             ),
                           )),
                       SizedBox(
                         height: 10,
                       ),
                       // Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                       //  child: Row(
                       //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       //    children: [
                       //      Text(App_Localization.of(context).translate("aed")+" "+productsController.range.value.start.toStringAsFixed(2),style: TextStyle(fontSize: 12),),
                       //
                       //      Text(App_Localization.of(context).translate("aed")+" "+productsController.range.value.end.toStringAsFixed(2),style: TextStyle(fontSize: 12)),
                       //    ],
                       //  ),
                       // ),

                       // Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                       //   child: Row(
                       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       //     children: [
                       //
                       //     ],
                       //   ),
                       // ),
                       Padding(
                         padding: EdgeInsets.symmetric(horizontal: 15),
                         child: AnimatedSize(
                             duration: Duration(milliseconds: 350),
                             child: productsController.openFilterBrand.value == 0
                                 ? Center()
                                 : Column(
                               children: [
                                 // Text(productsController.min!.value.toStringAsFixed(2),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),),

                                 RangeSlider(
                                 values: productsController.range.value,
                                   onChanged: (range) {
                                     productsController.range.value = range;
                                   },
                                   min: productsController.min!.value,
                                   max: productsController.max!.value,
                                 ),
                                 // Text(productsController.max!.value.toStringAsFixed(2),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(App_Localization.of(context).translate("aed")+" "+productsController.range.value.start.toStringAsFixed(2),style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),

                                     Text(App_Localization.of(context).translate("aed")+" "+productsController.range.value.end.toStringAsFixed(2),style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500)),
                                   ],
                                 ),
                               ],
                             )),
                       ),
                     ],
                   ):Center(),
                   SizedBox(
                     height: 70,
                   ),
                 ],
               ),
             ),
              Positioned(
                bottom: 5,
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                productsController.apply();
                              },
                              child: Container(
                                width: Get.width * 0.8,
                                height: 37,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: App.primary,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      App_Localization.of(context)
                                          .translate("apply"),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    )
                                  ],
                                ),
                              )),
                          GestureDetector(
                            onTap: () {
                              productsController.clear();
                            },
                            child: Icon(
                              Icons.delete_outline,
                              color: App.grey95,
                              size: 27,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Platform.isAndroid
                        ? Center()
                        : Container(
                            width: Get.width,
                            height: 20,
                            color: Colors.white,
                          )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  _sortList(BuildContext context) {
    int index = 0;
    return Container(
        color: Colors.white,
        child: Obx(() => ListView(
              padding: EdgeInsets.all(10),
              children: [
                productsController.fake.value ? Center() : Center(),
                ListTile(
                  onTap: () {
                    productsController.filterResult!.filter.sort = null;
                    productsController.apply();
                    productsController.updateFake();
                  },
                  leading: CircleAvatar(
                      backgroundColor: App.background,
                      child: SvgPicture.asset("assets/icons/Newest.svg")),
                  title: Text(
                    App_Localization.of(context).translate("newest"),
                  ),
                  subtitle: Text(
                    App_Localization.of(context).translate("newest_desc"),
                  ),
                  trailing: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey)),
                    child: Center(
                      child: productsController.filterResult!.filter.sort !=
                                  0 &&
                              productsController.filterResult!.filter.sort !=
                                  1 &&
                              productsController.filterResult!.filter.sort != 2
                          ? Icon(
                              Icons.check_circle,
                              size: 18,
                              color: App.primary,
                            )
                          : Center(),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    productsController.filterResult!.filter.sort = 2;
                    productsController.apply();
                    productsController.updateFake();
                  },
                  leading: CircleAvatar(
                      backgroundColor: App.background,
                      child: SvgPicture.asset("assets/icons/TopRated.svg")),
                  title: Text(
                    App_Localization.of(context).translate("top_rated"),
                  ),
                  subtitle: Text(
                    App_Localization.of(context).translate("top_rated_desc"),
                  ),
                  trailing: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey)),
                    child: Center(
                      child: productsController.filterResult!.filter.sort == 2
                          ? Icon(
                              Icons.check_circle,
                              size: 18,
                              color: App.primary,
                            )
                          : Center(),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    productsController.filterResult!.filter.sort = 0;
                    productsController.apply();
                    productsController.updateFake();
                  },
                  leading: CircleAvatar(
                      backgroundColor: App.background,
                      child: SvgPicture.asset("assets/icons/LowestPrice.svg")),
                  title: Text(
                    App_Localization.of(context).translate("lower_price"),
                  ),
                  subtitle: Text(
                    App_Localization.of(context).translate("lower_price_desc"),
                  ),
                  trailing: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey)),
                    child: Center(
                      child: productsController.filterResult!.filter.sort == 0
                          ? Icon(
                              Icons.check_circle,
                              size: 18,
                              color: App.primary,
                            )
                          : Center(),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    productsController.filterResult!.filter.sort = 1;
                    productsController.apply();
                    productsController.updateFake();
                  },
                  leading: CircleAvatar(
                      backgroundColor: App.background,
                      child: SvgPicture.asset("assets/icons/HighestPrice.svg")),
                  title: Text(
                    App_Localization.of(context).translate("higher_price"),
                  ),
                  subtitle: Text(
                    App_Localization.of(context).translate("higher_price_desc"),
                  ),
                  trailing: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey)),
                    child: Center(
                      child: productsController.filterResult!.filter.sort == 1
                          ? Icon(
                              Icons.check_circle,
                              size: 18,
                              color: App.primary,
                            )
                          : Center(),
                    ),
                  ),
                )
              ],
            )));
  }
}

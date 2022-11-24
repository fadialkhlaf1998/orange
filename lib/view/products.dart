import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/home_controller.dart';
import 'package:orange/controller/products_controller.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
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
  String option;
  
  ProductsController productsController = Get.put(ProductsController());
  HomeController homeController = Get.find();

  Products({
    required this.title,
    this.categories = const [],
    this.brands = const [],
    this.sub_categories = const [],
    this.products = const [],
    this.sort = null,
    this.lazy_load = 0,
    this.limit = null,
    this.option = "and"
  }){
    productsController.getData(categories, brands, sub_categories, products, sort, lazy_load, limit,option);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: App.primary_mid,
      appBar:  AppBar(
        title: Text(title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        leading: App.backBtn(context),
        actions: [
          IconButton(onPressed: (){
            filterSortBottomSheet(context);
          }, icon: Icon(Icons.filter_list_alt,color: Colors.white)),
          IconButton(onPressed: (){
            showSearch(context: context, delegate: SearchTextField());
          }, icon: Icon(Icons.search,color: Colors.white)),
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
      body: Obx(()=>Column(
        children: [
          Expanded(
              child: productsController.loading.value
        ?App.loading(context)
        :productsController.filterResult==null||
          productsController.filterResult!.products.isEmpty?App.noResult(context)
        :LazyLoadScrollView(
                isLoading: productsController.lazyLoading.value,
        onEndOfPage: () => productsController.loadMore(),
          child: Scrollbar(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 45/60,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: productsController.filterResult!.products.length,
                          itemBuilder: (context,index){
                            return ProductCard(productsController.filterResult!.products[index]);
                          }
                ),
                productsController.lazyLoading.value?
                    Padding(padding: EdgeInsets.symmetric(vertical: 15),
                      child: App.loading(context),
                    )
                    :Center()
              ],
            ),
          ),
        )
          )
        ],
      )),
    );
  }

  filterSortBottomSheet(BuildContext context){
    if(productsController.filterResult == null){
      return;
    }
    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )
      ),
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
          width: Get.width,
          height: Get.height * 0.8,
          decoration: BoxDecoration(
              gradient: App.linearGradient,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            )
          ),
          child: DefaultTabController(
            length: 2,  // Added
            initialIndex: 0, //Added
            child: Column(
              children:[
                TabBar(

                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(child: Container(
                      width: Get.width*0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.filter_list,color: Colors.white),
                          SizedBox(width: 10,),
                          Text(App_Localization.of(context).translate("filter"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),)
                        ],
                      ),
                    ),),
                    Tab(child: Container(
                      width: Get.width*0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.compare_arrows,color: Colors.white),
                          SizedBox(width: 10,),
                          Text(App_Localization.of(context).translate("sort"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),)
                        ],
                      ),
                    ),),
                  ],
                ),
                Expanded(child: TabBarView(
                  children: [
                    _filterList(context),
                    _sortList(context)
                  ],
                ))
              ],
              
            ),
          ),

        ),
      ),
    );
  }
  _filterList(BuildContext context){
    return Obx(() => Container(
      color: Colors.white,
      child: Stack(
        children: [
          ListView(
            // physics: NeverScrollableScrollPhysics(),
            // padding: EdgeInsets.only(bottom: 60),
            shrinkWrap: true,
            children: [
              productsController.fake.value?Center():Center(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: (){
                    productsController.openFilterCategory.value = productsController.openFilterCategory.value == 0 ? 1 : 0;
                  },
                  child: Row(
                    children: [
                      Text(App_Localization.of(context).translate("category"),style: TextStyle(color: App.primary,fontSize: 18,fontWeight: FontWeight.bold),),
                      Center(
                        child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            transitionBuilder: (child, anim) => RotationTransition(
                              turns: child.key == ValueKey('icon1')
                                  ? Tween<double>(begin: 1, end: 0).animate(anim)
                                  : Tween<double>(begin: 0, end: 1).animate(anim),
                              child: ScaleTransition(scale: anim, child: child),
                            ),
                            child: productsController.openFilterCategory.value == 0
                                ? Icon(Icons.arrow_drop_down,size: 30,color: App.primary, key: const ValueKey('icon1'))
                                : Icon(
                              Icons.arrow_drop_up,size: 30,
                              color: App.primary,
                              key: const ValueKey('icon2'),
                            )),

                      )
                    ],
                  ),
                )
              ),
              AnimatedSize(
                  duration: Duration(milliseconds: 350),
                curve: Curves.ease,
                child: productsController.openFilterCategory.value == 0?Center():ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: homeController.categories.length,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(homeController.categories[index].title),
                                  SizedBox(width: 10,),
                                  Checkbox(value: homeController.categories[index].isCheckedFilter(productsController.filterResult!.filter.categories)
                                      , onChanged: (value){
                                        if(value!){
                                          productsController.addCategory(homeController.categories[index].categorySlug);
                                        }else{
                                          productsController.removeCategory(homeController.categories[index].categorySlug,homeController.categories[index]);
                                        }
                                      })
                                ],
                              ),
                              AnimatedSize(duration: Duration(milliseconds: 350),
                                curve: Curves.ease,
                              child: homeController.categories[index].isCheckedFilter(productsController.filterResult!.filter.categories)
                                  ?ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: homeController.categories[index].subCategories.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context,subIndex){
                                    return Container(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Row(
                                          children: [


                                            Checkbox(value: homeController.categories[index].subCategories[subIndex].isCheckedFilter(productsController.filterResult!.filter.subCategories)
                                                , onChanged: (value){
                                                  if(value!){
                                                    productsController.addSubCategory(homeController.categories[index].subCategories[subIndex].subCategorySlug);
                                                  }else{
                                                    productsController.removeSubCategory(homeController.categories[index].subCategories[subIndex].subCategorySlug);
                                                  }
                                                }),
                                            SizedBox(width: 10,),
                                            Text(homeController.categories[index].subCategories[subIndex].title),
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                                  :Center(),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(height: 20,),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: (){
                      productsController.openFilterBrand.value = productsController.openFilterBrand.value == 0 ? 1 : 0;
                    },
                    child: Row(
                      children: [
                        Text(App_Localization.of(context).translate("brands"),style: TextStyle(color: App.primary,fontSize: 18,fontWeight: FontWeight.bold),),
                        Center(
                          child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 350),
                              transitionBuilder: (child, anim) => RotationTransition(
                                turns: child.key == ValueKey('icon1')
                                    ? Tween<double>(begin: 1, end: 0).animate(anim)
                                    : Tween<double>(begin: 0, end: 1).animate(anim),
                                child: ScaleTransition(scale: anim, child: child),
                              ),
                              child: productsController.openFilterBrand.value == 0
                                  ? Icon(Icons.arrow_drop_down,size: 30,color: App.primary, key: const ValueKey('icon1'))
                                  : Icon(
                                Icons.arrow_drop_up,size: 30,
                                color: App.primary,
                                key: const ValueKey('icon2'),
                              )),

                        )
                      ],
                    ),
                  )
              ),
              AnimatedSize(
                duration: Duration(milliseconds: 350),
                child: productsController.openFilterBrand.value==0
                    ?Center()
                    :GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1
                  ),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: homeController.brands.length,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return Container(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                    color: Colors.white,
                                    image: DecorationImage(
                                        image: NetworkImage(Api.media_url+homeController.brands[index].image)
                                    )
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  if(homeController.brands[index].isCheckedFilter(productsController.filterResult!.filter.brands)){
                                    productsController.removeBrand(homeController.brands[index].brandSlug);
                                  }else{
                                    productsController.addBrand(homeController.brands[index].brandSlug);
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 350),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                      gradient:homeController.brands[index].isCheckedFilter(productsController.filterResult!.filter.brands)
                                      ?App.linearGradientWithOpacity:null,
                                      // color: App.primary.withOpacity(0.5),
                                  ),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Icon(Icons.check_circle,size: 20,
                                        color: homeController.brands[index].isCheckedFilter(productsController.filterResult!.filter.brands)
                                            ?App.primary:Colors.transparent
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ),
                      );
                    }),
              ),
              SizedBox(height: 60,),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
            color: Colors.white,
            height: 45,
            width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: (){
                      productsController.clear();
                    },
                    child: Container(
                      width: Get.width*0.4,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: App.red,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete,color: Colors.white,),
                          SizedBox(width: 10,),
                          Text(App_Localization.of(context).translate("clear"),style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),)
                        ],
                      ),
                    )
                ),
                GestureDetector(
                    onTap: (){
                      productsController.apply();
                    },
                    child: Container(
                      width: Get.width*0.4,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: App.green,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline,color: Colors.white,),
                          SizedBox(width: 10,),
                          Text(App_Localization.of(context).translate("apply"),style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),)
                        ],
                      ),
                    )
                )
              ],
            ),
          ),)
        ],
      ),
    ));
  }
  _sortList(BuildContext context){
    int index = 0;
    return Container(
      color: Colors.white,
      child: Obx(()=>
          ListView(
        padding: EdgeInsets.all(10),
        children: [
          productsController.fake.value ?Center():Center(),
          ListTile(
            onTap: (){
              productsController.filterResult!.filter.sort = null;
              productsController.apply();
              productsController.updateFake();
            },
            leading: CircleAvatar(backgroundColor: App.primary,child: Icon(Icons.new_label_outlined)),
            title: Text(App_Localization.of(context).translate("newest"),),
            subtitle: Text(App_Localization.of(context).translate("newest_desc"),),
            trailing: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey)
              ),
              child: Center(
                child:
                productsController.filterResult!.filter.sort != 0
                    &&productsController.filterResult!.filter.sort != 1
                    &&productsController.filterResult!.filter.sort != 2?
                Icon(Icons.check_circle,size: 18,color: App.primary,)
                    :Center(),
              ),
            ),
          ),
          ListTile(
            onTap: (){
              productsController.filterResult!.filter.sort = 2;
              productsController.apply();
              productsController.updateFake();
            },
            leading: CircleAvatar(backgroundColor: App.primary,child: Icon(Icons.new_label_outlined)),
            title: Text(App_Localization.of(context).translate("top_rated"),),
            subtitle: Text(App_Localization.of(context).translate("top_rated_desc"),),
            trailing: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey)
              ),
              child: Center(
                child:
                productsController.filterResult!.filter.sort == 2
                    ?
                Icon(Icons.check_circle,size: 18,color: App.primary,)
                    :Center(),
              ),
            ),
          ),
          ListTile(
            onTap: (){
              productsController.filterResult!.filter.sort = 0;
              productsController.apply();
              productsController.updateFake();
            },
            leading: CircleAvatar(backgroundColor: App.primary,child: Icon(Icons.new_label_outlined)),
            title: Text(App_Localization.of(context).translate("lower_price"),),
            subtitle: Text(App_Localization.of(context).translate("lower_price_desc"),),
            trailing: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey)
              ),
              child: Center(
                child:
                productsController.filterResult!.filter.sort == 0
                    ?
                Icon(Icons.check_circle,size: 18,color: App.primary,)
                    :Center(),
              ),
            ),
          ),
          ListTile(
            onTap: (){
              productsController.filterResult!.filter.sort = 1;
              productsController.apply();
              productsController.updateFake();
            },
            leading: CircleAvatar(backgroundColor: App.primary,child: Icon(Icons.new_label_outlined)),
            title: Text(App_Localization.of(context).translate("higher_price"),),
            subtitle: Text(App_Localization.of(context).translate("higher_price_desc"),),
            trailing: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey)
              ),
              child: Center(
                child:
                productsController.filterResult!.filter.sort == 1
                    ?
                Icon(Icons.check_circle,size: 18,color: App.primary,)
                    :Center(),
              ),
            ),
          )
        ],
      ))
    );
  }
}

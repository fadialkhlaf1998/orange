import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/home_controller.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/model/section.dart';
import 'package:orange/view/products.dart';
import 'package:orange/widgets/product_card.dart';
import 'package:orange/widgets/searchDelgate.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
  }

  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: App.background,
      appBar: App.myHeader(context, height: 60, child: Center(
          child:  Container(
            width: Get.width*0.9,
            child: Row(
              children: [
                GestureDetector(
                    onTap: (){
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      child: Image.asset("assets/images/logo.png",),
                    )
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      showSearch(context: context, delegate: SearchTextField());
                    },
                    child: Container(
                      height: 40,

                      decoration: BoxDecoration(
                          color: App.grey,
                          borderRadius: BorderRadius.circular(25)
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          SvgPicture.asset("assets/icons/stroke/search.svg",width: 25,height: 25,),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                GestureDetector(
                    onTap: (){
                      homeController.pageController.jumpToTab(3);
                      homeController.selectedPage.value = 3;
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      child: SvgPicture.asset("assets/icons/stroke/Bag_orange.svg",),
                    )
                )
              ],
            ),
          )
      ),),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Obx(() => Container(
          width: Get.width,
          child:
          homeController.loading.value?
          Container(
            width: Get.width,
            height: Get.height,
            child: App.loading(context),
          )
              :Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _slider(context),
              SizedBox(height: 20,),
              _category(context),
              SizedBox(height: 20,),
              _brands(context),
              SizedBox(height: 10,),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: homeController.sections.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index){
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: _section(context,homeController.sections[index]),
                    );
                  }
              ),
              SizedBox(height: 20,),
            ],
          ),
        )),
      ),
    );
  }

  _slider(BuildContext context){
    return Container(
      width: Get.width,
      height: Get.width*0.5,
      // color: Colors.red,
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: Get.width*0.5,
              // aspectRatio: 2/1,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              // autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.height,

              onPageChanged: (index,controller){
                homeController.activeSlider.value = index;
              },
              scrollDirection: Axis.horizontal,
            ),
            items: homeController.banners.map((elm) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: (){
                      homeController.mainBannerPress(elm,context);
                    },
                    child: Container(
                      width: Get.width,
                      height: Get.width*0.5,
                      margin: EdgeInsets.symmetric(horizontal: 0.0),
                      decoration: BoxDecoration(
                        // color: Colors.red,
                          borderRadius: BorderRadius.circular(0),
                          image: DecorationImage(
                              image: NetworkImage(Api.media_url+elm.image),
                              fit: BoxFit.fill
                          )
                      ),
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
                   itemCount: homeController.banners.length,
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
                             color: homeController.activeSlider.value==index?App.primary:Colors.grey,
                             borderRadius: BorderRadius.circular(2.5)
                             // shape: BoxShape.circle,
                           ),
                         ),
                       )),
                     );
                   })
             ],
           ),
         ))
        ],
      ),
    );
  }

  _category(BuildContext context){
    return Container(
      width: Get.width*0.9,
      // height: Get.height*0.15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(App_Localization.of(context).translate("shop_by_category"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
          ),
          Container(
            height: Get.height*0.1,
            child: ListView.builder(
                itemCount: homeController.categories.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context,index){

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: (){
                        Get.to(()=>Products(title: homeController.categories[index].title,categories: [homeController.categories[index].categorySlug],));
                      },
                      child: Container(
                        height: Get.height*0.8,
                        padding: EdgeInsets.all(5),
                        width:Get.height*0.2+10,
                        decoration: BoxDecoration(
                          color: App.grey,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        // color: Colors.red,
                        child: Row(
                          children: [
                            Container(
                              height: Get.height*0.08,
                              width:Get.height*0.1,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(Api.media_url+homeController.categories[index].image)
                                  )
                              ),
                            ),
                            Container(
                              height: Get.height*0.08,
                              width:Get.height*0.1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(homeController.categories[index].title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.left,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
  _brands(BuildContext context){
    return Container(
      width: Get.width*0.9,
      // height: Get.height*0.15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(App_Localization.of(context).translate("shop_by_brand"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
          ),
          Container(
            height: Get.height*0.15,
            child: ListView.builder(
                itemCount: homeController.brands.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context,index){

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: (){
                        Get.to(()=>Products(title: homeController.brands[index].title,brands: [homeController.brands[index].brandSlug],));
                      },
                      child: Container(
                        height: Get.height*0.15,
                        width:Get.height*0.15,

                        decoration: BoxDecoration(
                            // shape: BoxShape.circle,
                          borderRadius: BorderRadius.circular(15),
                            color: App.grey,
                            // border: Border.all(color: Colors.grey.withOpacity(0.5)),
                            image: DecorationImage(
                                image: NetworkImage(Api.media_url+homeController.brands[index].image),
                              fit: BoxFit.contain
                            ),
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  _section(BuildContext context ,Section section){
    return section.type==0
          ?_productSection(context,section)
          :_bannerSection(context, section);
  }

  _bannerSection(BuildContext context ,Section section){
    return section.bannerItems.length == 1?_oneBanner(context, section, section.bannerItems[0])
            :section.bannerItems.length == 2?_twoBanner(context, section, section.bannerItems[0], section.bannerItems[1])
              :section.bannerItems.length == 3?_threeBanner(context, section, section.bannerItems[0], section.bannerItems[1],section.bannerItems[2])
                :section.bannerItems.length == 4?_fourBanner(context, section, section.bannerItems[0], section.bannerItems[1],section.bannerItems[2],section.bannerItems[3])
                  :_listBanner(context,section,section.bannerItems);
  }

  _productSection(BuildContext context ,Section section){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: Get.width * 0.9,
            child: Row(
          children: [
            Text(section.title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
          ],
        )),
        Container(
          width: Get.width*0.9,
          height: Get.width*0.6+20,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
              itemCount: section.products.length,
              itemBuilder: (context,index){
                return ProductCard(section.products[index]);
          }),
        ),
      ],
    );
  }

  _oneBanner(BuildContext context,Section section,BannerItem bannerItem_1){
    return Container(
      width: Get.width,
      height: Get.width*0.5,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(Api.media_url+section.backgroundImage),
          fit: BoxFit.cover
        )
      ),
      child: Center(
        child: _bannerImage(Get.width*0.45,bannerItem_1),
      ),
    );
  }

  _twoBanner(BuildContext context,Section section,BannerItem bannerItem_1,BannerItem bannerItem_2){
    return Container(
      width: Get.width,
      height: Get.width*0.5,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(Api.media_url+section.backgroundImage),
              fit: BoxFit.cover
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _bannerImage(Get.width*0.45,bannerItem_1),
          _bannerImage(Get.width*0.45,bannerItem_2),
        ],
      ),
    );
  }

  _threeBanner(BuildContext context,Section section,BannerItem bannerItem_1,BannerItem bannerItem_2,
      BannerItem bannerItem_3){
    return Container(
      width: Get.width,
      height: Get.width*0.35,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(Api.media_url+section.backgroundImage),
              fit: BoxFit.cover
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _bannerImage(Get.width*0.3,bannerItem_1),
          _bannerImage(Get.width*0.3,bannerItem_2),
          _bannerImage(Get.width*0.3,bannerItem_3),
        ],
      ),
    );
  }

  _fourBanner(BuildContext context,Section section,BannerItem bannerItem_1,BannerItem bannerItem_2,
      BannerItem bannerItem_3,BannerItem bannerItem_4){
    return Container(
      width: Get.width,
      height: Get.width*0.65,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(Api.media_url+section.backgroundImage),
              fit: BoxFit.cover
          )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _bannerImage(Get.width*0.3,bannerItem_1),
              _bannerImage(Get.width*0.3,bannerItem_2),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _bannerImage(Get.width*0.3,bannerItem_3),
              _bannerImage(Get.width*0.3,bannerItem_4),
            ],
          )
        ],
      ),
    );
  }

  _listBanner(BuildContext context,Section section,List<BannerItem> list){
    return Container(
      width: Get.width,
      height: Get.width*0.5,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(Api.media_url+section.backgroundImage),
              fit: BoxFit.cover
          )
      ),
      child: ListView.builder(
        controller: section.scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: list.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context,index){
            return Padding(padding: EdgeInsets.symmetric(horizontal: 10),
              child: Center(child: _bannerImage(Get.width*0.45, list[index]),),
            );
          }),
    );
  }

  ScrollController scrollController = ScrollController();

  _bannerImage(double size,BannerItem bannerItem){
    return GestureDetector(
      onTap: (){
        homeController.bannerItemPress(bannerItem,context);
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(Api.media_url+bannerItem.image),
              fit: BoxFit.fill,
            )
        ),
      ),
    );
  }
}

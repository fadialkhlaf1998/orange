import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/address_controller.dart';
import 'package:orange/controller/cart_controller.dart';
import 'package:orange/controller/category_controller.dart';
import 'package:orange/controller/orders_controller.dart';
import 'package:orange/controller/wishlist_controller.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/helper/store.dart';
import 'package:orange/model/category.dart';
import 'package:orange/model/brand.dart';
import 'package:orange/model/login_info.dart';
import 'package:orange/model/result.dart';
import 'package:orange/model/search_suggestions.dart';
import 'package:orange/model/section.dart';
import 'package:orange/model/banner.dart';
import 'package:orange/model/start_up.dart';
import 'package:orange/view/login.dart';
import 'package:orange/view/main.dart';
import 'package:orange/view/product_details.dart';
import 'package:orange/view/products.dart';
import 'package:orange/view/verification_code.dart';
import 'package:orange/view/welcome.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HomeController extends GetxController{

  PersistentTabController pageController = PersistentTabController(initialIndex: 0);
  RxInt selectedPage = 0.obs;

  List<Category> categories = <Category>[];
  List<Brand> brands = <Brand>[];
  List<Section> sections = <Section>[];
  List<MyBanner> banners = <MyBanner>[];
  List<SearchSuggestion> search_suggestions = <SearchSuggestion>[];

  RxInt activeSlider = 0.obs;
  RxBool loading = false.obs;


  @override
  void onInit(){
    super.onInit();
    initApp();
  }

  initApp()async{
    loading.value = true;
    LoginInfo? loginInfo = await Store.loadLoginInfo();
    StartUpDecoder? startUpDecoder;
    Result? loginResult;
    await Api.hasInternet();
    if(loginInfo != null ){
      loginResult = await Api.login(loginInfo.email, loginInfo.password);
      initControllers();
      if(Global.customer !=null){
        startUpDecoder = await Api.startUp(Global.locale, Global.customer!.id);
      }else {
        startUpDecoder = await Api.startUp(Global.locale, -1);
      }
    }else{
      initControllers();
      startUpDecoder = await Api.startUp(Global.locale, -1);

    }
    if(startUpDecoder != null){
      loading.value = false;
     navigate(startUpDecoder,loginResult);
    }else{
      initApp();
    }
  }

  initControllers(){
    WishlistController wishlistController = Get.put(WishlistController());
    CartController cartController = Get.put(CartController());
    AddressController addressController = Get.put(AddressController());
    OrdersController ordersController = Get.put(OrdersController());
  }

  wishlistEvent(int languageParent,int wishlist){
    for(int i=0;i<sections.length;i++){
      if(sections[i].type == 0){
        for(int j=0;j<sections[i].products.length;j++){
          if(sections[i].products[j].languageParent == languageParent){
            sections[i].products[j].wishlist.value = wishlist;
          }
        }
      }
    }
  }

  refreshController(){
    WishlistController wishlistController = Get.put(WishlistController());
    CartController cartController = Get.put(CartController());
    AddressController addressController = Get.put(AddressController());
    OrdersController ordersController = Get.put(OrdersController());
    CategoryController categoryController = Get.put(CategoryController());
    wishlistController.getData();
    cartController.getData();
    addressController.getData();
    ordersController.getData();
    categoryController.getData();
  }

  navigate(StartUpDecoder startUpDecoder,Result? loginResult)async{

    categories = startUpDecoder.categories;
    brands = startUpDecoder.brands;
    sections = startUpDecoder.sections;
    banners = startUpDecoder.banners;
    search_suggestions = startUpDecoder.search_suggestions;

    bool firstTime = await Store.loadFirstTime();
    if(firstTime){
      Get.off(()=>Welcome());
    }
    else if(loginResult == null){
      Get.off(()=>Login());
    }else if(loginResult.code == 1){
      Get.off(()=>Main());
    }else if(loginResult.code == -10){
      Get.off(()=>VerificationCode());
    }else{
      Get.off(()=>Login());
    }
  }


  refreshData()async{
    loading.value = true;
    StartUpDecoder? startUpDecoder;
    await Api.hasInternet();
    if(Global.customer !=null){
      startUpDecoder = await Api.startUp(Global.locale, Global.customer!.id);
    }else {
      startUpDecoder = await Api.startUp(Global.locale, -1);
    }
    // initControllers();

    if(startUpDecoder == null){
      refreshData();
    }else{
      categories = startUpDecoder.categories;
      brands = startUpDecoder.brands;
      sections = startUpDecoder.sections;
      banners = startUpDecoder.banners;
      search_suggestions = startUpDecoder.search_suggestions;

      refreshController();


      loading.value = false;
    }

  }

  mainBannerPress(MyBanner banner,BuildContext context){
    if(banner.products.length == 1 && banner.category.isEmpty && banner.subCategory.isEmpty && banner.brand.isEmpty ){
      Get.to(()=>ProductDetails((banner.products.first),-1));
    }else{
      Get.to(()=>Products(title: "",categories: banner.category,sub_categories: banner.subCategory,brands: banner.brand,products: banner.products,option: "or",));
    }
  }

  bannerItemPress(BannerItem banner,BuildContext context){
    if(banner.productSlug.isNotEmpty && banner.subCategorySlug.isEmpty && banner.brandSlug.isEmpty && banner.categorySlug.isEmpty ){
      Get.to(()=>ProductDetails((banner.productSlug),-1));
    }else{
      Get.to(()=>Products(
        title: App_Localization.of(context).translate("offers"),
        categories: banner.categorySlug.isNotEmpty?[banner.categorySlug]:[],
        sub_categories: banner.subCategorySlug.isNotEmpty?[banner.subCategorySlug]:[],
        brands: banner.brandSlug.isNotEmpty?[banner.brandSlug]:[],
        products: banner.productSlug.isNotEmpty?[banner.productSlug]:[],
        option: "or",)
      );
    }
  }

}
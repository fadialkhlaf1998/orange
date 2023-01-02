import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/cart_controller.dart';
import 'package:orange/controller/home_controller.dart';
import 'package:orange/controller/wishlist_controller.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/view/cart.dart';
import 'package:orange/view/category.dart';
import 'package:orange/view/home.dart';
import 'package:orange/view/profile.dart';
import 'package:orange/view/wishlist.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Main extends StatelessWidget {

  HomeController homeController = Get.find();

  List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
    return [
      PersistentBottomNavBarItem(
        icon:
        Obx(() => homeController.selectedPage.value == 0?
        SvgPicture.asset("assets/icons/fill/Home.svg")
            : SvgPicture.asset("assets/icons/stroke/Home.svg")),
        title: Global.locale=="ar"?
        " "+ App_Localization.of(context).translate("home").toUpperCase():
        ""+ App_Localization.of(context).translate("home").toUpperCase(),
        activeColorPrimary: CupertinoColors.white,
        inactiveColorPrimary: CupertinoColors.black.withOpacity(0.8),
      ),
      PersistentBottomNavBarItem(
        icon: Obx(() => homeController.selectedPage.value == 1?
        SvgPicture.asset("assets/icons/fill/Category.svg")
            : SvgPicture.asset("assets/icons/stroke/Category.svg")),
        title: Global.locale=="ar"?
        " "+ App_Localization.of(context).translate("category").toUpperCase():
        ""+ App_Localization.of(context).translate("category").toUpperCase(),
        activeColorPrimary: CupertinoColors.white,
        inactiveColorPrimary: CupertinoColors.black.withOpacity(0.8),
      ),
      PersistentBottomNavBarItem(
        icon: Obx(() => homeController.selectedPage.value == 2?
        SvgPicture.asset("assets/icons/fill/Heart.svg")
            : SvgPicture.asset("assets/icons/stroke/Heart.svg")),
        // contentPadding: 10,
        title: Global.locale=="ar"?
        " "+ App_Localization.of(context).translate("wishlist").toUpperCase():
        ""+ App_Localization.of(context).translate("wishlist").toUpperCase(),
        activeColorPrimary: CupertinoColors.white,
        inactiveColorPrimary: CupertinoColors.black.withOpacity(0.8),
      ),
      PersistentBottomNavBarItem(
        icon: Obx(() => homeController.selectedPage.value == 3?
        SvgPicture.asset("assets/icons/fill/Bag.svg")
            : SvgPicture.asset("assets/icons/stroke/Bag.svg")),
        title: Global.locale=="ar"?
        " "+ App_Localization.of(context).translate("cart").toUpperCase():
        ""+ App_Localization.of(context).translate("cart").toUpperCase(),
        activeColorPrimary: CupertinoColors.white,
        inactiveColorPrimary: CupertinoColors.black.withOpacity(0.8),
      ),
      PersistentBottomNavBarItem(
        icon: Obx(() => homeController.selectedPage.value == 4?
        SvgPicture.asset("assets/icons/fill/profile.svg")
            : SvgPicture.asset("assets/icons/stroke/profile.svg")),
        title: Global.locale=="ar"?
        " "+ App_Localization.of(context).translate("profile").toUpperCase():
        ""+ App_Localization.of(context).translate("profile").toUpperCase(),
        activeColorPrimary: CupertinoColors.white,
        inactiveColorPrimary: CupertinoColors.black.withOpacity(0.8),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: homeController.pageController,
      screens: [
        Home(),
        Category(),
        Wishlist(),
        Cart(),
        Profile(),
      ],
      onItemSelected: (index){
        homeController.selectedPage.value = index;
        if(index == 2){
          WishlistController wishlistController = Get.find();
          wishlistController.getData();
        }else if(index == 3){
          CartController cartController = Get.find();
          cartController.getData();
        }
      },
      items: _navBarsItems(context),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
        colorBehindNavBar: Colors.white,
        gradient:  LinearGradient(colors: [App.primary_light,App.primary],begin: Alignment.topCenter ,end: Alignment.bottomCenter)
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties:const ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation:const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }
}

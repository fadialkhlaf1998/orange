import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/view/login.dart';

class Welcome extends StatelessWidget {
  RxInt selectedIndex = 0.obs;
  CarouselController carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/welcome_background.png"),fit: BoxFit.cover)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: Get.width,
                height: Get.height*0.7  + 30,
                // color: Colors.red,
                child: Column(
                  children: [
                    CarouselSlider(
                      carouselController: carouselController,
                      options: CarouselOptions(
                        height: Get.height*0.7,
                        // aspectRatio: 1/3,
                        viewportFraction: 1,
                        initialPage: 0,
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
enableInfiniteScroll: true,
                        onPageChanged: (index,controller){
                          selectedIndex.value = index;
                        },
                        scrollDirection: Axis.horizontal,
                      ),
                      items: [
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage("assets/images/welcome_1.png"))
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage("assets/images/welcome_2.png"))
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage("assets/images/welcome_3.png"))
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: Get.width,
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListView.builder(
                              itemCount: 3,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context,index){
                                return Padding(
                                  padding: const EdgeInsets.only(left: 2,right: 2,top: 10),
                                  child: Obx(() => Center(
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 400),
                                      height: 5,
                                      width: selectedIndex.value==index?20:10,
                                      decoration: BoxDecoration(
                                          color: selectedIndex.value==index?App.primary:App.primary.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(2.5)
                                        // shape: BoxShape.circle,
                                      ),
                                    ),
                                  )),
                                );
                              })
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Welcome To ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Text("Orange ".toUpperCase(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: App.primary),),
                  Text("Store!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                ],
              ),
              GestureDetector(
                onTap: (){
                  if(selectedIndex.value == 2){
                    Get.off(()=>Login());
                  }else{
                    carouselController.nextPage();
                  }
                  print(selectedIndex.value);
                },
                child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                      color: App.primary,
                      borderRadius: BorderRadius.circular(25)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.arrow_forward_rounded,color: Colors.transparent,),
                      ),
                      Obx(() => Text(selectedIndex.value == 2 ?"GET STARTED":"NEXT",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)),),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.arrow_forward_rounded,color: Colors.white,),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

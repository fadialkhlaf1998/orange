import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/home_controller.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/view/product_details.dart';

class SearchTextField extends SearchDelegate<String> {

  HomeController homeController = Get.find();

  SearchTextField();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      query.isEmpty ?
      const Visibility(
        visible: false,
        child: Text('')
      ) : IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: () {
          query="";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back,color: Colors.white),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
      appBarTheme: AppBarTheme(
        color: App.primary,
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.white
      ),
      hintColor: Colors.white,
      textTheme: const TextTheme(
        headline6: TextStyle(
          // fontSize: App.medium,
          // color: App.lightWhite,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }


  @override
  Widget buildResults(BuildContext context) {
    final suggestions = homeController.search_suggestions.where((elm) {
      return elm.title.toLowerCase().contains(query.toLowerCase());
    });
    return suggestions.isEmpty ?
    Container(
      height: Get.height,
      width: Get.width,
      color: App.primary,
      child: Center(
        child: Text(App_Localization.of(context).translate("no_results_found"),
            style: const TextStyle(
                // color: App.lightWhite,
                // fontSize: App.small,
                fontWeight: FontWeight.w600
            )
        ),
      ),
    ) :
    Container(
        height: Get.height,
        width: Get.width,
        color: Colors.white,
        child: ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(

                  // tileColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  style: ListTileStyle.drawer,
                  leading: Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(
                              "${Api.media_url}/${suggestions.elementAt(index).image}",
                            ),
                            fit: BoxFit.contain
                        )
                    ),
                  ),
                  title: Text(suggestions.elementAt(index).title,
                    maxLines: 2,
                    style: const TextStyle(
                      // fontSize: App.medium,
                      // color: App.lightWhite,
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,

                    ),
                  ),
                  onTap: (){
                    Get.to(()=>ProductDetails(suggestions.elementAt(index).slug));
                  },
                ),
              ),
            );
          },
        )
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = homeController.search_suggestions.where((elm) {
      return elm.title.toLowerCase().contains(query.toLowerCase());
    });
    return suggestions.isEmpty ?
    Container(
      height: Get.height,
      width: Get.width,
      color: App.primary,
      child: Center(
        child: Text(App_Localization.of(context).translate("no_results_found"),
            style: const TextStyle(
              // color: App.lightWhite,
              // fontSize: App.small,
                fontWeight: FontWeight.w600
            )
        ),
      ),
    ) :
    Container(
        height: Get.height,
        width: Get.width,
        color: Colors.white,
        child: ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(

                  // tileColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  style: ListTileStyle.drawer,
                  leading: Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(
                              "${Api.media_url}/${suggestions.elementAt(index).image}",
                            ),
                            fit: BoxFit.contain
                        )
                    ),
                  ),
                  title: Text(suggestions.elementAt(index).title,
                    maxLines: 2,
                    style: const TextStyle(
                      // fontSize: App.medium,
                      // color: App.lightWhite,
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,

                    ),
                  ),
                  onTap: (){
                    Get.to(()=>ProductDetails(suggestions.elementAt(index).slug));
                  },
                ),
              ),
            );
          },
        )
    );
  }
}
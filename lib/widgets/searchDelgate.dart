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
        icon: const Icon(Icons.close, color: Colors.black),
        onPressed: () {
          query="";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back,color: Colors.black),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
      appBarTheme: AppBarTheme(
        color: Colors.white,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.black
      ),
      hintColor: App.grey95,
      textTheme: const TextTheme(

        headline6: TextStyle(
          // fontSize: App.medium,
          // color: App.lightWhite,
          color: Colors.black,
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
    return
      query.isEmpty?
          Container(
            height: Get.height,
            width: Get.width,
            color: Colors.white.withOpacity(0.8),
          )
      :suggestions.isEmpty ?
    Container(
      height: Get.height,
      width: Get.width,
      color: App.background,
      child: Center(
        child: Text(App_Localization.of(context).translate("no_results_found"),
            style: TextStyle(
                color: App.primary,
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
          padding: EdgeInsets.only(bottom: 50),
          itemCount: suggestions.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: (){
                Get.to(()=>ProductDetails(suggestions.elementAt(index).slug,-1));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: RichText(
                  text: searchMatch(suggestions.elementAt(index).title),
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

    return
      query.isEmpty?
      Container(
        height: Get.height,
        width: Get.width,
        color: Colors.white,
      )
          :suggestions.isEmpty ?
    Container(
      height: Get.height,
      width: Get.width,
      color: App.background,
      child: Center(
        child: Text(App_Localization.of(context).translate("no_results_found"),
            style: TextStyle(
              color: App.primary,
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
          padding: EdgeInsets.only(bottom: 50),
          itemCount: suggestions.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: (){
                Get.to(()=>ProductDetails(suggestions.elementAt(index).slug,-1));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: RichText(
                  text: searchMatch(suggestions.elementAt(index).title),
                ),
              ),
            );
          },
        )
    );
  }
  TextStyle positiveColorStyle = TextStyle(color: Colors.black,fontSize: 16);
  TextStyle negativeColorStyle = TextStyle(color: App.grey95,fontSize: 16);

  TextSpan searchMatch(String match) {
    if (query == null || query == "")
      return TextSpan(text: match, style: negativeColorStyle);
    var refinedMatch = match.toLowerCase();
    var refinedSearch = query.toLowerCase();
    if (refinedMatch.contains(refinedSearch)) {
      if (refinedMatch.substring(0, refinedSearch.length) == refinedSearch) {
        return TextSpan(
          style: positiveColorStyle,
          text: match.substring(0, refinedSearch.length),
          children: [
            searchMatch(
              match.substring(
                refinedSearch.length,
              ),
            ),
          ],
        );
      } else if (refinedMatch.length == refinedSearch.length) {
        return TextSpan(text: match, style: positiveColorStyle);
      } else {
        return TextSpan(
          style: negativeColorStyle,
          text: match.substring(
            0,
            refinedMatch.indexOf(refinedSearch),
          ),
          children: [
            searchMatch(
              match.substring(
                refinedMatch.indexOf(refinedSearch),
              ),
            ),
          ],
        );
      }
    } else if (!refinedMatch.contains(refinedSearch)) {
      return TextSpan(text: match, style: negativeColorStyle);
    }
    return TextSpan(
      text: match.substring(0, refinedMatch.indexOf(refinedSearch)),
      style: negativeColorStyle,
      children: [
        searchMatch(match.substring(refinedMatch.indexOf(refinedSearch)))
      ],
    );
  }
}
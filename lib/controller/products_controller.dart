import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/model/category.dart';
import 'package:orange/model/filter_result.dart';
import 'package:orange/model/product.dart';

class ProductsController extends GetxController {

  Filter initialFilter = Filter(categories: [], brands: [], subCategories: [], products: [], sort: null, limit: null, lazyLoad: 1, locale: Global.locale, customerId: -1,option: "and",max_price: null,min_price: null);
  RxBool loading = false.obs;
  RxBool lazyLoading = false.obs;
  RxBool fake = false.obs;
  FilterResult? filterResult;

  RxInt openFilterCategory = 1.obs;
  RxInt openFilterBrand = 0.obs;
  RxInt openFilterPrice = 0.obs;
  RxDouble? min = null;
  RxDouble? max = null;
  RxInt selectedTap = 0.obs;
  Rx<RangeValues> range = RangeValues(1,100).obs;

  getData(
      List<String> categories,
      List<String> brands,
      List<String> sub_categories,
      List<String> products,
      int? sort,
      int? lazy_load,
      int? limit,
      String option,
      double? min_price,
      double? max_price
      ) async{
    await Api.hasInternet();
    loading.value = true;
    filterResult = await Api.filter(categories: categories, brands: brands, sub_categories: sub_categories, products: products, sort: sort, lazy_load: lazy_load, limit: limit,option: option,max_price: max_price,min_price: min_price);

    saveRange();

    saveInitailFilter(filterResult!.filter);
    loading.value = false;
  }

  saveInitailFilter(Filter filter){
    initialFilter.categories.addAll(filter.categories);
    initialFilter.products.addAll(filter.products);
    initialFilter.brands.addAll(filter.brands);
    initialFilter.subCategories.addAll(filter.subCategories);
    initialFilter.sort = filter.sort;
    initialFilter.lazyLoad = filter.lazyLoad;
    initialFilter.locale = filter.locale;
    initialFilter.limit = filter.limit;
    initialFilter.customerId = filter.customerId;
    initialFilter.option = filter.option;
    initialFilter.max_price = filter.max_price;
    initialFilter.min_price = filter.min_price;
  }
  saveRange(){
    if(filterResult!= null && filterResult!.priceRange.min_price!= null
        &&filterResult!.priceRange.max_price!= null){
      min = filterResult!.priceRange.min_price!.obs;
      max = filterResult!.priceRange.max_price!.obs;
      if(filterResult!.filter.max_price != null && filterResult!.filter.min_price != null){
        range.value = RangeValues(filterResult!.filter.min_price!, filterResult!.filter.max_price!);
      }else{
        range.value = RangeValues(min!.value, max!.value);
      }
    }
  }
  apply()async{
    loading.value = true;
    filterResult!.filter.lazyLoad = 0;
    Get.back();
    filterResult = await Api.filter(categories: filterResult!.filter.categories,
        brands: filterResult!.filter.brands,
        sub_categories: filterResult!.filter.subCategories,
        products: [],
        sort: filterResult!.filter.sort,
        lazy_load: filterResult!.filter.lazyLoad,
        limit: filterResult!.filter.limit,
        max_price: range.value.end,
        min_price: range.value.start,
        option: "and"
    );
    saveRange();
    loading.value = false;
  }


  clear()async{
    loading.value = true;
    initialFilter.lazyLoad = 0;
    Get.back();
    filterResult = await Api.filter(categories: initialFilter.categories,
        brands: initialFilter.brands,
        sub_categories: initialFilter.subCategories,
        products: initialFilter.products,
        sort: initialFilter.sort,
        lazy_load: initialFilter.lazyLoad,
        limit: initialFilter.limit,
        max_price: initialFilter.max_price,
        min_price: initialFilter.min_price,
        option: initialFilter.option
    );
    log(filterResult!.filter.toJson());
    saveRange();
    loading.value = false;
  }

  loadMore()async{
    lazyLoading.value = true;
    if(filterResult!.filter.lazyLoad == null){
      filterResult!.filter.lazyLoad = 0;
    }else{
      filterResult!.filter.lazyLoad = filterResult!.filter.lazyLoad! + 1;
    }
    FilterResult temp = await Api.filter(categories: filterResult!.filter.categories,
        brands: filterResult!.filter.brands,
        sub_categories: filterResult!.filter.subCategories,
        products: filterResult!.filter.products,
        sort: filterResult!.filter.sort,
        lazy_load: filterResult!.filter.lazyLoad,
        limit: filterResult!.filter.limit,
        min_price: filterResult!.filter.min_price,
        max_price: filterResult!.filter.max_price,
        option: filterResult!.filter.option
    );
    filterResult!.products.addAll(temp.products);
    filterResult!.filter = temp.filter;
    lazyLoading.value = false;
  }

  addCategory(String slug){
    filterResult!.filter.categories.add(slug);
    updateFake();
  }

  removeCategory(String slug,Category category){
    filterResult!.filter.categories.remove(slug);
    category.subCategories.forEach((element) {removeSubCategory(element.subCategorySlug);});
    updateFake();
  }

  addSubCategory(String slug){
    filterResult!.filter.subCategories.add(slug);
    updateFake();
  }

  removeSubCategory(String slug){
    filterResult!.filter.subCategories.remove(slug);
    updateFake();
  }

  addBrand(String slug){
    filterResult!.filter.brands.add(slug);
    updateFake();
  }

  removeBrand(String slug){
    filterResult!.filter.brands.remove(slug);
    updateFake();
  }

  updateFake(){
    fake.value = !fake.value;
  }
}
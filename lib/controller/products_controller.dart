import 'package:get/get.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/model/category.dart';
import 'package:orange/model/filter_result.dart';
import 'package:orange/model/product.dart';

class ProductsController extends GetxController {

  Filter initialFilter = Filter(categories: [], brands: [], subCategories: [], products: [], sort: null, limit: null, lazyLoad: 1, locale: Global.locale, customerId: -1,option: "and");
  RxBool loading = false.obs;
  RxBool lazyLoading = false.obs;
  RxBool fake = false.obs;
  FilterResult? filterResult;

  RxInt openFilterCategory = 1.obs;
  RxInt openFilterBrand = 1.obs;

  getData(
      List<String> categories,
      List<String> brands,
      List<String> sub_categories,
      List<String> products,
      int? sort,
      int? lazy_load,
      int? limit,
      String option
      ) async{
    await Api.hasInternet();
    loading.value = true;
    filterResult = await Api.filter(categories: categories, brands: brands, sub_categories: sub_categories, products: products, sort: sort, lazy_load: lazy_load, limit: limit,option: option);
    saveInitailFilter(filterResult!.filter);
    loading.value = false;
  }

  saveInitailFilter(Filter filter){
    initialFilter.categories = filter.categories;
    initialFilter.products = filter.products;
    initialFilter.brands = filter.brands;
    initialFilter.subCategories = filter.subCategories;
    initialFilter.sort = filter.sort;
    initialFilter.lazyLoad = filter.lazyLoad;
    initialFilter.locale = filter.locale;
    initialFilter.limit = filter.limit;
    initialFilter.customerId = filter.customerId;
    initialFilter.option = filter.option;
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
        option: "and"
    );
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
        option: initialFilter.option
    );
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
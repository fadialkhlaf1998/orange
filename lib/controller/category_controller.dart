import 'package:get/get.dart';
import 'package:orange/controller/home_controller.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/model/product.dart';
import 'package:orange/model/sub_category.dart';
class CategoryController extends GetxController{

  HomeController homeController = Get.find();

  RxInt selectedCategory = 0.obs;
  RxInt selectedSubCategory = 0.obs;

  RxBool subCategoryLoading = false.obs;
  RxBool productLoading = false.obs;

  List<SubCategory> subCategory= <SubCategory>[];
  List<Product> products= <Product>[];

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  getData(){
    if(homeController.categories.isNotEmpty){
      selectSubCategory(homeController.categories.first.categorySlug,0);
    }
  }

  selectSubCategory(String categorySlug,int categoryIndex)async{
    await Api.hasInternet();
    selectedCategory.value = categoryIndex;
    subCategoryLoading.value =true;
    // subCategory = await Api.subCategoryByCategory(categorySlug);
    subCategory = homeController.categories[categoryIndex].subCategories;
    if(subCategory.isNotEmpty){
      selectProduct(0);
    }else{
      products.clear();
    }
    subCategoryLoading.value =false;
  }

  selectProduct(int index)async{
    await Api.hasInternet();
    selectedSubCategory.value = index;
    productLoading.value =true;
    products = (await Api.filter(
      categories: [],
      brands: [],
      lazy_load: null,
      limit: null,
      products: [],
      sort: null,
      sub_categories: [subCategory[index].subCategorySlug],
      option: "and",
      min_price: null,
      max_price: null
    )).products;
    productLoading.value =false;
  }

}
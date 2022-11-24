import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/model/product.dart';

class ProductDetailsController extends GetxController{

  RxString title = "".obs;

  Product? product;
  RxBool loading = false.obs;

  RxBool optionLoading = false.obs;
  RxBool reviewLoading = false.obs;
  RxBool cartLoading = false.obs;

  ///initial values
  RxInt activeSlider = 0.obs;
  String selectedRam="";
  String selectedHard="";
  String selectedAdditionalOption="";
  int selectedColorId=-1;
  RxInt cartCounter=1.obs;
  RxBool veiwMore = false.obs;
  TextEditingController review = TextEditingController();

  Future<void> getData(String slug)async{
    loading.value = true;
    product = await Api.productDetails(slug);
    if(product == null){
      Get.back();
    }else{
      title.value = product!.title;
      initValues();
    }
    loading.value = false;
  }

  initValues(){
    activeSlider.value = 0;
    selectedRam="";
    selectedHard="";
    selectedAdditionalOption="";
    selectedColorId=-1;
    review.clear();
    reviewLoading.value = false;
    optionLoading.value = false;
    loading.value = false;
    cartLoading.value = false;
    cartCounter.value = 1;
    for(var elm in product!.rams){
      if(elm.selected.value){
        selectedRam = elm.ram;
        break;
      }
    }

    for(var elm in product!.hards){
      if(elm.selected.value){
        selectedHard = elm.hard;
        break;
      }
    }

    for(var elm in product!.additionatlOptions){
      if(elm.selected.value){
        selectedAdditionalOption = elm.additionatlOption;
        break;
      }
    }

    for(var elm in product!.colors){
      if(elm.selected.value){
        selectedColorId = elm.colorId;
        break;
      }
    }
  }

  updateOption()async{
    optionLoading.value = true;
    Option? option = await Api.selectOption(
        selectedHard,
        selectedRam,
        selectedAdditionalOption,
        selectedColorId,
        product!.languageParent);
    if(option != null){
      product!.option = option;
      activeSlider.value = 0;
    }
    optionLoading.value = false;
  }

  selectColor(int colorId){
    selectedColorId = colorId;
    for(var elm in product!.colors){
      elm.selected.value = false;
      if(elm.id==selectedColorId){
        elm.selected.value = true;
      }
    }
    updateOption();
  }

  selectRam(String ram){
    selectedRam = ram;
    for(var elm in product!.rams){
      elm.selected.value = false;
      if(elm.ram==selectedRam){
        elm.selected.value = true;
      }
    }
    updateOption();
  }

  selectHard(String hard){
    selectedHard = hard;
    for(var elm in product!.hards){
      elm.selected.value = false;
      if(elm.hard==selectedHard){
        elm.selected.value = true;
      }
    }
    updateOption();
  }

  selectAdditionalOption(String additional){
    selectedAdditionalOption = additional;
    for(var elm in product!.additionatlOptions){
      elm.selected.value = false;
      if(elm.additionatlOption==selectedAdditionalOption){
        elm.selected.value = true;
      }
    }
    updateOption();
  }

  addReview(BuildContext context)async{
    if(Global.customer == null){
      App.errMsg(context, "review", "please_login_first");
    }
    if(review.text.isNotEmpty){
      reviewLoading.value = true;
      var succ = await Api.addReview(review.text, product!.id);
      if(succ){
        Product? requestProduct = await Api.productDetails(product!.ProductSlug);
        if(requestProduct != null){
          product!.rateReview = requestProduct.rateReview;
        }
        reviewLoading.value = false;
      }

    }
  }

}
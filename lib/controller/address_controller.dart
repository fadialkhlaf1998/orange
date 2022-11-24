import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orange/helper/api.dart';
import 'package:orange/model/address.dart';

class AddressController extends GetxController{
  RxBool loading = false.obs;
  List<Address> address = <Address>[];

  RxBool validate = false.obs;
  RxBool fake = false.obs;
  TextEditingController nick_name = TextEditingController();
  TextEditingController stret_name = TextEditingController();
  TextEditingController building = TextEditingController();
  TextEditingController floor = TextEditingController();
  TextEditingController flat = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController addetional_description = TextEditingController();
  RxBool is_default = false.obs;
  String iso_code = "AE";
  String dail_code = "+971";

  clear(){
    nick_name.clear();
    stret_name.clear();
    building.clear();
    floor.clear();
    flat.clear();
    phone.clear();
    addetional_description.clear();
    is_default.value = false;
    iso_code = "AE";
    dail_code = "+971";
  }

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  getData()async{
    loading.value = true;
    //todo remove delay
    // await Future.delayed(Duration(milliseconds: 3000));
    address = await Api.getAddress();
    loading.value = false;
  }

  setDefault(int index)async{
    loading.value = true;
    print("set Default "+address[index].id.toString());
    await Api.setDefault(
        id: address[index].id);
    getData();
  }

  deleteAddress(int index)async{
    loading.value = true;
    await Api.deleteAddress(address[index].id);
    getData();
  }

  edit({
    required String nick_name,
    required String stret_name,
    required String building,
    required int floor,
    required int flat,
    required String phone,
    required String addetional_description,
    required int is_default,
    required String dail_code,
    required String iso_code,
    required int id,
  })async{
    loading.value = true;
    await Api.editAddress(
        nick_name: nick_name,
        stret_name: stret_name,
        building: building,
        floor: floor,
        flat: flat,
        phone: phone,
        addetional_description: addetional_description,
        is_default: is_default,
        dail_code: dail_code,
        iso_code: iso_code,
        id: id);
    getData();
  }

  add({
    required String nick_name,
    required String stret_name,
    required String building,
    required int floor,
    required int flat,
    required String phone,
    required String addetional_description,
    required int is_default,
    required String dail_code,
    required String iso_code,
  })async{
    loading.value = true;
    await Api.addAddress(
        nick_name: nick_name,
        stret_name: stret_name,
        building: building,
        floor: floor,
        flat: flat,
        phone: phone,
        addetional_description: addetional_description,
        is_default: is_default,
        dail_code: dail_code,
        iso_code: iso_code);
    getData();
  }

  AddEditAddress(bool isEdit , {int id = -1}){
    validate.value = true;
    if(nick_name.text.isNotEmpty&&
    stret_name.text.isNotEmpty&&
    building.text.isNotEmpty&&
    floor.text.isNotEmpty&&
    flat.text.isNotEmpty&&
    phone.text.isNotEmpty&&
    dail_code.isNotEmpty&&
    iso_code.isNotEmpty){
      Get.back();
      if(isEdit){
        edit(nick_name: nick_name.text,
            stret_name: stret_name.text,
            building: building.text,
            floor: int.parse(floor.text),
            flat: int.parse(flat.text),
            phone: phone.text,
            addetional_description: addetional_description.text,
            is_default: is_default.value?1:0,
            dail_code: dail_code, iso_code: iso_code,
            id: id);
      }else{
        add(nick_name: nick_name.text,
            stret_name: stret_name.text,
            building: building.text,
            floor: int.parse(floor.text),
            flat: int.parse(flat.text),
            phone: phone.text,
            addetional_description: addetional_description.text,
            is_default: is_default.value?1:0,
            dail_code: dail_code, iso_code: iso_code);
      }
    }
  }
}
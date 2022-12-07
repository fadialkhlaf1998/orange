import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:orange/app_localization.dart';
import 'package:orange/controller/address_controller.dart';
import 'package:orange/helper/app.dart';
import 'package:orange/model/address.dart';
import 'package:orange/widgets/primary_bottun.dart';
import 'package:orange/widgets/text_field.dart';

class AddAddress extends StatelessWidget {
  AddressController addressController = Get.find();
  Address? address;
  AddAddress({this.address}){
    addressController.validate.value = false;
    if(this.address != null){
        addressController.nick_name.text = this.address!.nickName;
        addressController.stret_name.text = this.address!.stretName;
        addressController.building.text = this.address!.building;
        addressController.floor.text = this.address!.floor.toString();
        addressController.flat.text = this.address!.flat.toString();
        addressController.phone.text = this.address!.phone;
        addressController.addetional_description.text = this.address!.addetionalDescription;
        addressController.is_default.value = this.address!.isDefault == 1 ?true:false;
        addressController.dail_code = this.address!.dailCode;
        addressController.iso_code = this.address!.isoCode;
    }else{
      addressController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: App.primary_mid,
      appBar: App.myHeader(context, height: 60, child: Center(
          child:  Container(
            width: Get.width*0.9,
            child: Row(
              children: [
                GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      child: Icon(Icons.arrow_back_ios,color: App.primary),
                    )
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                    },
                    child: Container(
                      height: 40,

                      decoration: BoxDecoration(
                        // color: App.grey,
                          borderRadius: BorderRadius.circular(25)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(App_Localization.of(context).translate("address"),style: TextStyle(color: App.primary,fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                GestureDetector(
                    onTap: (){

                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      child: SvgPicture.asset("assets/icons/stroke/Bag_orange.svg",color: Colors.transparent,),
                    )
                )
              ],
            ),
          )
      ),),

      body: SingleChildScrollView(
        child: Obx(()=>Column(
          children: [
            SizedBox(height: 20,),
            addressController.fake.value?Center():Center(),
            MyTextField(
                width: Get.width * 0.9,
                height: 50,
                controller: addressController.nick_name,
                validate: (addressController.nick_name.text.isEmpty && addressController.validate.value).obs,
                label: "nick_name",
                onChanged: (value){
                  addressController.fake.value = ! addressController.fake.value;
                }
            ),
            SizedBox(height: 15,),
            MyTextField(
                width: Get.width * 0.9,
                height: 50,
                controller: addressController.stret_name,
                validate: (addressController.stret_name.text.isEmpty && addressController.validate.value).obs,
                label: "stret_name",
                onChanged: (value){
                  addressController.fake.value = ! addressController.fake.value;
                }
            ),
            SizedBox(height: 15,),
            MyTextField(
                width: Get.width * 0.9,
                height: 50,
                controller: addressController.building,
                validate: (addressController.building.text.isEmpty && addressController.validate.value).obs,
                label: "building",
                onChanged: (value){
                  addressController.fake.value = ! addressController.fake.value;
                }
            ),
            SizedBox(height: 15,),
            Container(
              width: Get.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  MyTextField(
                      width: Get.width * 0.4,
                      keyboardType: TextInputType.number,
                      height: 50,
                      controller: addressController.floor,
                      validate: (addressController.floor.text.isEmpty && addressController.validate.value).obs,
                      label: "floor",
                      onChanged: (value){
                        addressController.fake.value = ! addressController.fake.value;
                      }
                  ),
                  MyTextField(
                      width: Get.width * 0.4,
                      keyboardType: TextInputType.number,
                      height: 50,
                      controller: addressController.flat,
                      validate: (addressController.flat.text.isEmpty && addressController.validate.value).obs,
                      label: "flat",
                      onChanged: (value){
                        addressController.fake.value = ! addressController.fake.value;
                      }
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),

            Container(
              width: Get.width*0.9,
              height: 50,
              child: InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  print(number.dialCode);
                  print(number.isoCode);
                  addressController.iso_code = number.isoCode!;
                  addressController.dail_code = number.dialCode!;
                },
                onInputValidated: (bool value) {
                  print(value);
                },
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: TextStyle(color: Colors.black),
                initialValue: address == null?
                PhoneNumber(dialCode: "+971",isoCode: "AE")
                :PhoneNumber(dialCode: address!.dailCode,isoCode: address!.dailCode,phoneNumber: address!.phone),
                textFieldController: addressController.phone,
                formatInput: false,
                keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: true),
                maxLength: 9,
                inputDecoration: InputDecoration(
                  label: Text(App_Localization.of(context).translate("phone")),
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: addressController.phone.text.isEmpty&&addressController.validate.value
                      ?OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)
                  )
                      :OutlineInputBorder(
                      borderSide: BorderSide(color: App.grey)
                  ),
                  enabledBorder: addressController.phone.text.isEmpty&&addressController.validate.value
                      ?OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)
                  )
                      :OutlineInputBorder(
                      borderSide: BorderSide(color: App.grey)
                  ),
                ),
                
                inputBorder:addressController.phone.text.isEmpty&&addressController.validate.value
                  ?OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)
                  )
                    :OutlineInputBorder(
                      borderSide: BorderSide(color: App.grey)
                  ),
                onSaved: (PhoneNumber number) {
                  print('On Saved: $number');
                },
                onSubmit: (){
                  print('****');
                },
              ),
            ),

            SizedBox(height: 15,),
            MyTextField(
                width: Get.width * 0.9,
                height: 55,
                controller: addressController.addetional_description,
                validate: (false).obs,
                label: "additional_description",
                onChanged: (value){
                  addressController.fake.value = ! addressController.fake.value;
                }
            ),
            SizedBox(height: 15,),
            Container(
              width: Get.width*0.9,
              child: Row(
                children: [
                  Checkbox(value: addressController.is_default.value, onChanged: (value){
                    addressController.is_default.value = value!;
                  }),
                  Text(App_Localization.of(context).translate("default"))
                ],
              ),
            ),
            SizedBox(height: 15,),
            PrimaryBottun(width: Get.width*0.5, height: 40,
              onPressed: (){
              if(address == null){
                addressController.AddEditAddress(false);
              }else{
                addressController.AddEditAddress(true , id:address!.id);
              }
            }, color: Colors.white, text: "submit",linearGradient: App.linearGradient,)
          ],
        ),)
      ),
    );
  }
}

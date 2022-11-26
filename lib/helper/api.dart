import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:orange/helper/global.dart';
import 'package:orange/helper/store.dart';
import 'package:orange/model/address.dart';
import 'package:orange/model/cart.dart';
import 'package:orange/model/customer.dart';
import 'package:orange/model/filter_result.dart';
import 'package:orange/model/line_items.dart';
import 'package:orange/model/order.dart';
import 'package:orange/model/product.dart';
import 'package:orange/model/result.dart';
import 'package:orange/model/start_up.dart';
import 'package:orange/model/sub_category.dart';
import 'package:orange/view/no_internet.dart';

class Api{

  static String url = "https://phpstack-548447-2989628.cloudwaysapps.com";
  static String media_url = url+"/uploads/";
  static String token = "";

  static Future<StartUpDecoder?> startUp(String locale,int customerId)async{
    var request = http.Request('GET', Uri.parse(url+'/api/start-up/$locale/$customerId'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = (await response.stream.bytesToString());
      return StartUpDecoder.fromJson(data);
    }
    else {
      print(response.reasonPhrase);
      return null;
    }
  }

  static Future<Result> login(String email,String password)async{
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse(url+'/api/customer/login'));
    request.body = json.encode({
      "email": email,
      "password": password
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = (await response.stream.bytesToString());
      print(data);
      Store.saveLoginInfo(email, password);
      Global.customer = CustomerDecoder.fromJson(data).customer;
      token = Global.customer!.token;
      return Result(code: 1,message: "login_successfully");
    }
    else {
      print(response.reasonPhrase);
      Global.customer = null;
      token = "";
      String data = (await response.stream.bytesToString());
      Result result = Result.fromJson(data);
      if(result.code == -10 ){
        Store.saveLoginInfo(email, password);
        return Result(code: -10,message: "account_not_verified");
      }else{
        return Result(code: -1,message: "wrong_login_info");
      }
    }
  }

  static Future<bool> signup(String name,String email,String password, int is_active)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(url+'/api/customer/signup'));
    request.body = json.encode({
      "name": name,
      "email": email,
      "password": password,
      "is_active": is_active
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Store.saveLoginInfo(email, password);
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }
  static Future<bool> verivicationCode(String code,String email)async{
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse(url+'/api/customer/verification-code'));
    request.body = json.encode({
      "email": email,
      "code": code
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = (await response.stream.bytesToString());
      Global.customer = CustomerDecoder.fromJson(data).customer;
      token = Global.customer!.token;
      return true;
    }
    else {
    print(response.reasonPhrase);
    return false;
    }
  }

  static Future<bool> resendCode(String email)async{
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse(url+'/api/customer/resend-code'));
    request.body = json.encode({
      "email": email
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
     print(response.reasonPhrase);
     return false;
    }
  }

  static Future<bool> forgot_password(String email)async{
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse(url+'/api/customer/forgot-password'));
    request.body = json.encode({
      "email": email
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }

  static Future<List<SubCategory>> subCategoryByCategory(String slug)async{
    var request = http.Request('GET', Uri.parse(url+'/api/sub-category/${Global.locale}/$slug'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = (await response.stream.bytesToString());
      return SubCategoryDecoder.fromJson(data).sub_categories;
    }
    else {
      print(response.reasonPhrase);
      return <SubCategory>[];
    }
  }

  static Future<FilterResult> filter({
    required List<String> categories,required List<String> brands,required List<String> sub_categories,
    required List<String> products,
    required int? sort,
    required int? lazy_load,
    required int? limit,
    required String option
    })async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(url+'/api/filter'));
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }
    request.body = json.encode({
      "categories": categories,
      "brands": brands,
      "sub_categories": sub_categories,
      "products": products,
      "sort": sort,
      "lazy_load": lazy_load,
      "limit": limit,
      "locale": Global.locale,
      "option":option,
      "customer_id":customer_id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = (await response.stream.bytesToString());
      return FilterResult.fromJson(data);
    }
    else {
      print(response.reasonPhrase);
      return FilterResult(filter: Filter(categories: [], brands: [], subCategories: [],
          products: [], sort: null, limit: null, lazyLoad: null, locale: "en",
          customerId: -1,option: "and"), products: [],);
    }

  }

  static Future<List<Product>> getWishlist()async{
    var headers = {
      'Authorization': 'Barear '+token,
    };
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }else{
      return <Product>[];
    }
    var request = http.Request('GET', Uri.parse(url+'/api/wishlist/${Global.locale}/$customer_id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = (await response.stream.bytesToString());
      return ProductListDecoder.fromJson(data).products;
    }
    else {
      print(response.reasonPhrase);
      return <Product>[];
    }

  }

  static Future<bool> addToWishlist(int product_id)async{
    var headers = {
      'Authorization': 'Barear '+token,
      'Content-Type': 'application/json',
    };
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }else{
      return false;
    }
    var request = http.Request('POST', Uri.parse(url+'/api/wishlist'));
    request.body = json.encode({
      "product_id": product_id,
      "customer_id": customer_id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
    print(response.reasonPhrase);
      return false;
    }
  }

  static Future<bool> deleteFromWishlist(int product_id)async{
    var headers = {
      'Authorization': 'Barear '+token,
      'Content-Type': 'application/json',
    };
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }else{
      return false;
    }
    var request = http.Request('DELETE', Uri.parse(url+'/api/wishlist/by-product-id'));
    request.body = json.encode({
      "customer_id": customer_id,
      "product_id": product_id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }

  static Future<Product?> productDetails(String slug)async{
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }
    var request = http.Request('GET', Uri.parse(url+'/api/product-details/${Global.locale}/$slug/$customer_id'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = (await response.stream.bytesToString());
      print(data);
      return ProductDecoder.fromJson(data).product;
    }
    else {
      print(response.reasonPhrase);
      return null;
    }

  }

  static Future<Option?> selectOption(String hard,String ram,String additional_option,int color_id,int product_id)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(url+'/api/product-option'));
    request.body = json.encode({
      "hard": hard,
      "ram": ram,
      "additionatl_option": additional_option,
      "color_id": color_id,
      "product_id": product_id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = (await response.stream.bytesToString());
      return Option.fromMap(json.decode(data)["option"]);
    }
    else {
    print(response.reasonPhrase);
    return null;
    }
  }

  static addRate(double rate , int product_id)async{
    var headers = {
      'Authorization': 'Barear '+token,
      'Content-Type': 'application/json',
    };
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }else{
      return false;
    }
    var request = http.Request('POST', Uri.parse(url+'/api/rate-review/rate'));
    request.body = json.encode({
      "rate": rate,
      "customer_id": customer_id,
      "product_id": product_id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }

  static addReview(String review , int product_id)async{
    var headers = {
      'Authorization': 'Barear '+token,
      'Content-Type': 'application/json',
    };
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }else{
      return false;
    }
    var request = http.Request('POST', Uri.parse(url+'/api/rate-review/review'));
    request.body = json.encode({
      "review": review,
      "customer_id": customer_id,
      "product_id": product_id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }

  }

  static Future<CartModel?> getCart()async{
    var headers = {
      'Authorization': 'Barear '+token,
    };
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }else{
      return null;
    }
    var request = http.Request('GET', Uri.parse(url+'/api/cart/${Global.locale}/$customer_id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = (await response.stream.bytesToString());
      return CartModel.fromJson(data);
    }
    else {
      print(response.reasonPhrase);
      return null;
    }
  }

  static Future<bool> addToCart(int option_id,int count)async{
    var headers = {
      'Authorization': 'Barear '+token,
      'Content-Type': 'application/json',
    };
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }else{
      return false;
    }
    var request = http.Request('POST', Uri.parse(url+'/api/cart'));
    request.body = json.encode({
      "option_id": option_id,
      "customer_id": customer_id,
      "count": count
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = (await response.stream.bytesToString());
      Result result = Result.fromJson(data);
      if(result.code == 1){
        return true;
      }else{
        return false;
      }
    }
    else {
    print(response.reasonPhrase);
    return false;
    }

  }

  static Future<bool> deleteFromCart(int cart_id)async{
    var headers = {
      'Authorization': 'Barear '+token,
      'Content-Type': 'application/json',
    };
    var request = http.Request('DELETE', Uri.parse(url+'/api/cart'));
    request.body = json.encode({
      "id": cart_id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
    print(response.reasonPhrase);
    return false;
    }

  }


  static Future<Result> activateCode(String code)async{
    var headers = {
      'Authorization': 'Barear '+token,
      'Content-Type': 'application/json',
    };
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }else{
      return Result(code: -10, message: "please_login_first");
    }
    var request = http.Request('POST', Uri.parse(url+'/api/discount-code-activation'));
    request.body = json.encode({
      "code": code,
      "customer_id": customer_id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = (await response.stream.bytesToString());
      Result result = Result.fromJson(data);
      if(result.code == 1){
        return Result(code: 1, message: "code_activated_successfully");
      }else{
        return Result(code: -1, message: "code_activated_previously");
      }
    }
    else {
      print(response.reasonPhrase);
      return Result(code: -1, message: "wrong");
    }

  }

  static Future<bool> selectImage(XFile file)async{
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }else{
      return false;
    }
    var headers = {
      'Authorization': 'Barear '+token,
    };
    var request = http.MultipartRequest('PUT', Uri.parse(url+'/api/customer/upload-image'));
    request.fields.addAll({
      'id': customer_id.toString()
    });
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
    return true;
    }
    else {
    print(response.reasonPhrase);
    return false;
    }

  }

  static Future<bool> deletePhoto()async{
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }else{
      return false;
    }
    var headers = {
      'Authorization': 'Barear '+token,
      'Content-Type': 'application/json',
    };
    var request = http.Request('DELETE', Uri.parse(url+'/api/customer/delete-photo'));
    request.body = json.encode({
      "id": customer_id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
    print(response.reasonPhrase);
    return false;
    }

  }

  static Future<bool> deleteAccount()async{
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }else{
      return false;
    }
    var headers = {
      'Authorization': 'Barear '+token,
      'Content-Type': 'application/json',
    };
    var request = http.Request('DELETE', Uri.parse(url+'/api/customer/delete-account'));
    request.body = json.encode({
      "id": customer_id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }

  static Future<bool> changePassword(String newPassword)async{
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }else{
      return false;
    }
    var headers = {
      'Authorization': 'Barear '+token,
      'Content-Type': 'application/json',
    };
    var request = http.Request('PUT', Uri.parse(url+'/api/customer/change-password'));
    request.body = json.encode({
      "password": newPassword,
      "id": customer_id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Store.saveLoginInfo(Global.customer!.email, newPassword);
      Global.customer!.password = newPassword;
      return true;
    }
    else {
    print(response.reasonPhrase);
    return false;
    }

  }

  static Future<List<Address>> getAddress()async{
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }else{
      return <Address>[];
    }
    var headers = {
      'Authorization': 'Barear '+token,
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET', Uri.parse(url+'/api/address/$customer_id'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = (await response.stream.bytesToString());
      return AddressDecoder.fromJson(data).address;
    }
    else {
    print(response.reasonPhrase);
    return <Address>[];
    }

  }

  static Future<bool> addAddress({
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
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }else{
      return false;
    }
    var headers = {
      'Authorization': 'Barear '+token,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(url+'/api/address'));
    request.body = json.encode({
      "nick_name": nick_name,
      "stret_name": stret_name,
      "building": building,
      "floor": floor,
      "flat": flat,
      "phone": phone,
      "addetional_description": addetional_description,
      "is_default": is_default,
      "dail_code": dail_code,
      "iso_code": iso_code,
      "customer_id": customer_id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
    print(response.reasonPhrase);
    return false;
    }

  }
  static Future<bool> editAddress({
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
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }else{
      return false;
    }
    var headers = {
      'Authorization': 'Barear '+token,
      'Content-Type': 'application/json'
    };
    var request = http.Request('PUT', Uri.parse(url+'/api/address'));
    request.body = json.encode({
      "nick_name": nick_name,
      "stret_name": stret_name,
      "building": building,
      "floor": floor,
      "flat": flat,
      "phone": phone,
      "addetional_description": addetional_description,
      "is_default": is_default,
      "dail_code": dail_code,
      "iso_code": iso_code,
      "customer_id": customer_id,
      "id":id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }

  }

  static Future<bool> setDefault({
    required int id,
  })async{
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }else{
      return false;
    }
    var headers = {
      'Authorization': 'Barear '+token,
      'Content-Type': 'application/json'
    };
    var request = http.Request('PUT', Uri.parse(url+'/api/address/set-default'));
    request.body = json.encode({

      "customer_id": customer_id,
      "id":id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }

  }

  static Future<bool> deleteAddress(int addressId)async{
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }else{
      return false;
    }
    var headers = {
      'Authorization': 'Barear '+token,
      'Content-Type': 'application/json',
    };
    var request = http.Request('DELETE', Uri.parse(url+'/api/address'));
    request.body = json.encode({
      "customer_id": customer_id,
      "id": addressId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
    print(response.reasonPhrase);
    return false;
    }

  }

  static Future<bool> hasInternet()async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      var succ = await Get.to(()=>NoInternet());
      return hasInternet();
    } else {
      return true;
    }
  }

  static Future<bool> addOrder(int addressId , int isPaid)async{
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }else{
      return false;
    }
    print('Customer'+ customer_id.toString());
    var headers = {
      'Authorization': 'Barear '+token,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(url+'/api/orders'));
    request.body = json.encode({
      "address_id": addressId,
      "customer_id": customer_id,
      "is_paid": isPaid,
      "transaction_id": ""
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
     print(response.reasonPhrase);
     return false;
    }
  }

  static Future<List<Order>> getCustomerOrders()async{
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }else{
      return <Order>[];
    }
    var headers = {
      'Authorization': 'Barear '+token
    };
    var request = http.Request('GET', Uri.parse(url+'/api/orders/${Global.locale}/$customer_id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = (await response.stream.bytesToString());
      return OrdersDecoder.fromJson(data).orders;
    }
    else {
      print(response.reasonPhrase);
      return <Order>[];
    }

  }

  static Future<Order?> getOrderDetails(int order_id)async{
    var headers = {
      'Authorization': 'Barear '+token
    };
    var request = http.Request('GET', Uri.parse(url+'/api/orders/order-details/${Global.locale}/$order_id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = (await response.stream.bytesToString());
      return Order.fromJson(data);
    }
    else {
      print(response.reasonPhrase);
      return null;
    }

  }

  static Future<bool> cancelOrder(int orderId)async{
    var headers = {
      'Authorization': 'Barear '+token
    };
    var request = http.Request('DELETE', Uri.parse(url+'/api/orders/cancel-order/$orderId'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }

  }

  static Future<List<LineItem>> getReturns()async{
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }else{
      return <LineItem>[];
    }
    var headers = {
      'Authorization': 'Barear '+token,
    };
    var request = http.Request('GET', Uri.parse(url+'/api/line-items/return/${Global.locale}/$customer_id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = (await response.stream.bytesToString());
      return LineItemsDecoder.fromJson(data).lineItems;
    }
    else {
      print(response.reasonPhrase);
      return <LineItem>[];
    }

  }

  static Future<bool> returnProduct(int order_id,int line_item_id,int return_count)async{
    int customer_id = -1;
    if(Global.customer != null){
      customer_id = Global.customer!.id;
    }else{
      return false;
    }
    var headers = {
      'Authorization': 'Barear '+token,
      'Content-Type': 'application/json',
    };
    var request = http.Request('PUT', Uri.parse(url+'/api/orders/return'));
    request.body = json.encode({
      "order_id": order_id,
      "customer_id": customer_id,
      "return_count": return_count,
      "line_items_id": line_item_id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }

  }

  static Future<bool> checkInterNet()async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
}
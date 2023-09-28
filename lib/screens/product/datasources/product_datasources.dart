import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_admin_dashboard/models/category_model.dart';
import 'package:smart_admin_dashboard/models/post_response_model.dart';
import 'package:smart_admin_dashboard/models/product_model.dart';
import 'package:smart_admin_dashboard/models/subcategory_model.dart';

Future<PostResponseModel> addProduct(
    {required String name,
    required String price,
    required List<int> image,
    required String unit,
    String subCategory = '',
    String imageName = '',
    String desc = '',
    String priceSale = '',
    String category = '',
    bool isFeatured = false,
    String productDetail = ''}) async {
  final request = http.MultipartRequest(
      'POST', Uri.parse('https://api.sevva.co.id/api/product/insert'));
  request.fields['name'] = name;
  request.fields['description'] = desc;
  request.fields['category'] = category;
  request.fields['subcategory'] = subCategory;
  request.fields['productDetail'] = productDetail;
  request.fields['priceOriginal'] = price;
  request.fields['priceSale'] = priceSale;
  request.fields['isDeleted'] = 'false';
  request.fields['unit'] = unit;
  request.fields['isFeaturedProduct'] = isFeatured.toString();
  request.files
      .add(http.MultipartFile.fromBytes('image', image, filename: imageName));

  var response = await request.send();
  var responsed = await http.Response.fromStream(response);
  if (response.statusCode == 200) {
    return PostResponseModel.fromJson(json.decode(responsed.body));
  } else {
    print(responsed.body);
    return PostResponseModel.fromJson(json.decode(responsed.body));
  }
}

Future<CategoryModel> getCategory() async {
  final response = await http
      .get(Uri.https('api.sevva.co.id', 'api/category/getall'), headers: {
    "Access-Control-Allow-Origin": "*",
    'Content-Type': 'application/json',
    'Accept': '*/*'
  });
  print(response.body);
  if (response.statusCode == 200) {
    return CategoryModel.fromJson(json.decode(response.body));
  } else
    throw Exception(response.body);
}

Future<SubCategoryModel> getSubCategory(String category) async {
  final response = await http.get(Uri.parse(
      'https://api.sevva.co.id/api/subcategory/getallbycategory/$category'));
  if (response.statusCode == 200) {
    return SubCategoryModel.fromJson(json.decode(response.body));
  } else
    throw Exception(response.body);
}

Future<PostResponseModel> addCategory({required String category}) async {
  var headers = {'Content-Type': 'application/json'};
  Map body = {'category': category};
  final response = await http.post(
      Uri.parse('https://api.sevva.co.id/api/category/insert'),
      headers: headers,
      body: json.encode(body));
  if (response.statusCode == 200) {
    return PostResponseModel.fromJson(json.decode(response.body));
  } else
    throw Exception(response.body);
}

Future<PostResponseModel> addSubCategory(
    {required String category, required String subcategory}) async {
  var headers = {'Content-Type': 'application/json'};
  Map body = {'category': category, 'subcategory': subcategory};
  final response = await http.post(
      Uri.parse('https://api.sevva.co.id/api/subcategory/insert'),
      headers: headers,
      body: json.encode(body));
  if (response.statusCode == 200) {
    return PostResponseModel.fromJson(json.decode(response.body));
  } else
    throw Exception(response.body);
}

Future<ProductModel> getProduct() async {
  final response = await http.get(
      Uri.parse('https://api.sevva.co.id/api/product?limit=500&offset=0'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      });
  print(response.body);
  if (response.statusCode == 200) {
    return ProductModel.fromJson(json.decode(response.body));
  } else
    throw Exception(response.body);
}

Future<PostResponseModel> updateProduct(
    {required int id,
    required String name,
    required String price,
    required bool changeImage,
    required List<int> image,
    required String unit,
    String subCategory = '',
    String imageName = '',
    String desc = '',
    String priceSale = '',
    String category = '',
    bool isFeatured = false,
    String productDetail = ''}) async {
  final request = http.MultipartRequest(
      'POST', Uri.parse('https://api.sevva.co.id/api/product/update'));
  request.fields['name'] = name;
  request.fields['description'] = desc;
  request.fields['category'] = category;
  request.fields['subcategory'] = subCategory;
  request.fields['productDetail'] = productDetail;
  request.fields['priceOriginal'] = price;
  request.fields['priceSale'] = priceSale;
  request.fields['isDeleted'] = 'false';
  request.fields['unit'] = unit;
  request.fields['isFeaturedProduct'] = isFeatured.toString();
  if (changeImage)
    request.files
        .add(http.MultipartFile.fromBytes('image', image, filename: imageName));
  request.fields['id'] = id.toString();

  var response = await request.send();
  var responsed = await http.Response.fromStream(response);
  if (response.statusCode == 200) {
    return PostResponseModel.fromJson(json.decode(responsed.body));
  } else {
    print(responsed.body);
    return PostResponseModel.fromJson(json.decode(responsed.body));
  }
}

Future<PostResponseModel> deleteProduct({required Product product}) async {
  var headers = {'Content-Type': 'application/json'};
  Map body = {
    'name': product.name,
    'description': product.description,
    'productDetail': product.productDetail,
    'category': product.category,
    'subcategory': product.subcategory,
    'priceOriginal': product.priceOriginal,
    'priceSale': product.priceSale,
    'isFeaturedProduct': product.isFeatured,
    'unit': product.unit,
    'id': product.id,
    'isDeleted': true
  };
  final response = await http.post(
      Uri.parse('https://api.sevva.co.id/api/product/update'),
      headers: headers,
      body: json.encode(body));
  if (response.statusCode == 200) {
    return PostResponseModel.fromJson(json.decode(response.body));
  } else
    throw Exception(response.body);
}

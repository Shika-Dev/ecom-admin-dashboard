import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

@JsonSerializable()
class ProductModel extends Equatable{
  final List<Product> data;
  final ErrorModel errors;

  ProductModel({required this.data, required this.errors});

  factory ProductModel.fromJson(Map<String, dynamic> json)=>
      ProductModel(
          data: (json['data'] as List).map((e) => Product.fromJson(e)).toList(),
          errors: ErrorModel.fromJson(json['errors']));

  @override
  List<Object?> get props => [data, errors];
}

@JsonSerializable()
class Product extends Equatable{
  final int id;
  final String name;
  final String description;
  final String productDetail;
  final String imageUrl;
  final String unit;
  final int priceOriginal;
  final int priceSale;
  final bool isFeatured;
  final String category;
  final String subcategory;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.priceOriginal,
    required this.isFeatured,
    required this.unit,
    required this.priceSale,
    required this.productDetail,
    required this.category,
    required this.subcategory
  });

  factory Product.fromJson(Map<String, dynamic> json)=>
      Product(
          id: json['id'],
        name: json['name'],
        description: json['description'],
        productDetail: json['productDetail'],
        priceOriginal: json['priceOriginal'],
        priceSale: json['priceSale'],
        imageUrl: json['imageUrl'],
        unit: json['unit'],
        isFeatured: json['isFeaturedProduct'],
        category: json['category'],
        subcategory: json['subcategory']
      );

  @override
  List<Object?> get props => [id, name, description,productDetail, priceOriginal, priceSale, imageUrl, unit, isFeatured];
}

@JsonSerializable()
class ErrorModel extends Equatable{
  final int? errorCode;
  final String? errorMessage;

  ErrorModel({this.errorCode, this.errorMessage});

  factory ErrorModel.fromJson(Map<String, dynamic> json)=>
      ErrorModel(errorCode: json['errorCode'], errorMessage: json['errorMessage']);

  @override
  List<Object?> get props => [errorCode, errorMessage];
}
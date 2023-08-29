import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

@JsonSerializable()
class SubCategoryModel extends Equatable{
  final ListSubCategory data;
  final ErrorModel errors;

  SubCategoryModel({required this.data, required this.errors});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json)=>
      SubCategoryModel(data: ListSubCategory.fromJson(json['data']), errors: ErrorModel.fromJson(json['errors']));

  @override
  List<Object?> get props => [data, errors];
}

@JsonSerializable()
class ListSubCategory extends Equatable{
  final List<SubCategory> subcategories;

  ListSubCategory({required this.subcategories});

  factory ListSubCategory.fromJson(Map<String, dynamic> json)=>
      ListSubCategory(subcategories: (json['subcategories'] as List).map((e) => SubCategory.fromJson(e)).toList());

  @override
  List<Object?> get props => [subcategories];
}

@JsonSerializable()
class SubCategory extends Equatable{
  final String subcategory;

  SubCategory({required this.subcategory});

  factory SubCategory.fromJson(Map<String, dynamic> json)=>
      SubCategory(subcategory: json['subcategory']);

  @override
  List<Object?> get props => [subcategory];
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
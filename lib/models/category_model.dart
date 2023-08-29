import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

@JsonSerializable()
class CategoryModel extends Equatable{
  final ListCategory data;
  final ErrorModel errors;

  CategoryModel({required this.data, required this.errors});

  factory CategoryModel.fromJson(Map<String, dynamic> json)=>
      CategoryModel(data: ListCategory.fromJson(json['data']), errors: ErrorModel.fromJson(json['errors']));

  @override
  List<Object?> get props => [data, errors];
}

@JsonSerializable()
class ListCategory extends Equatable{
  final List<Category> categories;

  ListCategory({required this.categories});

  factory ListCategory.fromJson(Map<String, dynamic> json)=>
      ListCategory(categories: (json['categories'] as List).map((e) => Category.fromJson(e)).toList());

  @override
  List<Object?> get props => [categories];
}

@JsonSerializable()
class Category extends Equatable{
  final String category;

  Category({required this.category});

  factory Category.fromJson(Map<String, dynamic> json)=>
      Category(category: json['category']);

  @override
  List<Object?> get props => [category];
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
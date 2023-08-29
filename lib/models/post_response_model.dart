import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

@JsonSerializable()
class PostResponseModel extends Equatable{
  final dynamic data;
  final ErrorModel errors;

  PostResponseModel({required this.data, required this.errors});

  factory PostResponseModel.fromJson(Map<String, dynamic> json)=>
      PostResponseModel(data: json['data'], errors: ErrorModel.fromJson(json['errors']));

  @override
  List<Object?> get props => [data, errors];
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
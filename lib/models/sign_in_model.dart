import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class SignInModel extends Equatable {
  const SignInModel({this.errors, this.data});

  final ErrorModel? errors;
  final SignInData? data;

  factory SignInModel.fromJson(Map<String, dynamic> json) => SignInModel(
      data: SignInData.fromJson(json['data']),
      errors: ErrorModel.fromJson(json['errors']));

  @override
  List<Object?> get props => [data, errors];
}

@JsonSerializable()
class SignInData extends Equatable {
  const SignInData({required this.token});
  final TokenData token;

  factory SignInData.fromJson(Map<String, dynamic> json) =>
      SignInData(token: TokenData.fromJson(json['token']));

  @override
  List<Object?> get props => [token];
}

@JsonSerializable()
class TokenData extends Equatable {
  const TokenData({required this.token});

  final String token;

  factory TokenData.fromJson(Map<String, dynamic> json) =>
      TokenData(token: json['token']);

  @override
  List<Object?> get props => [token];
}

@JsonSerializable()
class ErrorModel extends Equatable {
  final int? errorCode;
  final String? errorMessage;

  ErrorModel({this.errorCode, this.errorMessage});

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
      errorCode: json['errorCode'], errorMessage: json['errorMessage']);

  @override
  List<Object?> get props => [errorCode, errorMessage];
}

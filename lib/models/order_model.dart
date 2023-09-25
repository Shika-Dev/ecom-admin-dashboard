import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class OrderModel extends Equatable {
  final OrderData data;
  final ErrorModel errors;

  OrderModel({required this.data, required this.errors});

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
      data: OrderData.fromJson(json['data']),
      errors: ErrorModel.fromJson(json['errors']));

  @override
  List<Object?> get props => [data, errors];
}

@JsonSerializable()
class OrderData extends Equatable {
  final List<Order> orders;
  final int totalRows;

  OrderData({required this.orders, required this.totalRows});

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
        orders: (json['orders'] as List).map((e) => Order.fromJson(e)).toList(),
        totalRows: json['totalRows'],
      );

  @override
  List<Object?> get props => [orders, totalRows];
}

@JsonSerializable()
class Order extends Equatable {
  final int userId;
  final List<Product> productList;
  final String clientName;
  final String eventStartDate;
  final String eventEndDate;
  final String phoneNo;
  final String address;
  final String orderStatus;
  final int totalOrderPrice;

  Order(
      {required this.userId,
      required this.clientName,
      required this.productList,
      required this.address,
      required this.orderStatus,
      required this.phoneNo,
      required this.totalOrderPrice,
      required this.eventStartDate,
      required this.eventEndDate});

  factory Order.fromJson(Map<String, dynamic> json) => Order(
      userId: json['userId'],
      clientName: json['clientName'],
      productList: (json['productList'] as List)
          .map((e) => Product.fromJson(e))
          .toList(),
      address: json['address'],
      eventStartDate: json['eventStartDate'],
      eventEndDate: json['eventEndDate'],
      orderStatus: json['orderStatus'],
      phoneNo: json['phoneNo'],
      totalOrderPrice: json['totalOrderPrice']);

  @override
  List<Object?> get props => [
        userId,
        productList,
        clientName,
        address,
        orderStatus,
        phoneNo,
        totalOrderPrice
      ];
}

@JsonSerializable()
class Product extends Equatable {
  final int productId;
  final int qty;
  final String name;
  final int priceOriginal;
  final int priceSale;

  Product(
      {required this.name,
      required this.productId,
      required this.qty,
      required this.priceOriginal,
      required this.priceSale});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      name: json['name'],
      productId: json['id'],
      qty: json['qty'],
      priceOriginal: json['priceOriginal'],
      priceSale: json['priceSale']);

  @override
  List<Object?> get props => [
        name,
        productId,
        qty,
        priceOriginal,
        priceSale,
      ];
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

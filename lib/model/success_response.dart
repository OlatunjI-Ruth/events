// To parse this JSON data, do
//
//     final purchaseResponseModel = purchaseResponseModelFromJson(jsonString);

import 'dart:convert';

PurchaseResponseModel purchaseResponseModelFromJson(String str) =>
    PurchaseResponseModel.fromJson(json.decode(str));

String purchaseResponseModelToJson(PurchaseResponseModel data) =>
    json.encode(data.toJson());

class PurchaseResponseModel {
  String? status;
  String? message;

  PurchaseResponseModel({
    this.status,
    this.message,
  });

  factory PurchaseResponseModel.fromJson(Map<String, dynamic> json) =>
      PurchaseResponseModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}

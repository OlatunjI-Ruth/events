// To parse this JSON data, do
//
//     final ticketModel = ticketModelFromJson(jsonString);

import 'dart:convert';

TicketModel ticketModelFromJson(String str) =>
    TicketModel.fromJson(json.decode(str));

String ticketModelToJson(TicketModel data) => json.encode(data.toJson());

class TicketModel {
  String? status;
  String? message;
  List<Datum>? data;

  TicketModel({
    this.status,
    this.message,
    this.data,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? id;
  String? name;
  String? location;
  DateTime? date;
  double? price;
  String? imagePath; // New field

  Datum({
    this.id,
    this.name,
    this.location,
    this.date,
    this.price,
    this.imagePath,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        location: json["location"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        price: json["price"]?.toDouble(),
        imagePath: json["imagePath"], // Include this if provided
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "location": location,
        "date": date?.toIso8601String().split('T').first,
        "price": price,
        "imagePath": imagePath,
      };
}

// To parse this JSON data, do
//
//     final reviews = reviewsFromJson(jsonString);

import 'dart:convert';

List<Reviews> reviewsFromJson(String str) => List<Reviews>.from(json.decode(str).map((x) => Reviews.fromJson(x)));

String reviewsToJson(List<Reviews> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reviews {
  String model;
  int pk;
  Fields fields;

  Reviews({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
    model: json["model"],
    pk: json["pk"],
    fields: Fields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "model": model,
    "pk": pk,
    "fields": fields.toJson(),
  };
}

class Fields {
  int user;
  int product;
  int ratings;
  String comments;

  Fields({
    required this.user,
    required this.product,
    required this.ratings,
    required this.comments,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    user: json["user"],
    product: json["product"],
    ratings: json["ratings"],
    comments: json["comments"],
  );

  Map<String, dynamic> toJson() => {
    "user": user,
    "product": product,
    "ratings": ratings,
    "comments": comments,
  };
}

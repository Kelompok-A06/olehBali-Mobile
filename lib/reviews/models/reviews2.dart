// To parse this JSON data, do
//
//     final reviews2 = reviews2FromJson(jsonString);

import 'dart:convert';

List<Reviews2> reviews2FromJson(String str) => List<Reviews2>.from(json.decode(str).map((x) => Reviews2.fromJson(x)));

String reviews2ToJson(List<Reviews2> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reviews2 {
  int id;
  int ratings;
  String comments;
  String username;

  Reviews2({
    required this.id,
    required this.ratings,
    required this.comments,
    required this.username,
  });

  factory Reviews2.fromJson(Map<String, dynamic> json) => Reviews2(
    id: json["id"],
    ratings: json["ratings"],
    comments: json["comments"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ratings": ratings,
    "comments": comments,
    "username": username,
  };
}

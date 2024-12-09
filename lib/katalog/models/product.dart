// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  String model;
  int pk;
  Fields fields;

  Product({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
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
  String nama;
  String kategori;
  int harga;
  String toko;
  String alamat;
  String deskripsi;
  String gambar;
  String gambarFile;

  Fields({
    required this.nama,
    required this.kategori,
    required this.harga,
    required this.toko,
    required this.alamat,
    required this.deskripsi,
    required this.gambar,
    required this.gambarFile,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        nama: json["nama"],
        kategori: json["kategori"],
        harga: json["harga"],
        toko: json["toko"],
        alamat: json["alamat"],
        deskripsi: json["deskripsi"],
        gambar: json["gambar"],
        gambarFile: json["gambar_file"],
      );

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "kategori": kategori,
        "harga": harga,
        "toko": toko,
        "alamat": alamat,
        "deskripsi": deskripsi,
        "gambar": gambar,
        "gambar_file": gambarFile,
      };
}

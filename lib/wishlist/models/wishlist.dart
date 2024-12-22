// To parse this JSON data, do
//
//     final wishlist = wishlistFromJson(jsonString);

import 'dart:convert';

Wishlist wishlistFromJson(String str) => Wishlist.fromJson(json.decode(str));

String wishlistToJson(Wishlist data) => json.encode(data.toJson());

class Wishlist {
    List<WishlistItem> wishlistItems;

    Wishlist({
        required this.wishlistItems,
    });

    factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
        wishlistItems: List<WishlistItem>.from(json["wishlist_items"].map((x) => WishlistItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "wishlist_items": List<dynamic>.from(wishlistItems.map((x) => x.toJson())),
    };
}

class WishlistItem {
    int id;
    String nama;
    String toko;
    int harga;
    String gambar;

    WishlistItem({
        required this.id,
        required this.nama,
        required this.toko,
        required this.harga,
        required this.gambar,
    });

    factory WishlistItem.fromJson(Map<String, dynamic> json) => WishlistItem(
        id: json["id"],
        nama: json["nama"],
        toko: json["toko"],
        harga: json["harga"],
        gambar: json["gambar"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "toko": toko,
        "harga": harga,
        "gambar": gambar,
    };
}

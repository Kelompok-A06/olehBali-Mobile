// lib/wishlist/screens/wishlist_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:olehbali_mobile/widgets/left_drawer.dart';
import 'package:olehbali_mobile/wishlist/models/wishlist.dart';
import 'package:olehbali_mobile/wishlist/widgets/wishlist_item.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:olehbali_mobile/katalog/screens/katalog_screen.dart';


class WishlistScreen extends StatefulWidget {

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late Future<Wishlist> _futureWishlist;

  @override
  void initState() {
    super.initState();
  }

  Future<Wishlist> fetchWishlist(BuildContext context) async {
    final request = context.read<CookieRequest>();
    final response = await request.get(
      "https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/wishlist/json/show_wishlist/",
    );

    if (response["wishlist_items"] != null) {
      return wishlistFromJson(json.encode(response));
    } else {
      throw Exception(response["message"] ?? 'Failed to load wishlist');
    }
  }


  Future<void> deleteWishlistItem(BuildContext context, int productId) async {
  final request = context.read<CookieRequest>();
  
  Map<String, dynamic> data = {
    "product_id": productId.toString(),
  };
  
  final response = await request.postJson(
    "https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/wishlist/json/delete_wishlist_flutter", 
     jsonEncode(data),
  );

  if (response["status"] == "success") {

    setState(() {
      _futureWishlist = fetchWishlist(context); 
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Produk berhasil dihapus dari wishlist')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response["message"] ?? 'Terjadi kesalahan saat menghapus produk')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    // Initialize _futureWishlist here to have access to context
    _futureWishlist = fetchWishlist(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist Anda'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<Wishlist>(
        future: _futureWishlist,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.wishlistItems.isEmpty) {

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Wishlist Anda saat ini kosong.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CatalogPage(),
                        ),
                      );
                    },
                    child: Text('Lihat Produk'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Wishlist dengan item
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _futureWishlist = fetchWishlist(context);
                });
              },
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: snapshot.data!.wishlistItems.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data!.wishlistItems[index];
                  return WishlistItemWidget(
                    wishlistItem: item,
                    onDelete: () => deleteWishlistItem(context, item.id),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

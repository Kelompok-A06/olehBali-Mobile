import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:olehbali_mobile/widgets/left_drawer.dart';
import 'package:olehbali_mobile/wishlist/models/wishlist.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late Future<Wishlist> wishlistFuture;

  @override
  void initState() {
    super.initState();
    wishlistFuture = fetchWishlist();
  }

  Future<Wishlist> fetchWishlist() async {
    final response = await http.get(Uri.parse('https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/wishlist/show_wishlist_flutter'));

    if (response.statusCode == 200) {
      return Wishlist.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load wishlist');
    }
  }

  Future<void> deleteWishlistItem(int productId) async {
    final response = await http.post(
      Uri.parse('https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/wishlist/delete_wishlist_flutter'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'product_id': productId}),
    );

    if (response.statusCode == 200) {
      setState(() {
        wishlistFuture = fetchWishlist();
      });
    } else {
      final errorMessage = json.decode(response.body)['message'] ?? 'Failed to delete item';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Wishlist'),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<Wishlist>(
        future: wishlistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load wishlist: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.wishlistItems.isEmpty) {
            return EmptyWishlistWidget();
          } else {
            return WishlistItemsList(
              wishlistItems: snapshot.data!.wishlistItems,
              onDelete: deleteWishlistItem,
            );
          }
        },
      ),
    );
  }
}

class WishlistItemsList extends StatelessWidget {
  final List<WishlistItem> wishlistItems;
  final Function(int) onDelete;

  WishlistItemsList({required this.wishlistItems, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: wishlistItems.length,
      itemBuilder: (context, index) {
        final item = wishlistItems[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: Image.network(
              item.gambar,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            title: Text(item.nama, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${item.toko}\nRp ${item.harga}', maxLines: 2),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => onDelete(item.id),
            ),
          ),
        );
      },
    );
  }
}

class EmptyWishlistWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 100, color: Colors.grey),
          SizedBox(height: 20),
          Text('Your wishlist is empty.', style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigasi ke katalog produk
              Navigator.pushNamed(context, '/catalog');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text('Browse Products'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:olehbali_mobile/widgets/left_drawer.dart';
import 'package:olehbali_mobile/wishlist/models/wishlist.dart';
import 'package:olehbali_mobile/widgets/left_drawer.dart';
import 'package:olehbali_mobile/wishlist/models/wishlist.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WishlistItemWidget extends StatelessWidget {
  final WishlistItem wishlistItem;
  final VoidCallback onDelete;

  const WishlistItemWidget({
    Key? key,
    required this.wishlistItem,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Gambar Produk
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: wishlistItem.gambar,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error, size: 50, color: Colors.red),
              ),
            ),
            SizedBox(height: 10),
            // Nama Produk
            Text(
              wishlistItem.nama,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            // Toko
            Text(
              wishlistItem.toko,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 5),
            // Harga
            Text(
              'Rp ${wishlistItem.harga}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            // Tombol Hapus
            ElevatedButton(
              onPressed: onDelete,
              child: Text('Delete'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

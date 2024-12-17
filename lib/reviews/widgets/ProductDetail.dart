import 'package:flutter/material.dart';
import 'package:olehbali_mobile/katalog/models/product.dart';

class ProductDetail extends StatelessWidget {
  final Product product;
  final double averageRating;

  const ProductDetail({super.key, required this.product, required this.averageRating});

  @override
  Widget build(BuildContext context) {
    // Determine the image source (URL or local file path)
    String imageUrl = product.fields.gambar.isNotEmpty ? product.fields.gambar : product.fields.gambarFile;

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image (URL or placeholder if no image)
            imageUrl.isNotEmpty
                ? Image.network(imageUrl, width: double.infinity, height: 200, fit: BoxFit.cover)
                : Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[300],
              child: const Center(child: Icon(Icons.image, size: 50, color: Colors.white)),
            ),
            const SizedBox(height: 12),
            // Product Name
            Text(
              product.fields.nama,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Product Category
            Text(
              product.fields.kategori,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            // Shop Name
            Text(
              product.fields.toko,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Shop Address
            Text(
              product.fields.alamat,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            // Price
            Text(
              "Rp${product.fields.harga}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Average Rating (Single star symbol)
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  '$averageRating', // Show the average rating value as text
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
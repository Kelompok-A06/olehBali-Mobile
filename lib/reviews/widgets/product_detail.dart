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
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 3, 164, 193)
              ),
            ),
            const SizedBox(height: 4),
            Text(
                product.fields.deskripsi,
                style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            // Product Category
            const Text(
              "Kategori",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 254, 150, 66)
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.fields.kategori,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            // Nama Toko
            const Text(
              "Nama Toko",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 254, 150, 66)
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.fields.toko,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            // Alamat Toko
            const Text(
              "Alamat Toko",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 254, 150, 66)
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.fields.alamat,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            // Harga
            const Text(
              "Harga",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 254, 150, 66)
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Rp${product.fields.harga}",
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            // Rating
            const Text(
              "Rata-rata rating",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 254, 150, 66)
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  "$averageRating",
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.amber,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:olehbali_mobile/katalog/models/product.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../models/reviews2.dart';
import '../widgets/product_detail.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;
  final String productName;
  final Function() onUpdate;

  const ProductDetailPage({
    super.key,
    required this.productId,
    required this.productName,
    required this.onUpdate,
  });

  @override
  State<StatefulWidget> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Product? product;
  double averageRating = 0;

  Future<List<Reviews2>> fetchCurrentProductReviews(CookieRequest request) async {
    int productId = widget.productId;

    // Fetch informasi produk
    final response1 = await request.get('https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/product/api-product/$productId');
    var dataProduct = response1;
    averageRating = 0;
    if (dataProduct[0] != null) {
      product = Product.fromJson(dataProduct[0]);
    }

    // Fetch data review-review product
    final response2 = await request.get('https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/product/api/$productId');
    var data = response2;
    List<Reviews2> listReview = [];
    for (var d in data) {
      if (d != null) {
        Reviews2 review = Reviews2.fromJson(d);
        listReview.add(review);
        averageRating += review.ratings;
      }
    }
    if (averageRating > 0) {
      averageRating /= listReview.length;
    }

    return listReview;
  }

  void update() {
    setState(() {});
    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.productName} Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: fetchCurrentProductReviews(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    Flexible(
                      child: ProductDetail(
                        product: product!,
                        averageRating: averageRating,
                        onReviewSubmitted: update,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ProductDetail(
                      product: product!,
                      averageRating: averageRating,
                      onReviewSubmitted: update,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) {
                        var review = snapshot.data![index];
                        Map<String, dynamic> jsonData = request.getJsonData();
                        bool isCurrentUser = review.username == jsonData["username"];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review.username,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          review.comments,
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.shade100,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.star, size: 16, color: Colors.amber),
                                            const SizedBox(width: 4),
                                            Text(
                                              "${review.ratings}",
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.amber,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (isCurrentUser)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start, // Align buttons to the left
                                    children: [
                                      // Edit Button
                                      ElevatedButton(
                                        onPressed: () async {
                                          // Handle Edit button logic
                                          int reviewId = review.id;
                                          // Implement the editing logic (e.g., navigate to the edit form or show a dialog)
                                          // For example:
                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => EditReviewPage(reviewId: reviewId)));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue, // You can customize this color
                                        ),
                                        child: const Text("Edit", style: TextStyle(color: Colors.white)),
                                      ),
                                      const SizedBox(width: 8), // Space between buttons
                                      // Delete Button
                                      ElevatedButton(
                                        onPressed: () async {
                                          int reviewId = review.id;
                                          final response = await request.postJson(
                                            "https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/product/delete-flutter/",
                                            jsonEncode(<String, String>{
                                              "id": "$reviewId",
                                            }),
                                          );
                                          update(); // Call update to refresh the widget after deletion
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red, // Red color for delete button
                                        ),
                                        child: const Text("Delete", style: TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}

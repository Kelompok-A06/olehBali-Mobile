import 'package:flutter/material.dart';
import 'package:olehbali_mobile/reviews/screens/ProductDetailPage.dart';
import 'package:olehbali_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/reviews.dart';


class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<StatefulWidget> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage>{
  Future<List<Reviews>> fetchReviews(CookieRequest request) async {
    final response = await request.get('https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/product/api-flutter/');
    var data = response;
    List<Reviews> listReview = [];
    for (var d in data) {
      if (d != null) {
        listReview.add(Reviews.fromJson(d));
      }
    }
    return listReview;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reviews"),
        backgroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
          future: fetchReviews(request),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator(),);
            } else {
                if (snapshot.data!.isEmpty) {
                  return  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0), // Add horizontal padding
                        child: Text(
                          'Belum ada yang meninggalkan review untuk produk manapun. Jadilah yang pertama untuk menambahkannya!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 79, 71, 70),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 245, 245, 245),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Text(
                          'Ayo beri ulasan pertama!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 105, 70), // Bright accent color
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) {
                      var review = snapshot.data![index];
                      return InkWell(
                        onTap: () {
                          // Example: Navigate to a detailed view or perform some action
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(tempReview: review), // Placeholder navigation
                            ),
                          );
                        },
                        child: Container(
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
                                review.fields.productName,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'By: ${review.fields.username}',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black54,
                                  fontStyle: FontStyle.italic,
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
                                          review.fields.comments,
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
                                              "${review.fields.ratings}",
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
                              const SizedBox(height: 12),
                              Divider(color: Colors.grey.shade300),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'View Details',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.blue.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
            }
          }
      ),
    );
  }

}
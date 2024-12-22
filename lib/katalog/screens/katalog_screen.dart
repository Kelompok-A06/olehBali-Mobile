import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:olehbali_mobile/katalog/models/product.dart';
import 'package:olehbali_mobile/katalog/screens/addproduct_form.dart';
import 'package:olehbali_mobile/widgets/left_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import '../../reviews/screens/product_detail_page.dart';

class ProductService {
  static const String apiUrl =
      'https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/api';
  static const String catalogUrl =
      'https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/catalog';

  static String? currentUserRole;
  static String? currentUsername;

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Product>> fetchProductsByCategory(String category) async {
    final response = await http.get(Uri.parse('$apiUrl/category/$category'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Product>> fetchProductsBySearch(String searchQuery) async {
    final response = await http.get(Uri.parse('$apiUrl?search=$searchQuery'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<String> getCsrfToken() async {
    final response = await http.get(Uri.parse(catalogUrl));
    String? csrfToken = response.headers['set-cookie']
        ?.split(';')
        .firstWhere((cookie) => cookie.trim().startsWith('csrftoken='))
        .split('=')[1];
    return csrfToken ?? '';
  }

  Future<bool> deleteProduct(int productId) async {
    try {
      final csrfToken = await getCsrfToken();

      final response = await http.delete(
        Uri.parse('$apiUrl/delete_product/$productId/'),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': csrfToken,
          'Cookie': 'csrftoken=$csrfToken',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 403) {
        throw Exception('Permission denied. Please check your authentication.');
      } else {
        throw Exception('Failed to delete product: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> fetchCurrentUser() async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/user/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        currentUsername = userData['username'];
        currentUserRole = userData['role'];
      } else {
        currentUsername = null;
        currentUserRole = null;
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      currentUsername = null;
      currentUserRole = null;
      rethrow;
    }
  }
}

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late Future<List<Product>> productsFuture = ProductService().fetchProducts();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await ProductService.fetchCurrentUser();
    setState(() {
      productsFuture = ProductService().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const LeftDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
                // backgroundImage: NetworkImage('https://example.com/your-avatar-url'),
                ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFF00BDD6),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Search...",
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.cyan[300],
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            productsFuture = ProductService()
                                .fetchProductsBySearch(_searchController.text);
                          });
                        },
                        padding: const EdgeInsets.all(8.0),
                        constraints: const BoxConstraints(
                          minWidth: 40.0,
                          minHeight: 40.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (ProductService.currentUserRole == 'owner')
                    _buildCategoryButton("Add Product", Icons.add_circle,
                        const Color.fromARGB(255, 0, 0, 0), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddProductForm(
                            onProductAdded: () {
                              setState(() {
                                productsFuture =
                                    ProductService().fetchProducts();
                              });
                            },
                          ),
                        ),
                      );
                    }),
                  _buildCategoryButton("All", Icons.view_list, Colors.black,
                      () {
                    setState(() {
                      productsFuture = ProductService().fetchProducts();
                    });
                  }),
                  _buildCategoryButton(
                      "Makanan/Minuman", Icons.fastfood_sharp, Colors.red, () {
                    setState(() {
                      productsFuture = ProductService()
                          .fetchProductsByCategory("makanan_minuman");
                    });
                  }),
                  _buildCategoryButton(
                      "Pakaian", Icons.shopping_bag_sharp, Colors.green, () {
                    setState(() {
                      productsFuture =
                          ProductService().fetchProductsByCategory("pakaian");
                    });
                  }),
                  _buildCategoryButton(
                      "Kerajinan", Icons.card_giftcard_sharp, Colors.orange,
                      () {
                    setState(() {
                      productsFuture = ProductService()
                          .fetchProductsByCategory("kerajinan_tangan");
                    });
                  }),
                  _buildCategoryButton(
                      "Lain-lain", Icons.more_horiz, Colors.teal, () {
                    setState(() {
                      productsFuture =
                          ProductService().fetchProductsByCategory("lain_lain");
                    });
                  }),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: FutureBuilder<List<Product>>(
                    future: productsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 2 / 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final product = snapshot.data![index];
                            return _buildProductCard(product);
                          },
                        );
                      } else {
                        return const Center(child: Text('No products found'));
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Category button builder
  Widget _buildCategoryButton(
      String label, IconData icon, Color iconColor, VoidCallback onPressed) {
    return SizedBox(
      width: 150,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  icon,
                  size: 28,
                  color: iconColor,
                ),
                onPressed: onPressed,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    bool canDelete = ProductService.currentUserRole == 'owner' &&
        ProductService.currentUsername == product.fields.toko;

    Widget buildProductImage() {
      if (product.fields.gambar.isNotEmpty) {
        return Image.network(
          product.fields.gambar,
          height: 120,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Icon(Icons.error));
          },
        );
      } else if (product.fields.gambarFile.isNotEmpty) {
        try {
          final imageBytes = base64Decode(product.fields.gambarFile);
          return Image.memory(
            imageBytes,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Icon(Icons.error));
            },
          );
        } catch (e) {
          return const Center(child: Icon(Icons.image_not_supported));
        }
      } else {
        return const Center(child: Icon(Icons.image_not_supported));
      }
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4,
      child: Column(
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(8.0)),
            child: buildProductImage(),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Text(
                product.fields.nama,
                style: GoogleFonts.lato(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Rp${product.fields.harga}',
                style: GoogleFonts.lato(),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (canDelete)
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      // Show confirmation dialog
                      bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Konfirmasi'),
                            content: const Text(
                                'Apakah anda yakin ingin menghapus produk ini?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: const Text('Delete'),
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        try {
                          bool success =
                              await ProductService().deleteProduct(product.pk);
                          if (success) {
                            setState(() {
                              productsFuture = ProductService().fetchProducts();
                            });

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Sukses menghapus produk'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Gagal menghapus produk: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    },
                  )
                else
                  const SizedBox(width: 48),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          productId: product.pk,
                          productName: product.fields.nama,
                        ),
                      ),
                    );
                  },
                  child: Text('See Detail', style: GoogleFonts.lato()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

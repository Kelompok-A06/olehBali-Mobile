import 'package:flutter/material.dart';
import 'package:olehbali_mobile/widgets/left_drawer.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

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
          // Blue search bar container
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search...",
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Category buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryButton("Makanan", Icons.restaurant),
                  _buildCategoryButton("Minuman", Icons.local_cafe),
                  _buildCategoryButton("Pakaian", Icons.shopping_bag),
                  _buildCategoryButton("Kerajinan", Icons.card_giftcard),
                  _buildCategoryButton("Lain-lain", Icons.more_horiz),
                ],
              ),
            ),
          ),
          // Cards for products (Replace with your custom card widgets)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio:
                      2 / 3, // Adjust the aspect ratio for card height
                ),
                itemCount: 6, // Adjust the number of cards
                itemBuilder: (context, index) {
                  return _buildProductCard();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Category button builder
  Widget _buildCategoryButton(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          IconButton(
            icon: Icon(icon, size: 30),
            onPressed: () {},
          ),
          Text(label),
        ],
      ),
    );
  }

  // Placeholder for product card (replace with your custom card)
  Widget _buildProductCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4,
      child: Column(
        children: [
          // Placeholder for product image
          Container(
            height: 120,
            color: Colors.grey[300],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "...",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("..."),
          ),
        ],
      ),
    );
  }
}

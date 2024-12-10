import 'package:flutter/material.dart';
import 'package:olehbali_mobile/widgets/left_drawer.dart';
import 'package:olehbali_mobile/widgets/dummycard.dart';

class MyHomePage extends StatelessWidget {
  final String npm = 'DUMMY'; // NPM
  final String name = 'DUMMY'; // Nama
  final String className = 'DUMMY'; // Kelas

  final List<ItemHomepage> items = [
    ItemHomepage("DUMMY", Icons.view_day_outlined, Colors.blueAccent),
    ItemHomepage("DUMMY", Icons.add, Colors.greenAccent),
    ItemHomepage("Logout", Icons.logout, Colors.redAccent),
  ];

  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo_olehBali.png',
              fit: BoxFit.contain,
              height: 42, // Adjust the height as needed
            ),
            const SizedBox(width: 8), // Spacing between the logo and the text
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "Oleh", // First part of the title
                    style: TextStyle(
                      color: Color.fromARGB(255, 3, 164, 193),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  TextSpan(
                    text: "Bali", // Second part of the title
                    style: TextStyle(
                      color: Color.fromARGB(255, 254, 150, 66),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 254, 150, 66)),
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoCard(title: 'DUMMY', content: npm, imageUrl: 'assets/images/purahome.png'),
              ],
            ),
            const SizedBox(height: 16.0),
            Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Welcome to OlehBali',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  GridView.count(
                    primary: true,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    children: items.map((ItemHomepage item) {
                      return ItemCard(item);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final String imageUrl;

  const InfoCard({
    super.key,
    required this.title,
    required this.content,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          // Image background
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imageUrl,
              width: MediaQuery.of(context).size.width / 3.5,
              height: 120, // Adjust height as needed
              fit: BoxFit.cover,
            ),
          ),
          // Text overlay
          Positioned(
            bottom: 8,
            left: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white, // White text for better contrast
                  ),
                ),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white, // White text for better contrast
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

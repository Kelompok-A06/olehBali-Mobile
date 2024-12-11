import 'dart:async';

import 'package:flutter/material.dart';
import 'package:olehbali_mobile/widgets/left_drawer.dart';
import 'package:olehbali_mobile/widgets/itemcard.dart';
import 'package:olehbali_mobile/userprofile/models/profile.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<ItemHomepage> items = [
    ItemHomepage("assets/images/logo_olehBali.png", "Katalog","Discover over 100 products available in Denpasar!"),
    ItemHomepage("assets/images/logo_olehBali.png", "Wishlist","Easily save various products you like."),
    ItemHomepage("assets/images/logo_olehBali.png", "Community","Discuss experiences and gain recommendations to find products."),
    ItemHomepage("assets/images/logo_olehBali.png", "Reviews","See what other people have to say."),

  ];

  late PageController _pageController;
  late Timer _carouselTimer;
  int _currentIndex = 0;

  Future<String> fetchUserName(CookieRequest request) async {
    final response = await request.get('https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/userprofile/api/profile/');
    final profile = Profile.fromJson(response[0]);
    return profile.fields.name;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);

    _startAutoScroll();
  }
  void _startAutoScroll() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentIndex < items.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0; // Reset to the first item
      }
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _carouselTimer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
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
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Oleh", // First part of the title
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 3, 164, 193),
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    )
                  ),
                  TextSpan(
                    text: "Bali", // Second part of the title
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 254, 150, 66),
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    )
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
      body: FutureBuilder(
        future: fetchUserName(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator(),);
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InfoCard(
                            title: 'Halo ${snapshot.data}!',
                            subTitle: 'Find Your Souvenirs',
                            content: "We give you Bali's best souvenirs in Denpasar.",
                            content1: 'Discover a wide range of unique and exclusive products.',
                            content2: 'Go, shopping!',
                            imageUrl : 'assets/images/purahome.png'
                        ),
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
                          const SizedBox(height: 16.0),
                          SizedBox(
                            height: 200, // Height of the carousel
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: items.length,
                              onPageChanged: (index) {
                                _currentIndex = index;
                              },
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: ItemCard(items[index]),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ],
              )
            );
          }
        }
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String content;
  final String? content1;
  final String? content2;
  final String imageUrl;

  const InfoCard({
    super.key,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.subTitle,
    this.content1,
    this.content2,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imageUrl,
              width: MediaQuery.of(context).size.width / 1.2,
              height: 175, // Adjust height as needed
              fit: BoxFit.cover,
            ),
          ),
          // Text overlay
          Positioned(
            right: 16,
            width: MediaQuery.of(context).size.width / 1.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white, // White text for better contrast
                  ),
                ),
                Text(
                  subTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white, // White text for better contrast
                  ),
                ),
                Flexible(
                    child: Text(
                      content,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white, // White text for better contrast
                      ),
                      textAlign: TextAlign.right,
                    ),
                ),
                if (content1 != null)
                  Flexible(
                    child: Text(
                      content1!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white, // White text for better contrast
                      ),
                      // textAlign: TextAlign.right,
                    ),
                  ),
                if (content2 != null)
                  Flexible(
                      child: Text(
                        content2!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white, // White text for better contrast
                        ),
                      ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

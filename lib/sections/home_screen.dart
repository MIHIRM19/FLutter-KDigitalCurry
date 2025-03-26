// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kdigital_ecom/sections/cart_screen.dart';
import 'package:kdigital_ecom/sections/category_view.dart';
import 'dart:convert';

import 'package:kdigital_ecom/sections/product_detail.dart';
import 'package:kdigital_ecom/sections/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> imageUrls = [
    'assets/images/banner.png',
    'assets/images/banner.png',
    'assets/images/banner.png',
    'assets/images/banner.png',
  ];

  final List<String> images = [
    'assets/images/hoodie.png',
    'assets/images/hoodie.png',
    'assets/images/hoodie.png',
    'assets/images/hoodie.png',
  ];

  List<String> brands = [
    "assets/images/mont_blanc.png",
    "assets/images/ulysee.png",
    "assets/images/raymond.png",
    "assets/images/longchamp.png",
    "assets/images/lancel.png",
    "assets/images/boggi.png",
  ];

  List<Map<String, dynamic>> categories = [
    {
      "name": "Watches",
      "image": "assets/images/watches.png",
    },
    {
      "name": "Shoes",
      "image": "assets/images/shoes.png",
    },
    {
      "name": "Heels",
      "image": "assets/images/heels.png",
    },
    {
      "name": "Beauty & Make Up",
      "image": "assets/images/beauty.png",
    },
    {
      "name": "Bags & Bag Packs",
      "image": "assets/images/bags.png",
    },
    {
      "name": "Jewellery",
      "image": "assets/images/jewellary.png",
    },
    {
      "name": "Sunglasses",
      "image": "assets/images/sunglass.png",
    },
    {
      "name": "Perfume",
      "image": "assets/images/perfumes.png",
    }
  ];

  List<dynamic> mensClothing = [];
  List<dynamic> womensClothing = [];
  bool isLoading = true;

  bool _isNavOpen = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
    fetchMenProducts();
    fetchWomenProducts();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Create slide animation
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // Starts from left
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _toggleNavigation() {
    setState(() {
      _isNavOpen = !_isNavOpen;

      if (_isNavOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Future<void> fetchWomenProducts() async {
    try {
      final response =
          await http.get(Uri.parse('https://fakestoreapi.com/products'));

      if (response.statusCode == 200) {
        List<dynamic> allProducts = json.decode(response.body);
        setState(() {
          // Filter products to get only men's clothing
          womensClothing = allProducts
              .where((product) => product['category'] == "women's clothing")
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load products')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> fetchMenProducts() async {
    try {
      final response =
          await http.get(Uri.parse('https://fakestoreapi.com/products'));

      if (response.statusCode == 200) {
        List<dynamic> allProducts = json.decode(response.body);
        setState(() {
          // Filter products to get only men's clothing
          mensClothing = allProducts
              .where((product) => product['category'] == "men's clothing")
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load products')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _toggleNavigation,
                        child: SvgPicture.asset(
                          "assets/svgs/ham.svg",
                          width: 24,
                          height: 16,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => ProfileScreen()));
                            },
                            child: SvgPicture.asset(
                              "assets/svgs/acc.svg",
                              width: 18,
                              height: 18,
                            ),
                          ),
                          const SizedBox(width: 30),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => CartScreen()));
                            },
                            child: SvgPicture.asset(
                              "assets/svgs/bag.svg",
                              width: 16,
                              height: 20,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      cursorColor: const Color.fromARGB(255, 32, 33, 37),
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 103, 103, 103),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 103, 103, 103),
                            width: 1,
                          ),
                        ),

                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Search",
                        hintStyle: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromARGB(255, 103, 103, 103)),
                        // Add lock icon to the left side
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color.fromARGB(255, 121, 121, 121),
                        ),
                        // Add eye icon to the right side
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 375,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: imageUrls.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.asset(
                                  imageUrls[index],
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                        // Dot Indicators
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            imageUrls.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  color: _currentPage == index
                                      ? Colors.black
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: _currentPage == index
                                      ? null
                                      : Border.all(
                                          color: const Color.fromARGB(
                                              255, 103, 103, 103))),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 7),
                                child: Text(
                                  "Shop By Brands",
                                  style: GoogleFonts.marcellus(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        const Color.fromARGB(255, 32, 33, 37),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              // First Row
                              Row(
                                children: brands.take(3).map((brand) {
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0),
                                      child: Container(
                                        height: screenWidth *
                                            0.25, // Dynamic height based on screen width
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 248, 248, 251),
                                          borderRadius:
                                              BorderRadius.circular(7.51),
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 226, 227, 231),
                                            width: 0.43,
                                          ),
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            brand,
                                            fit: BoxFit.contain,
                                            width: screenWidth *
                                                0.2, // Dynamic width
                                            height: screenWidth *
                                                0.2, // Dynamic height
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 10), // Space between rows

                              // Second Row
                              Row(
                                children: brands.skip(3).take(3).map((brand) {
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0),
                                      child: Container(
                                        height: screenWidth *
                                            0.25, // Dynamic height based on screen width
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 248, 248, 251),
                                          borderRadius:
                                              BorderRadius.circular(7.51),
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 226, 227, 231),
                                            width: 0.43,
                                          ),
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            brand,
                                            fit: BoxFit.contain,
                                            width: screenWidth *
                                                0.2, // Dynamic width
                                            height: screenWidth *
                                                0.2, // Dynamic height
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 40),
                              Padding(
                                padding: const EdgeInsets.only(left: 3),
                                child: Text(
                                  "Browse Category",
                                  style: GoogleFonts.marcellus(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        const Color.fromARGB(255, 32, 33, 37),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              _categories("Mens", "assets/images/mens.png",
                                  "men's clothing"),
                              _categories("Women", "assets/images/women.png",
                                  "women's clothing"),
                              _categories("Kids", "assets/images/kids.png",
                                  "kid's clothing"),
                              const SizedBox(height: 20),
                              Image.asset(
                                "assets/images/sponser.png",
                                width: double.infinity,
                                height: 190,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.only(left: 3),
                                child: Text(
                                  "Shop By Category",
                                  style: GoogleFonts.marcellus(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        const Color.fromARGB(255, 32, 33, 37),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Column(
                                children: [
                                  // First Row
                                  Row(
                                    children:
                                        categories.take(2).map((category) {
                                      return Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6.0, vertical: 4.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(4.53),
                                                child: Image.asset(
                                                  category['image'],
                                                  fit: BoxFit.cover,
                                                  width: screenWidth * 0.425,
                                                  height:
                                                      167.62, // Static height for the image
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  category['name'],
                                                  style: GoogleFonts.dmSans(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: const Color.fromARGB(
                                                        255, 32, 33, 37),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),

                                  // Second Row
                                  Row(
                                    children: categories
                                        .skip(2)
                                        .take(2)
                                        .map((category) {
                                      return Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6.0, vertical: 4.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(4.53),
                                                child: Image.asset(
                                                  category['image'],
                                                  fit: BoxFit.cover,
                                                  width: screenWidth * 0.425,
                                                  height:
                                                      167.62, // Static height for the image
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  category['name'],
                                                  style: GoogleFonts.dmSans(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: const Color.fromARGB(
                                                        255, 32, 33, 37),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),

                                  // Third Row
                                  Row(
                                    children: categories
                                        .skip(4)
                                        .take(2)
                                        .map((category) {
                                      return Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6.0, vertical: 4.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(4.53),
                                                child: Image.asset(
                                                  category['image'],
                                                  fit: BoxFit.cover,
                                                  width: screenWidth * 0.425,
                                                  height:
                                                      167.62, // Static height for the image
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  category['name'],
                                                  style: GoogleFonts.dmSans(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: const Color.fromARGB(
                                                        255, 32, 33, 37),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),

                                  // Fourth Row
                                  Row(
                                    children: categories
                                        .skip(6)
                                        .take(2)
                                        .map((category) {
                                      return Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6.0, vertical: 4.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(4.53),
                                                child: Image.asset(
                                                  category['image'],
                                                  fit: BoxFit.cover,
                                                  width: screenWidth * 0.425,
                                                  height:
                                                      167.62, // Static height for the image
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  category['name'],
                                                  style: GoogleFonts.dmSans(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: const Color.fromARGB(
                                                        255, 32, 33, 37),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                height: 0.5,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 206, 206, 206),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Men’s Cloth Collection",
                              style: GoogleFonts.marcellus(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromARGB(255, 32, 33, 37),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 0.5,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 206, 206, 206),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          height: 246, // Adjust height as needed
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: mensClothing.length,
                            itemBuilder: (context, index) {
                              var item = mensClothing[index];
                              return Padding(
                                padding: index == 0
                                    ? const EdgeInsets.only(left: 22, right: 15)
                                    : const EdgeInsets.only(right: 15),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => ProductDetail(
                                          image: item['image'],
                                          realPrice:
                                              '\$${item['price'].toStringAsFixed(2)}',
                                          price:
                                              '\$${(item['price'] * 1.2).toStringAsFixed(2)}',
                                          title: item['title'],
                                          description: item['description'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 153.45,
                                        height: 174.25,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4.16),
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 226, 227, 231),
                                              width: 1),
                                        ),
                                        child: Image.network(
                                          item['image'],
                                          fit: BoxFit.contain,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      SizedBox(
                                        width: 153.45, // Match image width
                                        child: Text(
                                          item['title'],
                                          style: GoogleFonts.dmSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            color: const Color.fromARGB(
                                                255, 32, 33, 37),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '\$${item['price'].toStringAsFixed(2)}',
                                            style: GoogleFonts.dmSans(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromARGB(
                                                  255, 32, 33, 37),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            '\$${(item['price'] * 1.2).toStringAsFixed(2)}', // Adding 20% for original price
                                            style: GoogleFonts.dmSans(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w300,
                                              color: const Color.fromARGB(
                                                  255, 103, 103, 103),
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              decorationColor:
                                                  const Color.fromARGB(
                                                      255, 103, 103, 103),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                height: 0.5,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 206, 206, 206),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Women’s Cloth Collection",
                              style: GoogleFonts.marcellus(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromARGB(255, 32, 33, 37),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 0.5,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 206, 206, 206),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 246, // Adjust height as needed
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: womensClothing.length,
                            itemBuilder: (context, index) {
                              var item = womensClothing[index];
                              return Padding(
                                padding: index == 0
                                    ? const EdgeInsets.only(left: 20, right: 15)
                                    : const EdgeInsets.only(right: 15),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => ProductDetail(
                                          image: item['image'],
                                          realPrice:
                                              '\$${item['price'].toStringAsFixed(2)}',
                                          price:
                                              '\$${(item['price'] * 1.2).toStringAsFixed(2)}',
                                          title: item['title'],
                                          description: item['description'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 153.45,
                                        height: 174.25,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4.16),
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 226, 227, 231),
                                              width: 1),
                                        ),
                                        child: Image.network(
                                          item['image'],
                                          fit: BoxFit.contain,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      SizedBox(
                                        width: 153.45, // Match image width
                                        child: Text(
                                          item['title'],
                                          style: GoogleFonts.dmSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            color: const Color.fromARGB(
                                                255, 32, 33, 37),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '\$${item['price'].toStringAsFixed(2)}',
                                            style: GoogleFonts.dmSans(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromARGB(
                                                  255, 32, 33, 37),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            '\$${(item['price'] * 1.2).toStringAsFixed(2)}', // Adding 20% for original price
                                            style: GoogleFonts.dmSans(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w300,
                                              color: const Color.fromARGB(
                                                  255, 103, 103, 103),
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              decorationColor:
                                                  const Color.fromARGB(
                                                      255, 103, 103, 103),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                height: 0.5,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 206, 206, 206),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Flash Sale",
                              style: GoogleFonts.marcellus(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromARGB(255, 32, 33, 37),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 0.5,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 206, 206, 206),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 239,
                          child: ListView.builder(
                            itemCount: images.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final data = images[index];
                              return Padding(
                                padding: index == images.length - 1
                                    ? const EdgeInsets.only(left: 13, right: 20)
                                    : index == 0
                                        ? const EdgeInsets.only(left: 20)
                                        : const EdgeInsets.only(left: 13),
                                child: Image.asset(
                                  data,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 60),
                        Container(
                          width: double.infinity,
                          height: 360,
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 200, 16, 46),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Image.asset(
                                      "assets/images/logo_final.png",
                                      width: 70,
                                      height: 58.01,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      _buildNavigationItem(
                                          0, "Products", screenWidth * 0.24),
                                      _buildNavigationItem(
                                          1, "Company", screenWidth * 0.23),
                                      _buildNavigationItem(
                                          2, "Shop", screenWidth * 0.22),
                                      _buildNavigationItem(
                                          3, "Service", screenWidth * 0.21),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "What’s New",
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Sales",
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Top Picks",
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "© 2025 KDigitalCurry. All rights reserved.",
                                style: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_isNavOpen)
              Positioned.fill(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: GestureDetector(
                    // Prevents closing when tapping on navigation content
                    onTap: () {},
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 30, top: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Back Button to Close Navigation
                                    InkWell(
                                      onTap: _toggleNavigation,
                                      child: SvgPicture.asset(
                                        "assets/svgs/pop.svg",
                                        width: 16,
                                        height: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 30),
                                    Text(
                                      "Categories",
                                      style: GoogleFonts.dmSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: const Color.fromARGB(
                                            255, 32, 33, 37),
                                      ),
                                    )
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => CartScreen()));
                                  },
                                  child: SvgPicture.asset(
                                    "assets/svgs/bag.svg",
                                    width: 16,
                                    height: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 50),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, bottom: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _cat("Mens", 0, "men's clothing"),
                                _cat("Womens", 15, "women's clothing"),
                                _cat("Electronics", 15, "electronics"),
                                _cat("Jewelery", 15, "jewelery"),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _cat(String text, double top, String type) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15, top: top),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) =>
                      CategoryView(category: type, mainCategory: text)));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromARGB(255, 32, 33, 37),
                  ),
                ),
                SvgPicture.asset(
                  "assets/svgs/look.svg",
                  width: 7.67,
                  height: 13.31,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _categories(String text, String image, String category) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              image,
              width: double.infinity,
              height: 210,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 3,
            left: 6,
            child: Text(
              text,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem(int index, String text, double width) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        width: width,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          border: index == 3
              ? Border.all(color: Colors.white)
              : const Border(
                  left: BorderSide(color: Colors.white),
                  top: BorderSide(color: Colors.white),
                  bottom: BorderSide(
                    color: Colors.white,
                  ),
                ),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isSelected ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

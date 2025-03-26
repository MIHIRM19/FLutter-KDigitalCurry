// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kdigital_ecom/sections/cart_screen.dart';
import 'package:kdigital_ecom/sections/product_detail.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({
    super.key,
    required this.category,
    required this.mainCategory,
  });

  final String category;
  final String mainCategory;

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView>
    with SingleTickerProviderStateMixin {
  List<dynamic> allProducts = [];
  List<dynamic> filteredProducts = [];
  bool isLoading = true;
  String _activeFilterSection = 'Price';
  int _selectedIndex = 0;

  bool _isNavOpen = false;
  bool _isSortOpen = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  // Filter options
  final List<String> priceRanges = [
    'All Prices',
    'Below \$100',
    'Below \$500',
    'Below \$1000'
  ];
  String selectedPriceRange = 'All Prices';

  final List<String> colors = ['Dark Brown', 'Steel Blue', 'Black'];
  List<String> selectedColors = [];

  final List<String> sizes = ['S', 'M', 'L', 'XS', 'XL'];
  List<String> selectedSizes = [];

  // Sort options
  final List<String> sortOptions = ['A to Z', 'Z to A'];
  String selectedSortOption = 'A to Z';

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController first
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Create slide animation after initializing AnimationController
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // Starts from left
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    fetchProducts();
  }

  void _toggleSortNavigation() {
    setState(() {
      _isSortOpen = !_isSortOpen;

      if (_isSortOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
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

  Future<void> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse('https://fakestoreapi.com/products'));

      if (response.statusCode == 200) {
        List<dynamic> fetchedProducts = json.decode(response.body);
        setState(() {
          // Filter products to get only products in the specific category
          allProducts = fetchedProducts
              .where((product) => product['category'] == widget.category)
              .toList();
          filteredProducts = List.from(allProducts);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load products')),
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

  void _applyFilters() {
    setState(() {
      filteredProducts = allProducts.where((product) {
        // Price range filter
        bool matchesPriceRange = true;
        switch (selectedPriceRange) {
          case 'Below \$100':
            matchesPriceRange = product['price'] < 100;
            break;
          case 'Below \$500':
            matchesPriceRange = product['price'] < 500;
            break;
          case 'Below \$1000':
            matchesPriceRange = product['price'] < 1000;
            break;
        }

        // Size filter (if any sizes are selected)
        bool matchesSize = selectedSizes.isEmpty ||
            selectedSizes.contains(_getProductSize(product));

        return matchesPriceRange && matchesSize;
      }).toList();

      // Close the filter navigation
      _toggleNavigation();
    });
  }

  void _applySorting() {
    setState(() {
      if (selectedSortOption == 'A to Z') {
        filteredProducts.sort((a, b) =>
            a['title'].toLowerCase().compareTo(b['title'].toLowerCase()));
      } else {
        filteredProducts.sort((a, b) =>
            b['title'].toLowerCase().compareTo(a['title'].toLowerCase()));
      }
      _toggleSortNavigation();
    });
  }

  // Helper method to get product size (mock implementation)
  String _getProductSize(dynamic product) {
    // This is a mock implementation. In a real app, you'd have actual size data
    if (product['title'].length % 3 == 0) return 'S';
    if (product['title'].length % 3 == 1) return 'M';
    if (product['title'].length % 3 == 2) return 'L';
    return 'XL';
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
                  padding: const EdgeInsets.only(left: 25, right: 30, top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset(
                              "assets/svgs/pop.svg",
                              width: 16,
                              height: 16,
                            ),
                          ),
                          const SizedBox(width: 30),
                          Text(
                            widget.mainCategory,
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromARGB(255, 32, 33, 37),
                            ),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => const CartScreen()));
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
                const SizedBox(height: 30),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _toggleSortNavigation,
                        child: Container(
                          width: 112,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 200, 16, 46),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/svgs/sortby.svg",
                                width: 10.33,
                                height: 12.67,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Sort By",
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 13),
                      GestureDetector(
                        onTap: _toggleNavigation,
                        child: Container(
                          width: 112,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 200, 16, 46),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/svgs/filt.svg",
                                width: 15,
                                height: 9,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Filter",
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // GridView with ScrollView
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 2 items per row
                              crossAxisSpacing: 20, // Spacing between columns
                              mainAxisSpacing: 15, // Spacing between rows
                              childAspectRatio:
                                  0.7, // Adjust this to control item height/width ratio
                            ),
                            itemCount: filteredProducts.length,
                            itemBuilder: (context, index) {
                              var item = filteredProducts[index];
                              return GestureDetector(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        height: 174.25,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4.16),
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 226, 227, 231),
                                            width: 1,
                                          ),
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
                                    ),
                                    const SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
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
                                                '\$${(item['price'] * 1.2).toStringAsFixed(2)}',
                                                style: GoogleFonts.dmSans(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w300,
                                                  color: const Color.fromARGB(
                                                      255, 103, 103, 103),
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  decorationColor:
                                                      const Color.fromARGB(
                                                          255, 103, 103, 103),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  "(20% OFF)",
                                                  style: GoogleFonts.dmSans(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w400,
                                                    color: const Color.fromARGB(
                                                        255, 230, 57, 70),
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 60),
                        // Footer
                        filteredProducts.isEmpty
                            ? Container()
                            : Container(
                                width: double.infinity,
                                height: 360,
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 200, 16, 46),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            _buildNavigationItem(0, "Products",
                                                screenWidth * 0.24),
                                            _buildNavigationItem(1, "Company",
                                                screenWidth * 0.23),
                                            _buildNavigationItem(
                                                2, "Shop", screenWidth * 0.22),
                                            _buildNavigationItem(3, "Service",
                                                screenWidth * 0.21),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          "What's New",
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
                                    const SizedBox(height: 20),
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
                    onTap: () {},
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 30, top: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
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
                                      "Filters",
                                      style: GoogleFonts.dmSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: const Color.fromARGB(
                                            255, 32, 33, 37),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            height: 0.5,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 138, 138, 138),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _activeFilterSection = 'Price';
                                        });
                                      },
                                      child: Container(
                                        width: 146,
                                        height: 42,
                                        decoration: BoxDecoration(
                                          color: _activeFilterSection == 'Price'
                                              ? const Color.fromARGB(
                                                  255, 200, 16, 46)
                                              : Colors.transparent,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Price",
                                            style: GoogleFonts.dmSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: _activeFilterSection ==
                                                      'Price'
                                                  ? Colors.white
                                                  : const Color.fromARGB(
                                                      255, 32, 33, 37),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Sizes Section
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _activeFilterSection = 'Sizes';
                                        });
                                      },
                                      child: Container(
                                        width: 146,
                                        height: 42,
                                        decoration: BoxDecoration(
                                          color: _activeFilterSection == 'Sizes'
                                              ? const Color.fromARGB(
                                                  255, 200, 16, 46)
                                              : Colors.transparent,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Sizes",
                                            style: GoogleFonts.dmSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: _activeFilterSection ==
                                                      'Sizes'
                                                  ? Colors.white
                                                  : const Color.fromARGB(
                                                      255, 32, 33, 37),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: _activeFilterSection == 'Price'
                                        ? _buildPriceContent()
                                        : _buildSizesContent(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 0.5,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 138, 138, 138),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: _toggleNavigation,
                                        child: Container(
                                          height: 42,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 103, 103, 103),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Cancel",
                                              style: GoogleFonts.dmSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: const Color.fromARGB(
                                                    255, 32, 33, 37),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: _applyFilters,
                                        child: Container(
                                          height: 42,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 200, 16, 46),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Apply Filter",
                                              style: GoogleFonts.dmSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            if (_isSortOpen)
              Positioned.fill(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 30, top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: _toggleSortNavigation,
                                    child: SvgPicture.asset(
                                      "assets/svgs/pop.svg",
                                      width: 16,
                                      height: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  Text(
                                    "Sort By",
                                    style: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          const Color.fromARGB(255, 32, 33, 37),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 0.5,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 138, 138, 138),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: sortOptions.map((option) {
                                bool isSelected = selectedSortOption == option;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedSortOption = option;
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 15),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color.fromARGB(
                                              255, 200, 16, 46)
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 200, 16, 46),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      option,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: isSelected
                                            ? Colors.white
                                            : const Color.fromARGB(
                                                255, 32, 33, 37),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 0.5,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 138, 138, 138),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: _toggleSortNavigation,
                                      child: Container(
                                        height: 42,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 103, 103, 103),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Cancel",
                                            style: GoogleFonts.dmSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: const Color.fromARGB(
                                                  255, 32, 33, 37),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: _applySorting,
                                      child: Container(
                                        height: 42,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 200, 16, 46),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Apply Sort",
                                            style: GoogleFonts.dmSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // New method to build Price content
  Widget _buildPriceContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: priceRanges.map((range) {
        bool isSelected = selectedPriceRange == range;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedPriceRange = range;
            });
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color.fromARGB(255, 200, 16, 46)
                  : Colors.transparent,
              border: Border.all(
                color: const Color.fromARGB(255, 200, 16, 46),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              range,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isSelected
                    ? Colors.white
                    : const Color.fromARGB(255, 32, 33, 37),
              ),
            ),
          ),
        );
      }).toList(),
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

// New method to build Sizes content
  Widget _buildSizesContent() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: sizes.map((size) {
        bool isSelected = selectedSizes.contains(size);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedSizes.remove(size);
              } else {
                selectedSizes.add(size);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color.fromARGB(255, 200, 16, 46)
                  : Colors.transparent,
              border: Border.all(
                color: const Color.fromARGB(255, 200, 16, 46),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              size,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isSelected
                    ? Colors.white
                    : const Color.fromARGB(255, 32, 33, 37),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kdigital_ecom/model/cart_model.dart';
import 'package:kdigital_ecom/sections/cart_screen.dart';
import 'package:kdigital_ecom/service/cart_service.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({
    super.key,
    required this.image,
    required this.realPrice,
    required this.price,
    required this.title,
    required this.description,
  });

  final String image;
  final String realPrice;
  final String price;
  final String title;
  final String description;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  String _selectedSize = 'L';

  final List<String> _sizes = ['S', 'M', 'L', 'XS', 'XL'];

  int _selectedIndex = 0;

  bool _isExpanded = false;

  Color? _selectedColor;

  // List of available colors with their names
  final List<Map<String, dynamic>> _availableColors = [
    {'color': const Color(0xFF64382D), 'name': 'Dark Brown'},
    {'color': const Color(0xFF7B8C9E), 'name': 'Steel Blue'},
    {'color': Colors.black, 'name': 'Black'},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
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
                        "Product Details ",
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromARGB(255, 32, 33, 37),
                        ),
                      )
                    ],
                  ),
                  InkWell(
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
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 381,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 226, 227, 231),
                                  width: 1),
                            ),
                            child: Image.network(
                              widget.image,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 17),
                          Text(
                            widget.title,
                            style: GoogleFonts.marcellus(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromARGB(255, 32, 33, 37),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.description,
                                style: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      const Color.fromARGB(255, 103, 103, 103),
                                ),
                                maxLines: _isExpanded ? null : 5,
                                overflow:
                                    _isExpanded ? null : TextOverflow.ellipsis,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  });
                                },
                                child: Text(
                                  _isExpanded ? 'Less' : 'More',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.realPrice,
                                style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromARGB(255, 32, 33, 37),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Text(
                                widget.price,
                                style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      const Color.fromARGB(255, 103, 103, 103),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/svgs/save.svg",
                                width: 16.23,
                                height: 16.23,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Save 20% Right Now",
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromARGB(255, 90, 90, 90),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Color",
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromARGB(255, 32, 33, 37),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: _availableColors.map((colorData) {
                                  return _buildColorSelector(
                                      colorData['color'], colorData['name']);
                                }).toList(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Select Size",
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromARGB(255, 32, 33, 37),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: _sizes.map((size) {
                                  return _buildSizeSelector(size);
                                }).toList(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          GestureDetector(
                            onTap: () {
                              // Validate color selection
                              if (_selectedColor == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Please select a color')),
                                );
                                return;
                              }

                              // Create unique ID for the cart item
                              String itemId = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();

                              // Determine selected color name
                              String selectedColorName =
                                  _availableColors.firstWhere((c) =>
                                      c['color'] == _selectedColor)['name'];

                              // Create cart item
                              CartItem cartItem = CartItem(
                                id: itemId,
                                title: widget.title,
                                description: widget.description,
                                price: widget.price,
                                realPrice: widget.realPrice,
                                image: widget.image,
                                size: _selectedSize,
                                color: selectedColorName,
                              );

                              // Add to cart with logging
                              CartService.addToCart(cartItem).then((_) {
                                debugPrint('Item added to cart successfully');

                                // Show success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Added to Cart'),
                                    action: SnackBarAction(
                                      label: 'View Cart',
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const CartScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }).catchError((error) {
                                debugPrint('Error adding to cart: $error');
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.73),
                                border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 32, 33, 37),
                                    width: 0.72),
                              ),
                              child: Center(
                                child: Text(
                                  "Add to Cart",
                                  style: GoogleFonts.dmSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        const Color.fromARGB(255, 32, 33, 37),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            width: double.infinity,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.73),
                              color: const Color.fromARGB(255, 200, 16, 46),
                            ),
                            child: Center(
                              child: Text(
                                "Buy Now",
                                style: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
      ),
    );
  }

  Widget _buildColorSelector(Color color, String colorName) {
    bool isSelected = _selectedColor == color;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              )
            else
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            const SizedBox(width: 8),
            Text(
              colorName,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color.fromARGB(255, 32, 33, 37),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeSelector(String size) {
    bool isSelected = _selectedSize == size;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSize = size;
        });
      },
      child: Container(
        width: 42.7,
        height: 42.7,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 200, 16, 46) // Red when selected
              : const Color.fromARGB(
                  255, 246, 246, 246), // White when unselected
          borderRadius: BorderRadius.circular(3.81),
        ),
        child: Center(
          child: Text(
            size,
            style: GoogleFonts.dmSans(
              fontSize: 12.2,
              fontWeight: FontWeight.w300,
              color: isSelected
                  ? Colors.white
                  : const Color.fromARGB(255, 32, 33, 37),
            ),
          ),
        ),
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

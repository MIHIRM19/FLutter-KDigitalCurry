// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kdigital_ecom/sections/cart_screen.dart';
import 'package:kdigital_ecom/sections/login_account.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 0;

  String address = '';
  String email = '';
  String fullName = '';
  String phoneNumber = '';
  String username = '';
  bool isLoading = true;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    // Fetch user data when the widget initializes
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      // Get the current user's UID
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        // Handle case where no user is signed in
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Fetch document from 'users' collection using current user's UID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      // Check if document exists
      if (userDoc.exists) {
        // Cast the data and extract specific fields
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        setState(() {
          // Safely extract each field, providing default empty string if not found
          address = userData['address'] ?? '';
          email = userData['email'] ?? '';
          fullName = userData['fullName'] ?? '';
          phoneNumber = userData['phoneNumber'] ?? '';
          username = userData['username'] ?? '';
          isLoading = false;
        });
      } else {
        // Handle case where user document doesn't exist
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle any errors during data fetching
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      // Sign out from Firebase Authentication
      await FirebaseAuth.instance.signOut();

      // Navigate to login screen or initial screen
      // Replace 'LoginScreen()' with your actual login screen widget
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginAccount()),
      );
    } catch (e) {
      // Handle logout errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Image.asset(
                    "assets/images/redlogo.png",
                    width: 61.34,
                    height: 44,
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
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              height: 0.5,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 138, 138, 138),
              ),
            ),
            const SizedBox(height: 35),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/user_sample.png",
                            width: 120,
                            height: 120,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            fullName,
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(255, 32, 33, 37),
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                            child: Text(
                              "View Profile",
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 103, 103, 103),
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            height: _isExpanded
                                ? 200
                                : 0, // Adjust height as needed
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: _isExpanded
                                  ? Border.all(
                                      color: const Color.fromARGB(
                                          255, 226, 227, 231),
                                      width: 1)
                                  : null,
                            ),
                            child: _isExpanded
                                ? Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Profile Details",
                                            style: GoogleFonts.dmSans(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "Username : $username",
                                            style: GoogleFonts.dmSans(
                                              fontSize: 12,
                                              color: const Color.fromARGB(
                                                  255, 103, 103, 103),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "Email : $email",
                                            style: GoogleFonts.dmSans(
                                              fontSize: 12,
                                              color: const Color.fromARGB(
                                                  255, 103, 103, 103),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "Address : $address",
                                            style: GoogleFonts.dmSans(
                                              fontSize: 12,
                                              color: const Color.fromARGB(
                                                  255, 103, 103, 103),
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "Phone : $phoneNumber",
                                            style: GoogleFonts.dmSans(
                                              fontSize: 12,
                                              color: const Color.fromARGB(
                                                  255, 103, 103, 103),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : null, // No child when not expanded
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, bottom: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/svgs/doc.svg",
                                width: 14,
                                height: 17,
                              ),
                              const SizedBox(width: 20),
                              Text(
                                "My Orders",
                                style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromARGB(255, 32, 33, 37),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 0.5,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 138, 138, 138),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, bottom: 25, top: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/svgs/wish.svg",
                                width: 14,
                                height: 14.55,
                              ),
                              const SizedBox(width: 20),
                              Text(
                                "My Wishlist",
                                style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromARGB(255, 32, 33, 37),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 0.5,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 138, 138, 138),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, bottom: 25, top: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/svgs/address.svg",
                                width: 14,
                                height: 15.69,
                              ),
                              const SizedBox(width: 20),
                              Text(
                                "My Address",
                                style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromARGB(255, 32, 33, 37),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 0.5,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 138, 138, 138),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, bottom: 25, top: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/svgs/us.svg",
                                width: 15,
                                height: 15.65,
                              ),
                              const SizedBox(width: 20),
                              Text(
                                "Contact Us",
                                style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromARGB(255, 32, 33, 37),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 0.5,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 138, 138, 138),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, bottom: 25, top: 25),
                          child: GestureDetector(
                            onTap: () => _logout(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/svgs/logou.svg",
                                  width: 17.42,
                                  height: 18.33,
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  "Logout",
                                  style: GoogleFonts.dmSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        const Color.fromARGB(255, 32, 33, 37),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 0.5,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 138, 138, 138),
                          ),
                        ),
                      ],
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

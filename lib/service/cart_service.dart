import 'dart:convert';

import 'package:kdigital_ecom/model/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static const String _cartKey = 'cart_items_v2';

  // Add item to cart with more robust error handling
  static Future<void> addToCart(CartItem item) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Retrieve existing cart items
      List<String> cartItemsJson = prefs.getStringList(_cartKey) ?? [];

      // Add new item
      cartItemsJson.add(json.encode(item.toJson()));

      // Save updated cart
      await prefs.setStringList(_cartKey, cartItemsJson);
    } catch (e) {
      print('Error adding to cart: $e');
      // Consider adding more robust error handling or logging
      throw Exception('Failed to add item to cart: $e');
    }
  }

  // Get all cart items with improved error handling
  static Future<List<CartItem>> getCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Explicitly check if SharedPreferences is available
      if (!prefs.containsKey(_cartKey)) {
        return [];
      }

      List<String> cartItemsJson = prefs.getStringList(_cartKey) ?? [];

      List<CartItem> items = cartItemsJson
          .map((itemJson) {
            try {
              return CartItem.fromJson(json.decode(itemJson));
            } catch (e) {
              print('Error parsing cart item: $e');
              return null;
            }
          })
          .whereType<CartItem>()
          .toList();

      return items;
    } catch (e) {
      print('Error getting cart items: $e');
      return [];
    }
  }

  // New method to remove a specific cart item
  static Future<void> removeCartItem(CartItem itemToRemove) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Retrieve existing cart items
      List<String> cartItemsJson = prefs.getStringList(_cartKey) ?? [];

      // Remove the item by comparing JSON representations
      cartItemsJson.removeWhere((jsonString) {
        try {
          final cartItem = CartItem.fromJson(json.decode(jsonString));
          // Compare key attributes to ensure we're removing the correct item
          return cartItem.title == itemToRemove.title &&
              cartItem.color == itemToRemove.color &&
              cartItem.size == itemToRemove.size &&
              cartItem.price == itemToRemove.price;
        } catch (e) {
          print('Error comparing cart items: $e');
          return false;
        }
      });

      // Save the updated cart
      await prefs.setStringList(_cartKey, cartItemsJson);
    } catch (e) {
      print('Error removing cart item: $e');
      throw Exception('Failed to remove item from cart: $e');
    }
  }

  // Optional: Clear entire cart
  static Future<void> clearCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cartKey);
    } catch (e) {
      print('Error clearing cart: $e');
      throw Exception('Failed to clear cart: $e');
    }
  }
}

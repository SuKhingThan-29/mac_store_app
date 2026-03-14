import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart.dart';

//Define a StateNotifierProvider to expose an instance of the CartNotifier
//Making it acc app
final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, Cart>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<Map<String, Cart>> {
  CartNotifier() : super({}) {
    _loadCardItems();
  }
  Future<void> _loadCardItems() async {
    final pref = await SharedPreferences.getInstance();
    final cartString = pref.getString("cart_items");
    if (cartString != null) {
      //decode the json String into map of dynamic data

      final Map<String, dynamic> cartMap = jsonDecode(cartString);

      //covert the dynamic map  into a map of Favorite Object using the 'fromjson" factory method
      final cartItems =
          cartMap.map((key, value) => MapEntry(key, Cart.fromJson(value)));

      print("CartItemsLength: ${cartItems.length}");
      //updating the state with the loaded favorites
      state = cartItems;
      print("CartItemsLengths: ${state.length}");
    }
  }

  Future<void> _saveCartItems() async {
    final pref = await SharedPreferences.getInstance();
    //encoding the current state (Map of favorite object ) into json String
    final cartString = jsonEncode(state);
    //saving the json string to sharedpreferences with the key "favorites"
    await pref.setString('cart_items', cartString);
  }

  void addProductToCart(
      {required String productName,
      required int productPrice,
      required String category,
      required List<String> image,
      required String vendorId,
      required int productQuantity,
      required int quantity,
      required String productId,
      required String description,
      required String fullName}) {
    //check if the product is already in the cart
    if (state.containsKey(productId)) {
      //if the product is already in the cart, update it quantity and maybe other detail
      state = {
        ...state,
        productId: Cart(
            productName: state[productId]!.productName,
            productPrice: state[productId]!.productPrice,
            category: state[productId]!.category,
            image: state[productId]!.image,
            vendorId: state[productId]!.vendorId,
            productQuantity: state[productId]!.productQuantity,
            quantity: state[productId]!.quantity + 1,
            productId: state[productId]!.productId,
            description: state[productId]!.description,
            fullName: state[productId]!.fullName)
      };
      _saveCartItems();
    } else {
      //if the product is not in the cart,add it with the provided details
      state = {
        ...state,
        productId: Cart(
            productName: productName,
            productPrice: productPrice.toInt(),
            category: category,
            image: image,
            vendorId: vendorId,
            productQuantity: productQuantity,
            quantity: quantity,
            productId: productId,
            description: description,
            fullName: fullName)
      };
      _saveCartItems();
    }
  }

  void incrementCartItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity++;

      //Notifier listener that the state has changed
      state = {...state};
      _saveCartItems();
    }
  }

  void decrementCartItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity--;

      //Notifier listener that the state has changed
      state = {...state};
      _saveCartItems();
    }
  }

  void removeCartItem(String productId) {
    state.remove(productId);

    //Notifier listener that the state has changed
    state = {...state};
    _saveCartItems();
  }

  double calculateTotalAmount() {
    double totalAmount = 0.0;
    state.forEach((productId, cartItem) {
      totalAmount += cartItem.quantity * cartItem.productPrice;
    });
    return totalAmount;
  }

  //Method to clear all items in the cart
  void clearCart() {
    state = {};
    //Notify the listeners that the state has changed

    state = {...state};

    _saveCartItems();
  }

  Map<String, Cart> get getCartItems => state;
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marketmate_app/models/order.dart';
import 'package:marketmate_app/services/manage_http_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global_variables.dart';
import 'package:http/http.dart' as http;

class OrderController {
  //function to upload order
  upfloadOrders(
      {required String id,
      required String fullName,
      required String email,
      required String state,
      required String city,
      required String locality,
      required String productName,
      required int productPrice,
      required int quantity,
      required String category,
      required String image,
      required String buyerId,
      required String vendorId,
      required bool processing,
      required bool delivered,
      required String paymentStatus,
      required String paymentIntentId,
      required String paymentMethod,
      required context}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");
      final Order order = Order(
          id: id,
          fullName: fullName,
          email: email,
          state: state,
          city: city,
          locality: locality,
          productName: productName,
          productPrice: productPrice,
          quantity: quantity,
          category: category,
          image: image,
          buyerId: buyerId,
          vendorId: vendorId,
          processing: processing,
          delivered: delivered,
          paymentStatus: paymentStatus,
          paymentIntentId: paymentIntentId,
          paymentMethod: paymentMethod);

      http.Response response = await http.post(
        Uri.parse("$uri/api/orders"),
        body: order.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
          "x-auth-token": token!
        },
      );
      print("Order upload: ${response.statusCode}");
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'You have place your order');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //Method to get orders by buyerid
  Future<List<Order>> loadOrders({required String buyerId, context}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");
      print("buyerId: $buyerId");
      http.Response response = await http.get(
        Uri.parse('$uri/api/orders/$buyerId'),
        headers: <String, String>{
          "Content-Type": 'application/json;charset=UTF-8',
          "x-auth-token": token!
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Order> orderList =
            data.map((order) => Order.fromJson(order)).toList();
        print("orderlist: ${orderList.length}");

        showSnackBar(context, 'OrderList: ${orderList.length}');

        return orderList;
      }
      {
        //Throw an exception if the server responsed with an error status code
        throw Exception("failed to load order");
      }
    } catch (e) {
      throw Exception("Error loading Orders:${e.toString()}");
    }
  }

  Future<void> deleteOrder({required String id, required context}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");
      http.Response response = await http.delete(
        Uri.parse("$uri/api/orders/$id"),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
          "x-auth-token": token!
        },
      );
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Order deleted successfully');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //Method to count delivered orders
  Future<int> getDeliveredOrderCount({required String buyerId}) async {
    try {
      //load all order
      List<Order> orders = await loadOrders(buyerId: buyerId);
      //Filter only delivered orders
      int deliveredCount = orders.where((order) => order.delivered).length;
      return deliveredCount;
    } catch (e) {
      throw Exception("Error counting Delivered Orders");
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      {required int amount, required String currency}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('auth_token');

      http.Response response = await http.post(
          Uri.parse('$uri/api/payment-intent'),
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8',
            "x-auth-token": token!
          },
          body: jsonEncode({'amount': amount, 'currency': currency}));
      print("PaymentIntentResponse: ${response.body}");
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to create payment intent ${response.body}");
      }
    } catch (e) {
      throw Exception("Error create payment intent$e");
    }
  }
  Future<String?> refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString(refresh_token);

    if (refreshToken == null) return null;

    final response = await http.post(
      Uri.parse("$uri/api/refresh-token"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'refreshToken': refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      final newToken = jsonDecode(response.body)['accessToken'];
      await prefs.setString(auth_token, newToken);
      return newToken;
    }

    return null;
  }

  Future<http.Response> authorizedGet(String url) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(auth_token);

    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 401) {
      final newToken = await refreshAccessToken();
      if (newToken == null) throw Exception("Session expired");

      // 🔁 retry with new token
      response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $newToken',
        },
      );
    }

    return response;
  }

  //retrive payment intent to know if the payment was successful or not
  Future<Map<String, dynamic>> getPaymentIntentStatus({
    required BuildContext context,
    required String paymentIntentId,
  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('auth_token');
      final url='$uri/api/payment-intent/$paymentIntentId';
      print("Request PaymentIntentId: $url");
      print("Request token: $token");



      http.Response response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8',
            'x-auth-token': token!
          });

     // final response=await authorizedGet(url);
      print("Response PaymentIntentId: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to get payment intent ${response.body}");
      }
    } catch (e) {
      throw Exception("Failed to get payment intent expire $e");
    }
  }
}

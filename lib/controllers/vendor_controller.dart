import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:marketmate_app/global_variables.dart';
import 'package:marketmate_app/models/banner_model.dart';

import '../models/vendor_model.dart';

class VendorController {
  //Fetch Banners

  Future<List<Vendor>> loadVendor() async {
    try {
      //send an http get request to fetch banners
      http.Response response = await http.get(Uri.parse('$uri/api/vendors'),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8'
          });
      print("Vendor: ${response.body}");
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Vendor> vendors =
        data.map((vendor) => Vendor.fromMap(vendor)).toList();
        return vendors;
      } else {
        throw Exception('Failed to load Banners');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error loading Banners$e');
    }
  }
}

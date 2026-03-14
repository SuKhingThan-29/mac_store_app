import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:marketmate_app/models/subcategory.dart';

import '../global_variables.dart';

class SubcategoryController {
  Future<List<Subcategory>> getSubCategoryByCategoryName(
      String categoryName) async {
    try {
      //send an http get request to fetch banners
      http.Response response = await http.get(
          Uri.parse('$uri/api/category/$categoryName/subcategories'),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8'
          });
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          List<Subcategory> subcategories = data
              .map((subcategory) => Subcategory.fromJson(subcategory))
              .toList();
          return subcategories;
        } else {
          print('subcategories not found');
          return [];
        }
      } else if (response.statusCode == 404) {
        print("subcategories not found");
        return [];
      } else {
        print("fail to fetch subcategoris");
        return [];
      }
    } catch (e) {
      print("error fetching categories $e");
      throw Exception('Error loading Categories$e');
    }
  }
}

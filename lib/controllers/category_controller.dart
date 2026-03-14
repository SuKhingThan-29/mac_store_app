import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:marketmate_app/models/category.dart';

import '../global_variables.dart';

class CategoryController {
  //Fetch Category

  Future<List<Category>> loadCategories() async {
    try {
      //send an http get request to fetch banners
      http.Response response = await http.get(Uri.parse('$uri$categoriesApi'),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8'
          });
      print('Response Category: ${response.body}');
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Category> categories =
            data.map((category) => Category.fromJson(category)).toList();
        return categories;
      } else {
        throw Exception('Failed to load Categories');
      }
    } catch (e) {
      throw Exception('Error loading Categories$e');
    }
  }
}

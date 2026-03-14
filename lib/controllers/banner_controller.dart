import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:marketmate_app/global_variables.dart';
import 'package:marketmate_app/models/banner_model.dart';

class BannerController {
  //Fetch Banners

  Future<List<BannerModel>> loadBanners() async {
    try {
      //send an http get request to fetch banners
      http.Response response = await http.get(Uri.parse('$uri/api/banner'),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8'
          });
      print("Banner Response: ${response.body}");
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<BannerModel> banners =
            data.map((banner) => BannerModel.fromJson(banner)).toList();
        return banners;
      } else {
        throw Exception('Failed to load Banners');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error loading Banners$e');
    }
  }
}

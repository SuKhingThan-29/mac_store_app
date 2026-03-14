import 'dart:convert';

import 'package:http/http.dart' as http;

import '../global_variables.dart';
import '../models/product.dart';

class ProductController {
  Future<List<Product>> loadPopularProducts() async {
    try {
      http.Response response = await http
          .get(Uri.parse("$uri/api/popular-product"), headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print("Response PopularProduct list: ${data.length}");

        //map each items in the list to the product model object which we can use
        List<Product> products = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();

        print("Response PopularProduct list2: ${products.length}");

        return products;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Fail to load popular product');
      }
    } catch (e) {
      throw Exception('Fail to load popular product');
    }
  }

  Future<List<Product>> loadProductByCategory(String category) async {
    try {
      http.Response response = await http.get(
          Uri.parse("$uri/api/products-by-category/$category"),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8',
          });
      print("Response getProduct: ${response.statusCode}");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;

        List<Product> products = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();

        return products;
      }else if (response.statusCode == 404) {
        return [];
      }  else {
        throw Exception('Fail to load product by category');
      }
    } catch (e) {
      throw Exception('Fail to load : $e');
    }
  }

  //display related product by subcategory
  Future<List<Product>> loadRelatedProducteBySubCategory(
      String productId) async {
    try {
      http.Response response = await http.get(
          Uri.parse("$uri/api/related-products-by-subcategory/$productId"),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8',
          });
      print("Response getRelatedProduct: ${response.statusCode}");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        print("Response getRelatedProduct s: ${data.length}");

        List<Product> relatedProducts = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        print("Response getRelatedProduct list: ${relatedProducts.length}");

        return relatedProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Fail to load related product by category');
      }
    } catch (e) {
      throw Exception('Error related product : $e');
    }
  }
//display product by subcategory
  Future<List<Product>> loadProducteBySubCategory(
      String subCategory) async {
    try {
      
      http.Response response = await http.get(
          Uri.parse("$uri/api/products-by-subcategory/$subCategory"),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8',
          });
      print("Response subcategoryProduct: ${response.statusCode}");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        print("Response subcategoryProduct s: ${data.length}");

        List<Product> relatedProducts = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        print("Response subcategoryProduct list: ${relatedProducts.length}");

        return relatedProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Fail to load subcategory products');
      }
    } catch (e) {
      throw Exception('Error subcategory product : $e');
    }
  }
  //method to get the top 10 highest-related products
  Future<List<Product>> loadTopRatedProduct() async {
    try {
      http.Response response = await http.get(
          Uri.parse("$uri/api/top-rated-products"),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8',
          });
      print("Response getTopRelatedProduct: ${response.statusCode}");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        print("Response getTopRelatedProduct s: ${data.length}");

        List<Product> relatedProducts = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        print("Response getTopRelatedProduct list: ${relatedProducts.length}");

        return relatedProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Fail to load top related product by category');
      }
    } catch (e) {
      throw Exception('Error top related product : $e');
    }
  }


   //Method to search for products by name of description 
   Future<List<Product>> searchProducts(String query) async {
    try {
      http.Response response = await http.get(
          Uri.parse("$uri/api/search-products?query=$query"),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8',
          });
      print("Response getSearchProduct: ${response.statusCode}");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        print("Response getSearchProduct s: ${data.length}");

        List<Product> relatedProducts = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        print("Response getSearchProduct list: ${relatedProducts.length}");

        return relatedProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Fail to SearchProduct');
      }
    } catch (e) {
      throw Exception('Error SearchProduct : $e');
    }
  }
  Future<List<Product>> loadVendorProduct(
      String vendorId) async {
    try {

      http.Response response = await http.get(
          Uri.parse("$uri/api/products/vendor/$vendorId"),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8',
          });
      print("Response vendorProduct: ${response.statusCode}");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        print("Response vendorProduct s: ${data.length}");

        List<Product> vendorProduct = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        print("Response vendorProduct list: ${vendorProduct.length}");

        return vendorProduct;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Fail to load vendorProduct ');
      }
    } catch (e) {
      throw Exception('Error vendorProduct: $e');
    }
  }

}

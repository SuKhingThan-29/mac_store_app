// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Product {
  final String productName;
  final int productPrice;
  final int quality;
  final String description;
  final String category;
  final String fullName;
  final String vendorId;
  final String subcategory;
  final List<String> images;
  final bool popular;
  final bool recommend;
  final String id;
  final double averageRating;
  final int totalRating;

  Product({
    required this.productName,
    required this.productPrice,
    required this.quality,
    required this.description,
    required this.category,
    required this.fullName,
    required this.vendorId,
    required this.subcategory,
    required this.images,
    required this.popular,
    required this.recommend,
    required this.id,
    required this.averageRating,
    required this.totalRating,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productName': productName,
      'productPrice': productPrice,
      'quality': quality,
      'description': description,
      'category': category,
      'fullName': fullName,
      'vendorId': vendorId,
      'subcategory': subcategory,
      'images': images,
      'popular': popular,
      'recommend': recommend,
      'id': id,
      'averageRating': averageRating,
      'totalRating': totalRating,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productName: map['productName'] as String,
      productPrice: map['productPrice'] as int, // Ensuring double type
      quality: map['quality'] as int,
      description: map['description'] as String,
      category: map['category'] as String,
      fullName: map['fullName'] as String,
      vendorId: map['vendorId'] as String,
      subcategory: map['subcategory'] as String,
      images: List<String>.from(map['images'] as List),
      popular: map['popular'] as bool,
      recommend: map['recommend'] as bool,
      id: map['_id'] as String, // Fixed key
      averageRating: (map['averageRating'] as num).toDouble(), // Ensuring double type
      totalRating: map['totalRatings'] as int, // Fixed key
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}

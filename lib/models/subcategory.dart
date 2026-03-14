import 'dart:convert';

//Deserialize
Subcategory subcategoryFromJson(String str) =>
    Subcategory.fromJson(json.decode(str));

//Serialize
String subcategoryToJson(Subcategory data) => json.encode(data.toJson());

class Subcategory {
  String id;
  String categoryId;
  String categoryName;
  String image;
  String subCategoryName;

  Subcategory({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.image,
    required this.subCategoryName,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
        id: json["_id"] as String,
        categoryId: json["categoryId"] as String,
        categoryName: json["categoryName"] as String,
        image: json["image"] as String,
        subCategoryName: json["subCategoryName"] as String,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "categoryId": categoryId,
        "categoryName": categoryName,
        "image": image,
        "subCategoryName": subCategoryName
      };
}

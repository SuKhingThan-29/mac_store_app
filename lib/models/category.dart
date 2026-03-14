import 'dart:convert';

//Deserialize
Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

//Serialize
String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  String id;
  String name;
  String image;
  String banner;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.banner,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"] as String,
        name: json["name"] as String,
        image: json["image"] as String,
        banner: json["banner"] as String,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "image": image,
        "banner": banner,
      };
}

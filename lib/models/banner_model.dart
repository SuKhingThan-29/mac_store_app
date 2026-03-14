import 'dart:convert';

//Deserialize
BannerModel bannerFromJson(String str) =>
    BannerModel.fromJson(json.decode(str));

//Serialize
String bannerToJson(BannerModel data) => json.encode(data.toJson());

class BannerModel {
  final String id;
  final String image;

  BannerModel({required this.id, required this.image});

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json["_id"] as String,
        image: json["image"] as String,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "image": image,
      };
}

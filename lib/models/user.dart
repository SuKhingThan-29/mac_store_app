import 'dart:convert';

class User {
  final String id;
  final String fullName;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String password;
  final String token;
  User(
      {required this.id,
      required this.fullName,
      required this.email,
      required this.state,
      required this.city,
      required this.locality,
      required this.password,
      required this.token});

  //Serialization:Convert User Object to a Map
  //Map: A Map is a collection fo key-value pairs
  //Why:Converting to a map is an intermediate step that makes it easier to serialize the object to formats like Json for storage or transmission

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "fullName": fullName,
      "email": email,
      "state": state,
      "city": city,
      "locality": locality,
      "password": password,
      "token": token
    };
  }
//Serialization:Convert Map to a Json String
//This method directly encodes the data from the Map inot a Json String
//The json.encode() function converts a Dart object (such as Map or List) into a Json String representation, making it suitable for communication between different systems.

  String toJson() => json.encode(toMap());

//Deserialization: Convert a Map to a User Object
//purpose Manipulation and user: Once the data is converted to a User object it can be easily manipulated and use within the application.
//for example we might want to display the user's fullName,email etc on the Ui or we might want ot save the data locally.

//The factory constructor takes a Map(usuall obtained from  a Json object) and converts it into a User object.
//if a field is not presend in the, it defaults to an empty string.

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: map['_id'] as String? ?? "",
        fullName: map['fullName'] as String? ?? "",
        email: map['email'] as String? ?? "",
        state: map['state'] as String? ?? "",
        city: map['city'] as String? ?? "",
        locality: map['locality'] as String? ?? "",
        password: map['password'] as String? ?? "",
        token: map['refreshToken'] as String? ?? "");
  }
  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}

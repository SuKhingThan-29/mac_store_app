import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:marketmate_app/provider/delivered_order_count_provider.dart';
import 'package:marketmate_app/provider/user_provider.dart';
import 'package:marketmate_app/views/presentation/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global_variables.dart';
import '../models/user.dart';
import '../services/manage_http_response.dart';
import '../views/presentation/authentication_screen/login_screen.dart';
import '../views/presentation/authentication_screen/otp_screen.dart';

class AuthController {
  final providerContainer = ProviderContainer();

  Future<void> singUpUsers({
    required BuildContext context,
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      User user = User(
          id: '',
          fullName: fullName,
          email: email,
          state: '',
          city: '',
          locality: '',
          password: password,
          token: '');
      http.Response response = await http.post(Uri.parse('$uri/api/signup'),
          body: user
              .toJson(), //convert the user Object to json for the request body,
          headers: <String, String>{
            //set the headers for the request
            "Content-Type": "application/json; charset=UTF-8",
            //specify the context types as Json
          });
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) {
                return OtpScreen(email: email);
              },
            ), (route) => false);
            showSnackBar(context, 'Account created. Please verify your otp');
          });
    } catch (e) {}
  }

  //Update user's state,city and locality
  Future<void> updateUserLocation(
      {required String id,
      required String state,
      required String city,
      required String locality,
      required context,
      required WidgetRef ref}) async {
    try {
      //make an Http Put to update user's state,city and locality
      http.Response response = await http.put(Uri.parse('$uri/api/users/$id'),
          //set the header for the request to specify that the content is Json
          headers: <String, String>{
            "Content-Type": "application/json;charset=UTF-8"
          },
          //encode the update data {state,city and locality} as Json Object
          body:
              jsonEncode({'state': state, 'city': city, 'locality': locality}));
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () async {
            //Decode the updated user data from the response body
            //this convert the json String response into Dart Map
            final updatedUser = jsonDecode(response.body);
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            final userJson = updatedUser['user'] as Map<String,dynamic>;
            ref.read(userProvider.notifier).setUser(userJson);

            await preferences.setString('user', jsonEncode(updatedUser));
             showSnackBar(context, 'Success Updated User: ${response.body}');
          });
    } catch (e) {
      showSnackBar(context, 'Error Updating: $e');
    }
  }

  //Signin
  Future<void> signInUsers(
      {required BuildContext context,
      required String email,
      required String password,
      required WidgetRef ref}) async {
    try {
      http.Response response = await http.post(Uri.parse("$uri/api/signin"),
          body: jsonEncode({
            'email': email,
            'password': password,
          }),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          });
      print("Response Login: ${response.statusCode}");
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();

            final data = jsonDecode(response.body);

            final userJson=data['user'] as Map<String,dynamic>;

            final accessToken = data['accessToken'];
            final refreshToken = data['refreshToken'];

            await pref.setString(auth_token, accessToken);
            await pref.setString(refresh_token, refreshToken);

            // response.body is already JSON string ✅
            await pref.setString(user, response.body);

            // keep provider in sync
            ref.read(userProvider.notifier).setUser(userJson);
            print("FullName:${ref.read(userProvider)!.fullName}");
            print("Full email:${ref.read(userProvider)!.email}");
            print("Full buyerId:${ref.read(userProvider)!.id}");


            if (ref.read(userProvider)!.token.isNotEmpty) {
              Navigator.pushAndRemoveUntil(
                  context,
                  //newRoute
                  MaterialPageRoute(builder: (context) => MainScreen()),
                  // predicate
                  (route) => false);
            } else {
              showSnackBar(context, 'Logged In: Token is empty');
            }

            showSnackBar(context, 'Logged In');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //Verify Otp Method
  Future<void> verifyOtp(
      {required BuildContext context,
      required String email,
      required String otp}) async {
    try {
      http.Response response = await http.post(Uri.parse('$uri/api/verify-otp'),
          body: jsonEncode({"email": email, "otp": otp}),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          });
      print("OTP: $otp");
      print("OTP response: ${response.body}");

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            Navigator.pushAndRemoveUntil(
                context,
                //newRoute
                MaterialPageRoute(builder: (context) => LoginScreen()),
                // predicate
                (route) => false);
            showSnackBar(context, 'Account verified. Please login.');
          });
    } catch (e) {
      showSnackBar(context, 'error verified: $e');
    }
  }

  getUserData(context, WidgetRef ref) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      String? token = pref.getString('auth_token');
      if (token == null) {
        pref.setString('auth_token', '');
      }
      var tokenResponse = await http
          .post(Uri.parse('$uri/tokenIsValid'), headers: <String, String>{
        "Content-Type": "application/json;charset=UTF-8",
        "x-auth_token": token!,
      });
      var response = jsonDecode(tokenResponse.body);
      if (response == true) {
        http.Response userResponse =
            await http.get(Uri.parse('$uri/'), headers: <String, String>{
          "Content-Type": "application/json;charset=UTF-8",
          "x-auth_token": token,
        });
        final userJson=response['user'] as Map<String,dynamic>;
        ref.read(userProvider.notifier).setUser(userJson);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //SignOut
  Future<void> signOutUser(
      {required BuildContext context, required WidgetRef ref}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.remove(auth_token);
      pref.remove(user);
      ref.read(userProvider.notifier).signout();
      ref.read(deliveredOrderCountProvider.notifier).resetCount();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return LoginScreen();
      }), (route) => false);
      showSnackBar(context, 'Signout successfully');
    } catch (e) {
      showSnackBar(context, 'error signing out');
    }
  }

  Future<void> deleteAccount(
      {required BuildContext context,
      required String id,
      required WidgetRef ref //Access to the riverpod provider
      }) async {
    try {
      //Get the authentication token from shared preferences for authorization
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('auth_token');
      if (token == null) {
        showSnackBar(context, "You need to login to perform this action");
        return;
      }

      //Send delete request to the backend api
      http.Response response = await http.delete(
          Uri.parse("$uri/api/user/delete-account/$id"),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            "x-auth-token": token
          });
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () async {
            //handle successful deleion, navigate the user back to the login presentation

            //clear user data from sharedPreferences
            await pref.remove('auth_token');

            await pref.remove('user');

            //clear the user data from the provider state
            ref.read(userProvider.notifier).signout();

            //Redirect to the login presentation after successfull deletion
            showSnackBar(context, 'Account Deleted successfully');

            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return LoginScreen();
            }), (route) => false);
          });
    } catch (e) {
      showSnackBar(context, 'Error deleting accunt $e');
    }
  }
}

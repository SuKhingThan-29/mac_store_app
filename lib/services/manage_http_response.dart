import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void manageHttpResponse(
    {required http.Response response, //the Http response from the request
    required BuildContext context,
    required VoidCallback onSuccess}) {
  switch (response.statusCode) {
    case 200: //status code 200 indicates a successful request
      onSuccess();
      break;
    case 400: //status code 400 indicate bad request
      showSnackBar(context, json.decode(response.body)['msg']);
      break;
    case 500: //status code 500 indicate a server error
      showSnackBar(context, json.decode(response.body)['error']);
      break;
    case 201: //status code 201 indicate a resource was created successfully
      onSuccess();
      break;
  }
}

void showSnackBar(BuildContext context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: EdgeInsets.all(15),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.grey,
      content: Text(title)));
}

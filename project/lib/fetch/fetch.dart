// import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_forms/models/products.dart';
import 'package:flutter_forms/models/usermodel.dart';
import 'package:http/http.dart';

Future<User> fetchUser(
    String kullaniciadiController, String sifreController) async {
  String authorization =
      kullaniciadiController + ":" + sifreController + ":61:61:TRTR";
  Codec<String, String> stringToBase4 = utf8.fuse(base64);
  String authorizationEncoded = "BASIC " + stringToBase4.encode(authorization);

  final response = await post(
    Uri.parse('https://jptest.diyalogo.com.tr/logo/restservices/rest/login'),
    headers: {
      HttpHeaders.authorizationHeader: authorizationEncoded,
    },
  );
  print(response.statusCode);
  return User.fromJson(json.decode(response.body));
}

Future<Products> fetchProduct(String authToken, String nameController) async {
  authToken = "61:" + authToken + ":" + nameController;
  Codec<String, String> stringToBase4 = utf8.fuse(base64);
  String authTokenEncoded = stringToBase4.encode(authToken);
  final response = await get(
    Uri.parse(
        'https://jptest.diyalogo.com.tr/logo/rest/v1.0/mmitemexchanges?offset=0&limit=100&direction=desc&expandlevel=25'),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      'Auth-Token': authTokenEncoded
    },
  );

  return Products.fromJson(List<dynamic>.from(
      json.decode(utf8.decode(response.bodyBytes))['data']['items']));
}

Future<int> fetchUpdate(
    Product product, String nameController, String authToken) async {
  authToken = "61:" + authToken + ":" + nameController;
  Codec<String, String> stringToBase4 = utf8.fuse(base64);
  String authTokenEncoded = stringToBase4.encode(authToken);

  final response = await get(
    Uri.parse(
        'https://jptest.diyalogo.com.tr/logo/rest/v1.0/mmitemexchanges/${product.uuid}?expandlevel=25'),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      'Auth-Token': authTokenEncoded
    },
  );
  var updateFile = json.decode(response.body);
  updateFile['data']['name'] = product.name;
  updateFile['data']['code'] = product.code;
  updateFile['data']['mainImage']['document'] = product.mainImage;
  if (updateFile['data']['mainImages']['items'].length > 0)
    updateFile['data']['mainImages']['items'][0]['document'] =
        product.mainImage;

  final update = await put(
    Uri.parse(
        'https://jptest.diyalogo.com.tr/logo/rest/v1.0/mmitemexchanges/${product.uuid}?expandlevel=25'),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      'Auth-Token': authTokenEncoded
    },
    body: json.encode(updateFile['data']),
  );
  return update.statusCode;
}

Future<int> fetchSave(
    Product product, String nameController, String authToken) async {
  authToken = "61:" + authToken + ":" + nameController;
  Codec<String, String> stringToBase4 = utf8.fuse(base64);
  String authTokenEncoded = stringToBase4.encode(authToken);
  var saveFile = json.decode("{"
      "\"data\": {"
      "\"code\": \"${product.code}\","
      "\"name\": \"${product.name}\","
      "\"mainImage\": {\"document\": \"${product.mainImage.toString()}\"},"
      "\"mainImages\": {\"items\": [{\"document\": \"${product.mainImage.toString()}\"}"
      "]"
      "}"
      "}"
      "}");
  final save = await post(
    Uri.parse('https://jptest.diyalogo.com.tr/logo/rest/v1.0/mmitemexchanges/'),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      'Auth-Token': authTokenEncoded
    },
    body: json.encode(saveFile['data']),
  );
  return save.statusCode;
}

Future<int> fetchDelete(
    Product product, String nameController, String authToken) async {
  authToken = "61:" + authToken + ":" + nameController;
  Codec<String, String> stringToBase4 = utf8.fuse(base64);
  String authTokenEncoded = stringToBase4.encode(authToken);

  final deleteproduct = await delete(
    Uri.parse(
        'https://jptest.diyalogo.com.tr/logo/rest/v1.0/mmitemexchanges/${product.uuid}?expandlevel=25'),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      'Auth-Token': authTokenEncoded
    },
  );
  return deleteproduct.statusCode;
}

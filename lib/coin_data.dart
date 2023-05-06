import 'package:crypto_tracker/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'dart:convert';

class CoinData {
  Future getCoinData(String crypto, String curr) async {
    // String requestURL = "$apiURL?$apiKey$apiKey&target=$curr";
    String requestURL = "$apiURL/$crypto/$curr?$apiKey&$inv";
    http.Response response = await http.get(Uri.parse(requestURL));

    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      var lastPrice = ((decodedData)["rate"]);
      return lastPrice;
    } else {
      print(response.statusCode);
      throw 'Problem with the get request';
    }
  }
}

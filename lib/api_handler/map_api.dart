import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_status_code/http_status_code.dart';

class MapApi {
  static Future<Map<String, dynamic>> fetchTaxiData() async { // todo unused bc cannot decode correctly
    Uri url = Uri.parse("https://api.data.gov.sg/v1/transport/taxi-availability");

    http.Response response = await http.get(url);

    if (response.statusCode == StatusCode.OK) {
      String responseBody = response.body;
      Map<String, dynamic> res = Map<String, dynamic>.from(json.decode(responseBody));
      return res;
    } else {
      print(
          "ERROR fetching taxi data: ${response.statusCode} ${getStatusMessage(response.statusCode)}");
      return {};
    }
  }
}
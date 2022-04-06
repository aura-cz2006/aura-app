import 'dart:convert';

import 'package:aura/config/config.dart';
import 'package:aura/models/amenity_category.dart';
import 'package:http/http.dart' as http;
import 'package:http_status_code/http_status_code.dart';

class MapApi {
  static Future<Map<String, dynamic>> fetchTaxiData() async {
    // todo unused bc cannot decode correctly
    Uri url = Uri.parse(
        "https://api.data.gov.sg/v1/transport/taxi-availability"); //Uri.parse("${Config().routes["api"]}/proxy/taxis/");

    http.Response response = await http.get(url);

    if (response.statusCode == StatusCode.OK) {
      String responseBody = response.body;
      Map<String, dynamic> res =
          Map<String, dynamic>.from(json.decode(responseBody));
      return res;
    } else {
      print(
          "ERROR fetching taxi data: ${response.statusCode} ${getStatusMessage(response.statusCode)}");
      return {};
    }
  }

  static Future<List<dynamic>> fetchAmenitiesData(
      AmenityCategory category) async {
    String? queryString = CategoryConvertor.getQueryString(category);
    if (queryString == null) {
      print("ERROR: invalid amenity category.");
      return [];
    }

    Uri url =
        Uri.parse("${Config().routes["api"]}/proxy/amenities/$queryString");

    http.Response response = await http.get(url);

    if (response.statusCode == StatusCode.OK) {
      String responseBody = response.body;
      List<dynamic> res = json
          .decode(responseBody)['query']
          .where((x) => x["FeatCount"] == null)
          .toList()
          .map((x) => {
                "name": x['NAME'],
                "lat": double.parse(x['LatLng'].split(',')[0]),
                "lng": double.parse(x['LatLng'].split(',')[1])
              })
          .toList();
      return res;
    } else {
      print(
          "ERROR fetching taxi data: ${response.statusCode} ${getStatusMessage(response.statusCode)}");
      return [];
    }
  }
}

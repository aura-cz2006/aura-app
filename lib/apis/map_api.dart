import 'dart:convert';

import 'package:aura/config/config.dart';
import 'package:aura/models/amenity_category.dart';
import 'package:http/http.dart' as http;
import 'package:http_status_code/http_status_code.dart';

class MapApi {
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
      Map<String, dynamic> responseBody = json.decode(response.body);
      List<dynamic> res = responseBody['query']
          .where((x) =>
              x["NAME"] !=
              null) // ignore metadata //todo fix where called on null
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

  static Future<List<Map<String, dynamic>>> fetchBusStopData() async {
    Uri url = Uri.parse("${Config().routes["api"]}/proxy/buses/busstops");

    http.Response response = await http.get(url);

    if (response.statusCode == StatusCode.OK) {
      String responseBody = response.body;
      List<Map<String, dynamic>> res = json.decode(responseBody)['busstops'];
      return res;
    } else {
      print(
          "ERROR fetching taxi data: ${response.statusCode} ${getStatusMessage(response.statusCode)}");
      return [];
    }
  }
}

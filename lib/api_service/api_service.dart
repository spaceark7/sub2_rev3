import 'dart:convert';
import 'package:pickeat/data/model/restaurant.dart';
import 'package:pickeat/data/model/restaurant_detail.dart';
import 'package:pickeat/data/model/search_result.dart';

import 'package:http/http.dart' as http;


class ApiService {
  static final String _baseUrl = "https://restaurant-api.dicoding.dev";
  static final String _listEndpoint = "/list";
  static final String _detailEndpoint = "/detail/";
  static final String _searchEndpoint = "/search?q=";

  Future<RestaurantResult> restaurantList() async {
    final response = await http.get(Uri.parse(_baseUrl + _listEndpoint));
    if (response.statusCode == 200) {
      return RestaurantResult.fromJson(json.decode(response.body));
    } else {
      return throw Exception("Failed to load list restaurant");
    }
  }

  Future<RestaurantDetailResult> restaurantDetail(String id) async {
    final response = await http.get(Uri.parse(_baseUrl + _detailEndpoint + id));
    if (response.statusCode == 200) {
      return RestaurantDetailResult.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed Fetch Detail Data");
    }
  }

  Future<SearchResult> searchRestaurant(String query) async {
    final response = await http.get(Uri.parse(_baseUrl + _searchEndpoint + query));
    if (response.statusCode == 200) {
      return SearchResult.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed fetch data");
    }
  }
}

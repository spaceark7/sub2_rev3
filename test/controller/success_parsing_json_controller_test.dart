import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pickeat/data/model/restaurant.dart';
import 'package:http/http.dart' as http;

void main() {
  test('Fetching data from Internet, Then Parse json to a list of restaurant object', () async {
    // arrange
    var restaurantsData;
    var restaurant;
    //Act
    var dataFromApi = await http.get(Uri.parse("https://restaurant-api.dicoding.dev/list"));
    var decode = jsonDecode(dataFromApi.body);

    restaurantsData = List<Restaurant>.from((decode['restaurants'] as List).map((e) => Restaurant.fromJson(e)));
    restaurant = restaurantsData[0]; 

    //assert
    expect(restaurant, isA<Restaurant>());
    
    /// uncomment below for fail test
    // expect(restaurant, isA<List<Restaurant>>());
  });
}

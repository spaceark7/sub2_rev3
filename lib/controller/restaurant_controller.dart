import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickeat/api_service/api_service.dart';
import 'package:pickeat/common/style.dart';
import 'package:pickeat/data/model/restaurant.dart';
import 'package:pickeat/data/model/restaurant_detail.dart';


class RestaurantController extends GetxController {
  var _restaurants = <Restaurant>[].obs;
  var _restaurant = Detail().obs;
  var _message = "".obs;
  var _isLoading = true.obs;
  var _searchResult = <Restaurant>[].obs;
  var _favList = <Restaurant>[].obs;
  var _isFav = false.obs;
  var query = "".obs;
  var _isSearch = false.obs;
  var _isNotFound = false.obs;

  get restaurants => this._restaurants;

  set restaurants(var value) => this._restaurants = value;

  get restaurant => this._restaurant;

  set restaurant(value) => this._restaurant = value;
  get favList => this._favList;
  get message => this._message;

  set message(value) => this._message = value;

  get isLoading => this._isLoading;

  set isLoading(value) => this._isLoading = value;

  get searchResult => this._searchResult;

  set searchResult(value) => this._searchResult = value;

  get isFav => this._isFav;

  set isFav(value) => this._isFav = value;

  get isSearch => this._isSearch;

  set isSearch(value) => this._isSearch = value;

  get isNotFound => this._isNotFound;

  set isNotFound(value) => this._isNotFound = value;

  RestaurantController() {
    fetchAllRestaurant();
  }

  get getFavList => this._favList;
  bool isFavCheck(dynamic restaurant) {
    return _favList.contains(restaurant);
  }

  void addFavorite(BuildContext context, dynamic restaurant) {
    bool fav = _favList.contains(restaurant);
    if (fav) {
      _isFav.value = false;
      final snackBar = SnackBar(
        duration: const Duration(milliseconds: 900),
        backgroundColor: secondaryBrandColor,
        content: Text('Removed From Favorite List'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      _favList.remove(restaurant);
    } else {
      final snackBar = SnackBar(
        
       
        backgroundColor: accentBrandColor,
         duration: const Duration(milliseconds: 900),
        content: Text('Added To Favorite List'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _isFav.value = true;
      _favList.add(restaurant);
    }
  }

  Future<dynamic> fetchAllRestaurant() async {
    try {
      _isLoading(true);
      var list = await ApiService().restaurantList();
      if (list.restaurants.isEmpty) {
        _message("Oops No data");
        return _message;
      } else {
        _restaurants.value = list.restaurants;
        _isLoading(false);
        return _restaurants;
      }
    } catch (e) {
      _message("Error --> $e");
      return _message;
    }
  }

  Future<dynamic> fetchDetail(String id) async {
    try {
      _isLoading(true);
      var detail = await ApiService().restaurantDetail(id);
      if (detail.error == false) {
        _restaurant(detail.restaurant);
        _isLoading(false);
        return _restaurant;
      }
    } catch (e) {
      _message("Error --> $e");
      return _message;
    } finally {
      _isLoading(false);
    }
  }

  Future<dynamic> fetchSearchData(String query) async {
    try {
      _isSearch(true);
      var searchData = await ApiService().searchRestaurant(query);
      if (searchData.restaurants.isEmpty) {
        _message("Oopsy! Try another keyword.");
        _isSearch(false);
        _isNotFound(true);
        _searchResult.clear();
        return _message;
      } else {
        _isNotFound(false);
        searchData.restaurants.sort((a, b) => b.getRating.compareTo(a.getRating));
        _searchResult.value = searchData.restaurants;
        _isSearch(false);
        return _searchResult;
      }
    } catch (e) {
      _message("Error --> $e");
      return _message;
    } finally {
      _isSearch(false);
    }
  }
}

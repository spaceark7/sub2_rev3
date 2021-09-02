import 'package:get/get.dart';
import 'package:pickeat/common/utils/ResultState.dart';
import 'package:pickeat/data/database/database_helper.dart';
import 'package:pickeat/data/model/restaurant.dart';

class DatabaseController extends GetxController {
  final DatabaseHelper databaseHelper;
  DatabaseController({required this.databaseHelper}) {
    _getFavorites();
  }
  static DatabaseController get to => Get.find();

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;
  var isFav = false.obs;

  List<Restaurant> favorites = <Restaurant>[].obs;

  void _getFavorites() async {
    favorites = await databaseHelper.getFavorites();
    
    if (favorites.length > 0) {
      _state = ResultState.HasData;
        update();
    } else {
      _state = ResultState.NoData;
        update();
      _message = "You haven\'t added any favorite places yet.";
    }
  }

  void addFavorite(Restaurant restaurant) async {
    try {
      await databaseHelper.insertRestaurant(restaurant);
      _getFavorites();
      update();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error : $e';
    }
  }

  Future<bool> isFavorite(String id) async {
    final favoriteRestaurant = await databaseHelper.getFavoritesById(id);
    isFav.value = favoriteRestaurant.isNotEmpty;
    return favoriteRestaurant.isNotEmpty;
  }

  void removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      _getFavorites();
      update();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error : $e';
    }
  }
}

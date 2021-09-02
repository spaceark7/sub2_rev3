import 'package:pickeat/data/model/restaurant.dart';

import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }
  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblFavorite = "favorites";

  Future<Database> _initDb() async {
    var path = getDatabasesPath();
    var db = openDatabase('$path/pickeat.db', onCreate: (db, version) async {
      await db.execute('''CREATE TABLE $_tblFavorite (
                      id TEXT PRIMARY KEY,
                      name TEXT,
                      description TEXT,
                      pictureId TEXT,
                      city TEXT,
                      rating REAL 
                    ) ''');
    }, version: 1);

    return db;
  }

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initDb();
    }
    return _database;
  }

  Future<void> insertRestaurant(Restaurant restaurant) async {
    final db = await database;
    await db!.insert(_tblFavorite, restaurant.toJson());
  }

  Future<List<Restaurant>> getFavorites() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblFavorite);
    
    
    return results.map((e) => Restaurant.fromJson(e)).toList();
  }

  Future<Map> getFavoritesById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(_tblFavorite, where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;

    await db!.delete(_tblFavorite, where: 'id=?', whereArgs: [id]);
  }
}

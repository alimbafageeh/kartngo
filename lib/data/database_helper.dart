import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../models/item.dart'; // ✅ now Item is recognized

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('shop.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // ✅ Pick the right databaseFactory based on platform
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    } else {
      // Android / iOS already supported by sqflite
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price REAL,
        image TEXT,
        category TEXT
      )
    ''');
  }

  // Insert item
  Future<int> insertItem(Item item) async {
    final db = await instance.database;
    return await db.insert('items', item.toMap());
  }

// Fetch all items
  Future<List<Item>> fetchItems() async {
    final db = await instance.database;
    final maps = await db.query('items');
    return maps.map((m) => Item.fromMap(m)).toList();
  }

  // Delete all items
  Future<int> clearItems() async {
    final db = await instance.database;
    return await db.delete('items');
  }

  Future<void> seedDemoItems() async {
    final db = await instance.database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM items'),
    );

    if (count == 0) {
      final demoItems = [
        Item(name: "Cheese Burger", price: 15.0, image: "assets/burger.png", category: "أفضل العروض"),
        Item(name: "Pepperoni Pizza", price: 25.0, image: "assets/pizza.png", category: "مستورد"),
        Item(name: "Fresh Juice", price: 10.0, image: "assets/juice.png", category: "أجبان قابلة للدهن"),
      ];

      for (final item in demoItems) {
        await db.insert('items', item.toMap());
      }
    }
  }

}

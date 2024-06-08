import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/customer.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('customer.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
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
    CREATE TABLE customers(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT NOT NULL,
      mobile TEXT NOT NULL,
      address TEXT,
      image TEXT,
      latitude REAL,
      longitude REAL
    )
    ''');
  }

  Future<List<Customer>> getAllCustomers() async {
    final db = await instance.database;

    final result = await db.query('customers');

    return result.map((json) => Customer.fromJson(json)).toList();
  }

  Future<int> insertCustomer(Customer customer) async {
    final db = await instance.database;
    return await db.insert('customers', customer.toJson());
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tabla para los pedidos
        await db.execute('''
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY,
            item TEXT
          )
        ''');

        // Tabla para la información del usuario logueado
        await db.execute('''
          CREATE TABLE user (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            email TEXT,
            telefono TEXT
          )
        ''');
      },
    );
  }

  // Métodos para gestionar pedidos
  Future<void> insertOrderItem(String item) async {
    final db = await database;
    await db.insert('orders', {'item': item});
  }

  Future<List<String>> getOrderItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('orders');
    return List.generate(maps.length, (i) => maps[i]['item']);
  }

  // Métodos para gestionar la información del usuario logueado
  Future<void> saveUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('user', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getUser() async {
    final db = await database;
    final result = await db.query('user');
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> deleteUser() async {
    final db = await database;
    await db.delete('user');
  }
}

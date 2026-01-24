import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// ------------------------------------------------------------
///                     DATABASE HELPER
///  Gestion centralisée de la base SQLite (Singleton)
/// ------------------------------------------------------------
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Accès unique à la base de données
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('my_app.db');
    return _database!;
  }

  /// Initialisation de la base
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1, // 🔹 Version 1 pour la V1 propre
      onCreate: _createDB,
    );
  }

  /// ------------------------------------------------------------
  ///                     CRÉATION DES TABLES
  /// ------------------------------------------------------------
  Future _createDB(Database db, int version) async {
    // 🔹 TABLE UTILISATEURS
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstname TEXT NOT NULL,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    // 🔹 TABLE CATEGORIES (MODIFIÉE AVEC ICON)
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titre TEXT NOT NULL,
        description TEXT,
        elements TEXT NOT NULL,        -- JSON : ["magasin","rayon","produit"]
        dateCreation TEXT NOT NULL,
        userId INTEGER NOT NULL,
        icon TEXT NOT NULL,            -- 🔥 AJOUT DU CHAMP ICONE
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

    // 🔹 TABLE ITEMS
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        categorieId INTEGER NOT NULL,
        valeurs TEXT NOT NULL,         -- JSON : {"magasin":"LIDL","rayon":"Fruits","produit":"Tomates"}
        dateCreation TEXT NOT NULL,
        FOREIGN KEY (categorieId) REFERENCES categories(id)
      )
    ''');
  }

  /// ------------------------------------------------------------
  ///                     MÉTHODES UTILISATEURS
  /// ------------------------------------------------------------

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await instance.database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUser(String username, String password) async {
    final db = await instance.database;

    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    return result.isNotEmpty ? result.first : null;
  }

  Future<bool> usernameExists(String username) async {
    final db = await instance.database;

    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    return result.isNotEmpty;
  }

  /// ------------------------------------------------------------
  ///                     MÉTHODES CATÉGORIES
  /// ------------------------------------------------------------

  Future<int> insertCategorie(Map<String, dynamic> categorie) async {
    final db = await instance.database;
    return await db.insert('categories', categorie);
  }

  Future<List<Map<String, dynamic>>> getCategoriesByUser(int userId) async {
    final db = await instance.database;
    return await db.query(
      'categories',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'dateCreation DESC',
    );
  }

  Future<int> updateCategorie(int id, Map<String, dynamic> categorie) async {
    final db = await instance.database;
    return await db.update(
      'categories',
      categorie,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCategorie(int id) async {
    final db = await instance.database;

    await db.delete(
      'items',
      where: 'categorieId = ?',
      whereArgs: [id],
    );

    return await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// ------------------------------------------------------------
  ///                     MÉTHODES ITEMS
  /// ------------------------------------------------------------

  Future<int> insertItem(Map<String, dynamic> item) async {
    final db = await instance.database;
    return await db.insert('items', item);
  }

  Future<List<Map<String, dynamic>>> getItemsByCategorie(int categorieId) async {
    final db = await instance.database;
    return await db.query(
      'items',
      where: 'categorieId = ?',
      whereArgs: [categorieId],
      orderBy: 'dateCreation DESC',
    );
  }

  Future<int> updateItem(int id, Map<String, dynamic> item) async {
    final db = await instance.database;
    return await db.update(
      'items',
      item,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteItem(int id) async {
    final db = await instance.database;
    return await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// ------------------------------------------------------------
  ///                     FERMETURE DE LA BASE
  /// ------------------------------------------------------------
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

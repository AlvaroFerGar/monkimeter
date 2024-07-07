import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

   class DatabaseHelper {
     static final DatabaseHelper instance = DatabaseHelper._init();
     static Database? _database;

     DatabaseHelper._init();

     Future<Database> get database async {
       if (_database != null) return _database!;
       _database = await _initDB('cuelgues.db');
       return _database!;
     }

     Future<Database> _initDB(String filePath) async {
       final dbPath = await getDatabasesPath();
       final path = join(dbPath, filePath);
       return await openDatabase(path, version: 1, onCreate: _createDB);
     }

      Future _createDB(Database db, int version) async {
       await db.execute('''
         CREATE TABLE cuelgues(
           id INTEGER PRIMARY KEY AUTOINCREMENT,
           segundos INTEGER,
           mano TEXT,
           pesoExtra INTEGER,
           tipoAgarre TEXT,
           fecha TEXT,
           hora TEXT
         )
       ''');
     }

     Future<int> insertCuelgue(Map<String, dynamic> row) async {
      print(await getDatabasesPath());
       Database db = await instance.database;
       return await db.insert('cuelgues', row);
     }

     Future<List<Map<String, dynamic>>> getCuelgues() async {
       Database db = await instance.database;
       return await db.query('cuelgues', orderBy: 'fecha DESC, hora DESC');
     }

      Future<List<Map<String, dynamic>>> getRecentMatchingCuelgues({
      required String mano,
      required int pesoExtra,
      required String tipoAgarre,
      int limit = 5
    }) async {
      Database db = await instance.database;
      return await db.query(
        'cuelgues',
        where: 'mano = ? AND pesoExtra = ? AND tipoAgarre = ?',
        whereArgs: [mano, pesoExtra, tipoAgarre],
        orderBy: 'fecha DESC, hora DESC',
        limit: limit,
      );
    }

     Future<void> deleteDatabase() async {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'cuelgues.db');

      // Close the database before deleting it
      if (_database != null) {
        await _database!.close();
        _database = null;
      }

      await databaseFactory.deleteDatabase(path);
    }
   }
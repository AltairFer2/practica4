import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pmsn20232/models/task_model.dart';
import 'package:pmsn20232/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AgendaDB {
  static final nameDB = 'AGENDADB';
  static final versionDB = 1;

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database!;
    return _database = await _initDatabase();
  }

  Future<Database?> _initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String pathDB = join(folder.path, nameDB);
    return openDatabase(pathDB, version: versionDB, onCreate: _createTables);
  }

  FutureOr<void> _createTables(Database db, int version) {
    String taskTableQuery = '''CREATE TABLE tblTareas( 
    idTask INTEGER PRIMARY KEY,
    nameTask VARCHAR(50),
    dscTask VARCHAR(50),
    sttTask BYTE,
    dateTask DATETIME
  );''';
    db.execute(taskTableQuery);

    String userTableQuery = '''CREATE TABLE tblUsuarios( 
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(50),
    password VARCHAR(50),
    userType INTEGER DEFAULT 1
  );''';
    db.execute(userTableQuery);
  }

  Future<int> INSERT(String tblName, Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion!.insert(tblName, data);
  }

  Future<int> UPDATE(String tblName, Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion!.update(tblName, data,
        where: 'idTask = ?', whereArgs: [data['idTask']]);
  }

  Future<int> DELETE(String tblName, int idTask) async {
    var conexion = await database;
    return conexion!.delete(tblName, where: 'idTask = ?', whereArgs: [idTask]);
  }

  Future<List<TaskModel>> GETALLTASK() async {
    var conexion = await database;
    var result = await conexion!.query('tblTareas');
    return result.map((task) => TaskModel.fromMap(task)).toList();
  }

  Future<UserModel?> getUser(String username) async {
    final conexion = await database;
    final result = await conexion!.query(
      'tblUsuarios', // Nombre de la tabla de usuarios en tu base de datos local
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    } else {
      return null;
    }
  }

  // Agrega un usuario a la base de datos local
  Future<int> addUser(UserModel user) async {
    final conexion = await database;
    return conexion!.insert('tblUsuarios', user.toMap());
  }

  Future<bool> userExists(String username) async {
    final conexion = await database;
    final result = await conexion!.query(
      'tblUsuarios',
      columns: ['id'],
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  Future<void> insertUser(Database database) async {
    String insertUserQuery = '''INSERT INTO tblUsuarios (
    username,
    password,
    userType
  ) VALUES (   
    'altair',
    '1234',
    2
  );''';

    try {
      await database.transaction((txn) async {
        await txn.rawInsert(insertUserQuery);
      });
    } catch (e) {
      print('Error al insertar usuario: $e');
    }
  }

  Future<int> getUserType(String username) async {
    final conexion = await database;
    final result = await conexion!.query(
      'tblUsuarios',
      columns: ['userType'],
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isNotEmpty) {
      return result.first['userType'] as int;
    } else {
      // Puedes devolver un valor predeterminado si el usuario no existe
      return 0; // Cambia esto al valor predeterminado que desees
    }
  }
}

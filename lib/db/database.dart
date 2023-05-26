import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled/db/student_table.dart';
import 'class_table.dart';
class SQLiteDb {
  static const String DB_NAME = "attendance1.db";
  static const int DB_VERSION = 1;
  static Database? _database;
  SQLiteDb._internal();
  static final SQLiteDb instance = SQLiteDb._internal();
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _init();
    return _database;
  }
  Future<Database> _init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, DB_NAME);
    return await openDatabase(path, version: DB_VERSION,
        onCreate: (db, version) {
      db.execute(ClassTable.CREATE_TABLE_QUERY);
      db.execute(StudentTable.CREATE_TABLE_QUERY);
    }, onUpgrade: (db, oldVersion, newVersion) {
      if (oldVersion < newVersion) {
        db.execute(StudentTable.CREATE_TABLE_QUERY);
        db.execute(ClassTable.CREATE_TABLE_QUERY);
      }
    });
  }
}

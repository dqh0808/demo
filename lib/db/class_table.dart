


import 'package:sqflite/sqflite.dart';


import '../entity/classs.dart';
import '../entity/classs.dart';
import 'database.dart';

class ClassTable {
  static const String TABLE_NAME = "class";
  static const String ID = "idClass";
  static const String NAME = "nameClass";
  static const String CREATE_TABLE_QUERY = '''
    CREATE TABLE $TABLE_NAME(
      $ID INTEGER PRIMARY KEY AUTOINCREMENT,
      $NAME TEXT
    )
  ''';
  static const String SELECT_ALL_QUERY = '''
    SELECT * FROM $TABLE_NAME
  ''';
  Future<int> insertClass(Classs entity ) async   {
    Database? db = await   SQLiteDb.instance.database;
    return await  db!.insert(TABLE_NAME, entity.toMap());
  }
  //get all class
  Future<List<Classs>> getAllClass() async {
    Database? db = await SQLiteDb.instance.database;
    List<Map<String, dynamic>> result = await db!.rawQuery(SELECT_ALL_QUERY);
    List<Classs> list = [];
    result.forEach((element) {
      list.add(Classs.fromMap(element));
    });
    return list;
  }
  //get class by id
  Future<Classs> getClassById(int id) async {
    Database? db = await SQLiteDb.instance.database;
    List<Map<String, dynamic>> result = await db!.rawQuery('''
    SELECT * FROM $TABLE_NAME WHERE $ID = $id
    ''');
    return Classs.fromMap(result.first);
  }

}
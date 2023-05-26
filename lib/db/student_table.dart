
import 'package:sqflite/sqflite.dart';

import '../entity/student.dart';
import 'database.dart';

class StudentTable{
  static const String TABLE_NAME = "student";
  static const String ID = "idStudent";
  static const String NAME = "name";
  static const String NAME_CLASS = "nameClass";
  static const String CREATE_TABLE_QUERY = '''
  CREATE TABLE $TABLE_NAME(
    $ID INTEGER PRIMARY KEY AUTOINCREMENT,
    $NAME TEXT,
    $NAME_CLASS TEXT,
    FOREIGN KEY ($NAME_CLASS) REFERENCES class (nameClass)
  )
''';

  static const String SELECT_ALL_QUERY = '''
  SELECT * FROM $TABLE_NAME
''';

  //SELECT_ALL_QUERY_BY_NAME_CLASS
  static const String SELECT_ALL_QUERY_BY_NAME_CLASS = '''
  SELECT * FROM $TABLE_NAME WHERE $NAME_CLASS = ?
''';
  //insert student
  Future<int> insertStudent(Student entity) async {
    Database? db = await SQLiteDb.instance.database;
    return await db!.insert(TABLE_NAME, entity.toMap());
  }
  //get all student
  Future<List<Student>> getAllStudent() async {
    Database? db = await SQLiteDb.instance.database;
    List<Map<String, dynamic>> result = await db!.rawQuery(SELECT_ALL_QUERY);
    List<Student> list = [];
    result.forEach((element) {
      list.add(Student.fromMap(element));
    });
    return list;
  }
  //get  student by nameclass
  Future<List<Student>> getStudentByNameClass(String nameClass) async {
    Database? db = await SQLiteDb.instance.database;
    List<Map<String, dynamic>> result = await db!.rawQuery(SELECT_ALL_QUERY_BY_NAME_CLASS, [nameClass]);
    List<Student> list = [];
    result.forEach((element) {
      list.add(Student.fromMap(element));
    });
    return list;
  }
}
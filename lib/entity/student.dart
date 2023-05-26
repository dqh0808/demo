import 'package:firebase_database/firebase_database.dart';

import 'classs.dart';

class Student {
  late int _idStudent;
  late String _name;
  late String classs;

  Student();

  Student.init(this._name, this.classs);

  get nameClass => classs;
  set nameClass(value) => classs = value;
  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get idStudent => _idStudent;

  set idStudent(int value) {
    _idStudent = value;
  }

  factory Student.fromMap(Map<String, dynamic> json) {
    return Student.init(json['name'], json['nameClass']);
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': _name,
      'nameClass': classs,
    };
    return map;
  }
}

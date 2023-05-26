





import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

import '../db/student_table.dart';
import '../entity/student.dart';

String _directoryPath = '';
void pickFile(String name) async {

  List<PlatformFile>? _paths;
  try {
    _paths = (await FilePicker.platform.pickFiles())?.files;
    _directoryPath = _paths!.first.path!;
    ByteData data = await rootBundle.load(_directoryPath!);
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    for (var table in excel.tables.keys) {
      for (int i = 1; i < excel.tables[table]!.maxRows; i++) {
        Sheet sheet = excel.tables[table]!;

        var date = (sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i))
            .value);
        var date2 = DateTime.parse(date.toString());
        Student user = Student();
        user.name = sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i))
            .value
            .toString();


        //insert
        StudentTable().insertStudent(user);







      }


    }
    print(StudentTable().getAllStudent());
    print("1");

  } on PlatformException catch (e) {

  } catch (e) {

  }
}


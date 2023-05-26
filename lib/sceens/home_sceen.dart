import 'dart:async';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:excel/excel.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/ui/firebase_sorted_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/db/class_table.dart';
import 'package:untitled/db/student_table.dart';
import 'package:untitled/routes/route.gr.dart';
import 'package:untitled/widget/Pickfile.dart';

import '../entity/classs.dart';
import '../entity/student.dart';
import '../main.dart';
import 'attendance_screen.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

late String key;
String _directoryPath = '';
void pickFile(String name) async {
  DatabaseReference db;
  db = FirebaseDatabase.instance.ref().child("student");
  List<PlatformFile>? paths;
  try {
    paths = (await FilePicker.platform.pickFiles())?.files;
    _directoryPath = paths!.first.path!;
    ByteData data = await rootBundle.load(_directoryPath!);
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    for (var table in excel.tables.keys) {
      for (int i = 1; i < excel.tables[table]!.maxRows; i++) {
        Sheet sheet = excel.tables[table]!;
        // var date = (sheet
        //     .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i))
        //     .value);
        // var date2 = DateTime.parse(date.toString());
        Student user = Student();
        user.name = sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i))
            .value
            .toString();
        user.classs = name;
        Map<String, dynamic> map = {
          "name": user.name,
          "nameClass": user.classs,
        };
        //insert
        StudentTable().insertStudent(user);
        db.push().set(map);
      }
    }
  } on PlatformException catch (e) {
    print("Unsupported operation$e");
  } catch (e) {
    print("error$e");
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _selected;
  final _formKey = GlobalKey<FormState>();
  late DatabaseReference _dbRef;
  late final Query _classQuery = FirebaseDatabase.instance.ref().child('classs');
  @override
  void initState() {
    super.initState();
    _dbRef = FirebaseDatabase.instance.ref().child('classs');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(),
        body: BlocBuilder<SelectedClass, String>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                          child: Text("Select Class:",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))),
                    ),
                  ),
                  Container(
                    width: size.width,
                    height: size.height,
                    child: FirebaseAnimatedList(
                      query: _classQuery,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        Map classs = snapshot.value as Map;
                        classs['key'] = snapshot.key;
                        return ListView(
                          padding: EdgeInsets.all(5.0),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Card(
                                child: ListTile(
                                  title: Text(classs['name']),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      _dbRef.child(classs['key']).remove();
                                    },
                                  ),
                                  onTap: () {
                                    _selected = classs['name'];
                                    context
                                        .read<SelectedClass>()
                                        .add(SelectedName(_selected!));
                                    print(state);
                                    AutoRouter.of(context)
                                        .push(const AttendanceScreenRoute());
                                    setState(() {
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Text(state),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: size.width,
                      decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(10)),
                      child: const SizedBox(
                        height: 10,
                        width: 200,
                        // child: FirebaseAnimatedList(query: _classQuery,  itemBuilder: (context, snapshot, animation, index)
                        // {
                        //
                        //   Map classs = snapshot.value as Map;
                        //   if(snapshot.exists){
                        //       return DropdownButton2(
                        //         items: classs.values
                        //             .map((e) => DropdownMenuItem(
                        //                   value: e['name'],
                        //                   child: Text(e['name']),
                        //                 ))
                        //             .toList(),
                        //         onChanged: (value) {
                        //           _selectedClass = value.toString();
                        //           context
                        //               .read<SelectedClass>()
                        //               .add(SelectedName(_selectedClass!));
                        //           print(state);
                        //
                        //           setState(() {
                        //             Navigator.push(
                        //                 context,
                        //                 MaterialPageRoute(
                        //                     builder: (context) =>
                        //                         AttendanceScreen()));
                        //           });
                        //         },
                        //         value: _selectedClass,
                        //         hint: const Text("Select Class"),
                        //       );
                        //     } else {
                        //       return const Center(
                        //         child: CircularProgressIndicator(),
                        //       );
                        //     }
                        // }
                        //
                        // ,)
                        // child: FutureBuilder(
                        //   future: getStudent(),
                        //
                        //   builder: (context,  snapshot) {
                        //     if (snapshot.hasData) {
                        //       return DropdownButton2(
                        //         items: snapshot.data!
                        //             .map((e) => DropdownMenuItem(
                        //                   value: e.nameClass,
                        //                   child: Text(e.nameClass),
                        //                 ))
                        //             .toList(),
                        //         onChanged: (value) {
                        //           _selectedClass = value.toString();
                        //           context
                        //               .read<SelectedClass>()
                        //               .add(SelectedName(_selectedClass!));
                        //           print(state);
                        //
                        //           setState(() {
                        //             Navigator.push(
                        //                 context,
                        //                 MaterialPageRoute(
                        //                     builder: (context) =>
                        //                         AttendanceScreen()));
                        //           });
                        //         },
                        //         value: _selectedClass,
                        //         hint: const Text("Select Class"),
                        //       );
                        //     } else {
                        //       return const Center(
                        //         child: CircularProgressIndicator(),
                        //       );
                        //     }
                        //   },
                        // ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Form(
                    key: _formKey,
                    child: AlertDialog(
                      title: const Text("Add Class"),
                      content: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter class name";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _selected = value;
                        },
                        decoration:
                            const InputDecoration(hintText: "Enter Class Name"),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              _formKey.currentState!.save();
                              ClassTable().insertClass(Classs.name(_selected!));
                              _dbRef.push().set({"name": _selected!});
                              print(_selected);
                              setState(() {
                                pickFile(_selected!);
                              });
                              context.router.pop();
                            },
                            child: const Text("Add")),
                        TextButton(
                            onPressed: () {
                              context.router.pop();
                            },
                            child: const Text("Cancel"))
                      ],
                    ),
                  );
                });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

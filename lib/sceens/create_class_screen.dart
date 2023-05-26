// import 'dart:typed_data';
//
// import 'package:auto_route/auto_route.dart';
// import 'package:excel/excel.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:untitled/db/class_table.dart';
// import 'package:untitled/widget/Pickfile.dart';
//
// import '../db/student_table.dart';
// import '../entity/classs.dart';
// import '../entity/student.dart';
// import '../main.dart';
//
// // @RoutePage()
// class CreateClassScreen extends StatefulWidget {
//   const CreateClassScreen({super.key});
//
//   @override
//   _CreateClassScreen createState() => _CreateClassScreen();
// }
//
// class _CreateClassScreen extends State<CreateClassScreen> {
//   String? _className;
//   String? _selected;
//   Classs classs = Classs();
//
//   String _directoryPath = '';
//   void pickFile(String name) async {
//     List<PlatformFile>? _paths;
//     // try {
//
//     _paths = (await FilePicker.platform.pickFiles())?.files;
//     _directoryPath = _paths!.first.path!;
//     ByteData data = await rootBundle.load(_directoryPath!);
//     var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//     var excel = Excel.decodeBytes(bytes);
//     for (var table in excel.tables.keys) {
//       for (int i = 1; i < excel.tables[table]!.maxRows; i++) {
//         Sheet sheet = excel.tables[table]!;
//
//         // var date = (sheet
//         //     .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i))
//         //     .value);
//         // var date2 = DateTime.parse(date.toString());
//         Student user = Student();
//         user.name = sheet
//             .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i))
//             .value
//             .toString();
//         user.classs = name;
//
//         //insert
//         StudentTable().insertStudent(user);
//         print(user);
//         print(StudentTable().getAllStudent());
//       }
//     }
//
//     // } on PlatformException catch (e) {
//     //
//     // } catch (e) {
//     //
//     //
//     // }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//     final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           title: const Text('File Picker example app'),
//         ),
//         body: BlocBuilder<SelectedClass, String>(builder: (context, state) {
//           return SafeArea(
//             child: Form(
//               key: formKey,
//               child: ListView(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: SizedBox(
//                         width: size.width * 0.95,
//                         height: size.height * 0.07,
//                         child: FutureBuilder(
//                           future: ClassTable().getAllClass(),
//                           builder: (data, snapshot) {
//                             if (snapshot.hasData) {
//                               return TextFormField(
//                                 decoration: InputDecoration(
//                                   labelText: 'Class Name',
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Vui lòng nhập tên lớp';
//                                   }
//                                   for (var i = 0;
//                                       i < snapshot.data!.length;
//                                       i++) {
//                                     if (value == snapshot.data![i].nameClass) {
//                                       return 'Tên lớp đã tồn tại';
//                                     }
//                                   }
//                                   return null;
//                                 },
//                                 onSaved: (value) {
//                                   _className = value;
//                                   print(_className);
//                                   classs.nameClass = _className!;
//                                   ClassTable().insertClass(classs);
//                                   context
//                                       .read<SelectedClass>()
//                                       .add(SelectedName(_className!));
//                                   print(state);
//                                 },
//                               );
//                             } else {
//                               return const Center(
//                                 child: CircularProgressIndicator(),
//                               );
//                             }
//                           },
//                         )),
//                   ),
//                   Align(
//                     alignment: const Alignment(0, -0.6),
//                     child: SizedBox(
//                       width: size.width * 0.95,
//                       height: size.height * 0.06,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           primary: Colors.blue,
//                           onPrimary: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(32.0),
//                           ),
//                         ),
//                         onPressed: () {
//                           if (!formKey.currentState!.validate()) {
//                             return;
//                           }
//                           formKey.currentState!.save();
//                           ClassTable().insertClass(classs);
//
//                           pickFile(_className!);
//                           print("pick file");
//                           print(_className);
//                         },
//                         child: Text('Create'),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//         }));
//   }
// }

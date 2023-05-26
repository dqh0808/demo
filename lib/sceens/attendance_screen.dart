import 'package:auto_route/auto_route.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/db/student_table.dart';
import 'package:untitled/entity/student.dart';
import 'package:untitled/sceens/bloc_provider.dart';

import '../main.dart';

@RoutePage()
class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late List<bool> isCheckList;
  String? _className;
  late DatabaseReference _dbRef;
  late Query _studentQuery = FirebaseDatabase.instance.ref().child('student');
  int count = 0;
  List<Student> listStudent = [];
  //datetimenow
  DateTime now = DateTime.now();
  String formattedDate = '';
  //convert datetimenow to string
  void convertDate() {
    formattedDate = '${now.day}-${now.month}-${now.year}';
  }

  @override
  void initState() {
    _dbRef = FirebaseDatabase.instance.ref().child('student');
    super.initState();
    convertDate();
    _className = BlocProvider.of<SelectedClass>(context).state;
    _studentQuery = FirebaseDatabase.instance
        .ref()
        .child('student')
        .orderByChild('nameClass')
        .equalTo(_className);
    initializeSelection();
    _getListStudent().then((value) {
      setState(() {
        listStudent = value;
      });
    });
    _getFileLength().then((value) {
      setState(() {
        lengthOfFile = value;
      });
    });
  }

  void initializeSelection() async {
    int listLength = await _getFileLength();
    isCheckList = List<bool>.generate(listLength, (_) => false);
    print(isCheckList);
  }

  late int lengthOfFile;

  Future<int> _getFileLength() async {
    return await StudentTable()
        .getStudentByNameClass(_className!)
        .then((value) {
      return value.length;
    });
  }

  Future<List<Student>> _getListStudent() async {
    return await StudentTable()
        .getStudentByNameClass(_className!)
        .then((value) {
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.router.pop();
            // Navigator.pop(context);
          },
        ),
        //datetime now
        title: Text(formattedDate),
      ),
      body: Column(
        children: [
          Container(
            height: size.height * 0.1,
            child: Center(
              child: Text(
                'Class: ${_className!}',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Expanded(
              child: FirebaseAnimatedList(
            query: _studentQuery,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              Map map = snapshot.value as Map;
              map['key'] = snapshot.key;
              return Card(
                child: ListTile(
                  tileColor: Colors.white,
                  style: color == Colors.white
                      ? ListTileStyle.list
                      : ListTileStyle.drawer,
                  title: Text(map['name'],
                      style: TextStyle(fontSize: 20),
                      selectionColor: Colors.black),
                  selectedTileColor: Colors.green,
                  selectedColor: Colors.black,
                  selected: isCheckList[index],
                  onLongPress: () {
                    _updateSelect(index);
                  },
                  onTap: count >= 1
                      ? () {
                          _updateSelect(index);
                          setState(() {});
                        }
                      : () {},
                ),
              );
            },
          )),
          Container(
            height: size.height * 0.1,
            child: Center(
              child: Text(
                'Total: $count',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _updateSelect(int index) {
    if (isCheckList[index] == true) {
      isCheckList[index] = false;
      --count;
      setState(() {});
    } else {
      isCheckList[index] = true;
      ++count;
      setState(() {});
    }
  }
}

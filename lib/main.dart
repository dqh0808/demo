import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled/db/database.dart';
import 'package:untitled/entity/classs.dart';
import 'package:untitled/routes/route.dart';
import 'package:untitled/routes/route.gr.dart';

import 'package:untitled/sceens/home_sceen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _appRouter = AppRouter();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _appRouter.config(),
      // home: const HomeScreen(),
      builder: (_, router) {
        return BlocProvider(
            create: (context) => SelectedClass(), child: router!);
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<SelectedClass, String>(
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state),
                  ElevatedButton(onPressed: () {}, child: const Text("Change"))
                ],
              ),
            );
          },
        ));
  }
}

abstract class BlocEvent {}

class SelectedName extends BlocEvent {
  late String _string;
  SelectedName(String name) {
    _string = name;
  }
  String get getString => _string;
}

class SelectedClass extends Bloc<BlocEvent, String> {
  SelectedClass() : super("") {
    on<SelectedName>((event, emit) async {
      emit(event.getString);
    });
  }
}

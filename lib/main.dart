import 'package:ali_poster/ui/splash/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(name: "AliPoster");
  runApp(MyApp(app: app));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.app}) : super(key: key);

  final FirebaseApp app;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FirebaseDatabase _database;

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase(app: widget.app);
    _database.setPersistenceEnabled(true);
    _database.setPersistenceCacheSizeBytes(10000000);
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: _database,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const Splash(),
      ),
    );
  }
}

import 'package:ali_poster/data/model/worker.dart';
import 'package:ali_poster/ui/home/home.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late FirebaseDatabase _database;
  String _pinCode = "";

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: mediaQuery.size.height,
          width: mediaQuery.size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: Image.asset("assets/images/background.jpg").image,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: mediaQuery.size.height * 0.3,
                width: mediaQuery.size.width * 0.3,
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextField(
                  onChanged: (value) {
                    _pinCode = value;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Введите пин код",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Consumer(
                builder: (BuildContext context, value, Widget? child) {
                  _database = Provider.of<FirebaseDatabase>(context);

                  var _workersRef = _database.reference().child("workers");
                  _workersRef.keepSynced(true);
                  List<Worker> _workers = [];
                  _workersRef.get().then((snapshot) {
                    return _workers = snapshot.value;
                  });

                  return MaterialButton(
                    color: Colors.purpleAccent,
                    child: const Text(
                      "Войти",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      if (_workers.any((element) => element.code == _pinCode)) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

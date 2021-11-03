import 'package:ali_poster/data/model/worker.dart';
import 'package:ali_poster/data/prefs/shared_preferences.dart';
import 'package:ali_poster/theme/color.dart';
import 'package:ali_poster/theme/style.dart';
import 'package:ali_poster/ui/main/home.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const route = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late FirebaseDatabase _cloudDatabase;
  String _pinCodeForLogIn = '';

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    List<Worker> _allWorkers = [];

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: _mediaQuery.size.height,
          width: _mediaQuery.size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: Image.asset('assets/images/background.jpg').image,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: _mediaQuery.size.height * 0.3,
                width: _mediaQuery.size.width * 0.3,
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) => _pinCodeForLogIn = value,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.white,
                    hintText: 'Введите пин код',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Consumer(
                builder: (BuildContext context, value, Widget? child) {
                  _cloudDatabase = Provider.of<FirebaseDatabase>(context);
                  var _workersReferenceToDatabase =
                      _cloudDatabase.reference().child('workers');
                  _workersReferenceToDatabase.keepSynced(true);
                  _workersReferenceToDatabase.get().then((workersSnapshot) =>
                      workersSnapshot.value
                          .forEach((index, value) => _allWorkers.add(Worker(
                                id: value['id'],
                                name: value['name'],
                                position: value['position'],
                                status: value['status'],
                                token: value['token'],
                                code: value['code'],
                              ))));

                  return MaterialButton(
                    color: AppColors.purple,
                    child: const Text(
                      'Войти',
                      style: AppTextStyle.buttonTextStyle,
                    ),
                    onPressed: () {
                      if (_allWorkers.any((element) {
                        if (element.code == _pinCodeForLogIn) {
                          saveUser(element.toJson());
                          return true;
                        }
                        return false;
                      })) {
                        Navigator.pushReplacementNamed(context, HomePage.route);
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

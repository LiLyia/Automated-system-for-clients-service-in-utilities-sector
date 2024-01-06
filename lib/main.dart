import 'package:flutter/material.dart';
import 'package:projects/screens/registration.dart';
import 'package:projects/screens/profile.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
//import 'package:sqflite_sqlcipher/sql.dart';
//import 'package:sqflite_sqlcipher/sqlite_api.dart';
//import 'package:sqflite_sqlcipher/sqflite.dart';
//import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => const MyHomePage(),
    },
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool passwordVisible = true;
  String error = '';
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isConneted = false;
  Future<int> dbConnected() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      String dbpath = await databaseFactoryFfi.getDatabasesPath();
      //String dbpath =
      //'C:/projects/.dart_tool/sqflite_common/databases/database.db';
      //debugPrint("The path is: $dbpath");
      databaseFactory = databaseFactoryFfi;
      final Database database = await openDatabase(
        join(dbpath, 'database.db'),
        //dbpath,
        //"C:/projects/.dart_tool/sqflite_common_ffi/databases/database.db",
        //password: "H3!yP97.sA",
      );
      final db = database;
      final List<Map<String, dynamic>> maps =
          await db.rawQuery('SELECT * FROM authentication');

      //Циклом проходим по листу и если сходятся параметры то возвращаем true
      for (int i = 0; i < maps.length; i++) {
        if (_loginController.text == maps[i]['login']) {
          if (_passwordController.text == maps[i]['password']) {
            debugPrint('Успешный поиск логина и пароля!');
            isConneted = true;
            return 1;
          } else {
            setState(() {
              error = "Ошибка! Неверный пароль";
            });
            return 0;
          }
        } else {
          setState(() {
            error = "Ошибка! Данного пользователя не существует";
          });
        }
      }
      debugPrint('НЕуспешный поиск логина и пароля!');
    } catch (e) {
      debugPrint('Cannot connect to the database! ${e.toString()}');
      setState(() {
        error = e.toString();
      });
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body:
              Stack(alignment: AlignmentDirectional.center, children: <Widget>[
            Positioned(
                top: 100,
                child: Container(
                    width: 600,
                    height: 500,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                      color: Color.fromRGBO(181, 255, 169, 1),
                    ))),
            const Positioned(
                top: 150,
                child: Text(
                  'Вход в личный кабинет',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontFamily: 'NanumGothic',
                      fontSize: 35,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1),
                )),
            Positioned(
                top: 260,
                child: Container(
                    width: 481,
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ))),
            Positioned(
                top: 380,
                child: Container(
                    width: 481,
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ))),
            Positioned(
                top: 380,
                child: SizedBox(
                    width: 465,
                    height: 40,
                    child: TextFormField(
                        obscureText: passwordVisible,
                        controller: _passwordController,
                        decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            suffixIcon: IconButton(
                                icon: Icon(passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  debugPrint('The eye has changed!');
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                }))))),
            Positioned(
                top: 260,
                child: SizedBox(
                    width: 465,
                    height: 40,
                    child: TextFormField(
                        controller: _loginController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        )))),
            const Positioned(
                top: 230,
                child: Text(
                  'Логин',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontFamily: 'NanumGothic',
                      fontSize: 21,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1),
                )),
            const Positioned(
                top: 350,
                child: Text(
                  'Пароль',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontFamily: 'NanumGothic',
                      fontSize: 21,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1),
                )),
            Positioned(
                top: 470,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(180, 45),
                      backgroundColor: const Color.fromRGBO(249, 255, 183, 1),
                      shadowColor: Colors.black,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      )),
                  onPressed: () async {
                    int res = await dbConnected();
                    debugPrint(res.toString());
                    if (res == 1) {
                      debugPrint('Trying to open profile...');
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Profile(login: _loginController.text);
                        },
                      ));
                    }
                  },
                  child: const Text('Войти',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'NanumGothic',
                          fontSize: 20,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1)),
                )),
            Positioned(
                top: 540,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const Reg();
                        },
                      ));
                    },
                    child: const Text('Нет личного кабинета? Регистрация.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'NanumGothic',
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            height: 1)))),
            Positioned(
                top: 630,
                child: Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color.fromRGBO(189, 58, 58, 1),
                      fontFamily: 'NanumGothic',
                      fontSize: 21,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1),
                )),
          ]),
        ));
  }
}

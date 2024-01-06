import 'package:flutter/material.dart';
import 'package:projects/screens/applications.dart';
import 'package:projects/screens/change_data.dart';
import 'package:projects/screens/counters.dart';
import 'package:projects/screens/statistics.dart';
import 'package:projects/screens/reference.dart';
import 'package:path/path.dart';
import 'package:scrollable/exports.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
//import 'package:sqflite_sqlcipher/sqflite.dart';

class Profile extends StatelessWidget {
  final String login;
  const Profile({Key? key, required this.login}) : super(key: key);

  Future<List<Map<String, dynamic>>> dbConnected() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      String dbpath = await databaseFactoryFfi.getDatabasesPath();
      final database = openDatabase(
        join(dbpath, 'database.db'),
      );
      final db = await database;
      final List<Map<String, dynamic>> maps =
          await db.rawQuery("SELECT * FROM profile where login = '$login'");

      return maps;
    } catch (e) {
      debugPrint('Cannot connect to the database! ${e.toString()}');
    }

    return List.empty();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Container(
                width: 1550,
                height: 800,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                child: Stack(children: <Widget>[
                  ScrollableView(
                      padding: const EdgeInsets.only(left: 290.0),
                      controller: ScrollController(),
                      child: FutureBuilder(
                          future: dbConnected(),
                          builder: (BuildContext context,
                                  AsyncSnapshot<List<Map<String, dynamic>>>
                                      map) =>
                              map.hasData
                                  ? Stack(
                                      children: <Widget>[
                                        Container(
                                            alignment:
                                                AlignmentDirectional.center,
                                            height: 850,
                                            width: 1250,
                                            color: Colors.white),
                                        const Positioned(
                                            top: 25,
                                            left: 30,
                                            child: Text(
                                              ("Профиль"),
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontSize: 23,
                                                  fontFamily: 'Nerko One',
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1),
                                            )),
                                        Positioned(
                                            top: 65,
                                            left: 30,
                                            child: Text(
                                              ("Логин: $login"),
                                              style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontSize: 21,
                                                  fontFamily: 'Nerko One',
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1),
                                            )),
                                        Positioned(
                                          top: 100,
                                          left: 30,
                                          child: Text(
                                              ("Электронная почта: ${map.data![0]['email']}"),
                                              style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontSize: 21,
                                                  fontFamily: 'Nerko One',
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1),
                                              softWrap: true,
                                              textAlign: TextAlign.center),
                                        ),
                                        Positioned(
                                          top: 135,
                                          left: 30,
                                          child: Text(
                                              ("Номер телефона: ${map.data![0]['phone']}"),
                                              style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontSize: 21,
                                                  fontFamily: 'Nerko One',
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1),
                                              softWrap: true,
                                              textAlign: TextAlign.center),
                                        ),
                                        Positioned(
                                          top: 170,
                                          left: 30,
                                          child: Text(
                                              ("Адрес: ${map.data![0]['address']}"),
                                              style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontSize: 21,
                                                  fontFamily: 'Nerko One',
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1),
                                              softWrap: true,
                                              textAlign: TextAlign.center),
                                        ),
                                        Positioned(
                                          top: 205,
                                          left: 30,
                                          child: Text(
                                              ("Количество проживающих: ${map.data![0]['residents_number'].toString()}"),
                                              style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontSize: 21,
                                                  fontFamily: 'Nerko One',
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1),
                                              softWrap: true,
                                              textAlign: TextAlign.center),
                                        ),
                                        Positioned(
                                          top: 240,
                                          left: 30,
                                          child: Text(
                                              ("Общая площадь: ${map.data![0]['area'].toString()}"),
                                              style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontSize: 21,
                                                  fontFamily: 'Nerko One',
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1),
                                              softWrap: true,
                                              textAlign: TextAlign.center),
                                        ),
                                        Positioned(
                                            top: 300,
                                            left: 540,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  fixedSize:
                                                      const Size(200, 40),
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          249, 255, 183, 1),
                                                  shadowColor: Colors.black,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20),
                                                      bottomLeft:
                                                          Radius.circular(20),
                                                      bottomRight:
                                                          Radius.circular(20),
                                                    ),
                                                  )),
                                              onPressed: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                  builder: (context) {
                                                    return ChangeData(
                                                        login: login,
                                                        email: map.data![0]
                                                            ['email'],
                                                        phone: map.data![0]
                                                            ['phone'],
                                                        address: map.data![0]
                                                            ['address'],
                                                        residents: map.data![0][
                                                            'residents_number'],
                                                        area: map.data![0]
                                                            ['area']);
                                                  },
                                                ));
                                              },
                                              child: const Text('Изменить',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontFamily: 'NanumGothic',
                                                      fontSize: 21,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height: 1)),
                                            )),
                                      ],
                                    )
                                  : const Center())),
                  Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                          width: 290,
                          height: 800,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(181, 255, 169, 1),
                          ))),
                  Positioned(
                      top: 120,
                      left: 0,
                      child: Container(
                          width: 290,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                  offset: Offset(0, 4),
                                  blurRadius: 4)
                            ],
                            color: Color.fromRGBO(255, 255, 255, 1),
                            border: Border.all(
                              color: Color.fromRGBO(66, 89, 170, 1),
                              width: 3,
                            ),
                          ))),
                  Positioned(
                      top: 124,
                      left: 60,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                        child: const Text('Профиль',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'NanumGothic',
                                fontSize: 21,
                                letterSpacing: 0,
                                fontWeight: FontWeight.bold,
                                height: 1)),
                      )),
                  Positioned(
                      top: 174,
                      left: 60,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Counters(
                                login: login,
                              );
                            },
                          ));
                        },
                        child: const Text('Счетчики',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'NanumGothic',
                                fontSize: 21,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                                height: 1)),
                      )),
                  Positioned(
                      top: 224,
                      left: 60,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Statistics(
                                login: login,
                              );
                            },
                          ));
                        },
                        child: const Text('Статистика',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'NanumGothic',
                                fontSize: 21,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                                height: 1)),
                      )),
                  Positioned(
                      top: 274,
                      left: 60,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Applications(
                                login: login,
                              );
                            },
                          ));
                        },
                        child: const Text('Заявки',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'NanumGothic',
                                fontSize: 21,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                                height: 1)),
                      )),
                  Positioned(
                      top: 324,
                      left: 60,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Support(
                                login: login,
                              );
                            },
                          ));
                        },
                        child: const Text('Справка',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'NanumGothic',
                                fontSize: 21,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                                height: 1)),
                      )),
                  Positioned(
                      top: 636,
                      left: 60,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                        child: const Text('Выйти',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'NanumGothic',
                                fontSize: 21,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                                height: 1)),
                      )),
                ]))));
  }
}

import 'package:flutter/material.dart';
import 'package:projects/screens/applications.dart';
import 'package:projects/screens/counters.dart';
import 'package:projects/screens/profile.dart';
import 'package:projects/screens/reference.dart';
import 'package:projects/screens/statistics.dart';
//import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class FillApp extends StatefulWidget {
  final String login;
  final String appType;
  const FillApp({Key? key, required this.login, required this.appType})
      : super(key: key);
  @override
  State<FillApp> createState() {
    return _FillApp();
  }
}

class _FillApp extends State<FillApp> {
  int accoutId = 0;

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _personController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<int> setData() async {
    if ((_addressController.text.isNotEmpty) &&
        (_emailController.text.isNotEmpty) &&
        (_personController.text.isNotEmpty) &&
        (_phoneController.text.isNotEmpty)) {
      try {
        String dbpath = await databaseFactoryFfi.getDatabasesPath();
        //String dbpath = await databaseFactoryFfi.getDatabasesPath();
        final database = openDatabase(
          join(dbpath, 'database.db'),
        );
        final db = await database;
        List<Map<String, dynamic>> valuesMap =
            await db.rawQuery("SELECT *FROM Applications");
        int appId = valuesMap.length + 1;
        if (accoutId != 0) {
          await db.execute(
              "INSERT INTO Applications VALUES($appId, '${widget.appType}', $accoutId, '${_addressController.text}', '${_personController.text}', '${_emailController.text}', '${_phoneController.text}', '${_taskController.text}')");
        }
        return 1;
      } catch (e) {
        debugPrint("Error: $e");
      }
    }
    return 0;
  }

  void getData() async {
    try {
      String dbpath = await databaseFactoryFfi.getDatabasesPath();
      final database = openDatabase(
        join(dbpath, 'database.db'),
      );
      final db = await database;
      List<Map<String, dynamic>> valuesMap = List.empty();
      List<Map<String, dynamic>> profileMap = await db
          .rawQuery("SELECT * FROM Profile WHERE login = '${widget.login}'");
      if (widget.appType == "Вызвать электрика") {
        valuesMap = await db.rawQuery(
            "SELECT * FROM Counters where login = '${widget.login}' and type = 'Electricity'");
      }
      if ((widget.appType == "Вызвать сантехника") ||
          (widget.appType == "Проверить/Заменить/Установить счетчик воды")) {
        valuesMap = await db.rawQuery(
            "SELECT * FROM Counters where login = '${widget.login}' and type = 'Water'");
      }
      if ((widget.appType == "Вызвать газовщика") ||
          (widget.appType == "Проверить/Заменить/Установить счетчик газа")) {
        valuesMap = await db.rawQuery(
            "SELECT * FROM Counters where login = '${widget.login}' and type = 'Gas'");
      }
      setState(() {
        accoutId = valuesMap[0]['account_id'];
        _addressController.text = profileMap[0]['address'];
        _emailController.text = profileMap[0]['email'];
        _phoneController.text = profileMap[0]['phone'];
      });
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Container(
                width: 1540,
                height: 800,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                child: Stack(children: <Widget>[
                  Positioned(
                      top: 22,
                      left: 320,
                      child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            color: Color.fromRGBO(249, 255, 183, 1),
                          ))),
                  Positioned(
                      top: 22,
                      left: 320,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        tooltip: "Вернуться назад",
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Applications(login: widget.login);
                            },
                          ));
                        },
                      )),
                  Positioned(
                      top: 30,
                      left: 380,
                      child: Text(
                        (widget.appType),
                        style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 23,
                            fontFamily: 'Nerko One',
                            letterSpacing: 0,
                            fontWeight: FontWeight.bold,
                            height: 1),
                      )),
                  Positioned(
                      top: 120,
                      left: 320,
                      child: Text(
                        ("Лицевой счет: ${accoutId.toString()}"),
                        style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 21,
                            fontFamily: 'Nerko One',
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      )),
                  Positioned(
                      top: 170,
                      left: 350,
                      child: SizedBox(
                          width: 465,
                          height: 70,
                          child: TextFormField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Адрес жилого помещения"),
                              controller: _addressController))),
                  Positioned(
                      top: 240,
                      left: 350,
                      child: SizedBox(
                          width: 465,
                          height: 70,
                          child: TextFormField(
                            controller: _personController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Контактное лицо (ФИО)"),
                          ))),
                  Positioned(
                      top: 310,
                      left: 350,
                      child: SizedBox(
                          width: 465,
                          height: 70,
                          child: TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "E-mail")))),
                  Positioned(
                      top: 380,
                      left: 350,
                      child: SizedBox(
                          width: 465,
                          height: 70,
                          child: TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Телефон")))),
                  Positioned(
                      top: 450,
                      left: 350,
                      child: SizedBox(
                          width: 465,
                          height: 70,
                          child: TextField(
                              controller: _taskController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Опишите задачу")))),
                  Positioned(
                      top: 550,
                      left: 458,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(250, 40),
                            backgroundColor:
                                const Color.fromRGBO(249, 255, 183, 1),
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
                          int res = await setData();
                          if (res == 1) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Applications(login: widget.login);
                            }));
                          }
                        },
                        child: const Text('Отправить',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'NanumGothic',
                                fontSize: 19,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                                height: 1)),
                      )),
                  Container(
                      width: 290,
                      height: 800,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(181, 255, 169, 1),
                      )),
                  Positioned(
                      top: 270,
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
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Profile(
                                login: widget.login,
                              );
                            },
                          ));
                        },
                        child: const Text('Профиль',
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
                      top: 174,
                      left: 60,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Counters(
                                login: widget.login,
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
                                login: widget.login,
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
                                login: widget.login,
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
                                fontWeight: FontWeight.bold,
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
                                login: widget.login,
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

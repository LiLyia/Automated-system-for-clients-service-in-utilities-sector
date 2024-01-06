import 'package:flutter/material.dart';
import 'package:projects/main.dart';
import 'dart:async';
import 'package:projects/screens/applications.dart';
import 'package:projects/screens/counters.dart';
import 'package:projects/screens/statistics.dart';
import 'package:projects/screens/reference.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
//import 'package:sqflite_sqlcipher/sqflite.dart';

class AddCounter extends StatefulWidget {
  const AddCounter({Key? key, required this.login, required this.type})
      : super(key: key);
  final String login, type;
  @override
  State<AddCounter> createState() {
    return _AddCounter();
  }
}

class _AddCounter extends State<AddCounter> {
  @override
  void initState() {
    ifVisible();
    super.initState();
  }

  final TextEditingController _accountController = TextEditingController();
  String dropdownvalue1 = '-Выберите-';
  String dropdownvalue2 = '-Выберите-';
  var counterType = ['-Выберите-', 'Электроэнергия', 'Газ', 'Вода'];
  var tarif = ['-Выберите-', 'Однотарифный', 'Двухтарифный'];
  bool elecVisible = false;
  bool typeVisible = false;
  void ifVisible() {
    if (widget.type == '') {
      setState(() {
        typeVisible = !typeVisible;
      });
    }
    if (widget.type == "Электроэнергия") {
      setState(() {
        elecVisible = !elecVisible;
      });
    }
  }

  Future<int> insertCounter() async {
    try {
      String dbpath = await databaseFactoryFfi.getDatabasesPath();
      final database = openDatabase(
        join(dbpath, 'database.db'),
      );
      final db = await database;
      debugPrint("Type: ${widget.type}");
      if ((widget.type == "Электроэнергия") ||
          (dropdownvalue2 == "Электроэнергия")) {
        debugPrint("Trying to insert a counter");
        await db.execute(
            "INSERT INTO Counters VALUES('${widget.login}', 'Electricity', ${_accountController.text} )");
        if (dropdownvalue1 == "Однотарифный") {
          await db.execute(
              "INSERT INTO Electricity VALUES(${_accountController.text}, '${widget.login}', 1)");
          await db.execute(
              "INSERT INTO Type1 VALUES(${_accountController.text}, NULL, NULL)");
        }
        if (dropdownvalue1 == "Двухтарифный") {
          await db.execute(
              "INSERT INTO Electricity VALUES(${_accountController.text}, '${widget.login}', 2)");
          await db.execute(
              "INSERT INTO Type2 VALUES(${_accountController.text}, NULL, NULL, NULL)");
        }
      }
      if (widget.type == "Газ") {
        await db.execute(
            "INSERT INTO Counters VALUES('${widget.login}', 'Gas', ${_accountController.text} )");
        await db.execute(
            "INSERT INTO Gas VALUES(${_accountController.text}, '${widget.login}')");
      }
      if (widget.type == "Вода") {
        await db.execute(
            "INSERT INTO Counters VALUES('${widget.login}', 'Water', ${_accountController.text} )");
        await db.execute(
            "INSERT INTO Water VALUES(${_accountController.text}, '${widget.login}, NULL, NULL, NULL)");
      }
      return 1;
    } catch (e) {
      debugPrint("An error: $e");
      return -1;
    }
    //return 0;
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
                              return Counters(login: widget.login);
                            },
                          ));
                        },
                      )),
                  const Positioned(
                      top: 30,
                      left: 380,
                      child: Text(
                        ("Добавление счетчика"),
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 23,
                            fontFamily: 'Nerko One',
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.bold,
                            height: 1),
                      )),
                  Positioned(
                      top: 85,
                      left: 320,
                      child: Visibility(
                          visible: typeVisible,
                          child: const Text(
                            ("Выберите тип коммунальных услуг"),
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontSize: 21,
                                fontFamily: 'Nerko One',
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ))),
                  Positioned(
                      top: 70,
                      left: 690,
                      child: Visibility(
                          visible: typeVisible,
                          child: DropdownButton(
                            value: dropdownvalue2,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: counterType.map((String counterType) {
                              return DropdownMenuItem(
                                value: counterType,
                                child: Text((counterType),
                                    style: const TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontSize: 21,
                                        fontFamily: 'Nerko One',
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue == "Электроэнергия") {
                                setState(() {
                                  elecVisible = true;
                                });
                              } else {
                                setState(() {
                                  elecVisible = false;
                                });
                              }
                              setState(() {
                                dropdownvalue2 = newValue!;
                              });
                            },
                          ))),
                  Positioned(
                      top: 85,
                      left: 320,
                      child: Visibility(
                          visible: !typeVisible,
                          child: Text(
                            ("Тип коммунальных услуг: ${widget.type}"),
                            style: const TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontSize: 21,
                                fontFamily: 'Nerko One',
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ))),
                  const Positioned(
                      top: 135,
                      left: 320,
                      child: Text(
                        ("Введите лицевой счет"),
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 21,
                            fontFamily: 'Nerko One',
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      )),
                  Positioned(
                    top: 120,
                    left: 550,
                    child: SizedBox(
                      width: 465,
                      height: 40,
                      child: TextFormField(
                        controller: _accountController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 210,
                      left: 320,
                      child: Visibility(
                          visible: elecVisible,
                          child: const Text(
                            ("Выберите тип счетчика"),
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontSize: 21,
                                fontFamily: 'Nerko One',
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ))),
                  Positioned(
                      top: 195,
                      left: 580,
                      child: Visibility(
                          visible: elecVisible,
                          child: DropdownButton(
                            value: dropdownvalue1,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: tarif.map((String tarif) {
                              return DropdownMenuItem(
                                value: tarif,
                                child: Text((tarif),
                                    style: const TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontSize: 21,
                                        fontFamily: 'Nerko One',
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue1 = newValue!;
                              });
                            },
                          ))),
                  Positioned(
                      top: 280,
                      left: 570,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(180, 40),
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
                          int res = await insertCounter();
                          if (res == 1) {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return Counters(login: widget.login);
                              },
                            ));
                          } else {
                            debugPrint('Could not insert values');
                          }
                        },
                        child: const Text('Добавить',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'NanumGothic',
                                fontSize: 20,
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
                      top: 170,
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
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
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
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.bold,
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
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
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
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
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
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1)),
                      )),
                  Positioned(
                      top: 636,
                      left: 60,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const MyHomePage();
                            },
                          ));
                        },
                        child: const Text('Выйти',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'NanumGothic',
                                fontSize: 21,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1)),
                      )),
                ]))));
  }
}

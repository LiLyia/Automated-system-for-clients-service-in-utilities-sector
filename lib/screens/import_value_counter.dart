import 'package:flutter/material.dart';
import 'package:projects/main.dart';
import 'package:projects/screens/applications.dart';
import 'package:projects/screens/counters.dart';
import 'package:projects/screens/profile.dart';
import 'package:projects/screens/reference.dart';
import 'package:projects/screens/statistics.dart';
//import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class ImportValue extends StatefulWidget {
  final String login, address, type;
  final int accountId;
  const ImportValue(
      {Key? key,
      required this.login,
      required this.address,
      required this.type,
      required this.accountId})
      : super(key: key);
  @override
  State<ImportValue> createState() {
    return _ImportValue();
  }
}

class _ImportValue extends State<ImportValue> {
  String formattedDate = '', text1 = '', text2 = '';
  bool fieldVisible = false;
  @override
  void initState() {
    DateTime nows = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd').format(nows);
    if (widget.type == "Газ") {
      setState(() {
        text1 = "Текущее значение";
      });
    }
    debugPrint("Текущий тип услуг: ${widget.type}");
    if (widget.type == "Вода") {
      setState(() {
        debugPrint("Trying to set text and fieldVisible");
        text1 = "Текущее значение ХВС";
        text2 = "Текущее значение ГВС";
        fieldVisible = true;
      });
    }
    setVisible();
    super.initState();
  }

  void setVisible() async {
    if (widget.type == "Электроэнергия") {
      try {
        String dbpath = await databaseFactoryFfi.getDatabasesPath();
        final database = openDatabase(
          join(dbpath, 'database.db'),
        );
        final db = await database;
        List<Map<String, dynamic>> valuesMap = await db.rawQuery(
            "SELECT counter_type from Electricity where account_id = '${widget.accountId}'");
        int res = valuesMap[0]['counter_type'];
        if (res == 1) {
          setState(() {
            text1 = "Текущее значение";
          });
        }
        if (res == 2) {
          setState(() {
            text1 = "Текущее значение День";
            text2 = "Текущее значение Ночь";
            fieldVisible = true;
          });
        }
      } catch (e) {
        debugPrint("Error: $e");
      }
    }
    //return 0;
  }

  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _value2Controller = TextEditingController();
  late DateTime nows = DateTime.now();
  Future<int> insertValue() async {
    try {
      String dbpath = await databaseFactoryFfi.getDatabasesPath();
      final database = openDatabase(
        join(dbpath, 'database.db'),
      );
      final db = await database;
      if (widget.type == "Электроэнергия") {
        List<Map<String, dynamic>> valuesMap = await db.rawQuery(
            "SELECT counter_type from Electricity where account_id = '${widget.accountId}'");
        if (valuesMap.isNotEmpty) {
          int res = valuesMap[0]['counter_type'];
          if (res == 1) {
            valuesMap = await db.rawQuery("SELECT * FROM Type1");
            if ((valuesMap[0]['current_value'] != null) &&
                (valuesMap[0]['current_period'] != null)) {
              await db.execute(
                  "INSERT INTO History_Electricity_1 VALUES ('${widget.login}', '${valuesMap[0]['current_period']}', '${valuesMap[0]['current_value']}')");
            }
            await db.execute(
                "UPDATE Type1 SET current_period = '$formattedDate', current_value = '${_valueController.text}' WHERE account_id = '${widget.accountId}'");
          } else if (res == 2) {
            valuesMap = await db.rawQuery("SELECT * FROM Type2");
            if ((valuesMap[0]['current_value_day'] != null) &&
                (valuesMap[0]['current_period'] != null) &&
                (valuesMap[0]['current_value_night'] != null)) {
              await db.execute(
                  "INSERT INTO History_Electricity_2 VALUES ('${widget.login}', '${valuesMap[0]['current_value_day']}', '${valuesMap[0]['current_value_night']}', '${valuesMap[0]['current_period']}')");
            }
            await db.execute(
                "UPDATE Type2 SET current_period = '$formattedDate', current_value_day = '${_valueController.text}', current_value_night = '${_value2Controller.text}' WHERE account_id = '${widget.accountId}'");
          }
        }
      }
      if (widget.type == "Газ") {
        List<Map<String, dynamic>> valuesMap = await db.rawQuery(
            "SELECT * from Gas where account_id = '${widget.accountId}'");
        if ((valuesMap[0]['current_period'] != null) &&
            (valuesMap[0]['current_value'] != null)) {
          await db.execute(
              "INSERT INTO History_Gas VALUES('${widget.login}', '${valuesMap[0]['current_period']}', '${valuesMap[0]['current_value']}')");
        }
        await db.execute(
            "UPDATE Gas SET current_period = '$formattedDate', current_value = '${_valueController.text}' WHERE account_id = '${widget.accountId}'");
      }
      if (widget.type == "Вода") {
        List<Map<String, dynamic>> valuesMap = await db.rawQuery(
            "SELECT * from Water where account_id = '${widget.accountId}'");
        if ((valuesMap[0]['current_period'] != null) &&
            (valuesMap[0]['current_value_hot'] != null) &&
            (valuesMap[0]['current_value_cold'] != null)) {
          await db.execute(
              "INSERT INTO History_Water VALUES('${widget.login}', '${valuesMap[0]['current_period']}', '${valuesMap[0]['current_value_hot']}', '${valuesMap[0]['current_value_cold']}')");
        }
        await db.execute(
            "UPDATE Water SET current_period = '$formattedDate', current_value_cold = '${_valueController.text}', current_value_hot = '${_value2Controller.text}' WHERE account_id = '${widget.accountId}'");
      }
      return 1;
    } catch (e) {
      debugPrint("Error updating tables: $e");
    }
    return 0;
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
                        ("Подать показания"),
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
                      child: Text(
                        ("Лицевой счет: ${widget.accountId}\nТип услуг: ${widget.type}\n${widget.address}"),
                        style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 23,
                            fontFamily: 'Nerko One',
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      )),
                  Positioned(
                      top: 190,
                      left: 320,
                      child: Text(
                        ("$text1\n\n\n$text2"),
                        style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 21,
                            fontFamily: 'Nerko One',
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      )),
                  Positioned(
                      top: 175,
                      left: 600,
                      child: SizedBox(
                          width: 465,
                          height: 40,
                          child: TextFormField(
                              controller: _valueController,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                              )))),
                  Positioned(
                      top: 235,
                      left: 600,
                      child: SizedBox(
                          width: 465,
                          height: 40,
                          child: Visibility(
                              visible: fieldVisible,
                              child: TextFormField(
                                  controller: _value2Controller,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                  ))))),
                  Positioned(
                      top: 335,
                      left: 510,
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
                          int result = await insertValue();
                          if (result == 1) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Counters(login: widget.login);
                            }));
                          }
                        },
                        child: const Text('Сохранить',
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
                      top: 170,
                      child: Container(
                          width: 290,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
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

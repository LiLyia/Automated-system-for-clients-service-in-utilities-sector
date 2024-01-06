import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:projects/main.dart';
import 'package:projects/screens/add_counter.dart';
import 'package:projects/screens/applications.dart';
import 'package:projects/screens/import_value_counter.dart';
import 'package:projects/screens/profile.dart';
import 'package:projects/screens/statistics.dart';
import 'package:projects/screens/reference.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
//import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:scrollable/exports.dart';

class Counters extends StatefulWidget {
  const Counters({Key? key, required this.login}) : super(key: key);
  final String login;
  @override
  State<Counters> createState() {
    return _Counters();
  }
}

class _Counters extends State<Counters> {
  @override
  void initState() {
    getAddress().then(
      (value) {
        if (value.isNotEmpty) {
          setState(
            () {
              address = value;
            },
          );
        }
      },
    );
    ifHasCounter().then((value) {
      if (value == 1) {
        setState(
          () {
            addVisible = !addVisible;
          },
        );
      }
    });
    super.initState();
  }

  String address = '';
  int elecValue = 0,
      elecValueDay = 0,
      elecValueNight = 0,
      waterHotValue = 0,
      waterColdValue = 0,
      gasValue = 0;
  //accId = 0;
  bool addVisible = false,
      elecMoreVisible = false,
      elecMoreVisible2 = false,
      elecVisible = false,
      gasVisible = false,
      waterVisible = false;
  Future<List<Map<String, dynamic>>> getCounters() async {
    try {
      String dbpath = await databaseFactoryFfi.getDatabasesPath();
      final database = openDatabase(
        join(dbpath, 'database.db'),
      );
      final db = await database;
      List<Map<String, dynamic>> valuesMap = await db
          .rawQuery("SELECT * FROM Counters where login = '${widget.login}'");

      if (valuesMap.isNotEmpty) {
        debugPrint('valuesMap is not empty!');
        return valuesMap;
      }
    } catch (e) {
      debugPrint('An error occured!');
    }
    debugPrint('Returning an empty list!');
    return List.empty();
  }

  Future<String> getAddress() async {
    try {
      String dbpath = await databaseFactoryFfi.getDatabasesPath();
      final database = openDatabase(
        join(dbpath, 'database.db'),
        //password: "H3!yP97.sA",
      );
      final db = await database;
      List<Map<String, dynamic>> addressMap = await db
          .rawQuery("SELECT * FROM profile where login = '${widget.login}'");
      return addressMap[0]['address'];
    } catch (e) {
      debugPrint('An error occured?');
    }
    return '';
  }

  Future<int> ifHasCounter() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      String dbpath = await databaseFactoryFfi.getDatabasesPath();
      final database = openDatabase(
        join(dbpath, 'database.db'),
        //password: "H3!yP97.sA",
      );
      final db = await database;
      List<Map<String, dynamic>> valuesMap = await db.rawQuery(
          "SELECT * FROM Counters where login = '${widget.login}' and type = 'Electricity'");
      int accIdElec = 0, accIdWater = 0, accIdGas = 0;
      if (valuesMap.isNotEmpty) accIdElec = valuesMap[0]['account_id'];
      valuesMap = await db.rawQuery(
          "SELECT * FROM Counters where login = '${widget.login}' and type = 'Water'");
      if (valuesMap.isNotEmpty) accIdWater = valuesMap[0]['account_id'];
      valuesMap = await db.rawQuery(
          "SELECT * FROM Counters where login = '${widget.login}' and type = 'Gas'");
      if (valuesMap.isNotEmpty) accIdGas = valuesMap[0]['account_id'];
      debugPrint("account_id: $accIdElec");

      List<Map<String, dynamic>> elecMap = await db.rawQuery(
          "SELECT * FROM Electricity WHERE account_id = '$accIdElec'");
      List<Map<String, dynamic>> gasMap =
          await db.rawQuery("SELECT * FROM Gas WHERE account_id = '$accIdGas'");
      List<Map<String, dynamic>> waterMap = await db
          .rawQuery("SELECT * FROM Water WHERE account_id = '$accIdWater'");
      if ((waterMap.isEmpty) && (elecMap.isEmpty) && (gasMap.isEmpty)) return 1;
      if (elecMap.isNotEmpty) {
        debugPrint("elecMap is not empty");
        debugPrint("The type is: ${elecMap[0]['counter_type']}");
        if (elecMap[0]['counter_type'] == 1) {
          setState(() {
            elecMoreVisible = !elecMoreVisible;
          });
          List<Map<String, dynamic>> elecTarifMap = await db.rawQuery(
              "SELECT * FROM Type1 WHERE account_id = ${elecMap[0]['account_id']}");
          if (elecTarifMap.isNotEmpty) {
            setState(() {
              elecValue = elecTarifMap[0]['current_value'];
            });
          }
        }
        if (elecMap[0]['counter_type'] == 2) {
          debugPrint("The type is 2");
          setState(() {
            elecMoreVisible2 = !elecMoreVisible2;
          });
          debugPrint("Account_id: ${elecMap[0]['account_id']}");
          List<Map<String, dynamic>> elecTarifMap = await db.rawQuery(
              "SELECT * FROM Type2 WHERE account_id = ${elecMap[0]['account_id']}");
          if (elecTarifMap.isNotEmpty) {
            debugPrint("Opening elecTarifMap");
            if (elecTarifMap[0]['current_value_day'] != null) {
              setState(() {
                elecValueDay = elecTarifMap[0]['current_value_day'];
              });
            }
            if (elecTarifMap[0]['current_value_night'] != null) {
              setState(() {
                elecValueNight = elecTarifMap[0]['current_value_night'];
              });
            }
          }
        }

        setState(
          () {
            elecVisible = !elecVisible;
          },
        );
      }
      if (gasMap.isNotEmpty) {
        setState(
          () {
            gasValue = gasMap[0]['current_value'];
            gasVisible = !gasVisible;
          },
        );
      }
      if (waterMap.isNotEmpty) {
        setState(
          () {
            waterHotValue = waterMap[0]['current_value_hot'];
            waterColdValue = waterMap[0]['current_value_cold'];
            waterVisible = false;
          },
        );
      }
      return 0;
    } catch (e) {
      debugPrint('An error occured counter.dart: $e');
    }
    return -1;
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
                          future: getCounters(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Map<String, dynamic>>> map) {
                            int indexElec = 0, indexGas = 0, indexWater = 0;

                            if ((map.data != List.empty()) &&
                                (map.data != null) &&
                                (map.data != []) &&
                                ((map.data!.isNotEmpty))) {
                              for (int i = 0; i < map.data!.length; i++) {
                                if (map.data![i]['type'] == 'Electricity') {
                                  indexElec = i;
                                  elecVisible = true;
                                  break;
                                }
                              }
                              for (int i = 0; i < map.data!.length; i++) {
                                if (map.data![i]['type'] == 'Gas') {
                                  indexGas = i;
                                  gasVisible = true;
                                  break;
                                }
                              }
                              for (int i = 0; i < map.data!.length; i++) {
                                if (map.data![i]['type'] == 'Water') {
                                  indexWater = i;
                                  waterVisible = true;
                                  break;
                                }
                              }
                              return Stack(children: <Widget>[
                                Container(
                                    alignment: AlignmentDirectional.center,
                                    height: 950,
                                    width: 1260,
                                    color: Colors.white),
                                const Positioned(
                                    top: 25,
                                    left: 30,
                                    child: Text(
                                      ("Счетчики"),
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontSize: 23,
                                          fontFamily: 'Nerko One',
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.bold,
                                          height: 1),
                                    )),
                                Positioned(
                                    top: 65,
                                    left: 30,
                                    child: Visibility(
                                        visible: !addVisible,
                                        child: Text(
                                          (address),
                                          style: const TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 21,
                                              fontFamily: 'Nerko One',
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ))),
                                Positioned(
                                  top: 110,
                                  left: 195,
                                  child: LimitedBox(
                                    maxHeight: 50,
                                    maxWidth: 850,
                                    child: SvgPicture.asset(
                                      "assets/images/vector1.svg",
                                    ),
                                  ),
                                ),
                                Positioned(
                                    top: 135,
                                    left: 550,
                                    child: Visibility(
                                        visible: !addVisible,
                                        child: const Text(
                                          ("Электроэнергия"),
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 21,
                                              fontFamily: 'Nerko One',
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.bold,
                                              height: 1),
                                        ))),
                                Positioned(
                                    top: 175,
                                    left: 30,
                                    child: Visibility(
                                        visible: elecVisible,
                                        child: Text(
                                          ("Лицевой счет: ${map.data![indexElec]['account_id'].toString()}"),
                                          style: const TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 21,
                                              fontFamily: 'Nerko One',
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ))),
                                Positioned(
                                    top: 210,
                                    left: 30,
                                    child: Visibility(
                                        visible: elecMoreVisible,
                                        child: Text(
                                          ("Текущее показание: ${elecValue.toString()}"),
                                          style: const TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 21,
                                              fontFamily: 'Nerko One',
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ))),
                                Positioned(
                                    top: 210,
                                    left: 30,
                                    child: Visibility(
                                        visible: elecMoreVisible2,
                                        child: Text(
                                          ("Текущее показание День: ${elecValueDay.toString()}\nТекущее показание Ночь: ${elecValueNight.toString()}"),
                                          style: const TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 21,
                                              fontFamily: 'Nerko One',
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ))),
                                Positioned(
                                    top: 315,
                                    left: 510,
                                    child: Visibility(
                                        visible: elecVisible,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(250, 40),
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      249, 255, 183, 1),
                                              shadowColor: Colors.black,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
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
                                              return ImportValue(
                                                  login: widget.login,
                                                  address: address,
                                                  type: "Электроэнергия",
                                                  accountId:
                                                      map.data![indexElec]
                                                          ['account_id']);
                                            }));
                                          },
                                          child: const Text('Внести показания',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontFamily: 'NanumGothic',
                                                  fontSize: 19,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1)),
                                        ))),
                                Positioned(
                                    top: 195,
                                    left: 30,
                                    child: Visibility(
                                        visible: !elecVisible,
                                        child: const Text(
                                          ("У вас еще нет счетчика по электричеству"),
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 21,
                                              fontFamily: 'Nerko One',
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ))),
                                Positioned(
                                    top: 315,
                                    left: 540,
                                    child: Visibility(
                                        visible: !elecVisible,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(180, 40),
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      249, 255, 183, 1),
                                              shadowColor: Colors.black,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
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
                                                return AddCounter(
                                                    login: widget.login,
                                                    type: 'Электроэнергия');
                                              },
                                            ));
                                          },
                                          child: const Text('Добавить',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontFamily: 'NanumGothic',
                                                  fontSize: 20,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1)),
                                        ))),
                                Positioned(
                                  top: 380,
                                  left: 195,
                                  child: LimitedBox(
                                    maxHeight: 50,
                                    maxWidth: 850,
                                    child: SvgPicture.asset(
                                      "assets/images/vector1.svg",
                                    ),
                                  ),
                                ),
                                const Positioned(
                                    top: 405,
                                    left: 610,
                                    child: Text(
                                      ("Газ"),
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontSize: 21,
                                          fontFamily: 'Nerko One',
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.bold,
                                          height: 1),
                                    )),
                                Positioned(
                                    top: 445,
                                    left: 30,
                                    child: Visibility(
                                        visible: gasVisible,
                                        child: Text(
                                          ("Лицевой счет: ${map.data![indexGas]['account_id'].toString()}\n\nТекущее показание: ${gasValue.toString()}"),
                                          style: const TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 21,
                                              fontFamily: 'Nerko One',
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ))),
                                Positioned(
                                    top: 495,
                                    left: 30,
                                    child: Visibility(
                                        visible: !gasVisible,
                                        child: const Text(
                                          ("У вас еще нет счетчика по газу"),
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 21,
                                              fontFamily: 'Nerko One',
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ))),
                                Positioned(
                                    top: 570,
                                    left: 540,
                                    child: Visibility(
                                        visible: !gasVisible,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(180, 40),
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      249, 255, 183, 1),
                                              shadowColor: Colors.black,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
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
                                                return AddCounter(
                                                    login: widget.login,
                                                    type: 'Газ');
                                              },
                                            ));
                                          },
                                          child: const Text('Добавить',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontFamily: 'NanumGothic',
                                                  fontSize: 20,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1)),
                                        ))),
                                Positioned(
                                    top: 570,
                                    left: 510,
                                    child: Visibility(
                                        visible: gasVisible,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(250, 40),
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      249, 255, 183, 1),
                                              shadowColor: Colors.black,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
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
                                              return ImportValue(
                                                  login: widget.login,
                                                  address: address,
                                                  type: "Газ",
                                                  accountId: map.data![indexGas]
                                                      ['account_id']);
                                            }));
                                          },
                                          child: const Text('Внести показания',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontFamily: 'NanumGothic',
                                                  fontSize: 19,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1)),
                                        ))),
                                Positioned(
                                  top: 635,
                                  left: 195,
                                  child: LimitedBox(
                                    maxHeight: 50,
                                    maxWidth: 850,
                                    child: SvgPicture.asset(
                                      "assets/images/vector1.svg",
                                    ),
                                  ),
                                ),
                                const Positioned(
                                    top: 660,
                                    left: 605,
                                    child: Text(
                                      ("Вода"),
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontSize: 21,
                                          fontFamily: 'Nerko One',
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.bold,
                                          height: 1),
                                    )),
                                Positioned(
                                    top: 700,
                                    left: 30,
                                    child: Visibility(
                                        visible: waterVisible,
                                        child: Text(
                                          ("Лицевой счет: ${map.data![indexWater]['account_id'].toString()}\n\nТекущее показание ХВС: ${waterColdValue.toString()}\nТекущее показание ГВС: ${waterHotValue.toString()}"),
                                          style: const TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 21,
                                              fontFamily: 'Nerko One',
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ))),
                                Positioned(
                                    top: 850,
                                    left: 510,
                                    child: Visibility(
                                        visible: waterVisible,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(250, 40),
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      249, 255, 183, 1),
                                              shadowColor: Colors.black,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
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
                                              return ImportValue(
                                                  login: widget.login,
                                                  address: address,
                                                  type: "Вода",
                                                  accountId:
                                                      map.data![indexWater]
                                                          ['account_id']);
                                            }));
                                          },
                                          child: const Text('Внести показания',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontFamily: 'NanumGothic',
                                                  fontSize: 19,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1)),
                                        ))),
                                Positioned(
                                    top: 750,
                                    left: 30,
                                    child: Visibility(
                                        visible: !waterVisible,
                                        child: const Text(
                                          ("У вас еще нет счетчика по воде"),
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 21,
                                              fontFamily: 'Nerko One',
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ))),
                                Positioned(
                                    top: 825,
                                    left: 540,
                                    child: Visibility(
                                        visible: !waterVisible,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(180, 40),
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      249, 255, 183, 1),
                                              shadowColor: Colors.black,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
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
                                                return AddCounter(
                                                    login: widget.login,
                                                    type: 'Вода');
                                              },
                                            ));
                                          },
                                          child: const Text('Добавить',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontFamily: 'NanumGothic',
                                                  fontSize: 20,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1)),
                                        ))),
                              ]);
                            } else {
                              debugPrint("No counters!");
                              return Stack(
                                children: [
                                  Container(
                                      alignment: AlignmentDirectional.center,
                                      height: 800,
                                      width: 1260,
                                      color: Colors.white),
                                  const Positioned(
                                      top: 75,
                                      left: 30,
                                      child: Text(
                                        ("У вас еще нет ни одного счетчика"),
                                        style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontSize: 23,
                                            fontFamily: 'Nerko One',
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      )),
                                  Positioned(
                                      top: 175,
                                      left: 540,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(180, 40),
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    249, 255, 183, 1),
                                            shadowColor: Colors.black,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20),
                                              ),
                                            )),
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return AddCounter(
                                                  login: widget.login,
                                                  type: '');
                                            },
                                          ));
                                        },
                                        child: const Text('Добавить',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                                fontFamily: 'NanumGothic',
                                                fontSize: 20,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.normal,
                                                height: 1)),
                                      )),
                                ],
                              );
                            }
                          })),
                  Positioned(
                      child: Container(
                          width: 290,
                          height: 800,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(181, 255, 169, 1),
                          ))),
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
                                letterSpacing: 0,
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
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                                height: 1)),
                      )),
                ]))));
  }
}

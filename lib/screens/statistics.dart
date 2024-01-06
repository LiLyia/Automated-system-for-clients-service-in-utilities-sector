import 'package:flutter/material.dart';
import 'package:projects/screens/applications.dart';
import 'package:projects/screens/counters.dart';
import 'package:projects/screens/profile.dart';
import 'package:projects/screens/reference.dart';
import 'package:scrollable/exports.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
//import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart';
//import 'package:path_provider/path_provider.dart';

class GDPData {
  GDPData(this.month, this.value);
  final String month;
  final int value;
}

class Statistics extends StatefulWidget {
  const Statistics({Key? key, required this.login}) : super(key: key);
  final String login;
  @override
  State<Statistics> createState() {
    return _Statistics();
  }
}

class _Statistics extends State<Statistics> {
  List<GDPData> gasData = [];
  List<GDPData> waterColdData = [];
  List<GDPData> waterHotData = [];
  List<GDPData> elec1Data = [];
  List<GDPData> elec2Data = [];
  bool elec2Visible = false;
  String elecTitle = '';
  @override
  void initState() {
    getChartData();
    super.initState();
  }

  PageController controller = PageController();
  void getChartData() async {
    try {
      String dbpath = await databaseFactoryFfi.getDatabasesPath();
      final database = openDatabase(
        join(dbpath, 'database.db'),
      );
      final db = await database;
      int accId = 0;
      List<Map<String, dynamic>> valuesMap;
      valuesMap = await db.rawQuery(
          "SELECT * FROM Counters WHERE login = '${widget.login}' and type = 'Electricity'");
      if (valuesMap.isNotEmpty) accId = valuesMap[0]['account_id'];
      valuesMap = await db.rawQuery(
          "SELECT counter_type FROM Electricity WHERE account_id = '$accId'");
      int elecType = 0;
      if (valuesMap.isNotEmpty) elecType = valuesMap[0]['counter_type'];
      if (elecType == 1) {
        valuesMap = await db.rawQuery(
            "SELECT * FROM History_Electricity_1 WHERE login = '${widget.login}'");
        if (valuesMap.isNotEmpty) {
          for (int i = 0; i < valuesMap.length; i++) {
            setState(() {
              elec1Data
                  .add(GDPData(valuesMap[i]['date'], valuesMap[i]['value']));
            });
          }
        }
      }
      if (elecType == 2) {
        setState(() {
          elec2Visible = true;
          elecTitle = 'День';
        });
        valuesMap = await db.rawQuery(
            "SELECT * FROM History_Electricity_2 WHERE login = '${widget.login}'");
        if (valuesMap.isNotEmpty) {
          for (int i = 0; i < valuesMap.length; i++) {
            setState(() {
              elec1Data.add(
                  GDPData(valuesMap[i]['date'], valuesMap[i]['value_day']));
              elec2Data.add(
                  GDPData(valuesMap[i]['date'], valuesMap[i]['value_night']));
            });
          }
        }
      }
      valuesMap = await db.rawQuery(
          "SELECT * FROM History_Water WHERE login = '${widget.login}'");
      if (valuesMap.isNotEmpty) {
        for (int i = 0; i < valuesMap.length; i++) {
          setState(() {
            waterColdData.add(GDPData(
                valuesMap[i]['date'], valuesMap[i]['value_cold_water']));
            waterHotData.add(
                GDPData(valuesMap[i]['date'], valuesMap[i]['value_hot_water']));
          });
        }
      }
      valuesMap = await db.rawQuery(
          "SELECT * FROM History_Gas WHERE login = '${widget.login}'");
      if (valuesMap.isNotEmpty) {
        for (int i = 0; i < valuesMap.length; i++) {
          setState(() {
            gasData.add(GDPData(valuesMap[i]['date'], valuesMap[i]['value']));
          });
        }
      }
    } catch (e) {
      debugPrint('An error occured: $e');
    }
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
                    child: Stack(
                      children: [
                        Container(
                            alignment: AlignmentDirectional.center,
                            height: 1300,
                            width: 1260,
                            color: Colors.white),
                        Positioned(
                            top: 120,
                            left: 30,
                            child: SizedBox(
                                height: 350,
                                width: 550,
                                child: SfCartesianChart(
                                    primaryXAxis: CategoryAxis(),
                                    title: ChartTitle(
                                        text: elecTitle,
                                        textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Nerko One',
                                          fontStyle: FontStyle.italic,
                                          fontSize: 15,
                                        )),
                                    series: <LineSeries>[
                                      LineSeries<GDPData, String>(
                                          dataSource: elec1Data,
                                          xValueMapper: (GDPData data, _) =>
                                              data.month,
                                          yValueMapper: (GDPData data, _) =>
                                              data.value,
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true))
                                    ]))),
                        Positioned(
                            top: 120,
                            left: 600,
                            child: Visibility(
                                visible: elec2Visible,
                                child: SizedBox(
                                    height: 350,
                                    width: 550,
                                    child: SfCartesianChart(
                                        primaryXAxis: CategoryAxis(),
                                        title: ChartTitle(
                                            text: 'Ночь',
                                            textStyle: const TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Nerko One',
                                              fontStyle: FontStyle.italic,
                                              fontSize: 15,
                                            )),
                                        series: <LineSeries>[
                                          LineSeries<GDPData, String>(
                                              dataSource: elec2Data,
                                              xValueMapper: (GDPData data, _) =>
                                                  data.month,
                                              yValueMapper: (GDPData data, _) =>
                                                  data.value,
                                              dataLabelSettings:
                                                  const DataLabelSettings(
                                                      isVisible: true))
                                        ])))),
                        Positioned(
                            top: 540,
                            left: 30,
                            child: SizedBox(
                                height: 300,
                                width: 550,
                                child: SfCartesianChart(
                                    primaryXAxis: CategoryAxis(),
                                    series: <LineSeries>[
                                      LineSeries<GDPData, String>(
                                          dataSource: gasData,
                                          xValueMapper: (GDPData data, _) =>
                                              data.month,
                                          yValueMapper: (GDPData data, _) =>
                                              data.value,
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true))
                                    ]))),
                        Positioned(
                            top: 900,
                            left: 30,
                            child: SizedBox(
                                height: 330,
                                width: 550,
                                child: SfCartesianChart(
                                    primaryXAxis: CategoryAxis(),
                                    title: ChartTitle(
                                        text: 'Холодное водоснабжение',
                                        textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Nerko One',
                                          fontStyle: FontStyle.italic,
                                          fontSize: 15,
                                        )),
                                    series: <LineSeries>[
                                      LineSeries<GDPData, String>(
                                          dataSource: waterColdData,
                                          xValueMapper: (GDPData data, _) =>
                                              data.month,
                                          yValueMapper: (GDPData data, _) =>
                                              data.value,
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true))
                                    ]))),
                        Positioned(
                            top: 900,
                            left: 600,
                            child: SizedBox(
                                height: 330,
                                width: 550,
                                child: SfCartesianChart(
                                    primaryXAxis: CategoryAxis(),
                                    title: ChartTitle(
                                        text: 'Горячее водоснабжение',
                                        textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Nerko One',
                                          fontStyle: FontStyle.italic,
                                          fontSize: 15,
                                        )),
                                    series: <LineSeries>[
                                      LineSeries<GDPData, String>(
                                          dataSource: waterHotData,
                                          xValueMapper: (GDPData data, _) =>
                                              data.month,
                                          yValueMapper: (GDPData data, _) =>
                                              data.value,
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true))
                                    ]))),
                        const Positioned(
                            top: 25,
                            left: 30,
                            child: Text(
                              ("Статистика переданных показаний"),
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 23,
                                  fontFamily: 'Nerko One',
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.bold,
                                  height: 1),
                            )),
                        const Positioned(
                            top: 90,
                            left: 30,
                            child: Text(
                              ("Электроэнергия (кВтч)"),
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 21,
                                  fontFamily: 'Nerko One',
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.bold,
                                  height: 1),
                            )),
                        const Positioned(
                            top: 500,
                            left: 30,
                            child: Text(
                              ("Газ (м\u00b3)"),
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 21,
                                  fontFamily: 'Nerko One',
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.bold,
                                  height: 1),
                            )),
                        const Positioned(
                            top: 870,
                            left: 30,
                            child: Text(
                              ("Вода (м\u00b3)"),
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 21,
                                  fontFamily: 'Nerko One',
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.bold,
                                  height: 1),
                            )),
                      ],
                    ),
                  ),
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
                      top: 220,
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
                                fontWeight: FontWeight.bold,
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

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:projects/screens/counters.dart';
import 'package:projects/screens/fill_application.dart';
import 'package:projects/screens/profile.dart';
import 'package:projects/screens/statistics.dart';
import 'package:projects/screens/reference.dart';

class Applications extends StatefulWidget {
  final String login;
  const Applications({Key? key, required this.login}) : super(key: key);
  @override
  State<Applications> createState() {
    return _Applications();
  }
}

class _Applications extends State<Applications> {
  bool firstVisible = true,
      secondVisible = false,
      thirdVisible = false,
      backButtonVisible = false;
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
                      top: 25,
                      left: 320,
                      child: Visibility(
                          visible: firstVisible,
                          child: const Text(
                            ("Оформить заявление на оказание услуги"),
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontSize: 23,
                                fontFamily: 'Nerko One',
                                letterSpacing: 0,
                                fontWeight: FontWeight.bold,
                                height: 1),
                          ))),
                  Positioned(
                      top: 30,
                      left: 380,
                      child: Visibility(
                          visible: secondVisible,
                          child: const Text(
                            ("Вызвать мастера"),
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontSize: 23,
                                fontFamily: 'Nerko One',
                                letterSpacing: 0,
                                fontWeight: FontWeight.bold,
                                height: 1),
                          ))),
                  Positioned(
                      top: 30,
                      left: 380,
                      child: Visibility(
                          visible: thirdVisible,
                          child: const Text(
                            ("Проверка, замена, установка счетчиков"),
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontSize: 23,
                                fontFamily: 'Nerko One',
                                letterSpacing: 0,
                                fontWeight: FontWeight.bold,
                                height: 1),
                          ))),
                  Positioned(
                      top: 105,
                      left: 350,
                      child: Visibility(
                          visible: firstVisible,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                      width: 2,
                                      color: Color.fromRGBO(181, 255, 169, 1)),
                                  fixedSize: const Size(240, 160),
                                  backgroundColor:
                                      const Color.fromRGBO(255, 255, 255, 1),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  )),
                              onPressed: () {
                                setState(() {
                                  firstVisible = false;
                                  secondVisible = true;
                                  backButtonVisible = true;
                                });
                              },
                              child: Column(children: [
                                const SizedBox(height: 20, width: 240),
                                SvgPicture.asset(
                                  "assets/images/repair2.svg",
                                ),
                              ])))),
                  Positioned(
                      top: 105,
                      left: 620,
                      child: Visibility(
                          visible: firstVisible,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                      width: 2,
                                      color: Color.fromRGBO(181, 255, 169, 1)),
                                  fixedSize: const Size(240, 160),
                                  backgroundColor:
                                      const Color.fromRGBO(255, 255, 255, 1),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  )),
                              onPressed: () {
                                setState(() {
                                  firstVisible = false;
                                  thirdVisible = true;
                                  backButtonVisible = true;
                                });
                              },
                              child: Column(children: [
                                const SizedBox(height: 20, width: 240),
                                SvgPicture.asset(
                                  "assets/images/register2.svg",
                                ),
                              ])))),
                  Positioned(
                      top: 22,
                      left: 320,
                      child: Visibility(
                          visible: backButtonVisible,
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
                              )))),
                  Positioned(
                      top: 22,
                      left: 320,
                      child: Visibility(
                          visible: backButtonVisible,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            tooltip: "Вернуться назад",
                            onPressed: () {
                              setState(() {
                                firstVisible = true;
                                secondVisible = false;
                                thirdVisible = false;
                                backButtonVisible = false;
                              });
                            },
                          ))),
                  Positioned(
                      top: 105,
                      left: 350,
                      child: Visibility(
                          visible: secondVisible,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                      width: 2,
                                      color: Color.fromRGBO(181, 255, 169, 1)),
                                  fixedSize: const Size(240, 160),
                                  backgroundColor:
                                      const Color.fromRGBO(255, 255, 255, 1),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  )),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return FillApp(
                                      login: widget.login,
                                      appType: "Вызвать электрика",
                                    );
                                  },
                                ));
                              },
                              child: const Text('Вызвать электрика',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumGothic',
                                      fontSize: 19,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.normal,
                                      height: 1))))),
                  Positioned(
                      top: 105,
                      left: 620,
                      child: Visibility(
                          visible: secondVisible,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                      width: 2,
                                      color: Color.fromRGBO(181, 255, 169, 1)),
                                  fixedSize: const Size(240, 160),
                                  backgroundColor:
                                      const Color.fromRGBO(255, 255, 255, 1),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  )),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return FillApp(
                                      login: widget.login,
                                      appType: "Вызвать сантехника",
                                    );
                                  },
                                ));
                              },
                              child: const Text('Вызвать сантехника',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumGothic',
                                      fontSize: 19,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.normal,
                                      height: 1))))),
                  Positioned(
                      top: 105,
                      left: 890,
                      child: Visibility(
                          visible: secondVisible,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                      width: 2,
                                      color: Color.fromRGBO(181, 255, 169, 1)),
                                  fixedSize: const Size(240, 160),
                                  backgroundColor:
                                      const Color.fromRGBO(255, 255, 255, 1),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  )),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return FillApp(
                                      login: widget.login,
                                      appType: "Вызвать газовщика",
                                    );
                                  },
                                ));
                              },
                              child: const Text('Вызвать газовщика',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumGothic',
                                      fontSize: 19,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.normal,
                                      height: 1))))),
                  Positioned(
                      top: 105,
                      left: 350,
                      child: Visibility(
                          visible: thirdVisible,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                      width: 2,
                                      color: Color.fromRGBO(181, 255, 169, 1)),
                                  fixedSize: const Size(240, 160),
                                  backgroundColor:
                                      const Color.fromRGBO(255, 255, 255, 1),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  )),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return FillApp(
                                      login: widget.login,
                                      appType:
                                          "Проверить/Заменить/Установить счетчик газа",
                                    );
                                  },
                                ));
                              },
                              child: const Text(
                                  'Проверить или заменить (установить) счетчик газа',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumGothic',
                                      fontSize: 19,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.normal,
                                      height: 1))))),
                  Positioned(
                      top: 105,
                      left: 620,
                      child: Visibility(
                          visible: thirdVisible,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                      width: 2,
                                      color: Color.fromRGBO(181, 255, 169, 1)),
                                  fixedSize: const Size(240, 160),
                                  backgroundColor:
                                      const Color.fromRGBO(255, 255, 255, 1),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  )),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return FillApp(
                                      login: widget.login,
                                      appType:
                                          "Проверить/Заменить/Установить счетчик воды",
                                    );
                                  },
                                ));
                              },
                              child: const Text(
                                  'Проверить или заменить (установить) счетчик воды',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumGothic',
                                      fontSize: 19,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.normal,
                                      height: 1))))),
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

import 'package:flutter/material.dart';
import 'package:projects/screens/applications.dart';
import 'package:projects/screens/counters.dart';
import 'package:projects/screens/profile.dart';
import 'package:projects/screens/reference.dart';
import 'package:projects/screens/statistics.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
//import 'package:sqflite_sqlcipher/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

class ChangeData extends StatefulWidget {
  final String login, email, phone, address;
  final int residents;
  final double area;
  const ChangeData(
      {Key? key,
      required this.login,
      required this.email,
      required this.phone,
      required this.address,
      required this.residents,
      required this.area})
      : super(key: key);
  @override
  State<ChangeData> createState() {
    return _ChangeData();
  }
}

class _ChangeData extends State<ChangeData> {
  //final TextEditingController _loginController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _residentsController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  void setText() {
    setState(() {
      //_loginController.text = widget.login;
      _emailController.text = widget.email;
      _phoneController.text = widget.phone;
      _addressController.text = widget.address;
      _residentsController.text = widget.residents.toString();
      _areaController.text = widget.area.toString();
    });
  }

  @override
  void initState() {
    setText();
    super.initState();
  }

  Future<int> toChange() async {
    try {
      String dbpath = await databaseFactoryFfi.getDatabasesPath();
      final database = openDatabase(
        join(dbpath, 'database.db'),
      );
      final db = await database;
      await db.execute(
          "UPDATE Profile SET email = '${_emailController.text}', phone = '${_phoneController.text}', residents_number = ${_residentsController.text}, address = '${_addressController.text}', area = ${_areaController.text} WHERE login = '${widget.login}'");
      return 1;
    } catch (e) {
      debugPrint("Error: $e");
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
                              return Profile(login: widget.login);
                            },
                          ));
                        },
                      )),
                  const Positioned(
                      top: 30,
                      left: 380,
                      child: Text(
                        ("Изменить данные профиля"),
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 23,
                            fontFamily: 'Nerko One',
                            letterSpacing: 0,
                            fontWeight: FontWeight.bold,
                            height: 1),
                      )),
                  const Positioned(
                    top: 95,
                    left: 320,
                    child: Text(("Электронная почта:"),
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 21,
                            fontFamily: 'Nerko One',
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            height: 1),
                        softWrap: true,
                        textAlign: TextAlign.center),
                  ),
                  Positioned(
                      top: 80,
                      left: 620,
                      child: SizedBox(
                          width: 465,
                          height: 40,
                          child: TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                              )))),
                  const Positioned(
                      top: 140,
                      left: 320,
                      child: Text(
                        ("Номер телефона: "),
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 21,
                            fontFamily: 'Nerko One',
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      )),
                  Positioned(
                      top: 125,
                      left: 620,
                      child: SizedBox(
                          width: 465,
                          height: 40,
                          child: TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                              )))),
                  const Positioned(
                      top: 185,
                      left: 320,
                      child: Text(
                        ("Адрес: "),
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 21,
                            fontFamily: 'Nerko One',
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      )),
                  Positioned(
                      top: 170,
                      left: 620,
                      child: SizedBox(
                          width: 465,
                          height: 40,
                          child: TextFormField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                              )))),
                  const Positioned(
                      top: 230,
                      left: 320,
                      child: Text(
                        ("Количество проживающих: "),
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 21,
                            fontFamily: 'Nerko One',
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      )),
                  Positioned(
                      top: 215,
                      left: 620,
                      child: SizedBox(
                          width: 465,
                          height: 40,
                          child: TextFormField(
                              controller: _residentsController,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                              )))),
                  const Positioned(
                      top: 275,
                      left: 320,
                      child: Text(
                        ("Общая площадь: "),
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 21,
                            fontFamily: 'Nerko One',
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      )),
                  Positioned(
                      top: 260,
                      left: 620,
                      child: SizedBox(
                          width: 465,
                          height: 40,
                          child: TextFormField(
                              controller: _areaController,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                              )))),
                  Positioned(
                      top: 340,
                      left: 830,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(200, 40),
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
                          int result = await toChange();
                          if (result == 1) {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return Profile(login: widget.login);
                              },
                            ));
                          }
                        },
                        child: const Text('Сохранить',
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

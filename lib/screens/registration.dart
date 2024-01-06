import 'package:flutter/material.dart';
import 'package:projects/main.dart';
import 'package:projects/screens/thanks.dart';
import 'package:path/path.dart';
//import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Reg extends StatefulWidget {
  const Reg({super.key});
  @override
  Registration createState() => Registration();
}

class Registration extends State<Reg> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _residentsNumberController =
      TextEditingController();
  bool isConnected = false;
  bool _toVisible = false;
  bool passwordVisible = true;
  bool password2Visible = true;
  void showText() {
    setState(() {
      _toVisible = !_toVisible;
    });
  }

  Future<int> setData() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      String log = _loginController.text,
          pass = _passwordController.text,
          email = _emailController.text,
          phone = _phoneController.text,
          adr = _addressController.text;
      int res = int.parse(_residentsNumberController.text);
      double area = double.parse(_areaController.text);
      String dbpath = await databaseFactoryFfi.getDatabasesPath();
      final database = openDatabase(
        join(dbpath, 'database.db'),
        //password: "H3!yP97.sA",
      );
      final db = await database;
      final List<Map<String, dynamic>> maps =
          await db.rawQuery('SELECT * FROM authentication');
      for (int i = 0; i < maps.length; i++) {
        if (maps[i]['login'] == log) return -1;
      }
      if (_passwordController.text == _password2Controller.text) {
        await db.execute("INSERT INTO authentication VALUES('$log', '$pass')");
        await db.execute(
            "INSERT INTO profile VALUES('$log', '$email', '$phone', '$res', '$adr', '$area')");
      }
      isConnected = true;
      return 1;
    } catch (e) {
      debugPrint('Error while registration! ${e.toString()}');
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Container(
                alignment: AlignmentDirectional.center,
                width: 1550,
                height: 800,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                child: Stack(alignment: AlignmentDirectional.center, children: <
                    Widget>[
                  Container(
                      alignment: AlignmentDirectional.center,
                      width: 1300,
                      height: 750,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                        color: Color.fromRGBO(181, 255, 169, 1),
                      )),
                  const Positioned(
                      top: 30,
                      child: Text('Регистрация',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'NanumGothic',
                              fontSize: 35,
                              letterSpacing: 0,
                              fontWeight: FontWeight.normal,
                              height: 1))),
                  Positioned(
                      top: 110,
                      left: 171,
                      child: Container(
                          alignment: AlignmentDirectional.center,
                          width: 1000,
                          height: 500,
                          child: Stack(children: <Widget>[
                            Positioned(
                                top: 35,
                                left: 0,
                                child: Container(
                                    width: 415,
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
                                top: 35,
                                left: 7,
                                child: SizedBox(
                                    width: 400,
                                    height: 40,
                                    child: TextFormField(
                                        controller: _loginController,
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                        )))),
                            Positioned(
                                top: 165,
                                left: 550,
                                child: Container(
                                    width: 415,
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
                                top: 165,
                                left: 557,
                                child: SizedBox(
                                    width: 400,
                                    height: 40,
                                    child: TextFormField(
                                        controller: _addressController,
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                        )))),
                            Positioned(
                                top: 165,
                                left: 0,
                                child: Container(
                                    width: 415,
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
                                top: 165,
                                left: 7,
                                child: SizedBox(
                                    width: 400,
                                    height: 40,
                                    child: TextFormField(
                                        obscureText: passwordVisible,
                                        controller: _passwordController,
                                        decoration: InputDecoration(
                                            border:
                                                const UnderlineInputBorder(),
                                            suffixIcon: IconButton(
                                              icon: Icon(passwordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off),
                                              onPressed: () {
                                                setState(() {
                                                  passwordVisible =
                                                      !passwordVisible;
                                                });
                                              },
                                            ))))),
                            Positioned(
                                top: 295,
                                left: 550,
                                child: Container(
                                    width: 415,
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
                                top: 295,
                                left: 557,
                                child: SizedBox(
                                    width: 400,
                                    height: 40,
                                    child: TextFormField(
                                        controller: _areaController,
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                        )))),
                            Positioned(
                                top: 295,
                                left: 0,
                                child: Container(
                                    width: 415,
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
                                top: 295,
                                left: 7,
                                child: SizedBox(
                                    width: 400,
                                    height: 40,
                                    child: TextFormField(
                                        obscureText: password2Visible,
                                        controller: _password2Controller,
                                        decoration: InputDecoration(
                                            border:
                                                const UnderlineInputBorder(),
                                            suffixIcon: IconButton(
                                              icon: Icon(password2Visible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off),
                                              onPressed: () {
                                                setState(
                                                  () {
                                                    password2Visible =
                                                        !password2Visible;
                                                  },
                                                );
                                              },
                                            ))))),
                            Positioned(
                                top: 425,
                                left: 0,
                                child: Container(
                                    width: 415,
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
                                top: 425,
                                left: 7,
                                child: SizedBox(
                                    width: 400,
                                    height: 40,
                                    child: TextFormField(
                                        controller: _emailController,
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                        )))),
                            Positioned(
                                top: 425,
                                left: 550,
                                child: Container(
                                    width: 415,
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
                                top: 425,
                                left: 557,
                                child: SizedBox(
                                    width: 400,
                                    height: 40,
                                    child: TextFormField(
                                        controller: _residentsNumberController,
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                        )))),
                            Positioned(
                                top: 35,
                                left: 550,
                                child: Container(
                                    width: 415,
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
                                top: 35,
                                left: 557,
                                child: SizedBox(
                                    width: 400,
                                    height: 40,
                                    child: TextFormField(
                                        controller: _phoneController,
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                        )))),
                            const Positioned(
                                left: 0,
                                child: Text(
                                  'Придумайте Логин',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumGothic',
                                      fontSize: 21,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                )),
                            const Positioned(
                                top: 130,
                                left: 550,
                                child: Text(
                                  'Адрес',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumGothic',
                                      fontSize: 21,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                )),
                            const Positioned(
                                top: 130,
                                left: 0,
                                child: Text(
                                  'Придумайте Пароль',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumGothic',
                                      fontSize: 21,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                )),
                            const Positioned(
                                top: 260,
                                left: 0,
                                child: Text(
                                  'Повторите Пароль',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumGothic',
                                      fontSize: 21,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                )),
                            const Positioned(
                                top: 260,
                                left: 550,
                                child: Text(
                                  'Общая площадь',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumGothic',
                                      fontSize: 21,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                )),
                            const Positioned(
                                top: 390,
                                left: 0,
                                child: Text(
                                  'Электронная почта',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumGothic',
                                      fontSize: 21,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                )),
                            const Positioned(
                                top: 390,
                                left: 550,
                                child: Text(
                                  'Количество проживающих',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumGothic',
                                      fontSize: 21,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                )),
                            const Positioned(
                                left: 550,
                                child: Text(
                                  'Номер телефона',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumGothic',
                                      fontSize: 21,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                )),
                          ]))),
                  Positioned(
                      top: 630,
                      child: Container(
                          alignment: AlignmentDirectional.center,
                          width: 320,
                          height: 60,
                          child: Stack(children: <Widget>[
                            Positioned(
                                left: 25,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(270, 55),
                                      backgroundColor: const Color.fromRGBO(
                                          249, 255, 183, 1),
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
                                    debugPrint(res.toString());
                                    if (res == 1) {
                                      debugPrint('Trying to registrate...');
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return const Thanks();
                                        },
                                      ));
                                    } else if (res == -1) {
                                      debugPrint('The user already exists');
                                      showText();
                                      _loginController.clear();
                                      _passwordController.clear();
                                      _password2Controller.clear();
                                      _emailController.clear();
                                      _phoneController.clear();
                                      _addressController.clear();
                                      _areaController.clear();
                                      _residentsNumberController.clear();
                                    }
                                  },
                                  child: const Text('Зарегистрироваться',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontFamily: 'NanumGothic',
                                          fontSize: 21,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.normal,
                                          height: 1)),
                                )),
                          ]))),
                  Visibility(
                      visible: _toVisible,
                      child: Positioned(
                          top: 690,
                          child: Container(
                              width: 600,
                              height: 50,
                              alignment: AlignmentDirectional.center,
                              child: const Text(
                                'Ошибка! Такой пользователь уже существует.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(231, 37, 37, 1),
                                    fontFamily: 'NanumGothic',
                                    fontSize: 21,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              )))),
                  Positioned(
                      top: 638,
                      left: 45,
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
                      top: 638,
                      left: 45,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        tooltip: "Вернуться назад",
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const MyHomePage();
                            },
                          ));
                        },
                      )),
                ]))));
  }
}

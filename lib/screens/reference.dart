import 'package:flutter/material.dart';
import 'package:projects/screens/applications.dart';
import 'package:projects/screens/counters.dart';
import 'package:projects/screens/profile.dart';
import 'package:projects/screens/statistics.dart';
import 'package:scrollable/exports.dart';

class Support extends StatelessWidget {
  final String login;
  const Support({Key? key, required this.login}) : super(key: key);

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
                  ScrollableView(
                      padding: const EdgeInsets.only(left: 290.0),
                      controller: ScrollController(),
                      //child: SingleChildScrollView(
                      child: Stack(children: <Widget>[
                        Container(
                            alignment: AlignmentDirectional.center,
                            height: 1000,
                            width: 1250,
                            color: Colors.white),
                        const Positioned(
                            top: 25,
                            left: 30,
                            child: Text(
                              ("Пользовательское соглашение "),
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 23,
                                  fontFamily: 'Nerko One',
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.bold,
                                  height: 1),
                            )),
                        const Positioned(
                            top: 65,
                            left: 30,
                            child: Text(
                              ("Настоящее Пользовательское Соглашение (Далее Соглашение) регулирует отношения между владельцем (далее Система \nклиентского обслуживания коммунальных услуг или Администрация) с одной стороны и пользователем сайта с другой."
                                  "\nСайт Система клиентского обслуживания коммунальных услуг не является средством массовой информации.\nИспользуя сайт, Вы соглашаетесь с условиями данного соглашения."
                                  "Если Вы не согласны с условиями данного соглашения,\nне используйте сайт Система клиентского обслуживания коммунальных услуг! "),
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 21,
                                  fontFamily: 'Nerko One',
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                              //maxLines: 10
                              //softWrap: true,
                              //textAlign: TextAlign.center
                            )),
                        const Positioned(
                            top: 190,
                            left: 30,
                            child: Text(
                              ("Предмет соглашения"),
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 22,
                                  fontFamily: 'Nerko One',
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.bold,
                                  height: 1),
                            )),
                        const Positioned(
                            top: 220,
                            left: 30,
                            child: Text(
                              ("Администрация предоставляет пользователю право на размещение на сайте следующей информации:\n- Текстовой информации"),
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 21,
                                  fontFamily: 'Nerko One',
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            )),
                        const Positioned(
                            top: 280,
                            left: 30,
                            child: Text(
                              ("Права и обязанности сторон\nПользователь имеет право:"),
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 22,
                                  fontFamily: 'Nerko One',
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.bold,
                                  height: 1),
                            )),
                        const Positioned(
                            top: 330,
                            left: 30,
                            child: Text(
                              ("- осуществлять поиск информации на сайте\n- получать информацию на сайте- распространять информацию на сайте\n- использовать информацию сайта в личных некоммерческих целях"),
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 21,
                                  fontFamily: 'Nerko One',
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            )),
                        const Positioned(
                            top: 400,
                            left: 30,
                            child: Text(
                              ("Администрация имеет право:"),
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 22,
                                  fontFamily: 'Nerko One',
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.bold,
                                  height: 1),
                            )),
                        const Positioned(
                            top: 430,
                            left: 30,
                            child: Text(
                              ("- по своему усмотрению и необходимости создавать, изменять, отменять правила\n- ограничивать доступ к любой информации на сайте\n- создавать, изменять, удалять информацию"),
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 21,
                                  fontFamily: 'Nerko One',
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            )),
                        const Positioned(
                            top: 500,
                            left: 30,
                            child: Text(
                              ("Пользователь обязуется:"),
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 22,
                                  fontFamily: 'Nerko One',
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.bold,
                                  height: 1),
                            )),
                        const Positioned(
                            top: 530,
                            left: 30,
                            child: Text(
                              ("- обеспечить достоверность предоставляемой информации\n- обновлять Персональные данные, предоставленные при регистрации, в случае их изменения\n- не нарушать работоспособность сайта\n- не создавать несколько учётных записей на Сайте, если фактически они принадлежат одному и тому же лицу\n- не передавать в пользование свою учетную запись и/или логин и пароль своей учетной записи третьим лицам\n- не регистрировать учетную запись от имени или вместо другого лица за исключением случаев, предусмотренных \nзаконодательством РФ"),
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 21,
                                  fontFamily: 'Nerko One',
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            )),
                        const Positioned(
                            top: 685,
                            left: 30,
                            child: Text(
                              ("Администрация обязуется:"),
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 22,
                                  fontFamily: 'Nerko One',
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.bold,
                                  height: 1),
                            )),
                        const Positioned(
                            top: 715,
                            left: 30,
                            child: Text(
                              ("- поддерживать работоспособность сайта за исключением случаев, когда это невозможно по независящим от \nАдминистрации причинам."),
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 21,
                                  fontFamily: 'Nerko One',
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            )),
                        const Positioned(
                            top: 770,
                            left: 30,
                            child: Text(
                              ("Ответственность сторон"),
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 22,
                                  fontFamily: 'Nerko One',
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.bold,
                                  height: 1),
                            )),
                        const Positioned(
                            top: 795,
                            left: 30,
                            child: Text(
                              ("- администрация не несет никакой ответственности за услуги, предоставляемые третьими лицами- в случае возникновения \nфорс-мажорной ситуации (боевые действия, чрезвычайное положение, стихийное бедствие и т. д.) Администрация \nне гарантирует сохранность информации, размещённой Пользователем, а также бесперебойную работу информационного \nресурса"),
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 21,
                                  fontFamily: 'Nerko One',
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            )),
                        const Positioned(
                            top: 890,
                            left: 30,
                            child: Text(
                              ("Условия действия Соглашения"),
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 22,
                                  fontFamily: 'Nerko One',
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.bold,
                                  height: 1),
                            )),
                        const Positioned(
                            top: 915,
                            left: 30,
                            child: Text(
                              ("Данное Соглашение вступает в силу при любом использовании данного сайта.Соглашение перестает действовать при \nпоявлении его новой версии."
                                  "Администрация оставляет за собой право в одностороннем порядке изменять данное \nсоглашение по своему усмотрению.Администрация не оповещает пользователей об изменении в Соглашении."),
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 21,
                                  fontFamily: 'Nerko One',
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            )),
                      ])),
                  Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                          alignment: AlignmentDirectional.topEnd,
                          width: 290,
                          height: 800,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(181, 255, 169, 1),
                          ))),
                  Positioned(
                      top: 320,
                      left: 0,
                      child: Container(
                          alignment: AlignmentDirectional.topEnd,
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
                              return Profile(login: login);
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
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
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
                              return Support(login: login);
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
                                fontWeight: FontWeight.bold,
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
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1)),
                      )),
                ]))));
  }
}

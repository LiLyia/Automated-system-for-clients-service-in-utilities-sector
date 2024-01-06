import 'package:flutter/material.dart';

class Thanks extends StatelessWidget {
  const Thanks({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
      alignment: AlignmentDirectional.center,
      width: 1550,
      height: 800,
      decoration: const BoxDecoration(
          color : Color.fromRGBO(255, 255, 255, 1),
  ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
        Container(
          alignment: AlignmentDirectional.center,
        width: 1300,
        height: 750,
        decoration: const BoxDecoration(
          borderRadius : BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
      color : Color.fromRGBO(181, 255, 169, 1),
  )
        ),
        const Positioned(
        top: 200,
        //left: 600,
        child: Text('Спасибо за регистрацию!', textAlign: TextAlign.center, style: TextStyle(
        color: Color.fromRGBO(0, 0, 0, 1),
        fontFamily: 'NanumGothic',
        fontSize: 35,
        letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
        fontWeight: FontWeight.normal,
        height: 1
      ),)
      ),
      Container(
          alignment: AlignmentDirectional.center,
        width: 320,
        height: 60,
        decoration: const BoxDecoration(
          borderRadius : BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
      boxShadow : [BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.25),
          offset: Offset(4,4),
          blurRadius: 10
      )],
      color : Color.fromRGBO(249, 255, 183, 1),
  ) 
      ),
      Container(
        alignment: AlignmentDirectional.center,
      child: Positioned(
        //top: 30,
        //left: 25,
        child: 
        TextButton(
          onPressed: () async {
            Navigator.pushNamed(context, '/');
          },
          child: const Text('Войти', textAlign: TextAlign.center, style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
            fontFamily: 'NanumGothic',
            fontSize: 24,
            letterSpacing: 0,
            fontWeight: FontWeight.normal,
            height: 1 )
      ),)
      ),),
      
        ]
      )
        )
      )
    );
}
}
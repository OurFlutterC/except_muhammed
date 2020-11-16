
import 'package:except_Mohammed/GetProductByName.dart';
import 'package:except_Mohammed/OnBoarding.dart';
import 'package:except_Mohammed/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    theme: ThemeData(
      fontFamily: "Cairo-Black"
    ),
    debugShowCheckedModeBanner: false,
    routes: <String, WidgetBuilder>{
    '/search': (BuildContext context) => new GetByName(),
},
home: FutureBuilder(
  future: getFirst(),
  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    return snapshot.hasData?GetByName():onBoarding();
  },),
);
  }
}
//300–379
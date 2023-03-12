import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:willbond/startapp/SplashScrean.dart';

import 'Design_page_error_fether/NotFond_Error.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // use to do not change rotation on all app
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // builder: (BuildContext context, Widget widget) {
      //   ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      //     return buildError(context, errorDetails);
      //   };
      //   return widget;
      // },
      home:SplashScrean(),
      // home:SignUp(),

//      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


Widget buildError(BuildContext context, FlutterErrorDetails error) {
  return Scaffold(
    appBar: AppBar(title: Text(""),
      backgroundColor: Color(0xff212660),
      iconTheme: new IconThemeData(color: Color(0xffffffff)),
      elevation: 2.0,
    ),
    body:

    Center(
      child:NotFond_Error()
    ),
  )
  ;
}

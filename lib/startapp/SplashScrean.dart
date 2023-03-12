import 'dart:async';

import 'package:flutter/material.dart';
import 'package:response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:willbond/HOME/Home.dart';

import 'Login.dart';
//import 'package:prestige/HomeApp.dart';
//import 'package:prestige/aboutApp_ConnectUs/ConnectUs.dart';
//import 'package:prestige/aboutApp_ConnectUs/TestPajenation.dart';
//import 'package:prestige/aboutApp_ConnectUs/TestPajenation1.dart';
//import 'package:prestige/start_App/SignUp.dart';
//import 'package:response/response.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//
//import 'Login.dart';


class SplashScrean extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return UISplash ();
  }

}

class UISplash extends State<SplashScrean> {


  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    // String stringValue = prefs.getString('idUser');
    bool checkValue = prefs.containsKey('token');
    print("idUser=> "+checkValue.toString());
    if(checkValue== true){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>  Home()));
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => Login()));
    }
//    return stringValue;
  }

  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
            () {
              getStringValuesSF();
    });
  }

  @override
  Widget build(BuildContext context) {

   return Scaffold(

     body: Center(
       child: Container(
         decoration: BoxDecoration(
           color: Color(0xff212660),
//           image: DecorationImage(
//               image: new AssetImage('bg_splach1.png'),
//               //image: NetworkImage('https://images.unsplash.com/photo-1547665979-bb809517610d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=675&q=80'),
//               fit: BoxFit.fill
//           ) ,
         ),

         child: Center(
             child: new Image(image: AssetImage('assets/logo.png'),color: Color(0xffffffff),width:170,height: 165,),
//             child: new Image(image: AssetImage('assets/logo.png'),color: Color(0xffffffff),width: response.setWidth(170),height: response.setHeight(165),),
//           child: Image.asset(image: new AssetImage('bg_splasch.png'),)
         ),
       ),
     ),
   );
  }
}


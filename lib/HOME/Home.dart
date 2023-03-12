
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:willbond/DatabaseHelper/DatabaseHelperFinal.dart';
import 'package:willbond/aboutUs/AboutUs.dart';
import 'package:willbond/cart/Cart.dart';
import 'package:willbond/connectUs/ConnectUs.dart';
import 'package:willbond/favorite/Favorite.dart';
import 'package:willbond/homeWite1.dart';
import 'package:willbond/itemList_new_And_All/ListItem.dart';
import 'package:willbond/itemList_new_And_All/list_new_item.dart';
import 'package:willbond/item_deteals/Item_details.dart';
import 'package:willbond/notofiaction/Notofication.dart';
import 'package:willbond/serch_home/SershHome.dart';
import 'package:willbond/startapp/ChangePassword.dart';
import 'package:willbond/startapp/Login.dart';
import 'package:willbond/startapp/Update_profile.dart';
import 'package:willbond/trackorder/All_order_Finsh.dart';
import 'package:willbond/trackorder/TrackOrder.dart';
import 'package:http_parser/http_parser.dart';
import '../URL_LOGIC.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UiHome();
  }

}

class UiHome extends State<Home>{

  // final FirebaseMessaging? _messaging = FirebaseMessaging();
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  // FlutterLocalNotificationsPlugin fltrNotification;
  @override
  void initState() {
    super.initState();

    print("home");
    getToken();
//    getRefrich();

    getData("");
    getData_New("");
    getDatauser("");
    getdatabase();

    // _messaging. getToken().then((token) {
    //   print("token  >>>>>>>$token");
    //   print("token  >>>>>>>$token");
    //   _sendItemData(token);
    // });


    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     var androidInitilize = new AndroidInitializationSettings('wellbond');
    //     var iOSinitilize = new IOSInitializationSettings();
    //     var initilizationsSettings =
    //     new InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
    //     fltrNotification = new FlutterLocalNotificationsPlugin();
    //     fltrNotification.initialize(initilizationsSettings, onSelectNotification: notificationSelected);
    //
    //     print("onMessage: $message");
    //     print("onMessage: ${message["notification"]["body"]}");
    //
    //     _showNotification("${message["notification"]["body"]}");
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     Navigator.pushNamed(context, '/Home');
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //   },
    // );
  }

  // Future _showNotification(String s) async {
  //   var androidDetails = new AndroidNotificationDetails(
  //       "Channel ID", "Desi programmer", "This is my channel",
  //       importance: Importance.max);
  //   var iSODetails = new IOSNotificationDetails();
  //   var generalNotificationDetails =
  //   new NotificationDetails(android: androidDetails, iOS: iSODetails);
  //
  //   await fltrNotification.show(
  //       10, "WellBond", "$s",
  //       generalNotificationDetails, payload: "Task");
  // }



  Future notificationSelected(String payload) async {
//    showDialog(
//      context: context,
//      builder: (context) => AlertDialog(
//        content: Text("Notification : $payload"),
//      ),
//    );
  }



  int retoken_user=0;
  int retoken_new=0;
  int retoken_list=0;



  //token
  Future<List?> _sendItemData(token) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id= prefs.getString('idUser');
    Map<String, dynamic> body = {
      "deviceToken":token,
    };

    String? token_login = prefs.getString('token');
    try{
      final encoding = Encoding.getByName('utf-8');
      final headers = {'Content-Type': 'application/json',"Authorization":"$token_login"};
      //http://freemoneyforums.com/apps/api/clinets//gettoken/id/token

      String jsonBody = json.encode(body);
      final response = await http.put(Uri.parse(URL_LOGIC.token_firebase_send),
        headers: headers,
        body:jsonBody,
encoding: encoding
//        headers: {"Authorization":"$token_login"},
      );

      var datauser = json.decode(response.body);
      print("token>>??؟؟؟؟؟؟؟؟ "+token);
      print("token>>??؟؟؟؟؟؟؟؟ "+datauser.toString());


    }catch(exception){
      print("object ??"+exception.toString());
//      pr.hide().then((isHidden) {
//        print(isHidden);
//      });
//      showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          return   AlertDialog(
//            title: null,
//            content: Text("++++++++++يرجي التاكد من الاتصال بل النترنت"),
//            actions: [
////            okButton,
//            ],
//          );
//        },
//      );
    }
  }

  Future getdatabase() async{
    try {
      var db = new DatabaseHelperFinal();
      var userSaved = await db.getUser();
      print("userSaved  $userSaved");
    } catch(exception){
      print("userSaved  ?>>>?");
    }
  }

  Future getRefrich() async {
//     data_offer_new.clear();
//     userData_offer_new.clear();
     data_offer?.clear();
     _All.clear();
    getData("");
     getData("");
     getData_New("");
     getDatauser("");
//    getData_New("");
    await Future.delayed(Duration(seconds: 3));
  }
  
  Future? getRefrich_all()  {
    setState(() {
      getData("search");
      getData_New("search");
      getDatauser("search");
    });

//    await Future.delayed(Duration(seconds: 3));
  }

  getToken () async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? token = prefs.getString('token');
    print(">>>>>>home>>>>>>");
    print("toke  $token");
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startLoader() {
    setState(() {
//      fetchData();
      getData("");
      getDatauser("");
    });
  }

  Map ? data_offer_new;
  List? userData_offer_new;
  Map? data_offer;
  List _All = [];

  Map data_user_map={};
  List data_user_list=[];

  String test_code_list="0";


  ScrollController? controller;
  bool isLoading = false;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  int numpage = 1;
  int totalRow=0;
  int test=0;


  Future getData(var search) async {
    try {
      ProgressDialog pr;
      pr = new ProgressDialog(context);
      pr = new ProgressDialog(context, type: ProgressDialogType.Normal,
          isDismissible: true,
          showLogs: true);
//    pr.show();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //Return String
      String? token = prefs.getString('token');

      Map<String, String> timeOutMessage = {
        'state': 'timeout',
        'content': 'server is not responding'
      };

      // item
      http.Response response_offer = await http.get(
          Uri.parse(URL_LOGIC.listItem_Home),
        headers: {"Authorization": "$token"},
      )
          .timeout(Duration(seconds: 90), onTimeout: () {
        return Future.value(http.Response(json.encode(timeOutMessage), 500));
      }).catchError((err) {
        // nothing
      });
      data_offer = json.decode(response_offer.body);



      setState(() {
        if (data_offer?["status"] == null) {
          setState(() {
            Future.delayed(Duration(seconds: 1)).then((value) {
              pr.hide();
              // setState(() {
              //   test_code_list = "1";
              // });
            });
            setState(() {
              test_code_list = "1";
            });
            // print(data_offer?.toString());

            isLoading = !isLoading;
            data_offer = json.decode(response_offer.body);

            _All.addAll(data_offer?["resultData"]["resultData"]??[]);
            numpage++;
            //
            totalRow = 4;
            isLoading = !isLoading;

            print(">>>>>>>>>>> offer<<<<<<<<<<<<");
            print("????>?>?>?>${_All}");
          });
        } else if (data_offer?["status"].toString() == "401") {
          print(">>>>>>>+++++++++++++++++++>>>>>>>>>>>?????????????");
          setState(() {
            retoken_list = 1;
          });
          refrech_token();
//        return;
        }
      });
    }catch(e){
      exitApp();
    }

  }


  Future refrech_token() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? reToken = prefs.getString('reToken');
    String? token = prefs.getString('token');


    Map<String, dynamic> body = {
      "refreshToken": reToken
    };
    debugPrint("?????????");
    print("body is :"+body.toString());
    print("url is :"+URL_LOGIC.refrechToken);

    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};
//    final headers = {'Content-Type': 'application/json',"Authorization":"$token"};
    final response = await http.post(Uri.parse(URL_LOGIC.refrechToken),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    var datauserxx = json.decode(response.body);
    debugPrint(datauserxx.toString());


    Future.delayed(Duration(seconds: 3)).then((value)  {
      setState(() async {
        if(datauserxx["errorStatus"]==true || datauserxx["errorStatus"]=="true"){
          exitApp();

//          showDialog(
//            context: context,
//            builder: (BuildContext context) {
//              return   AlertDialog(
//                title: null,
//                content: Text("${datauserxx["errorResponsePayloadList"][0]["arabicMessage"]}",textAlign: TextAlign.center,
//                    style: TextStyle(
//                      fontFamily: 'Cairo',
////                      color: Color(0xffffffff),
//                      fontSize: 12,
//                      fontWeight: FontWeight.w400,
//                      fontStyle: FontStyle.normal,
//                    )
//                ),
//              );
//            },
//          );
        }
        else{
//          saveToken(datauser);
          print("refresh Token");
          print(datauserxx.toString());

          var token=datauserxx["resultData"]["tokenPair"]["jwt"];
          var retoken=datauserxx["resultData"]["tokenPair"]["refreshToken"];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token',token.toString());
          prefs.setString('reToken',retoken.toString());

          getRefrich_all();
        }
//        getRefrich_all();
//        for(int i=0 ; i<_selecteCategorys_index.length ;i++){
//          _All.removeAt(_selecteCategorys_index[i]);
//        }
//
//        _selecteCategorys_index.clear();
//        _selecteCategorys.clear();
//        visible=false;
      });

    });
}

  Future getData_New(var search) async {
    ProgressDialog pr;
    pr = new ProgressDialog(context);
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
//    pr.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? token = prefs.getString('token');

    Map<String, String> timeOutMessage = {
      'state': 'timeout',
      'content': 'server is not responding'
    };

    // new
    http.Response response_offer_new = await http.get(
        Uri.parse(URL_LOGIC.new_listItem_news_Home),
      headers: {"Authorization":"$token"},

    ).timeout(Duration(seconds: 90),onTimeout: (){
      return Future.value(http.Response(json.encode(timeOutMessage),500));
    }).catchError((err){
      // nothing
    });
    data_offer_new = json.decode(response_offer_new.body);


    setState(() {
      if(data_offer_new?["status"]==null){
        setState(() {
          userData_offer_new =data_offer_new?["resultData"]["resultData"]??[];
          Future.delayed(Duration(seconds: 1)).then((value) {
            pr.hide();
            // setState(() {
              test_code_list="1";
            // });
          });
          setState(() {
            test_code_list="1";
          });
//      print(data_offer.toString());

          isLoading = !isLoading;
//      _All.addAll(data_offer["resultData"]["resultData"]);


          userData_offer_new =data_offer_new?["resultData"]["resultData"]??[];
          numpage++;

          totalRow = 4;
//      var x=  totalRow/ 2 ;
//      test=x.toInt();
          isLoading = !isLoading;
        });


    }else  if(data_offer_new?["status"]=="401") {
    print(">>>>>>>+++++++++++++++++++>>>>>>>>>>>?????????????");
    setState(() {
      retoken_new=1;
    });
    refrech_token();
//    return;
    }
    });




  }

  Future getDatauser(var search) async {
    print("getDatauser?????>>>>>");
    ProgressDialog pr;
    pr = new ProgressDialog(context);
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
//    pr.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ?token = prefs.getString('token');

    Map<String, String> timeOutMessage = {
      'state': 'timeout',
      'content': 'server is not responding'
    };

    // data user
    http.Response data_user_info = await http.get(
        Uri.parse(URL_LOGIC.getInfo_dataUser),
      headers: {"Authorization":"$token"},

    ).timeout(Duration(seconds: 20),onTimeout: (){
      return Future.value(http.Response(json.encode(timeOutMessage),50));
    }).catchError((err){
      // nothing
    });

    print("getDatauser?????>>>>>");
    print(data_user_info.statusCode);
    print(data_user_info.body.toString());
    print("-----------------------------------------");

    data_user_map = json.decode(data_user_info.body);//json.decode(response_offer.body);



    setState(() {
      if(data_user_map["status"]==null){
        // data_user_list =data_user_map["resultData"];
        Future.delayed(Duration(seconds: 1)).then((value) {
        pr.hide();
      });
      //data info user
        setState(() {

          data_user_map = json.decode(data_user_info.body);
          // data_user_list =data_user_map["resultData"];
        });

      }else  if(data_user_map["status"].toString()=="401") {
        print(">>>>>>>+++++++++++++++++++>>>>>>>>>>>?????????????");
        setState(() {
          retoken_user=1;
        });
        refrech_token();
//        return;
      }
    });
  }






  Future<List?> _sendItemData_favorite( int idItem  ,  Map itemList ,index ) async {

    print("id item >>> $itemList");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String ? token = prefs.getString('token');

    //to send order
    ProgressDialog pr = new ProgressDialog(context);
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.show();


//    Map<String,String> timeOutMessage = {'state':'timeout','content':'server is not responding'};
    try{
      Map<String, dynamic> body = {
        "items": {
          "id" : idItem
        }
      };

      debugPrint("?????????");
      print("body is :"+body.toString());
      print("url is :"+URL_LOGIC.favorite);

      final encoding = Encoding.getByName('utf-8');
      String jsonBody = json.encode(body);
      final headers = {'Content-Type': 'application/json',"Authorization":"$token"};
      final response = await http.post(Uri.parse(URL_LOGIC.favorite),
        body:jsonBody,
        encoding: encoding,
        headers: headers,
      );
      var datauser3 = json.decode(response.body);
//      var code=datauser["code"];
//      var actions=datauser["action"];
      debugPrint(datauser3.toString());


//      debugPrint("message >>> "+actions);

      Future.delayed(Duration(seconds: 1)).then((value) async {
        pr.hide();
        if(datauser3["errorStatus"]==true){
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return   AlertDialog(
                  title: null,
                  content: Text("${datauser3["errorResponsePayloadList"][0]["arabicMessage"]}",textAlign: TextAlign.center,),
                  actions: [
//            okButton,
                  ],
                );
                },
          );
        }else{
          Future.delayed(Duration(seconds: 1)).then((value) async {
            pr.hide();
            print(itemList.toString());

            setState(() {
              _All[index]={
                "id": itemList["id"],
                "itemFavFlag": 1,
                "itemCode": itemList["itemCode"],
                "itemDescription": itemList["itemDescription"],
                "itemPricePerMetter": itemList["itemPricePerMetter"],
                "colorLookup": {
                  "id": itemList["colorLookup"]["id"],
                  "code": itemList["colorLookup"]["code"],
                  "description": itemList["colorLookup"]["description"],
                  "colorValue": itemList["colorLookup"]["colorValue"],
                  "colorDescEn": itemList["colorLookup"]["colorDescEn"],
                  "documentImagePath": itemList["colorLookup"]["documentImagePath"]
                }
              };
            });

//            getRefrich();
          print(">>>>>>>>>>>>>");
          print(_All);

          });
//          getRefrich();
        }

      });
    }catch(exception){
      Future.delayed(Duration(seconds: 3)).then((value) {
        pr.hide();
        setState(() {
          print("object ??"+exception.toString());
          pr.hide().then((isHidden) {
            print(isHidden);
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return   AlertDialog(
                title: null,
                content: Text("يرجي التاكد من الاتصال بل النترنت"),
                actions: [
//            okButton,
                ],
              );
            },
          );
//            Navigator.pop(context, true);
        });
      });

    }
  }

  Future<List?> _sendItemData_unfavorite(int idItem ,  Map itemList ,index ) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? token = prefs.getString('token');

    //to send order
    ProgressDialog pr = new ProgressDialog(context);
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.show();


//    Map<String,String> timeOutMessage = {'state':'timeout','content':'server is not responding'};
    try{
      Map<String, dynamic> body = {
        "itemsFavouriteList": [
          "$idItem"
        ]
      };

      debugPrint("?????????");
      print("body is :"+body.toString());
      print("url is :"+URL_LOGIC.Un_favorite);

//      final encoding = Encoding.getByName('utf-8');
//      String jsonBody = json.encode(body);
      final headers = {'Content-Type': 'application/json',"Authorization":"$token"};
      final response = await http.delete(Uri.parse(URL_LOGIC.Un_favorite+"$idItem"),
//        body:jsonBody,
//        encoding: encoding,
        headers: headers,
      );
      var datauser = json.decode(response.body);
      debugPrint(datauser.toString());
      Future.delayed(Duration(seconds: 1)).then((value) async {
        pr.hide();
//        getRefrich();
        setState(() {
          _All[index]={
            "id": itemList["id"],
            "itemFavFlag": 0,
            "itemCode": itemList["itemCode"],
            "itemDescription": itemList["itemDescription"],
            "itemPricePerMetter": itemList["itemPricePerMetter"],
            "colorLookup": {
              "id": itemList["colorLookup"]["id"],
              "code": itemList["colorLookup"]["code"],
              "description": itemList["colorLookup"]["description"],
              "colorValue": itemList["colorLookup"]["colorValue"],
              "colorDescEn": itemList["colorLookup"]["colorDescEn"],
              "documentImagePath": itemList["colorLookup"]["documentImagePath"]
            }
          };
        });


      });
    }catch(exception){
      Future.delayed(Duration(seconds: 1)).then((value) {
        pr.hide();
        setState(() {
          print("object ??"+exception.toString());
          pr.hide().then((isHidden) {
            print(isHidden);
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return   AlertDialog(
                title: null,
                content: Text("يرجي التاكد من الاتصال بل النترنت"),
                actions: [
//            okButton,
                ],
              );
            },
          );
//            Navigator.pop(context, true);
        });
      });

    }
  }











  @override
  Widget build(BuildContext context) {
    return
      Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Color(0xffffffff),

            appBar: AppBar(title: Text("الرئيسية",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Color(0xffffffff),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                )
            ),
              backgroundColor: Color(0xff212660),

              actions: <Widget>[
                IconButton(
                  icon:  Image.asset('assets/notif.png',),
                  tooltip: 'Show Snackbar',
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => Notofication()),);
//                scaffoldKey.currentState.showSnackBar(snackBar);
                  },
                ),
              ],
            ),

            drawer: Container(
                width: MediaQuery.of(context).size.width* 0.95 ,
                child: drwable()
            ),

//            drawer: drwable(),

            body:
            _All==null?HomeWiting1()
            :
            RefreshIndicator(
              onRefresh: getRefrich,
              color: Colors.white,
              backgroundColor: Colors.black,
              child:Directionality(textDirection: TextDirection.rtl,
              child: Padding(padding: EdgeInsets.only(left: 0, right: 0),
                  child:
                  CustomScrollView(

                    slivers: <Widget>[

                      SerachAppBar(),

//                      textUP_new_listitem(),
                      //new list
//                      Offer(),

//                      textUP_listitem(),
                      //list item


                   test_code_list=="0"?HomeWiting1():
                      listItem(),



                    ],

//                    shrinkWrap: true,


                  )
              ),
            ),
          ),


            bottomNavigationBar:bottomNavigationBarDesigin(),
          )
      );
  }


  Widget drwable(){

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color(0xff212660), //This will change the drawer background to blue.
          //other styles
        ),
//          child: Align(
//            alignment: FractionalOffset.topRight,
        child:
        Drawer(
          child: ListView(
//            reverse: true,
//            shrinkWrap: true,
          scrollDirection: Axis.vertical,
//            physics: FixedExtentScrollPhysics(),
            padding: EdgeInsets.zero,
            children: <Widget>[
              // Drawer items go in here

              retoken_user==1?
              SizedBox(height: 100,)
                  :
              data_user_map==null?
              SizedBox(height: 100,)
                  :
              data_user_map.isEmpty?
              SizedBox(height: 100,)
                  :
          InkWell(
            onTap: ()=>{
              diloge_uplodeImage()
              },

              child:Container(
//                  width: 328,
                  height: 167,
                  padding: EdgeInsets.all(11),
                  margin: EdgeInsets.only(left: 18,right: 18,top: 35,bottom: 18),
                  decoration: new BoxDecoration(
                    color: Color(0x24a6a8bf),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [BoxShadow(
                        color: Color(0x29000000),
                        offset: Offset(0,3),
                        blurRadius: 6,
                        spreadRadius: 0
                    ) ],
                  ),

                child: Column(
                  children: [

                    // image , name  , phone
                    Row(
                      children: [

                        Container(
                          height: 50, width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image:
                              // data_user_map["resultData"]["profileImagePath"]!=null?
                              NetworkImage(
                                  data_user_map["resultData"]["profileImagePath"]??""
                              )
                              //     :
                              // AssetImage(
                              //   'assets/iii.png',
                              // )
                              ,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(right: 11),
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  data_user_map["resultData"]["fullName"]!=null?data_user_map["resultData"]["fullName"].toString()
                                  : ""
                                  ,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    color: Color(0xffffffff),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  )
                              ),
                              Text(
                                  data_user_map["resultData"]["phoneNumber"]!=null?data_user_map["resultData"]["phoneNumber"].toString()
                                      : ""
                                  ,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    color: Color(0xffffffff),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  )
                              ),
                            ],
                          ) ,
                        ),

                      ],
                    ),


                    //مشتري مميز

                    SizedBox(
                      width: 14,
                      height: 18,
                    ),

                    Row(
                      children: [
                        Container(
                          height: 25,
                          width: 25,
//                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/new.png', width: 25.0,
                                height: 25.0,
//                                color: Color(0xff212660),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          width: 14,
                        ),

                        new Text("مشتري مميز",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: Color(0xffffffff),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            )
                        ),
                      ],
                    ),


//                    orderTotal , orderTotal_price
                    Directionality(
                      textDirection: TextDirection.ltr,
//                      color: Colors.black,
                      child:  Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //orderTotal

                          Column(
//                          crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(data_user_map["resultData"]["totalOrderPrice"]!=null?data_user_map["resultData"]["totalOrderPrice"].toString()
                                  : "0",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              Text('اجمالي الطلبات',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 33,
                          ),

                          Column(
//                          crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(data_user_map["resultData"]["orderTotal"]!=null?data_user_map["resultData"]["orderTotal"].toString()
                                  : "0",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              Text('  عدد الطلبات',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          //totalOrderPrice

                        ],
                      ),
                    ),



                  ],

                ),
              )),

              Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
//                    verticalDirection: VerticalDirection.up,
                    children: [
                      //    تعديل الملف الشخصي
                      ListTile(
                        leading: Icon(Icons.person_outline,color: Colors.white,),
                        title: Transform(
                            transform: Matrix4.translationValues(25, 0.0, 0.0),
                            child:Text('تعديل الملف الشخصي',
                            style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                        )
                        ),
                        onTap: () => {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => UpdateProfile(id: data_user_map["resultData"]["id"].toString() ,
                              address: data_user_map["resultData"]["address"].toString(),fullName: data_user_map["resultData"]["fullName"].toString(),
                              phoneNumber: data_user_map["resultData"]["phoneNumber"].toString(),
                          )))
                        },
                      ),


                      //  تغيير كلمة السر
                      ListTile(
                          leading: Icon(Icons.lock_open,color: Colors.white,textDirection: TextDirection.rtl,),
                          title: Transform(
                            transform: Matrix4.translationValues(25, 0.0, 0.0),
                            child: Text('تغيير كلمة السر',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w600,
                            ),
                          )
                          ),
                          onTap: () =>
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => ChangePassword(id_user: data_user_map["resultData"]["id"].toString() ,)))
                      ),




                      //  أرشيف الطلبات
                      ListTile(

//                        leading:
                        leading: SizedBox(
                          height: 24.0,
                          width: 24.0, // fixed width and height
                          child: Image.asset('assets/draftorder.png', )
                      ),//Image.asset('assets/draftorder.png', ),
//                        leading: Icon(Icons.reorder,color: Colors.white,),
                        title:  Transform(
    transform: Matrix4.translationValues(25, 0.0, 0.0),
    child:Text('أرشيف الطلبات',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                        )
                        ),
                        onTap: () => {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => All_Order_Finsh()))
                        },
                      ),



                      //          المفضلة
                      ListTile(
                        leading: Icon(Icons.favorite_border,color: Colors.white,),
                        title:  Transform(
    transform: Matrix4.translationValues(25, 0.0, 0.0),
    child:Text('المفضلة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                        )
                        ),
                        onTap: () =>
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => Favorite())),
                      ),

                      //من نحن
                      ListTile(
                        leading: SizedBox(
                            height: 24.0,
                            width: 24.0, // fixed width and height
                            child: Image.asset('assets/we.png', )
                        ),
//                leading: Icon(Icons.favorite_border,color: Colors.white,),
                        title:  Transform(
    transform: Matrix4.translationValues(25, 0.0, 0.0),
    child:Text('من نحن',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                        )
                        ),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUs()))
                        ,
                      ),
                      //اتصل بنا
                      ListTile(
                        leading: Icon(Icons.add_call,color:Colors.white,),
                        title:  Transform(
    transform: Matrix4.translationValues(25, 0.0, 0.0),
    child:Text('اتصل بنا',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                        )
                        ),
                        onTap: () =>
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => CinnectUs())),
                      ),


                      //تسجيل خروج
                      ListTile(
                        onTap: ()=>{
                          exitApp(),
                        },
                        leading: Icon(Icons.exit_to_app,color:Colors.white,),
                        title:  Transform(
                        transform: Matrix4.translationValues(25, 0.0, 0.0),
                        child:Text('تسجيل خروج',
                                    style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                        )
                        ),
//                onTap: () =>
//                    Navigator.push(
//                        context, MaterialPageRoute(builder: (context) => CinnectUs())),
                      ),
                      //>>> face book


                      SizedBox(height: 60,),


                      Center(
                        child: Text("Wellbond",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      Center(
                        child: Text("نسخة رقم 1.0",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: Color(0xffffffff),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                            )
                        ),
                      )
                    ],
                  ),

            ],
          ),
        ),
//          )


      ),
    );
  }






  diloge_uplodeImage(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return   AlertDialog(
          title: null,
          content: Text("هل تريد تغير صور البروفيل الخاص بك ",textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
//                      color: Color(0xffffffff),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              )
          ),
          actions: [
//            okButton,
            OutlineButton(
              onPressed: ()=>Navigator.pop(context),
              child: Text("الغاء "),
            ),

            OutlineButton(
              onPressed: () async => {

                Navigator.pop(context),
//                 file = await ImagePicker.pickImage(
//                     source: ImageSource.gallery),
//                 setState(() async {
//                   var res = await uploadImage(file.path);
// //                var res = await uploadImage(file.path);
//                   setState(() {
//                     print(res);
//                   });
//                 }),

              },
              child: Text("موافق "),
            ),

          ],
        );
      },
    );
  }

  File? file;

  Future<String> uploadImage(filename) async {


    ProgressDialog  pr = new ProgressDialog(context);
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.show();
    print("start upload ");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final headers1 = {'Content-Type': 'application/json',"Accept":"application/json","Authorization":"$token"};

    Map<String, String> headers = {"Authorization":"$token"};
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(
        URL_LOGIC.uplodeImage+"image.jpg",
      ),
    );
    //add text fields

    request.headers["Authorization"]=token!;

//    request.fields["type"] = type;
//    request.fields["note"] = note;
//    for (var item in filename) {
    var ext = filename.split('.').last;
    var pic = await http.MultipartFile.fromPath("file", filename, contentType: MediaType('image', ext));
    request.files.add(pic);
//    }

    //add multipart to request

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    var d = jsonDecode(responseString);
//    JSON.decode(response.body);
//   var c= json.decode(utf8.decode(responseByteArray));
    Map dd= jsonDecode(responseString);
    if(dd["errorStatus"].toString()=="false"){
      Future.delayed(Duration(seconds: 1)).then((value) async {
        pr.hide();
//        _All.clear();
//        data_offer.clear();
        data_user_map.clear();;
//        data_user_list.clear();;
        getDatauser("");
      });
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return   AlertDialog(
            title: null,
            content: Text("لقد حدث خطا في تحميل الصوره",textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
//                      color: Color(0xffffffff),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                )
            ),
            actions: [
//            okButton,
            ],
          );
        },
      );
    }

    return  d.toString();

//    var uri = Uri.parse("http://pub.dartlang.org/packages/create");
//    var request = new http.MultipartRequest("POST", uri);
//    request.fields['user'] = 'nweiz@google.com';
//    request.files.add(new http.MultipartFile.fromFile(
//        'package',
//        new File('build/package.tar.gz'),
//        contentType: MediaType('application', 'x-tar')));
//        request.send().then((response) {
//      if (response.statusCode == 200) print("Uploaded!");
//    });

//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    //Return String
//    String token = prefs.getString('token');
//
//    var request = http.MultipartRequest(
//      "POST",
//      Uri.parse(
//        URL_LOGIC.uplodeImage,
//      ),
//    );
//    Map<String, String> headers = {
//      'Content-Type': 'multipart/form-data',
//      'token': token
//    };
//    request.headers['token'] = token;
//    request.headers["Content-Type"]='multipart/form-data';
//    request.fields["name"] = "hardik";
//
//    request.fields["email"] = "h@gmail.com";
//    request.fields["mobile"] = "00000000";
//    request.fields["address"] = "afa";
//    request.fields["city"] = "fsf";
//
//    if (filename != null) {
////      print(filename.path.split(".").last);
//      request.files.add(
//        http.MultipartFile.fromBytes(
//
//          "avatar",
//          filename.readAsBytesSync(),
//          filename: "test.${filename.path.split(".").last}",
//          contentType:
//          MediaType("image", "${filename.path.split(".").last}",headers),
//        ),
//      );
//    }
//    request.fields["reminder_interval"] = "1";
//
//    request.send().then((onValue) {
//      print(onValue.statusCode);
//
//      print(onValue.headers);
//      print(onValue.contentLength);
//    });

//    var request = http.MultipartRequest('POST', Uri.parse(URL_LOGIC.uplodeImage),);
//    request.files.add(await http.MultipartFile.fromPath('picture', filename));
//    var res = await request.send();
//    print("?>>>>>>"+res.toString());
//    return res.reasonPhrase;
  }
















  Widget SerachAppBar() {
    return SliverList(
        delegate: SliverChildListDelegate([


          InkWell(
            onTap: () =>
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SerchHome()),),
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              color: Color(0xff212660),
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 13.0, right: 13.0, top: 5, bottom: 9),
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(
                            width: 1.0,
                            color: Colors.grey.shade300
                        )
                    ),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child:

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(Icons.search, color: Color(0xff4f008d),),
                          Text("ابحث",
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16.0
                            ),),
                        ],
                      ),
                    ),
                  )
              ),
            ),
          )

        ]
        )
    );
  }

  Widget textUP_listitem() {
    return SliverList(
        delegate: SliverChildListDelegate([

          Padding(
            padding: EdgeInsets.all(19),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: InkWell(

                onTap: ()=>  Navigator.push(context,MaterialPageRoute(builder: (context) => Listitem()),),

                child:
                Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(5),
                      child: Text("ألواح ألومنيوم مركبة",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Color(0xff000000),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          )
                      ),
                    ),

                    Expanded(child:
                    Directionality(
                        textDirection: TextDirection.ltr,
                        child: Column(
                          children: <Widget>[
                            Container(
                                child:Row(
                                  children: <Widget>[
                                    Text("عرض المزيد",
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      color: Color(0xff000000),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                )
                            ),

                          ],
                        )
                    )
                    )


                  ],
                ),
              ),
            ),),

        ]
        )
    )
    ;
  }


  Widget listItem(){
    return SliverList(
      delegate: SliverChildListDelegate([
          Container(
            // height: 500,
            child:ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: [

                // text وصل حديثا
                retoken_new == 1 ? Text(""):
                userData_offer_new == null ? Text(""):
                userData_offer_new?[0]["id"] == null ? Text("") :
                Padding(
                  padding: EdgeInsets.all(19),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: InkWell(

                      onTap: ()=>  Navigator.push(context,MaterialPageRoute(builder: (context) => ListNewItem()),),

                      child:Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(5),
                            child: Text("وصل حديثاً",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: Color(0xff000000),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                )
                            ),
                          ),

                          Expanded(child:
                          Directionality(
                              textDirection: TextDirection.ltr,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      child:Row(
                                        children: <Widget>[
                                          Text("عرض المزيد",
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              color: Color(0xff000000),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      )
                                  ),

                                ],
                              )
                          )
                          )


                        ],
                      ),
                    ),
                  ),),


                //list_/وصل حديثا
                retoken_new == 1 ? Text(""):
                userData_offer_new == null ? Text(""):
                userData_offer_new?[0]["id"] == null ? Text(""):
                Container(
                  height: 180,
                  width: 100,
                  padding: EdgeInsets.only(right: 15, left: 15),
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: new
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: userData_offer_new == null ? 0 : userData_offer_new!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return

                        InkWell(
                          onTap: () =>
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Item_details(
                                            id_item: "${userData_offer_new?[index]["id"]??""}",))
                              ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(10),
                                  topRight: Radius.circular(20)
                              ),

//                      side: BorderSide(width: 5, color: Colors.white)
                            ),
                            margin: EdgeInsets.all(12),
                            elevation: 4,
                            child:
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child:
//                           Wrap(
//                             children: <Widget>[

                              Directionality(
                                textDirection: TextDirection.ltr,
                                child:
                                Stack(
                                  children: <Widget>[

                                    Directionality(
                                        textDirection: TextDirection.rtl,
                                        child:Padding(padding: EdgeInsets.only(left: 0,right: 0),
                                          child:  Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[

                                              //Image offer
                                              Padding(padding: EdgeInsets.only(top: 5 ,),
                                                child: Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration: new BoxDecoration(
                                                      color: Color(0xffebebeb),
                                                      borderRadius: BorderRadius.circular(8)
                                                  ),

                                                  child:userData_offer_new?[index]["colorLookup"]["documentImagePath"]!=null? Container(
                                                    height: 59,
                                                    width: 59,
                                                    margin: EdgeInsets.all(11),
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: CachedNetworkImageProvider(
                                                          "${userData_offer_new?[index]["colorLookup"]["documentImagePath"]??""}",
                                                        ),
//                                                              NetworkImage(
//                                                                  _All[index]["colorLookup"]["documentImagePath"]
//                                                              ),
                                                        fit: BoxFit.cover,
                                                      ),
//                                                     color: Color(int.parse("0xff${userData_offer_new[index]['colorLookup']['colorValue']}")),
                                                      borderRadius: BorderRadius.circular(2),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Color(0x26000000),
                                                          offset: Offset(0, 3),
                                                          blurRadius: 6,
                                                          spreadRadius: 0,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                  :
                                                 Container(
                                                   height: 59,
                                                   width: 59,
                                                   margin: EdgeInsets.all(11),
                                                   decoration: BoxDecoration(
                                                     color: Color(int.parse("0xff${userData_offer_new?[index]['colorLookup']['colorValue']??"000000"}")),
                                                     borderRadius: BorderRadius.circular(2),
                                                     boxShadow: [
                                                       BoxShadow(
                                                         color: Color(0x26000000),
                                                         offset: Offset(0, 3),
                                                         blurRadius: 6,
                                                         spreadRadius: 0,
                                                       ),
                                                     ],
                                                   ),
                                                 ),


                                                ),
                                              ),
                                              Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15,
                                                        right: 15,
                                                        top: 7),
                                                    child:Container(
                                                      width: 100,
                                                      child:  Column(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .center,
                                                        mainAxisSize: MainAxisSize
                                                            .min,
                                                        children: [
                                                          Expanded(
                                                              flex: 1,
                                                              child:
                                                              Text(
                                                                userData_offer_new?[index]['colorLookup']['description']??"",
                                                                style: TextStyle(
                                                                  fontFamily: 'Cairo',
                                                                  color: Color(0xff000000),
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontStyle: FontStyle.normal,
                                                                ),
                                                                textAlign: TextAlign.center,
                                                              )
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                              ),

                                              Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15,
                                                        right: 15,
                                                        top: 7),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      mainAxisSize: MainAxisSize
                                                          .min,
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child:
                                                            Text(userData_offer_new?[index]['colorLookup']['colorDescEn']??"",
                                                                style: TextStyle(
                                                                  fontFamily: 'Cairo',
                                                                  color: Color(0xff000000),
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontStyle: FontStyle.normal,
                                                                )
                                                            )
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                              ),

                                            ],
                                          ),
                                        )

                                    ),

                                  ],
                                ),
                              ),
//                             ],
//                           )
                            ),
                          ),
                        );
                    },
                  ),



                ),




                //<>>>>>>>>>>>>>>>>><>>>>>>>>>>>>>>>>><>>>>>>>>>>>>>>>>><>>>>>>>>>>>>>>>>>

                //ألواح ألومنيوم مركبة
                retoken_list == 1 ? Text(""):
                _All == null ? Text(""):
                Padding(
                  padding: EdgeInsets.all(19),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: InkWell(

                      onTap: ()=>  Navigator.push(context,MaterialPageRoute(builder: (context) => Listitem()),),

                      child:
                      Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(5),
                            child: Text("ألواح ألومنيوم مركبة",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: Color(0xff000000),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                )
                            ),
                          ),

                          Expanded(child:
                          Directionality(
                              textDirection: TextDirection.ltr,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      child:Row(
                                        children: <Widget>[
                                          Text("عرض المزيد",
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              color: Color(0xff000000),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      )
                                  ),

                                ],
                              )
                          )
                          )


                        ],
                      ),
                    ),
                  ),),


                //<>>>>>>>>>>>>>>>>><>>>>>>>>>>>>>>>>><>>>>>>>>>>>>>>>>><>>>>>>>>>>>>>>>>>
                //ألواح ألومنيوم مركبة list
                retoken_list == 1 ? Text(""):
                _All == null ? Text(""):
                new GridView.builder(
                  shrinkWrap: true,
              physics: ScrollPhysics(),
                  padding: EdgeInsets.only(
                    top: 5.0,
                  ),
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:0.70
                  ),
                  controller: controller,
                  itemCount: _All == null ? 0 : _All
                      .length,
//                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    return
                      Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(20)
                            ),

//                      side: BorderSide(width: 5, color: Colors.white)
                          ),
                          margin: EdgeInsets.all(12),
                          elevation: 4,
                          child:
                          Container(
                            width: MediaQuery.of(context).size.width/2,
//                          height: 220,
                            child: Center(
                              child:
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child:
//                            Wrap(
//                              children: <Widget>[

                                Stack(
                                  children: <Widget>[

                                    Container(

                                      child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: InkWell(
                                              onTap: () =>
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Item_details(
                                                                id_item: _All[index]["id"].toString(),))
                                                  ),
                                              child: Column(
                                                children: <Widget>[

                                                  // icon favorit and code
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    mainAxisSize: MainAxisSize
                                                        .min,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [

                                                      Expanded(
                                                        flex: 1,
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child:      Container(
                                                              padding: EdgeInsets.all(6),
                                                              decoration: new BoxDecoration(
                                                                  color: Color(0xffebebeb),
                                                                  borderRadius: BorderRadius.circular(1)
                                                              ),

                                                              child: FittedBox(
                                                                fit: BoxFit.fill,
                                                                child:
                                                                Text(
                                                                  _All[index]["itemCode"].toString(),
                                                                  style: TextStyle(
                                                                    fontFamily: 'Cairo',
                                                                    color: Color(0xff000000),
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontStyle: FontStyle.normal,
                                                                  ),
                                                                  textAlign: TextAlign.left,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 1,
                                                                ),
                                                              )
                                                          ),

                                                        ),

                                                      ),

                                                      Expanded(
                                                        flex: 1,
                                                        child:Align(
                                                          alignment: Alignment.centerLeft,
                                                          child:  Row(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .end,
                                                            mainAxisSize: MainAxisSize
                                                                .min,
                                                            children: [
                                                              Container(
                                                                padding: EdgeInsets.all(11),
//                                                            decoration: new BoxDecoration(
//                                                                color: Color(0xffebebeb),
//                                                                borderRadius: BorderRadius.circular(1)
//                                                            ),
                                                                child:InkWell(
                                                                  onTap: ()=> {
                                                                    _All[index]["itemFavFlag"]==0 ? _sendItemData_favorite(_All[index]["id"] , _All[index],index) :

                                                                    _sendItemData_unfavorite(_All[index]["id"], _All[index], index)
                                                                  },

                                                                  child: _All[index]["itemFavFlag"]==0 ? Icon(Icons.favorite_border,size: 25,): Icon(Icons.favorite,color: Color(0xffc59400),),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
//                                                  Image(image: CachedNetworkImageProvider(url)),
                                                  //_All[index]["itemCode"]
                                                  Padding(padding: EdgeInsets.only(top: 5 ,),
                                                    child: Container(
                                                      width: 80,
                                                      height: 80,
                                                      decoration: new BoxDecoration(
                                                          color: Color(0xffebebeb),
                                                          borderRadius: BorderRadius.circular(8)
                                                      ),

                                                      child:_All[index]["colorLookup"]["documentImagePath"]!=null? Container(
                                                        height: 59,
                                                        width: 59,
                                                        margin: EdgeInsets.all(11),
                                                        decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: CachedNetworkImageProvider(
                                                                "${_All[index]["colorLookup"]["documentImagePath"]}",
                                                              ),
//                                                              NetworkImage(
//                                                                  _All[index]["colorLookup"]["documentImagePath"]
//                                                              ),
                                                            fit: BoxFit.cover,
                                                          ),
//                                                     color: Color(int.parse("0xff${userData_offer_new[index]['colorLookup']['colorValue']}")),
                                                          borderRadius: BorderRadius.circular(2),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Color(0x26000000),
                                                              offset: Offset(0, 3),
                                                              blurRadius: 6,
                                                              spreadRadius: 0,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                          : Container(
                                                        height: 59,
                                                        width: 59,
                                                        margin: EdgeInsets.all(11),
                                                        decoration: BoxDecoration(

                                                          color: Color(int.parse("0xff${_All[index]['colorLookup']['colorValue']}")),
//                                                        color: Color(0xff+ int.parse(_All[index]["colorLookup"]["colorValue"], radix: 16)),
//                                                        color: Hexcolor("#"+_All[index]["colorLookup"]["colorValue"]),
                                                          borderRadius: BorderRadius.circular(2),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Color(int.parse("0xff${_All[index]['colorLookup']['colorValue']}")),
//                                                            color: Color(0xff+ int.parse(_All[index]["colorLookup"]["colorValue"], radix: 16)),
                                                              offset: Offset(0, 1),
                                                              blurRadius: 1,
                                                              spreadRadius: 0,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),



                                                  Expanded(
                                                      flex: 3,
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                            left: 15,
                                                            right: 15,
                                                            top: 7),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          mainAxisSize: MainAxisSize
                                                              .min,
                                                          children: [
                                                            Expanded(
                                                                flex: 1,
                                                                child:
                                                                Text(_All[index]['itemDescription'].toString(),
                                                                    style: TextStyle(
                                                                      fontFamily: 'Cairo',
                                                                      color: Color(0xff000000),
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w600,
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                  overflow: TextOverflow.ellipsis,
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                  ),
                                                  Expanded(
                                                      flex: 3,
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                            left: 15,
                                                            right: 15,
                                                            top: 7),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          mainAxisSize: MainAxisSize
                                                              .min,
                                                          children: [
                                                            Expanded(
                                                                flex: 1,
                                                                child:
                                                                Text(_All[index]['colorLookup']['colorDescEn'].toString(),
                                                                  style: TextStyle(
                                                                    fontFamily: 'Cairo',
                                                                    color: Color(0xff000000),
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontStyle: FontStyle.normal,
                                                                  ),
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                  ),
                                                  Expanded(
                                                      flex: 3,
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                            left: 15,
                                                            right: 15,
                                                            top: 7),
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          mainAxisSize: MainAxisSize
                                                              .min,
                                                          children: [

//

//                                                          Expanded(
//                                                              flex: 1,
//                                                              child:


                                                            Text(_All[index]['itemPricePerMetter'].toString(),
                                                                style: TextStyle(
                                                                  fontFamily: 'Cairo',
                                                                  color: Color(0xff000000),
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w700,
                                                                  fontStyle: FontStyle.normal,
                                                                ),
                                                              overflow: TextOverflow.ellipsis,
                                                            ),

                                                            SizedBox(width: 5,),

                                                            Text("ج.م/م2",
                                                                style: TextStyle(
                                                                  fontFamily: 'Cairo',
                                                                  color: Color(0xff000000),
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w700,
                                                                  fontStyle: FontStyle.normal,


                                                                ),
                                                              overflow: TextOverflow.ellipsis,
                                                            )
//                                                          ),
                                                          ],
                                                        ),
                                                      )
                                                  ),

                                                ],
                                              )
                                          )
                                      ),
                                    ),

                                  ],
                                ),

//                              ],
//                            )
                              ),
                            ),
                          )
                      );
                  },
                ),


                SizedBox(height: 30,)
              ],
            )

          )
          ]
        )
    );
  }

//وصل حديثا
  Widget textUP_new_listitem() {
    return SliverList(
        delegate: SliverChildListDelegate([

          Padding(
            padding: EdgeInsets.all(19),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: InkWell(

                onTap: ()=>  Navigator.push(context,MaterialPageRoute(builder: (context) => ListNewItem()),),

                child:Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(5),
                      child: Text("وصل حديثاً",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Color(0xff000000),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          )
                      ),
                    ),

                    Expanded(child:
                    Directionality(
                        textDirection: TextDirection.ltr,
                        child: Column(
                          children: <Widget>[
                            Container(
                                child:Row(
                                  children: <Widget>[
                                    Text("عرض المزيد",
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        color: Color(0xff000000),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                )
                            ),

                          ],
                        )
                    )
                    )


                  ],
                ),
              ),
            ),),

        ]
        )
    )
    ;
  }

//وصل حديثا
  Widget Offer() {
    return
      SliverList(
        delegate: SliverChildListDelegate([

            new Container(
              height: 180,
              width: 100,
              padding: EdgeInsets.only(right: 15, left: 15),
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: new
                  ListView.builder(

                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: userData_offer_new == null ? 0 : userData_offer_new!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return

                        InkWell(
//                      onTap: ()=>print(userData_offer_new[index]['id'].toString()),
                          onTap: () =>
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Item_details(
                                            id_item: userData_offer_new?[index]["id"]??"",))
                              ),
//                      onTap: ()=>  Navigator.push(context,MaterialPageRoute(builder: (context) =>
//                      ListNewItem(),)),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(10),
                                  topRight: Radius.circular(20)
                              ),

//                      side: BorderSide(width: 5, color: Colors.white)
                            ),
                            margin: EdgeInsets.all(12),
                            elevation: 4,
                            child:
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child:
//                           Wrap(
//                             children: <Widget>[

                              Directionality(
                                textDirection: TextDirection.ltr,
                                child:
                                Stack(
                                  children: <Widget>[

                                    Directionality(
                                        textDirection: TextDirection.rtl,
                                        child:Padding(padding: EdgeInsets.only(left: 0,right: 0),
                                          child:  Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[

                                              //Image offer
                                              Padding(padding: EdgeInsets.only(top: 5 ,),
                                                child: Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration: new BoxDecoration(
                                                      color: Color(0xffebebeb),
                                                      borderRadius: BorderRadius.circular(8)
                                                  ),

                                                  child:
                                                  Container(
                                                    height: 59,
                                                    width: 59,
                                                    margin: EdgeInsets.all(11),
                                                    decoration: BoxDecoration(
//                                                  color: Hexcolor("#"+userData_offer_new[index]['colorLookup']['colorValue']),
//                                                  color: Color(0xff+userData_offer_new[index]['colorLookup']['colorValue']),
                                                      color: Color(int.parse("0xff${userData_offer_new?[index]['colorLookup']['colorValue']??"000000"}")),
                                                      borderRadius: BorderRadius.circular(2),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Color(0x26000000),
                                                          offset: Offset(0, 3),
                                                          blurRadius: 6,
                                                          spreadRadius: 0,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15,
                                                        right: 15,
                                                        top: 7),
                                                    child:Container(
                                                      width: 100,
                                                      child:  Column(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .center,
                                                        mainAxisSize: MainAxisSize
                                                            .min,
                                                        children: [
                                                          Expanded(
                                                              flex: 1,
                                                              child:
                                                              Text(
                                                                 userData_offer_new?[index]['colorLookup']['description']??"",
                                                                style: TextStyle(
                                                                  fontFamily: 'Cairo',
                                                                  color: Color(0xff000000),
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontStyle: FontStyle.normal,
                                                                ),
                                                                textAlign: TextAlign.center,
                                                                overflow: TextOverflow.ellipsis,
                                                              )
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                              ),
                                              Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15,
                                                        right: 15,
                                                        top: 7),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      mainAxisSize: MainAxisSize
                                                          .min,
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child:
                                                            Text(userData_offer_new?[index]['colorLookup']['colorDescEn']??"",
                                                                style: TextStyle(
                                                                  fontFamily: 'Cairo',
                                                                  color: Color(0xff000000),
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontStyle: FontStyle.normal,
                                                                ),
                                                              overflow: TextOverflow.ellipsis,
                                                            )
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                              ),

                                            ],
                                          ),
                                        )

                                    ),

                                  ],
                                ),
                              ),
//                             ],
//                           )
                            ),
                          ),
                        );
                    },
                  ),



            ),

        ],
        ),

      );
  }


  Widget bottomNavigationBarDesigin(){
    int currentTab = 0;
    return  BottomAppBar(
      shape: CircularNotchedRectangle(),
//      notchMargin: 10,
      child: Container(
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            //home
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//                      Icon(
//                        Icons.dashboard,
////                        color: currentTab == 2 ? Colors.blue : Colors.grey,
//                      ),
//
//                Icon(Icons.home, color: Color(0xff999999),),
                IconButton(icon:  Icon(Icons.home, color: Color(0xff212660),), onPressed:()=>
                {

//                  Navigator.pop(context),
//                 Navigator.push(context,MaterialPageRoute(builder: (context) => Home())),
                }
                ),
//                      'قريب مني'
                Text(
                  'الرئيسية',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xff000000),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    )
                ),
              ],
            ),
              flex: 1,
            ),


            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//                      Icon(
//                        Icons.dashboard,
////                        color: currentTab == 2 ? Colors.blue : Colors.grey,
//                      ),
//
                IconButton(icon:  Icon(Icons.add_shopping_cart, color: Color(0xff999999),),
                    onPressed:()=> Navigator.push(context,MaterialPageRoute(builder: (context) => Cart()),),
                ),
//                      'قريب مني'
                Text(
                  'السله',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xff000000),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    )
                ),
              ],
            ),
            flex: 1,
            ),





            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            IconButton(icon:  Icon(Icons.border_all, color: Color(0xff999999),),
                onPressed:()=> Navigator.push(context,MaterialPageRoute(builder: (context) => TrackOrder()),)),
//                      'قريب مني'
                Text(
                  'الطلبات',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xff000000),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    )
                ),
              ],
            ),
              flex: 1,
            ),

//

          ],
        ),
      ),
    );
  }

  exitApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String reToken = prefs.getString('reToken');
    prefs.clear();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => Login()));
//    SystemNavigator.pop();
  }
}



//class SideDrawer extends StatelessWidget {
//  const SideDrawer({Key key, this.user}) : super(key: key);
//  final String user;
//
//  @override
//  Widget build(BuildContext context) {
//    return new SizedBox(
//      width: MediaQuery.of(context).size.width * 0.85,
//      child: Drawer(
//          child: new ListView(
//            children: <Widget>[
//              new DrawerHeader(
//                child: new Text("DRAWER HEADER.."),
//                decoration: new BoxDecoration(color: Colors.orange),
//              ),
//              new ListTile(
//                title: new Text("Item => 1"),
//                onTap: () {
//                  Navigator.pop(context);
////                  Navigator.push(context,
////                      new MaterialPageRoute(builder: (context) => new HomePage()));
//                },
//              ),
//            ],
//          )),
//    );
//  }
//}
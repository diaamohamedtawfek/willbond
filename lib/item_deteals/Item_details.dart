import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:willbond/DatabaseHelper/DatabaseHelperFinal.dart';
import 'package:willbond/homeWite.dart';

import '../URL_LOGIC.dart';


import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Item_details extends StatefulWidget{

//  Item_details({Key key, this.id_item}) : super(key: key);
  Item_details( {Key? key, this.id_item,}) : super(key: key);
  String? id_item;

  @override
  UIItem_details createState() => UIItem_details(id_item:id_item!);

}







class UIItem_details extends State<Item_details>{
  int _languageIndex = -1;
  int _languageIndex_FireResistanceDegree = -1;


  var itemThicknessList=null;
  var id_itemThicknessList=null;

  var itemFireResistanceDegreeList=null;
  var id_itemFireResistanceDegreeList=null;


  int numOfItems = 1;
//  UIItem_details(String id_item, {String id_item});
  UIItem_details( {this.id_item,});

  String ?id_item;


  Future getRefrich() async {
    getData("");
    await Future.delayed(Duration(seconds: 1));
  }

  ScrollController? controller;
//  List _All = <Object>[];
//  List<Map<String, dynamic>> arrayOfProductList = List<Map<String, dynamic>>();
  final _saved = new Set<Object>();
  bool isLoading = false;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  int numpage = 0;
  int totalRow=0;
  int test=0;



  @override
  void initState() {
    super.initState();
    getData("");
    controller = new ScrollController()
      ..addListener(_scrollListener);


    Icon actionIcon = new Icon(Icons.search, color: Colors.white,);
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  void _scrollListener() {
    if (controller?.position.pixels == controller?.position.maxScrollExtent) {
      if(numpage<test+1) {
        isLoading=true;
        startLoader();
//        startLoader();
      }else{
        setState(() {
//          isLoading=false;
//          isLoading = !isLoading;
        });
      }
    }
  }

  void startLoader() {
    setState(() {
//      fetchData();
      getData("");
    });
  }

  Map data_offer={};
  List userData_find_item=[];


  Future<Map<String, dynamic>?> getData(var search) async {

    setState(() {
      isLoading=true;
      _loader();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? token = prefs.getString('token');

    print(URL_LOGIC.find_by_id+"${id_item}");
    isLoading = true;
    setState(() {
      isLoading = true;
//      data_offer.clear();
//      _All.clear();
    });
    Map<String, String> timeOutMessage = {
      'state': 'timeout',
      'content': 'server is not responding'
    };

    print(URL_LOGIC.find_by_id+"${id_item}");
    // offer
//    final headers = {'Content-Type': 'application/json',"Accept":"application/json"};
    http.Response response_offer = await http.get(
//      URL_LOGIC.find_by_id+"2",
        Uri.parse(URL_LOGIC.find_by_id+"${id_item}"),
      headers: {"Authorization":"$token"},
    )
        .timeout(Duration(seconds: 90), onTimeout: () {
      return Future.value(http.Response(json.encode(timeOutMessage), 500));
    }).catchError((err) {
      // nothing
    });

      print(response_offer.body);
    data_offer = json.decode(response_offer.body);
//    userData_offer = data_offer["bestseller"];
        ;

    setState(() {
      if(data_offer["status"]==null){
      data_offer = json.decode(response_offer.body);
      print(">>>>>>>${data_offer}");
//      print(">>>>>>>${data_offer["resultData"]}");
      numpage++;
      }else  if(data_offer["status"].toString()=="401") {
        print(">>>>>>>+++++++++++++++++++>>>>>>>>>>>?????????????");
        setState(() {
//          retoken_list=1;
        });
        refrech_token();
        return;
      }
    });

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
    final headers = {'Content-Type': 'application/json',"Authorization":"$token"};
    final response = await http.post(Uri.parse(URL_LOGIC.refrechToken),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    var datauserxx = json.decode(response.body);
    debugPrint(datauserxx.toString());


    Future.delayed(Duration(seconds: 3)).then((value)  {
      setState(()  async {
        if(datauserxx["errorStatus"]==true || datauserxx["errorStatus"]=="true"){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return   AlertDialog(
                title: null,
                content: Text("${datauserxx["errorResponsePayloadList"][0]["arabicMessage"]}",textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
//                      color: Color(0xffffffff),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    )
                ),
              );
            },
          );
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
      });

    });


  }

  Future getRefrich_all() async {
    setState(() {
      getData("search");
    });
  }





  Future<List?> _sendItemData_favorite(int idItem) async {

    print("id item >>> $idItem");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String ?token = prefs.getString('token');

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
      var datauserfav = json.decode(response.body);
//      var code=datauser["code"];
//      var actions=datauser["action"];
      debugPrint(datauserfav.toString());


//      debugPrint("message >>> "+actions);

      Future.delayed(Duration(seconds: 1)).then((value) async {
        pr.hide();
        if(datauserfav["errorStatus"]==true){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return   AlertDialog(
                title: null,
                content: Text("${datauserfav["errorResponsePayloadList"][0]["arabicMessage"]}",textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xffffffff),
                      fontSize: 16,
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
        }else{
          Future.delayed(Duration(seconds: 1)).then((value) async {
            pr.hide();
            setState(() {
              data_offer = {
                "errorStatus": data_offer["errorStatus"],
                "resultData": {
                  "id": data_offer["resultData"]["id"],
                  "itemCode": data_offer["resultData"]["itemCode"],
                  "itemArea": data_offer["resultData"]["itemArea"],
                  "itemPricePerMetter": data_offer["resultData"]["itemPricePerMetter"],
                  "itemDescription": data_offer["resultData"]["itemDescription"],
                  "itemFavFlag": 1,

                  "colorLookup": {
                    "id": data_offer["resultData"]["colorLookup"]["id"],
                    "code": data_offer["resultData"]["colorLookup"]["code"],
                    "description": data_offer["resultData"]["colorLookup"]["description"],
                    "colorValue": data_offer["resultData"]["colorLookup"]["colorValue"],
                    "colorDescEn": data_offer["resultData"]["colorLookup"]["colorDescEn"],
                    "documentImagePath": data_offer["resultData"]["colorLookup"]["documentImagePath"]
                  },
                  "itemThicknessList": data_offer["resultData"]["itemThicknessList"],

                  "itemFireResistanceDegreeList": data_offer["resultData"]["itemFireResistanceDegreeList"]
                }
              };
            }
            );
            getRefrich();


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
                content: Text("يرجي التاكد من الاتصال بل النترنت",
                    style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Color(0xffffffff),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                )),
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

  Future<List?> _sendItemData_unfavorite(int idItem) async {

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
      print("url is :"+URL_LOGIC.Un_favorite+"$idItem");

//      final encoding = Encoding.getByName('utf-8');
//      String jsonBody = json.encode(body);
      final headers = {'Content-Type': 'application/json',"Authorization":"$token"};
      final response = await http.delete(Uri.parse(URL_LOGIC.Un_favorite+"$idItem"),
//        body:jsonBody,
//        encoding: encoding,
        headers: headers,
      );
      var datauser = json.decode(response.body);
//      var code=datauser["code"];
//      var actions=datauser["action"];
      debugPrint(datauser.toString());


//      debugPrint("message >>> "+actions);

      Future.delayed(Duration(seconds: 1)).then((value) async {
        pr.hide();
        setState(() {
          data_offer={
            "errorStatus": data_offer["errorStatus"],
            "resultData": {
              "id": data_offer["resultData"]["id"],
              "itemCode":data_offer["resultData"]["itemCode"],
              "itemArea":data_offer["resultData"]["itemArea"],
              "itemPricePerMetter": data_offer["resultData"]["itemPricePerMetter"],
              "itemDescription": data_offer["resultData"]["itemDescription"],
              "itemFavFlag": 0,

              "colorLookup": {
                "id": data_offer["resultData"]["colorLookup"]["id"],
                "code": data_offer["resultData"]["colorLookup"]["code"],
                "description":data_offer["resultData"]["colorLookup"]["description"],
                "colorValue": data_offer["resultData"]["colorLookup"]["colorValue"],
                "colorDescEn": data_offer["resultData"]["colorLookup"]["colorDescEn"],
                "documentImagePath": data_offer["resultData"]["colorLookup"]["documentImagePath"]
              },
              "itemThicknessList": data_offer["resultData"]["itemThicknessList"],

              "itemFireResistanceDegreeList": data_offer["resultData"]["itemFireResistanceDegreeList"]
            }
          };
        });

        getRefrich();
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
                content: Text("يرجي التاكد من الاتصال بل النترنت",style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Color(0xffffffff),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                )),
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
//    print(widget.);
//  var x;
    // TODO: implement build
    if (data_offer == null){
      return Directionality(textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: Color(0xfff3f1f1),
            appBar: AppBar(
              title: Text("",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xffffffff),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  )
              ),

              backgroundColor: Color(0xff212660),
            ),

            body: HomeWiting()
        ),
      );
    }
    else if (data_offer["resultData"] != null) {
      return Directionality(textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Color(0xfff3f1f1),
            appBar: AppBar(
              title: Text("",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xffffffff),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  )
              ),

              backgroundColor: Color(0xff212660),
            ),

            body: Stack(
              children: [
                ListView (
                  padding: EdgeInsets.only(bottom: 73),
                  children: [
                    Column(
                      children: [

                        //color item
                        data_offer["resultData"]['colorLookup']['documentImagePath']!=null?  Container(
                          height: 150,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 1.5,
                          margin: EdgeInsets.only(left: 11,right: 11,top: 11,bottom: 0),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                "${data_offer["resultData"]['colorLookup']['documentImagePath']}",
                              ),
//                                                              NetworkImage(
//                                                                  _All[index]["colorLookup"]["documentImagePath"]
//                                                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                            :
                        Container(
                          height: 150,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 1.5,
                          margin: EdgeInsets.all(11),
                          decoration: BoxDecoration(
                            color: data_offer["resultData"] == null ? Colors
                                .transparent :
                            data_offer["resultData"]['colorLookup']['colorValue'] ==
                                null ? Colors.transparent :
                            Color(int.parse(
                                "0xff${data_offer["resultData"]['colorLookup']['colorValue']}")),
                            borderRadius: BorderRadius.circular(8),
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

//                  detalesItem(),

                        Description_item(),

                        SizedBox(height: 1,),

                        num_Item_Need(),

                        Container(
                          padding: EdgeInsets.all(11),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          color: Colors.white,
                          child: Text("السمك المتاح",
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: Color(0xff000000),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                              )
                          ),
                        ),
                        //list Thickness
                        data_offer['resultData']["itemThicknessList"]!=null?
                        Thickness():
                        Text(""),

                        //درجة مقاومة للحريق
                        Container(
                          padding: EdgeInsets.all(21),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          color: Colors.white,
                          child: Text("درجة مقاومة للحريق",
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: Color(0xff000000),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                              )
                          ),
                        ),

                        data_offer['resultData']["itemFireResistanceDegreeList"]!=null?
                        FireResistanceDegree():Text(""),



                      ],
                    ),


                  ],
                ),


                Align(
                  alignment: Alignment.bottomCenter,
                  child: //add to sqlite
                  InkWell(
                    onTap: () async =>
                    {
                      if(id_itemThicknessList != null){
                        if(id_itemFireResistanceDegreeList != null){
                          save_inSqliute()
                        } else
                          {
                            dilogerror("يجب اختيار درجة مقاومة للحريق")
                          }
//                       save_inSqliute()
                      } else
                        {
                          dilogerror("يجب اختيار السمك")
                        }
                    },

                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: 55,
                      color: Color(0xff212660),
                      padding: EdgeInsets.only(left: 22 ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("أضف إلى السلة",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Color(0xffffffff),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0.07,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                )
              ],

            )


          )
      );
    } else {
      return Directionality(textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: Color(0xfff3f1f1),
            appBar: AppBar(
              title: Text("",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xffffffff),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  )
              ),

              backgroundColor: Color(0xff212660),
            ),

            body: Center(child: Text("لايوجد بيانات متوفره"),)
        ),
      );
    }
  }


  //<<<<<<<<<<<    detaels item
  Widget detalesItem(){
    return Container(
        width: MediaQuery.of(context).size.width,
//        height: 174,
        decoration: new BoxDecoration(
//          color: Color(0xffffffff),
          boxShadow: [BoxShadow(
              color: Color(0x3ddfe0e1),
              offset: Offset(0,-1),
              blurRadius: 0,
              spreadRadius: 0
          ) ],
        ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Description_item(),
          num_Item_Need(),


        ],
      ),
    );
  }

  //Description item
  Widget Description_item(){
    return Container(
      width: MediaQuery.of(context).size.width,
//        height: 174,
      decoration: new BoxDecoration(
          color: Color(0xffffffff),
        boxShadow: [BoxShadow(
            color: Color(0x3ddfe0e1),
            offset: Offset(0,-1),
            blurRadius: 0,
            spreadRadius: 0
        ) ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //name and hard
          Padding(padding: EdgeInsets.only(left: 21,right: 21,top: 11),
            child:   Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex:3,
                  child: Text("${data_offer['resultData']['colorLookup']['description']}"
                      + "    "+"${data_offer['resultData']['colorLookup']['code'].toString()}"
                      ,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Color(0xff000000),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      )
                  ),
                ),

                Expanded(flex:1,
                    child:InkWell(
                      onTap: ()=> {
                        print(data_offer['resultData']["itemFavFlag"]),
                        data_offer['resultData']["itemFavFlag"]==null ? _sendItemData_favorite(data_offer['resultData']["id"]) :
                        data_offer['resultData']["itemFavFlag"]==0 ? _sendItemData_favorite(data_offer['resultData']["id"]) :
                        _sendItemData_unfavorite(data_offer['resultData']["id"])
                      },

                      child: Icon(data_offer['resultData']["itemFavFlag"]==0?Icons.favorite_border:
                      Icons.favorite
                        ,size: 25,),
                    )
                ),
              ],
            ),
          ),

          //Description
          Padding(padding: EdgeInsets.only(left: 21,right: 21,top: 0),
              child: Text("${data_offer['resultData']['itemDescription']}",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xff000000),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  )
              )
          ),

          // salary
          Padding(padding: EdgeInsets.only(left: 21,right: 21,top: 1,bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${data_offer['resultData']['itemPricePerMetter']}",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Color(0xff000000),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      )
                  ),

                  SizedBox(width: 5,),

                  Text("ج.م/م2",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Color(0xff000000),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,


                      )
                  )

                ],
              )
          ),
        ],
      ),
    );
  }

  Widget num_Item_Need(){
    return Container(
      padding: EdgeInsets.only(left: 20,right: 15,top: 11),
      width: MediaQuery.of(context).size.width,
//        height: 174,
      decoration: new BoxDecoration(
        color: Color(0xffffffff),
        boxShadow: [BoxShadow(
            color: Color(0x3ddfe0e1),
            offset: Offset(0,-1),
            blurRadius: 0,
            spreadRadius: 0
        ) ],
      ),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text("اختر المواصفات المطلوبة",
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Color(0xff000000),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
              )
          ),

          SizedBox(height: 11,),

          Text("الكمية",
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Color(0xff000000),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
              )
          ),



          // button + and -  and total salary
         Row(
           children: [

             Row(
               children: <Widget>[
                 buildOutlineButton(
                   icon: Icons.remove,
                   press: () {
                     if (numOfItems > 1) {
                       setState(() {
                         numOfItems--;
                       });
                     }
                   },
                 ),
                 Padding(
                   padding: EdgeInsets.all(8),
//                padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
                   child: Text(
                     // if our item is less  then 10 then  it shows 01 02 like that
                       numOfItems.toString().padLeft(2, "0"),
//                  style: Theme.of(context).textTheme.headline6,
                       style: TextStyle(
                         fontFamily: 'Cairo',
                         color: Color(0xff000000),
                         fontSize: 13,
                         fontWeight: FontWeight.w400,
                         fontStyle: FontStyle.normal,


                       )
                   ),
                 ),
                 buildOutlineButton(
                     icon: Icons.add,
                     press: () {
                       setState(() {
                         numOfItems++;
                       });
                     }),
               ],
             ),

             SizedBox(width: 11,),
             Text("لوح",
                 style: TextStyle(
                   fontFamily: 'Cairo',
                   color: Color(0xff000000),
                   fontSize: 12,
                   fontWeight: FontWeight.w400,
                   fontStyle: FontStyle.normal,
                 )
             ),


             Text("اللوح الواحد =",
                 style: TextStyle(
                   fontFamily: 'Cairo',
                   color: Color(0xff000000),
                   fontSize: 12,
                   fontWeight: FontWeight.w400,
                   fontStyle: FontStyle.normal,


                 )
             ),


             Text(" (2.5)م2",
                 style: TextStyle(
                   fontFamily: 'Cairo',
                   color: Color(0xff000000),
                   fontSize: 12,
                   fontWeight: FontWeight.w400,
                   fontStyle: FontStyle.normal,


                 )
             )

           ],
         ),

          SizedBox(height: 11,),
          Text("   الإجمالي :  " +" ${numOfItems*data_offer['resultData']['itemPricePerMetter'] } "+"  جنيه مصري  ",
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Color(0xff000000),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              )
          )

        ],
      ),
    );
  }
  // design button + and -
  SizedBox buildOutlineButton({IconData? icon, var press}) {
    return SizedBox(
      width: 28,
      height: 28,
      child: OutlineButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        onPressed: press,
        child: Icon(icon),
      ),
    );
  }


  //السمك المتاح
  Widget  Thickness(){
//    var len=data_offer['resultData']["itemThicknessList"].length;
//    print(" length  السمك المتاح >>>${data_offer['resultData']["itemThicknessList"].length}");
//    print(">>>${data_offer['resultData']["itemThicknessList"][0]["id"].toString()}");
//    int _languageIndex = -1;
    if(data_offer['resultData']["itemThicknessList"].length > 0) {
      return Container(
        height: 50,
        width: MediaQuery
            .of(context)
            .size
            .width,
//        height: 174,
        decoration: new BoxDecoration(
          color: Color(0xffffffff),
          boxShadow: [BoxShadow(
              color: Color(0x3ddfe0e1),
              offset: Offset(0, -1),
              blurRadius: 0,
              spreadRadius: 0
          )
          ],
        ),
        child:
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
//            alignment: Alignment.bottomCenter,
            children: <Widget>[

                  ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data_offer['resultData']["itemThicknessList"] == null
                      ? 0
                      : data_offer['resultData']["itemThicknessList"].length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: _buildWidget(data_offer['resultData']["itemThicknessList"][index]["thicknessLookup"]["description"], index),
                      onTap: () => setState(() => {
                        _languageIndex = index,
                        itemThicknessList=data_offer['resultData']["itemThicknessList"][index]["thicknessLookup"]["description"],
                        id_itemThicknessList=data_offer['resultData']["itemThicknessList"][index]["thicknessLookup"]["id"],
                        print(">>>>>>>>>السمك المتاح${_languageIndex}"),
                      }
                      ),
                    );
                  }
              ),
            ],
          ),
        ),);
    }else {
      return Text("");
    }
  }
  // item   السمك المتاح
  Widget _buildWidget(String language, int index) {
    print(language);
    bool isSelected = _languageIndex == index;
    return Padding(padding: EdgeInsets.only(left: 10,right: 10),
      child:  Container(
        padding: EdgeInsets.only(left: 10,right: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: isSelected ? Color(0xffc59400) : Color(0xfff3f1f1)),
          color: isSelected ? Color(0xffc59400): Color(0xfff3f1f1),
//        color: Colors.grey[900],
        ),
        child: Text(
          language,
          style: TextStyle(fontSize: 16, color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }



  //درجة مقاومة للحريق
  Widget  FireResistanceDegree() {
//    var len=data_offer['resultData']["itemThicknessList"].length;
//    print(
//        " length  السمك المتاح >>>${data_offer['resultData']["itemFireResistanceDegreeList"]
//            .length}");
//    print(">>>${data_offer['resultData']["itemThicknessList"][0]["id"].toString()}");
//    int _languageIndex = -1;
    if (data_offer['resultData']["itemFireResistanceDegreeList"].length > 0) {
      print("itemFireResistanceDegreeList>>>>>>>>>>>>>>>>>>");
      return Container(
        height: 50,
        width: MediaQuery
            .of(context)
            .size
            .width,
//        height: 174,
        decoration: new BoxDecoration(
          color: Color(0xffffffff),
          boxShadow: [BoxShadow(
              color: Color(0x3ddfe0e1),
              offset: Offset(0, -1),
              blurRadius: 0,
              spreadRadius: 0
          )
          ],
        ),
        child:
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
//            alignment: Alignment.bottomCenter,
            children: <Widget>[

              ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data_offer['resultData']["itemFireResistanceDegreeList"] ==
                      null
                      ? 0
                      : data_offer['resultData']["itemFireResistanceDegreeList"]
                      .length,
//            crossAxisCount: 2,
//            crossAxisSpacing: 10,
//            mainAxisSpacing: 10,
//            childAspectRatio: 2.4,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: _buildWidget_FireResistanceDegree(
                          data_offer['resultData']["itemFireResistanceDegreeList"][index]["fireResistanceDegreeLookup"]["description"],
                          index),
                      onTap: () =>
                          setState(() =>
                          {
                            _languageIndex_FireResistanceDegree = index,
                            itemFireResistanceDegreeList=data_offer['resultData']["itemFireResistanceDegreeList"][index]["fireResistanceDegreeLookup"]["description"],
                            id_itemFireResistanceDegreeList=data_offer['resultData']["itemFireResistanceDegreeList"][index]["fireResistanceDegreeLookup"]["id"],
                          }
                          ),


                    );
                  }
              ),
            ],
          ),
        ),);
    } else {
      return Text("");
    }
  }

// item   درجة مقاومة للحريق
  Widget _buildWidget_FireResistanceDegree(String language, int index) {
    print(language);
    bool isSelected = _languageIndex_FireResistanceDegree == index;
    return Padding(padding: EdgeInsets.only(left: 10,right: 10),
      child:  Container(
        padding: EdgeInsets.only(left: 10,right: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: isSelected ? Color(0xffc59400) : Color(0xfff3f1f1)),
          color: isSelected ? Color(0xffc59400): Color(0xfff3f1f1),
//        color: Colors.grey[900],
        ),
        child: Text(
          language,
          style: TextStyle(fontSize: 16, color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  save_inSqliute() async {

    DatabaseHelperFinal helper = DatabaseHelperFinal();
    var userSaved = await helper.saveUser(
        data_offer['resultData']['id'].toString(),
        data_offer['resultData']['colorLookup']['description'].toString(),
        data_offer['resultData']['colorLookup']['colorValue'].toString(),
        data_offer['resultData']['colorLookup']['code'].toString(),
        data_offer['resultData']['itemPricePerMetter'].toString(),
        numOfItems.toString(),
        id_itemThicknessList.toString(),
        itemThicknessList.toString(),
        id_itemFireResistanceDegreeList.toString(),
        itemFireResistanceDegreeList.toString(),
        data_offer["resultData"]['colorLookup']['documentImagePath'].toString(),
    );
    dilogerror("تم الاضافه ");
    Navigator.pop(context);
    Navigator.pop(context);
//    print("save in database  $userSaved");
    print("save in database  $userSaved");
  }

  dilogerror(var string){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return   AlertDialog(
          title: null,
          content: Text(" $string ",style: TextStyle(
            fontFamily: 'Cairo',
            color: Color(0xff000000),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          textAlign: TextAlign.center,
          ),
          actions: [

//            InkWell(
//              child: Te,
//            )
//            okButton,
          ],
        );
      },
    );
  }


  Widget _loader() {
    return isLoading
        ? new Align(
      child: new Container(
        width: 70.0,
        height: 70.0,
        child: new Padding(
            padding: const EdgeInsets.all(5.0),
            child: new Center(child: new CircularProgressIndicator())),
      ),
      alignment: FractionalOffset.bottomCenter,
    )
        : new SizedBox(
      width: 0.0,
      height: 0.0,
    );
  }

}
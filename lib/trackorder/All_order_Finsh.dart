import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:willbond/feltter/filtterlist.dart';
import 'package:willbond/homeWite.dart';
import 'package:willbond/item_deteals/Item_details.dart';


import 'package:http/http.dart' as http;
import 'package:willbond/trackorder/detales_item/item_All_orderFinsh.dart';

import '../URL_LOGIC.dart';

class All_Order_Finsh extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UiTrackOrder();
  }

}

class UiTrackOrder extends State<All_Order_Finsh>{


  //ارشيف الطلبات

  Map? data_offer;

  ScrollController? controller;
  List _All = [];
  final _saved = new Set<Object>();
  bool isLoading = false;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  int numpage = 0;
  int totalRow = 0;
  int test = 0;

  Future getRefrich() async {
    getData("");
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();
    getData("");
    controller = new ScrollController()..addListener(_scrollListener);

    Icon actionIcon = new Icon(
      Icons.search,
      color: Colors.white,
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  void _scrollListener() {
    if (controller?.position.pixels == controller?.position.maxScrollExtent) {
      if (numpage < test + 2) {
        isLoading = true;
        startLoader();
//        startLoader();
      } else {
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

  //>>>>>>>>>>>>      get data  >>>>>>>>>>>>
  Future getData(var search) async {
    setState(() {
      isLoading=true;
      _loader();
    });
    print(">>>>>>>>>>Runing");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? token = prefs.getString('token');

    print(URL_LOGIC.get_completed_orders + "${numpage}" + "&size=15");
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

    // offer
    final headers = {
      'Content-Type': 'application/json',
      "Accept": "application/json"
    };
    http.Response response_offer = await http.get(
        Uri.parse(URL_LOGIC.get_completed_orders + "${numpage}" + "&size=10"),
      headers: {"Authorization": "$token"},
    ).timeout(Duration(seconds: 90), onTimeout: () {
      return Future.value(http.Response(json.encode(timeOutMessage), 500));
    }).catchError((err) {
      // nothing
    });
    data_offer = json.decode(response_offer.body);
//    userData_offer = data_offer["bestseller"];
//    _All.addAll(data_offer["resultData"]);

    setState(() {
      print("all item>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//      print("data_offer  > $data_offer");
      data_offer = json.decode(response_offer.body);
//      print(data_offer["resultData"]);

      _All.addAll(data_offer?["resultData"]["resultData"]??[]);
      numpage++;

      print(_All);

//      count

//      print("totalItemsCount > ${data_offer["resultData"]["totalItemsCount"]}");
      totalRow = data_offer?["resultData"]["totalItemsCount"]??0;
      var x = totalRow / 10;
      test = x.toInt();

      isLoading = false;
      _loader();
//      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: _All== null ? HomeWiting()
              :
          RefreshIndicator(
            onRefresh: getRefrich,
            color: Colors.white,
            backgroundColor: Colors.black,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: Color(0xffffffff),

                appBar: AppBar(title: Text("أرشيف الطلبات",
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

                      // change list
//                      Padding(padding: EdgeInsets.only(left: 1, right: 1),
//                          child: Container(
//                            decoration: BoxDecoration(
//                              shape: BoxShape.circle,
//                            ),
//                            child: IconButton(
//                              icon:  Image.asset('assets/filter_icon.png',color: Color(0xffffffff),),
//                              tooltip: 'Show Snackbar',
//                              onPressed: () {
//                                Navigator.push(context,MaterialPageRoute(builder: (context) => FiltterListHome()),);
////                scaffoldKey.currentState.showSnackBar(snackBar);
//                              },
//                            ),
//                          )
//                      ),
                    ]

                ),



                body: _All== null ? HomeWiting()
                    :
                Padding(
                    padding: EdgeInsets.only(left: 0, right: 0),
                    child: Stack(
                      children: [

                        Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: _All== null ? HomeWiting()
                              :listItem_new(),
                        ),

                        _loader()
                      ],
                    )),
              )

            ),
          ),
        ));
  }

  Widget listItem_new() {
    if (totalRow == 0) {
      return Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

//                Text(
//                  "لا يوجد لديك طلبات جديدة يمكنك إضافة طلبات جديدة ",
//                  style: TextStyle(
//                    fontFamily: 'Cairo',
//                    color: Color(0xff000000),
//                    fontSize: 16,
//                    fontWeight: FontWeight.w600,
//                    fontStyle: FontStyle.normal,
//                  ),
//                ),
                new Image(
                  image: AssetImage('assets/search.png'),
                  width: 114,
                  height: 165,
                ),
              ],
            ),
          ));
    } else {


      return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
//            height: 80,
            child: new ListView.builder(
//              shrinkWrap: true,
              padding: EdgeInsets.only(
                top: 5.0,
              ),
//              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                  crossAxisCount: 2,
//                  childAspectRatio: .80
//              ),
              // SliverGridDelegateWithFixedCrossAxisCount
              controller: controller,
              itemCount: _All == null ? 0 : _All.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                return InkWell(
                  onTap: ()=> Navigator.push(context,MaterialPageRoute(builder: (context) => Item_order_item_Finch(id: _All[index]["id"].toString(),)),),
//                  child: Card(
//                      shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.only(
//                            bottomLeft: Radius.circular(10),
//                            topLeft: Radius.circular(20),
//                            bottomRight: Radius.circular(10),
//                            topRight: Radius.circular(20)),
//
////                      side: BorderSide(width: 5, color: Colors.white)
//                      ),
//                      margin: EdgeInsets.all(12),
//                      elevation: 1,
                      child:
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
//                        padding: EdgeInsets.only(left: 22, right: 22),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
//                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child:
                                  Padding(
                                    padding: EdgeInsets.only(left: 22, right: 22),
//                            padding: const EdgeInsets.all(0.0),
//                            padding: const EdgeInsets.all(10.0),
                                    child:Text(
                                      "${_All[index]["orderStatus"]["description"]}",
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        color: Color(0xff000000),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                      ))
                                  ),
                                ),

                                // رقم الطلب
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 22, right: 22),
//                            padding: const EdgeInsets.all(0.0),
//                            padding: const EdgeInsets.all(10.0),
                                    child:Row(
                                    children: [
                                      Text("رقم الطلب",
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            color: Color(0xff000000),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                          )),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Text("${_All[index]["id"]}",
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            color: Color(0xff000000),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                          ))
                                    ],
                                  )
                                  ),
                                ),

                                //قيد المراجعة
                                Expanded(
                                  flex: 1,
                                  child:Padding(
                                    padding: EdgeInsets.only(left: 22, right: 22),
//                            padding: const EdgeInsets.all(0.0),
//                            padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "${_All[index]["orderTotal"]}" +
                                              "    جنيه",
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            color: Color(0xff000000),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                          )),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Row(
                                        children: [

                                          dateAnd_time(index),


                                          Icon(
                                            Icons.arrow_back_ios,
                                            textDirection: TextDirection.ltr,
                                            size: 13,
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                  ),
                                ),

                                Divider(
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
//                  ),
                );
              },
            ),
          ));
    }
  }



  Widget dateAnd_time(index) {
//    var c=_All[index]["submitDate"].toString().substring(0,10);
    return Row(
      children: [
        Text(
            _All[index]["submitDate"] == null
                ? "لايوجد تاريخ"
                : "${_All[index]["submitDate"].toString().substring(0, 10)}",
            style: TextStyle(
              fontFamily: 'Cairo',
              color: Color(0xff707070),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            )),

        SizedBox(
          width: 11,
        ),

//        Text("${_All[index]["submitDate"].toString()}",
//            style: TextStyle(
//              fontFamily: 'Cairo',
//              color: Color(0xff707070),
//              fontSize: 12,
//              fontWeight: FontWeight.w600,
//              fontStyle: FontStyle.normal,
//
//
//            )
//        ),
      ],
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
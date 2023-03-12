import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../../progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:willbond/item_deteals/Item_details.dart';


import 'package:http/http.dart' as http;

import '../../URL_LOGIC.dart';


class Item_order_item_Finch extends StatefulWidget{
  Item_order_item_Finch({Key? key, this.id}) : super(key: key);
  final String? id;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Ui_Item_order_item_Finch();
  }

}


class Ui_Item_order_item_Finch extends State<Item_order_item_Finch> {

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String ?token = prefs.getString('token');

    print(URL_LOGIC.get_item_order_finch+widget.id.toString());
    isLoading = true;
    setState(() {
      isLoading = true;
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
      Uri.parse(URL_LOGIC.get_item_order_finch+widget.id!),
      headers: {"Authorization": "$token"},
    ).timeout(Duration(seconds: 90), onTimeout: () {
      return Future.value(http.Response(json.encode(timeOutMessage), 500));
    }).catchError((err) {
      // nothing
    });
    data_offer = json.decode(response_offer.body);

    setState(() {
      print("all item_All_order_finsh>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print("data_offer item_All_order_finsh  > ${data_offer.toString()}");
      data_offer = json.decode(response_offer.body);
//      print(data_offer["resultData"]);

      _All.addAll(data_offer?["resultData"]["orderDetailsList"]??[]);
//      numpage++;
//
//      print(_All);
//
////      count
//
//      print("totalItemsCount > ${data_offer["resultData"]["totalItemsCount"]}");
//      totalRow = data_offer["resultData"]["totalItemsCount"];
//      var x = totalRow / 15;
//      test = x.toInt();
//
//      isLoading = false;
//      _loader();
//      isLoading = !isLoading;
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Directionality(
        textDirection: TextDirection.rtl,
        child:  RefreshIndicator(
              onRefresh: getRefrich,
              color: Colors.white,
              backgroundColor: Colors.black,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                    backgroundColor: Color(0xffffffff),

                    appBar: AppBar(title: Text(" رقم الطلب  "+widget.id.toString(),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Color(0xffffffff),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                      textDirection: TextDirection.rtl,
                    ),
                      backgroundColor: Color(0xff212660),

                    ),


                    body:data_offer== null ? Center(
                      child: Text("",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Color(0xff000000),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          )
                      ),
                    ):


                    data_offer?["errorStatus"]==false ?
                    ListView(

//                      physics: NeverScrollableScrollPhysics(),
//                      physics: ,
                      padding: EdgeInsets.only(left: 17,right: 17),
                      children: [

                        SizedBox(height: 33,),

                        //عنوان التسليم  /تاريخ الطلب
                        date_(),

                        SizedBox(height: 13,),

                        Text("أصناف الطلب",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: Color(0xff000000),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,


                            )
                        ),

                        SizedBox(height: 4,),
                        listItem_new(),


                        SizedBox(height: 13,),
                        reson_close(),

                        SizedBox(height: 13,),
                        totalPrice(),


                      ],
                    )
                  : Center(
                      child: Text("لايوجد بيانات ",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Color(0xff000000),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          )
                      ),
                    )
                ),
              ),
            )
    );
  }

  Widget date_() {
    return Container(
        width: 328,
        padding: EdgeInsets.all(14),
        height: 98,
        decoration: new BoxDecoration(
          color: Color(0xb8fbfbfb),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [BoxShadow(
              color: Color(0x29f3f1f1),
              offset: Offset(0, 3),
              blurRadius: 6,
              spreadRadius: 0
          )
          ],
        ),


      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //تاريخ الطلب
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text("تاريخ الطلب",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xff000000),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                    overflow: TextOverflow.ellipsis,
              )),

              Expanded(
                  flex: 2,
                  child: data_offer?["resultData"]["submitDate"]  == null ? Text("") : Text(
                  "${data_offer?["resultData"]["submitDate"].toString().substring(0,10)??""}",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Color(0xff000000),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                    overflow: TextOverflow.ellipsis,
                  )
              )
            ],
          ),

          //تاريخ الغاء الطلب
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text("تاريخ الغاء  الطلب ",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Color(0xff000000),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    overflow: TextOverflow.ellipsis,
                  )),

              Expanded(
                  flex: 2,
                  child: data_offer?["resultData"]["closedDate"]==null? Text("") :Text(
                  "${data_offer?["resultData"]["closedDate"].toString().substring(0,10)??""}",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Color(0xff000000),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                    overflow: TextOverflow.ellipsis,
                  )
              )
            ],
          ),

          //عنوان التسليم
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text("عنوان التسليم",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Color(0xff000000),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    overflow: TextOverflow.ellipsis,
                  )),

              Expanded(
                  flex: 2,
                  child: Text(
                    // data_offer["resultData"]["branchLookup"]["description"]==null? Text("") :
                  "${data_offer?["resultData"]["branchLookup"]["description"]??""}",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Color(0xff000000),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                    overflow: TextOverflow.ellipsis,
                  )
              )
            ],
          ),

        ],
      ),
    );
  }

  Widget reson_close(){

    List _All_orderTrackList =[];
     _All_orderTrackList.addAll(data_offer?["resultData"]["orderTrackList"]??[]);
     var x=_All_orderTrackList.length;
     var z=x-1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Visibility(
          visible:data_offer?["resultData"]["orderStatus"]["description"].toString().trim() =="تسليم الطلب" ? false
              :true ,
            child: Text(data_offer?["resultData"]["orderStatus"]["description"].toString().trim() =="الغاء الطلب" ? "أسباب الغاء الطلب"
            : "أسباب رفض الطلب",
            style: TextStyle(
              fontFamily: 'Cairo',
              color: Color(0xff000000),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,


            )
        )),

        Container(
            width: MediaQuery.of(context).size.width,
            height: 98,
            padding: EdgeInsets.only(left: 17,right: 17,top: 9),
            decoration: new BoxDecoration(
              color: Color(0xb8fbfbfb),
              borderRadius: BorderRadius.circular(5),
              boxShadow: [BoxShadow(
                  color: Color(0x29f3f1f1),
                  offset: Offset(0,3),
                  blurRadius: 6,
                  spreadRadius: 0
              ) ],
            ),

          child: Text("${_All_orderTrackList[z]["orderTrackComment"]}",
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Color(0xff000000),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,


              )
          ),
        )

      ],
    );
  }


  Widget totalPrice(){
    return Container(
        width: 360,
        height: 60,
        decoration: new BoxDecoration(
            color: Color(0x82f3f1f1)
        ),

      child: Center(
        child: Container(
          padding: EdgeInsets.only(left: 17,right: 17),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("إجمالي الطلب",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xff000000),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  )
              ),


              Text("${data_offer?["resultData"]["orderTotal"]??""}"+"  ج.م",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xff000000),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,


                  )
              )
            ],
          ),
        ),
      )
    );
  }








  Widget listItem_new() {
    return
      Container(
        color: Colors.transparent,
//            height: 80,
        child: new ListView.builder(

          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
//              physics: ScrollPhysics(),
          padding: EdgeInsets.only(
            top: 1.0,
          ),
          // EdgeInsets.only
//          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//            crossAxisCount: 1,
////              childAspectRatio:1.0
//            childAspectRatio: MediaQuery
//                .of(context)
//                .size
//                .width /
//                (MediaQuery
//                    .of(context)
//                    .size
//                    .height / 6),
//          ),
          // SliverGridDelegateWithFixedCrossAxisCount
          controller: controller,
          itemCount: _All == null ? 0 : _All
              .length,
//          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (_, index) {
            return

              Card(
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.only(
//                        bottomLeft: Radius.circular(10),
//                        topLeft: Radius.circular(20),
//                        bottomRight: Radius.circular(10),
//                        topRight: Radius.circular(20)
//                    ),
//
////                      side: BorderSide(width: 5, color: Colors.white)
//                  ),
//                  margin: EdgeInsets.all(4),
                  elevation: 1,
                  child:
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 80,
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
//                                      onTap: () =>
//                                          Navigator.push(context,
//                                              MaterialPageRoute(
//                                                  builder: (context) =>
//                                                      Item_details(
//                                                        id_item: _All[index]["id"].toString(),))
//                                          ),
                                      child: Row(
                                        children: <Widget>[

                                          //_All[index]['colorLookup']['colorValue']
                                          //color conttener
                                          Padding(
                                            padding: EdgeInsets.only(top: 5,),
                                            child: Container(
                                              width: 60,
                                              height: 60,
                                              decoration: new BoxDecoration(
                                                  color: Color(0xffebebeb),
                                                  borderRadius: BorderRadius
                                                      .circular(8)
                                              ),

                                              child:_All[index]["items"]['colorLookup']['documentImagePath']!=null?  Container(
                                                height: 59,
                                                width: 59,
                                                margin: EdgeInsets.all(11),
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: CachedNetworkImageProvider(
                                                      "${_All[index]["items"]['colorLookup']['documentImagePath']}",
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
                                                height: 49,
                                                width: 49,
                                                margin: EdgeInsets.all(11),
                                                decoration: BoxDecoration(

                                                  color: Color(int.parse(
                                                      "0xff${_All[index]["items"]['colorLookup']['colorValue']}")),
//                                                        color: Color(0xff+ int.parse(_All[index]["colorLookup"]["colorValue"], radix: 16)),
//                                                        color: Hexcolor("#"+_All[index]["colorLookup"]["colorValue"]),
                                                  borderRadius: BorderRadius
                                                      .circular(2),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(int.parse(
                                                          "0xff${_All[index]["items"]['colorLookup']['colorValue']}")),
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

                                          //name rn , name ar
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                      flex: 3,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            left: 15,
                                                            right: 15,
                                                            top: 7),
                                                        child:
//                                                        Expanded(
//                                                            flex: 1,
//                                                            child:
                                                       Row(
                                                         children: [
                                                           Text(
                                                             "  ${_All[index]["items"]['colorLookup']['description'].toString()+"  "+ _All[index]["items"]['itemCode'].toString()}  "
                                                                  ,
                                                             style: TextStyle(
                                                               fontFamily: 'Cairo',
                                                               color: Color(
                                                                   0xff000000),
                                                               fontSize: 12,
                                                               fontWeight: FontWeight
                                                                   .w600,
                                                               fontStyle: FontStyle
                                                                   .normal,
                                                             ),
                                                             textDirection: TextDirection.rtl,
//                                                            )
                                                           ),



                                                           Text(
                                                             "  ${_All[index]["itemPrice"].toString()}"
                                                                 +" * "+_All[index]["itemQuantity"].toString() ,
                                                             style: TextStyle(
                                                               fontFamily: 'Cairo',
                                                               color: Color(
                                                                   0xff000000),
                                                               fontSize: 12,
                                                               fontWeight: FontWeight
                                                                   .w600,
                                                               fontStyle: FontStyle
                                                                   .normal,
                                                             ),
                                                             textDirection: TextDirection.rtl,
//                                                            )
                                                           ),

                                                         ],
                                                       )
                                                      )
                                                  ),
                                                  Expanded(
                                                      flex: 3,
                                                      child: Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                              left: 15,
                                                              right: 15,
                                                              top: 7),
                                                          child:
//                                                        Expanded(
//                                                            flex: 1,
//                                                            child:
                                                          _All[index]["thickness"]!=null?
                                                          Text(
                                                              " سمك   ".toString()+"  "+_All[index]["thickness"]["description"]+"    "+
                                                              "درجة المقاومة   "+"  "+_All[index]["fireResistanceDegree"]["description"],
                                                              style: TextStyle(
                                                                fontFamily: 'Cairo',
                                                                color: Color(
                                                                    0xff000000),
                                                                fontSize: 12,
                                                                fontWeight: FontWeight
                                                                    .w600,
                                                                fontStyle: FontStyle
                                                                    .normal,
                                                              )
                                                          )
                                                              :Text("")

//                                                        ),
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ),
                                            flex: 3,
                                          ),

//                                          Expanded(
//                                            child: Align(
//                                                alignment: Alignment.centerLeft,
//                                                child:
//                                                Container(
//                                                  color: Colors.white,
//                                                  child: Column(
//                                                    crossAxisAlignment: CrossAxisAlignment.end,
//                                                    children: [
//
//                                                      // icon favorit and code
//                                                      Expanded(
//                                                        flex: 3,
//                                                        child:
//                                                        Row(
//                                                          crossAxisAlignment: CrossAxisAlignment.start,
//                                                          children: [
//                                                            Expanded(
//                                                              flex: 2,
//                                                              child:
//                                                              Align(
//                                                                alignment: Alignment
//                                                                    .centerLeft,
//                                                                child:
//                                                                Container(
//                                                                  padding: EdgeInsets.all(6),
//                                                                  decoration: new BoxDecoration(
//                                                                      color: Color(
//                                                                          0xffebebeb),
//                                                                      borderRadius: BorderRadius
//                                                                          .circular(
//                                                                          1)
//                                                                  ),
//
//                                                                  child: Text(
//                                                                    _All[index]["items"]["itemCode"]
//                                                                        .toString(),
//                                                                    textAlign: TextAlign
//                                                                        .left,),
//                                                                ),
//
//                                                              ),
//
//                                                            ),
//                                                          ],
//                                                        ),),
//
//
//
//                                                      // price
//                                                      Expanded(
//                                                          flex: 3,
//                                                          child: Padding(
//                                                            padding: EdgeInsets
//                                                                .only(
//                                                                left: 15,
//                                                                right: 15,
//                                                                top: 7),
//                                                            child: Row(
//                                                              crossAxisAlignment: CrossAxisAlignment
//                                                                  .start,
//                                                              mainAxisSize: MainAxisSize
//                                                                  .min,
//                                                              children: [
//
////
//
////                                                          Expanded(
////                                                              flex: 1,
////                                                              child:
//
//
//                                                                Text(
//                                                                    _All[index]["items"]['itemPricePerMetter']
//                                                                        .toString(),
//                                                                    style: TextStyle(
//                                                                      fontFamily: 'Cairo',
//                                                                      color: Color(
//                                                                          0xff000000),
//                                                                      fontSize: 12,
//                                                                      fontWeight: FontWeight
//                                                                          .w700,
//                                                                      fontStyle: FontStyle
//                                                                          .normal,
//                                                                    )
//                                                                ),
//
//                                                                SizedBox(width: 5,),
//
//                                                                Text("ج.م/م2",
//                                                                    style: TextStyle(
//                                                                      fontFamily: 'Cairo',
//                                                                      color: Color(
//                                                                          0xff000000),
//                                                                      fontSize: 12,
//                                                                      fontWeight: FontWeight
//                                                                          .w700,
//                                                                      fontStyle: FontStyle
//                                                                          .normal,
//
//
//                                                                    )
//                                                                )
////                                                          ),
//                                                              ],
//                                                            ),
//                                                          )
//                                                      ),
//                                                    ],
//                                                  ),
//                                                )
//                                            ),
//                                            flex: 3,
//                                          ),


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
      )
        ;
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
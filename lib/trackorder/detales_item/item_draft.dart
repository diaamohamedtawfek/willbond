import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:willbond/HOME/Home.dart';
import 'package:willbond/cart/CartFinal.dart';
import 'package:willbond/homeWite.dart';


import 'package:http/http.dart' as http;
import 'package:willbond/trackorder/TrackOrder.dart';

import '../../URL_LOGIC.dart';
import '../../progress_dialog.dart';
import '../All_order_Finsh.dart';


class Item_Draft extends StatefulWidget{
  Item_Draft({Key? key,required this.id}) : super(key: key);
  final String id;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Ui_Item_order_item_Finch();
  }

}


class Ui_Item_order_item_Finch extends State<Item_Draft> {

  Map? data_offer;

  ScrollController? controller;
  List? _All = [];
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
    String? token = prefs.getString('token');

    print(URL_LOGIC.get_item_order_finch+widget.id);
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
        Uri.parse(URL_LOGIC.get_item_order_finch+widget.id),
      headers: {"Authorization": "$token"},
    ).timeout(Duration(seconds: 90), onTimeout: () {
      return Future.value(http.Response(json.encode(timeOutMessage), 500));
    }).catchError((err) {
      // nothing
    });
    data_offer = json.decode(response_offer.body);

    setState(() {
      print("all item_All_order_finsh>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print("data_offer item_All_order_finsh  > ${data_offer}");
      data_offer = json.decode(response_offer.body);
//      print(data_offer["resultData"]);

      _All!.addAll(data_offer?["resultData"]["orderDetailsList"]??[]);
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


  Future<List?> _sendItemData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? token = prefs.getString('token');

    //to send order
    ProgressDialog pr = new ProgressDialog(context);
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.show();
    try{
      Map<String, dynamic> body = {

          "id": widget.id
      };

      debugPrint("?????????");
      print("body is : "+body.toString());
      print("url is : "+URL_LOGIC.resend_order);

      final encoding = Encoding.getByName('utf-8');
      String jsonBody = json.encode(body);
//      final headers = {'Content-Type': 'application/json'};
      final headers = {'Content-Type': 'application/json','Authorization':'$token'};
      print("headers : "+headers.toString());
      final response = await http.post(
          Uri.parse(URL_LOGIC.resend_order),
        body:jsonBody,
        encoding: encoding,
        headers: headers,
      );
      //"message":"You Logined To Your Account ."
      var datauser = json.decode(response.body);
//      var code=datauser["code"];
//      var actions=datauser["action"];
      debugPrint(datauser.toString());


//      debugPrint("message >>> "+actions);

      Future.delayed(Duration(seconds: 1)).then((value) async {
        pr.hide();
        if(datauser["errorStatus"]==false || datauser["errorStatus"]=="false"){
          print("object");
          pr.hide();

          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(context,MaterialPageRoute(builder: (context) =>TrackOrder(id: 1,)),);
          Navigator.push(context,MaterialPageRoute(builder: (context) =>TrackOrder(id: 1,)),);

//                     Navigator.of(context).pushReplacement(MaterialPageRoute(
//                     builder: (BuildContext context) =>  TrackOrder()));
          Navigator.push(context,MaterialPageRoute(builder: (context) =>CartFinal()),);
        }else{
          print("login");

        }


      });

//      if(datauser["code"]=="009"){
//
//        SharedPreferences prefs = await SharedPreferences.getInstance();
//        prefs.setString('idUser', datauser["userid"]);
//
//        Navigator.push(
//            context, MaterialPageRoute(builder: (context) => HomApp()));
//      }else{
//        showDilogFieldLogin(datauser["message"]);
//      }



    }catch(exception){
      Future.delayed(Duration(seconds: 3)).then((value) {
        pr.hide();
//            _validate_username=true;
//            _validate=true;
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

                appBar: AppBar(title: Text(" رقم الطلب  "+widget.id,
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

                body:data_offer== null ? HomeWiting()
                    :

                data_offer?["errorStatus"]==false ? ListView(
                  padding: EdgeInsets.only(left: 17,right: 17),
                  children: [

                    SizedBox(height: 23,),

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

                    SizedBox(height: 13,),
                    listItem_new(),


//                    SizedBox(height: 33,),
//                    reson_close(),

                    SizedBox(height: 13,),
                    
                    re_send_order(),

                    SizedBox(height: 13,),

                    close_order(),


                    SizedBox(height: 23,),
                    totalPrice(),


                  ],
                )
                    : Center(
                  child: Text("",
//                  child: Text("لايوجد بيانات ",
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
  
  Widget re_send_order(){
    return InkWell(
      
      onTap: ()=>_sendItemData(),
      
      child:   Container(
        width: MediaQuery.of(context).size.width,
//                        padding: EdgeInsets.only(left: 45,right: 45),
        margin: EdgeInsets.only(left: 45,right: 45),
        height: 45,
        decoration: new BoxDecoration(
            color: Color(0xff212660),
            borderRadius: BorderRadius.circular(23)
        ),
        child: Center(
          child: Text("إرسال الطلب",
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Color(0xffffffff),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                letterSpacing: 0.14,

              )
          ),
        ),
      ),
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


                      )
                  )),

              Expanded(
                  flex: 3,
                  child: data_offer?["resultData"]["submitDate"] == null ? Text("") :Text(
                  "${data_offer?["resultData"]["submitDate"].toString().substring(0,10).toString()}",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Color(0xff000000),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      )
                  )
              )
            ],
          ),

//          //تاريخ الغاء الطلب
//          Row(
//            children: [
//              Expanded(
//                  flex: 1,
//                  child: Text("تاريخ الغاء الطلب",
//                      style: TextStyle(
//                        fontFamily: 'Cairo',
//                        color: Color(0xff000000),
//                        fontSize: 12,
//                        fontWeight: FontWeight.w400,
//                        fontStyle: FontStyle.normal,
//
//
//                      )
//                  )),
//
//              Expanded(
//                  flex: 3,
//                  child: Text(data_offer["resultData"]["closedDate"]==null? Text("") :
//                  "${data_offer["resultData"]["closedDate"].toString().substring(0,10).toString()}",
//                      style: TextStyle(
//                        fontFamily: 'Cairo',
//                        color: Color(0xff000000),
//                        fontSize: 12,
//                        fontWeight: FontWeight.w600,
//                        fontStyle: FontStyle.normal,
//                      )
//                  )
//              )
//            ],
//          ),

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


                      )
                  )),

              Expanded(
                  flex: 3,
                  child: Text(
                      // data_offer["resultData"]["branchLookup"]["description"]==null? Text("") :
                  "${data_offer?["resultData"]["branchLookup"]["description"]??""}",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Color(0xff000000),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      )
                  )
              )
            ],
          ),

        ],
      ),
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
        child: new GridView.builder(

          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
//              physics: ScrollPhysics(),
          padding: EdgeInsets.only(
            top: 5.0,
          ),
          // EdgeInsets.only
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
//              childAspectRatio:1.0
            childAspectRatio: MediaQuery
                .of(context)
                .size
                .width /
                (MediaQuery
                    .of(context)
                    .size
                    .height / 6),
          ),
          // SliverGridDelegateWithFixedCrossAxisCount
          controller: controller,
          itemCount: _All == null ? 0 : _All!
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

                                              child:  _All?[index]["items"]['colorLookup']['documentImagePath']!=null?  Container(
                                                height: 59,
                                                width: 59,
                                                margin: EdgeInsets.all(11),
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: CachedNetworkImageProvider(
                                                      "${_All?[index]["items"]['colorLookup']['documentImagePath']??""}",
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
                                                      "0xff${_All?[index]["items"]['colorLookup']['colorValue']??""}")),
//                                                        color: Color(0xff+ int.parse(_All[index]["colorLookup"]["colorValue"], radix: 16)),
//                                                        color: Hexcolor("#"+_All[index]["colorLookup"]["colorValue"]),
                                                  borderRadius: BorderRadius
                                                      .circular(2),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(int.parse(
                                                          "0xff${_All?[index]["items"]['colorLookup']['colorValue']??""}")),
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
                                                                "  ${_All?[index]["items"]['colorLookup']['description']??""+"  "+
                                                                    _All?[index]["items"]['itemCode']??""}  "
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
                                                                "  ${_All?[index]["itemPrice"]??""}"
                                                                    +" * "+"${_All?[index]["itemQuantity"]??""}" ,
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
                                                          _All?[index]["thickness"]!=null?
                                                          Text(
                                                              " سمك   ".toString()+"  "+_All?[index]["thickness"]["description"]+"    "+
                                                                  "درجة المقاومة   "+"  "+_All?[index]["fireResistanceDegree"]["description"],
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

  Widget close_order(){
    return InkWell(

      onTap: ()=>  _branch_list_settingModalBottomSheet(context),

      child:   Container(
        width: MediaQuery.of(context).size.width,
//                        padding: EdgeInsets.only(left: 45,right: 45),
        margin: EdgeInsets.only(left: 45,right: 45),
        height: 45,
        decoration: new BoxDecoration(
//            color: Color(0xff212660),
            borderRadius: BorderRadius.circular(23)
        ),
        child: Center(
          child: Text("الغاء الطلب",
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Color(0xff212660),
//                color: Color(0xffffffff),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                letterSpacing: 0.14,

              )
          ),
        ),
      ),
    );
  }

  void _branch_list_settingModalBottomSheet(context) {


    TextEditingController password=new TextEditingController();

    showModalBottomSheet(
        context: context,
        elevation: 12,
//        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0.0),
              topRight: Radius.circular(0.0)),

        ),
//        isScrollControlled: true,
//        clipBehavior: Clip.antiAlias,
        isDismissible: true,
        builder: (BuildContext bc) {
          return Padding(
            padding: EdgeInsets.only(left: 0,bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom),
            child:
            new
            ListView(
              physics: ScrollPhysics(),
              children: <Widget>[

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      children: [

                        SizedBox(height: 23,),

                        Text("أسباب الغاء الطلب",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: Color(0xff000000),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                            )
                        ),



                        SizedBox(height: 23,),

                        Padding(
                          padding: EdgeInsets.only(left: 17,right: 17),
                          child: TextFormField(
                              minLines: 1,
                              maxLines: 111,
                              controller: password,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return  'الرقم السري';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'ما هي  أسباب الغاء الطلب؟',
                                hintText:  'ما هي  أسباب الغاء الطلب؟',
//                              errorText: _validate ? "يرجي التاكد من الرقم السري" : null,
                              ),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: Color(0xff000000),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,

                              )
                          ),

                        ),

                        SizedBox(height: 43,),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            margin: EdgeInsets.only(left: 45,right: 45),
                            decoration: new BoxDecoration(
                                color: Color(0xff212660),
                                borderRadius: BorderRadius.circular(23)
                            ),

                            child: InkWell(
                              onTap: ()=>_Close_sendItemData(password.text.toString()),

                              child: Center(
                                child: Text("موافق",
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    color: Color(0xffffffff),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: 0.14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                        )

                      ],
                    ),


//                    Padding(padding: EdgeInsets.all(15)),

                  ),
                )
              ],
            ),
//            )
          );
        }
    );
  }
  Future<List?> _Close_sendItemData(String re) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? token = prefs.getString('token');

    //to send order
    ProgressDialog pr = new ProgressDialog(context);
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.show();
    try{
      Map<String, dynamic> body ={
        "orderId" : widget.id ,
        "statusId" : 7 ,
        "comment" : re
      };

      debugPrint("?????????");
      print("body is : "+body.toString());
      print("url is : "+URL_LOGIC.close_order);

      final encoding = Encoding.getByName('utf-8');
      String jsonBody = json.encode(body);
//      final headers = {'Content-Type': 'application/json'};
      final headers = {'Content-Type': 'application/json','Authorization':'$token'};
      print("headers : "+headers.toString());
      final response = await http.post(Uri.parse(URL_LOGIC.close_order),
        body:jsonBody,
        encoding: encoding,
        headers: headers,
      );
      //"message":"You Logined To Your Account ."
      var datauser = json.decode(response.body);
//      var code=datauser["code"];
//      var actions=datauser["action"];
      debugPrint("close order");
      debugPrint(datauser.toString());


//      debugPrint("message >>> "+actions);

      Future.delayed(Duration(seconds: 1)).then((value) async {
        pr.hide();
        if(datauser["errorStatus"]==false || datauser["errorStatus"]=="false"){
          print("object");
          Navigator.pop(context,true);
          Navigator.pop(context,true);
          Navigator.pop(context,true);
          Navigator.push(context,MaterialPageRoute(builder: (context) =>All_Order_Finsh()),);
        }else{
          print("login");

        }


      });

//      if(datauser["code"]=="009"){
//
//        SharedPreferences prefs = await SharedPreferences.getInstance();
//        prefs.setString('idUser', datauser["userid"]);
//
//        Navigator.push(
//            context, MaterialPageRoute(builder: (context) => HomApp()));
//      }else{
//        showDilogFieldLogin(datauser["message"]);
//      }



    }catch(exception){
      Future.delayed(Duration(seconds: 3)).then((value) {
        pr.hide();
//            _validate_username=true;
//            _validate=true;
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

}
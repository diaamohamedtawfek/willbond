import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../progress_dialog.dart';
import 'package:willbond/item_deteals/Item_details.dart';
import 'package:willbond/serch_home/SershHome.dart';

import '../URL_LOGIC.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class ListNewItem extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UiListNewItem();
  }

}

class UiListNewItem extends State<ListNewItem>{


  Future getRefrich() async {
    _All!.clear();
    numpage=0;
    getData("");
    await Future.delayed(Duration(seconds: 1));
  }

  ScrollController? controller;
  List? _All =[];
//  List _All_totall = <Object>[];
//  final _saved = new Set<Object>();
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


//    Icon actionIcon = new Icon(Icons.search, color: Colors.white,);
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

  Map? data_offer;

  Future getData(var search) async {
    setState(() {
      isLoading=true;
      _loader();
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? token = prefs.getString('token');

    print(URL_LOGIC.new_listItem_news_AllList+"${numpage}"+"&size=4");
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
//    final headers = {'Content-Type': 'application/json',"Accept":"application/json"};
    http.Response response_offer = await http.get(
        Uri.parse(URL_LOGIC.new_listItem_news_AllList+"$numpage"+"&size=15"),
      headers: {"Authorization":"$token"},
    )
        .timeout(Duration(seconds: 90), onTimeout: () {
      return Future.value(http.Response(json.encode(timeOutMessage), 500));
    }).catchError((err) {
      // nothing
    });
    data_offer = json.decode(response_offer.body);
//    userData_offer = data_offer["bestseller"];


    setState(() {
      data_offer = json.decode(response_offer.body);
      if(data_offer!["status"]==null){
//      print("totalItemsCount>>>> ${data_offer["totalItemsCount"]}");

      print("all$_All");
//      print(_All[0]["name_shop"]);

//      count

      _All!.addAll(data_offer?["resultData"]["resultData"]??[]);
      print("all$_All");
//      _All_totall.addAll(data_offer["totalItemsCount"]);
//      print("_All_totall $_All_totall");
      numpage++;


//      totalRow = data_offer["totalItemsCount"];
//      totalRow = data_offer["totalItemsCount"];
      totalRow = data_offer?["resultData"]["totalItemsCount"]??0;
//      print("total${_All_totall[0]}");
      var x=  totalRow / 15 ;
      test=x.toInt();
      }else  if(data_offer?["status"].toString()=="401") {
        print(">>>>>>>+++++++++++++++++++>>>>>>>>>>>?????????????");
        setState(() {
        });
        refrech_token();
        return;
      }
      isLoading = false ;
      _loader();

//      isLoading = !isLoading;
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



  Future<List?> _sendItemData_favorite(int idItem  ,  Map itemList ,index ) async {

    print("id item >>> $idItem");
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
      var datauser = json.decode(response.body);
      debugPrint(datauser.toString());

      Future.delayed(Duration(seconds: 3)).then((value) async {
        pr.hide();
        if(data_offer?["status"]==null){
        if(datauser["errorStatus"]==true){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return   AlertDialog(
                title: null,
                content: Text("${datauser["errorResponsePayloadList"][0]["arabicMessage"]}",textAlign: TextAlign.center,),
                actions: [
                ],
              );
            },
          );
        }else{
//          getRefrich();
          setState(() {
            _All![index]={
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
        }
        }else  if(data_offer?["status"].toString()=="401") {
          print(">>>>>>>+++++++++++++++++++>>>>>>>>>>>?????????????");
          setState(() {
          });
          refrech_token();
          return;
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

  Future<List?> _sendItemData_unfavorite(int idItem  ,  Map itemList ,index ) async {

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

      final encoding = Encoding.getByName('utf-8');
      String jsonBody = json.encode(body);
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

      Future.delayed(Duration(seconds: 3)).then((value) async {
        pr.hide();
//        getRefrich();

        setState(() {
          _All![index]={
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









  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Color(0xffffffff),
          appBar: AppBar(title: Text("كافة الأصناف",
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



          body: RefreshIndicator(
            onRefresh: getRefrich,
            color: Colors.white,
            backgroundColor: Colors.black,
            child:Directionality(textDirection: TextDirection.rtl,
              child: Padding(
                  padding: EdgeInsets.only(left: 0, right: 0),
                  child:
                  Stack(

                    children: [


                      InkWell(
                        onTap: ()=>  Navigator.push(context,MaterialPageRoute(builder: (context) => SerchHome()),),
                        child:SerachAppBar()
                      ),

//                      textUP_new_listitem(),
//                      //new list
//                      Offer(),

                      Padding(padding: EdgeInsets.only(top: 50),child: textUP_listitem(),),

//                     //list item
                      Padding(padding: EdgeInsets.only(top: 100),child: listItem_new(),),


                      _loader(),
                    ],
                  )
              ),
            ),
          ),


        )
    );
  }



  Widget SerachAppBar(){
    return
//      SliverList(
//        delegate: SliverChildListDelegate([


          Container(
            width: MediaQuery.of(context).size.width,
            color: Color(0xff212660),
            child: Padding(
              padding: EdgeInsets.only(left: 13.0, right: 13.0,top: 5,bottom: 9),
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
                  child:  Directionality(
                    textDirection: TextDirection.rtl,
                    child:

                    InkWell(
//                      onTap: ()=>  Navigator.push(context,MaterialPageRoute(builder: (context) => SearchCatigory()),),
                      child:   Row(
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

//        ]
//        )
//    )
    ;
  }

  Widget textUP_listitem() {
    return
//      SliverList(
//        delegate: SliverChildListDelegate([

          Padding(
            padding: EdgeInsets.all(19),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: InkWell(

//                onTap: ()=>  Navigator.push(context,MaterialPageRoute(builder: (context) => Best_sellerNew()),),

                child:Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(5),
                      child: Text("وصل حديثا",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Color(0xff000000),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          )
                      ),
                    ),

                  ],
                ),
              ),
            ),)

//        ]
//        )
//    )
    ;
  }


  Widget listItem(){
    return
//      SliverList(
//        delegate: SliverChildListDelegate([
//          _buildSuggestions()
          Container(
//            height: 100,
            child: new GridView.builder(

              shrinkWrap: true,
//              physics: ScrollPhysics(),
              padding: EdgeInsets.only(
                top: 5.0,
              ),
              // EdgeInsets.only
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio:0.70
//                childAspectRatio: MediaQuery.of(context).size.width /
//                    (MediaQuery.of(context).size.height / 1),
              ),
              // SliverGridDelegateWithFixedCrossAxisCount
              controller: controller,
              itemCount: _All == null ? 0 : _All!
                  .length,
              physics: const AlwaysScrollableScrollPhysics(),
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
                                                          id_item: "${_All?[index]["id"]??""}",))
                                            ),
                                          child: Column(
                                            children: <Widget>[

                                              // icon favorit and code
                                              Row(

                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child:   Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.all(6),
                                                            decoration: new BoxDecoration(
                                                                color: Color(0xffebebeb),
                                                                borderRadius: BorderRadius.circular(1)
                                                            ),

                                                            child: Text(_All?[index]["itemCode"]??"",textAlign: TextAlign.left,),
                                                          ),
                                                        ],
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
                                                            child:_All?[index]["itemFavFlag"]==0 ? Icon(Icons.favorite_border,size: 25,): Icon(Icons.favorite,color: Color(0xffc59400),),
//
//                                                            child: Icon(Icons.favorite_border,size: 25,),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              //_All[index]["itemCode"]
                                              Padding(padding: EdgeInsets.only(top: 5 ,),
                                                child: Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration: new BoxDecoration(
                                                      color: Color(0xffebebeb),
                                                      borderRadius: BorderRadius.circular(8)
                                                  ),

                                                  child: Container(
                                                    height: 59,
                                                    width: 59,
                                                    margin: EdgeInsets.all(11),
                                                    decoration: BoxDecoration(

                                                      color: Color(int.parse("0xff${_All?[index]['colorLookup']['colorValue']??""}")),
//                                                        color: Color(0xff+ int.parse(_All[index]["colorLookup"]["colorValue"], radix: 16)),
//                                                        color: Hexcolor("#"+_All[index]["colorLookup"]["colorValue"]),
                                                      borderRadius: BorderRadius.circular(2),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Color(int.parse("0xff${_All?[index]['colorLookup']['colorValue']??""}")),
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
                                                            Text(_All?[index]['colorLookup']['description']??"",
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
                                                            Text(_All?[index]['colorLookup']['colorDescEn']??"",
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


                                                        Text(_All?[index]['itemPricePerMetter']??"",
                                                            style: TextStyle(
                                                              fontFamily: 'Cairo',
                                                              color: Color(0xff000000),
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w700,
                                                              fontStyle: FontStyle.normal,
                                                            )
                                                        ),

                                                        SizedBox(width: 5,),

                                                        Text("ج.م/م2",
                                                            style: TextStyle(
                                                              fontFamily: 'Cairo',
                                                              color: Color(0xff000000),
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w700,
                                                              fontStyle: FontStyle.normal,


                                                            )
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
          )
//        ]
//        )
//    )
    ;
  }

  Widget listItem_new() {
    return
//      SliverList(
//        delegate: SliverChildListDelegate([
//          _buildSuggestions()
      Container(
//            height: 80,
        child: new ListView.builder(

          shrinkWrap: true,
//              physics: ScrollPhysics(),
//          padding: EdgeInsets.only(
//            top: 5.0,
//          ),
//          // EdgeInsets.only
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
          itemCount: _All == null ? 0 : _All!
              .length,
          physics: const AlwaysScrollableScrollPhysics(),
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
                  margin: EdgeInsets.all(6),
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
                                      onTap: () =>
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Item_details(
                                                        id_item: "${_All?[index]["id"]??""}",))
                                          ),
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
                                                  color: Colors.black12,
//                                                  color: Color(0xffebebeb),
                                                  borderRadius: BorderRadius
                                                      .circular(8)
                                              ),

                                              child:
                                              _All?[index]['colorLookup']['documentImagePath']!=null?  Container(
                                                height: 59,
                                                width: 59,
                                                margin: EdgeInsets.all(11),
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: CachedNetworkImageProvider(
                                                      "${_All?[index]['colorLookup']['documentImagePath']??""}",
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
                                                      "0xff${_All?[index]['colorLookup']['colorValue']??""}")),
//                                                        color: Color(0xff+ int.parse(_All[index]["colorLookup"]["colorValue"], radix: 16)),
//                                                        color: Hexcolor("#"+_All[index]["colorLookup"]["colorValue"]),
                                                  borderRadius: BorderRadius
                                                      .circular(2),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(int.parse(
                                                          "0xff${_All?[index]['colorLookup']['colorValue']??""}")),
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
                                                            Text(
                                                                _All?[index]['colorLookup']['description']??"",
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
//                                                            )
                                                        ),

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
                                                            Text(
                                                                _All?[index]['itemDescription']??"",
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

//                                                        ),
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ),
                                            flex: 3,
                                          ),

                                          Expanded(
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child:
                                                Container(
                                                  color: Colors.white,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [

                                                      // icon favorit and code
                                                      Expanded(
                                                        flex: 3,
                                                        child:
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Expanded(
                                                              flex: 2,
                                                              child:
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child:
                                                                Container(
                                                                  padding: EdgeInsets.all(6),
                                                                  decoration: new BoxDecoration(
                                                                      color: Color(
                                                                          0xffebebeb),
                                                                      borderRadius: BorderRadius
                                                                          .circular(
                                                                          1)
                                                                  ),

                                                                  child: Text(
                                                                    _All?[index]["itemCode"]??"",
                                                                    textAlign: TextAlign
                                                                        .left,),
                                                                ),

                                                              ),

                                                            ),

//                                                            Expanded(
//                                                              flex: 1,
//                                                              child:
//                                                              Align(
//                                                                alignment: Alignment
//                                                                    .center,
//                                                                child:
//                                                                Container(
////                                                                padding: EdgeInsets
////                                                                    .all(11),
////                                                            decoration: new BoxDecoration(
////                                                                color: Color(0xffebebeb),
////                                                                borderRadius: BorderRadius.circular(1)
////                                                            ),
//
//                                                                  child: Icon(
//                                                                    Icons.favorite_border,
//                                                                    size: 25,),
//                                                                ),
//
//                                                              ),
//                                                            ),
                                                            Expanded(
                                                              flex: 1,
                                                              child:Align(
                                                                alignment: Alignment.center,
                                                                child:  Row(
                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                      .end,
                                                                  mainAxisSize: MainAxisSize
                                                                      .min,
                                                                  children: [
                                                                    Container(
                                                                      padding: EdgeInsets.all(0),
//                                                            decoration: new BoxDecoration(
//                                                                color: Color(0xffebebeb),
//                                                                borderRadius: BorderRadius.circular(1)
//                                                            ),
                                                                      child:InkWell(
                                                                        onTap: ()=> {
                                                                          _All?[index]["itemFavFlag"]==0 ? _sendItemData_favorite(_All?[index]["id"],_All?[index],index) :

                                                                          _sendItemData_unfavorite(_All?[index]["id"],_All?[index],index)
                                                                        },

                                                                        child: _All?[index]["itemFavFlag"]==0 ? Icon(Icons.favorite_border,size: 25,): Icon(Icons.favorite,color: Color(0xffc59400),),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),),



                                                      // price
                                                      Expanded(
                                                          flex: 3,
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .only(
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


                                                                Text(
                                                                    "${_All?[index]['itemPricePerMetter']??""}",
                                                                    style: TextStyle(
                                                                      fontFamily: 'Cairo',
                                                                      color: Color(
                                                                          0xff000000),
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight
                                                                          .w700,
                                                                      fontStyle: FontStyle
                                                                          .normal,
                                                                    )
                                                                ),

                                                                SizedBox(width: 5,),

                                                                Text("ج.م/م2",
                                                                    style: TextStyle(
                                                                      fontFamily: 'Cairo',
                                                                      color: Color(
                                                                          0xff000000),
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight
                                                                          .w700,
                                                                      fontStyle: FontStyle
                                                                          .normal,


                                                                    )
                                                                )
//                                                          ),
                                                              ],
                                                            ),
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                )
                                            ),
                                            flex: 3,
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
      )
//        ]
//        )
//    )
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
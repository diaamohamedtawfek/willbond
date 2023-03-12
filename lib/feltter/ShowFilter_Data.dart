import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:response/response.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:willbond/trackorder/detales_item/item_RuningOrder.dart';

import '../URL_LOGIC.dart';


class ShowDataFiltter extends StatefulWidget{
  ShowDataFiltter({Key? key, this.idUser, this.url}) : super(key: key);
  var idUser;
  final String? url;
  //&page=0&size=15

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UIShowDataFiltter();
  }

}


class UIShowDataFiltter extends State<ShowDataFiltter>{

  Map data_offer={};

  ScrollController? controller;
  List _All = <Object>[];
  final _saved = new Set<Object>();
  bool isLoading = false;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  int numpage = 0;
  int totalRow = 0;
  int test = 0;

  Future getRefrich() async {
    numpage=0;
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
    controller!.dispose();
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
    print(">>>>>>>>>>Runing");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? token = prefs.getString('token');

    print(URL_LOGIC.api2+widget.url.toString()+"&page=$numpage&size=15");
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
        Uri.parse(URL_LOGIC.api2+widget.url.toString()+"&page=$numpage&size=15"),
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
      print("data_offer  > $data_offer");
      if(data_offer["status"]==null){
      data_offer = json.decode(response_offer.body);
      print(data_offer["resultData"]);

      _All.addAll(data_offer["resultData"]["resultData"]);
      numpage++;

      print(_All);

//      count

      print("totalItemsCount > ${data_offer["resultData"]["totalItemsCount"]}");
      totalRow = data_offer["resultData"]["totalItemsCount"];
      var x = totalRow / 15;
      test = x.toInt();
    }else  if(data_offer["status"].toString()=="401") {
    print(">>>>>>>+++++++++++++++++++>>>>>>>>>>>?????????????");
    setState(() {
    });
    refrech_token();
    return;
    }
      isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: Text("فلتر الطلبات",
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
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                  padding: EdgeInsets.only(left: 0, right: 0),
                  child: Stack(
                    children: [
//                      Center(
//                        child: Text("data"),
//                      ),
//                     //list item

                      Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: listItem_new(),
                      ),
                    ],
                  )),
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
                Text(
                  "لا يوجد لديك طلبات جديدة يمكنك إضافة طلبات جديدة ",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xff000000),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),
                ),
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
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                Item_RuningOrder(
                                  id: _All[index]["id"].toString(),)),),
//                    child: Card(
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.only(
//                              bottomLeft: Radius.circular(10),
//                              topLeft: Radius.circular(20),
//                              bottomRight: Radius.circular(10),
//                              topRight: Radius.circular(20)),
//
////                      side: BorderSide(width: 5, color: Colors.white)
//                        ),
//                        margin: EdgeInsets.all(12),
//                        elevation: 1,
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: 100,
//                          padding: EdgeInsets.only(left: 22, right: 22),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
//                              padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child:Padding(
                                    padding: EdgeInsets.only(left: 22, right: 22),
//                            padding: const EdgeInsets.all(0.0),
//                            padding: const EdgeInsets.all(10.0),
                                    child: dateAnd_time(index)
                                ),
                              ),

                              // رقم الطلب
                              Expanded(
                                flex: 1,
                                child:Padding(
                                    padding: EdgeInsets.only(left: 22, right: 22),
//                            padding: const EdgeInsets.all(0.0),
//                            padding: const EdgeInsets.all(10.0),
                                    child: Row(
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
                                child: Padding(
                                    padding: EdgeInsets.only(left: 22, right: 22),
//                            padding: const EdgeInsets.all(0.0),
//                            padding: const EdgeInsets.all(10.0),
                                    child:Row(
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
                                            Text(
                                                "${_All[index]["orderStatus"]["description"]}",
                                                style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                  color: Color(0xff000000),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.normal,
                                                )),
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
                              )

                            ],
                          ),
                        ),
                      ),
                    )
//                    )
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

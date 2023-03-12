import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:willbond/Design_page_error_fether/Notfication_empty.dart';
//import 'package:willbond_emp/Item_details_Running_order/Item_details_Running_Order.dart';

import '../URL_LOGIC.dart';


class Notofication extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UiNotofication();
  }

}

class UiNotofication extends State<Notofication>{

  bool errorStatus=false;
  String dropdownValue="حالة الطلب";

  TextEditingController email=new TextEditingController();

  var visible=false;

  Map? data_offer;

  ScrollController? controller;
  List? _All = [];
  final _saved = new Set<Object>();
  bool isLoading = false;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  int numpage = 0;
  int totalRow=0;
  int test=0;


  Future getRefrich() async {
    numpage=0;
    _All!.clear();
    getData("");
    await Future.delayed(Duration(seconds: 1));
  }

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
      if(numpage<test+2) {
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



  Future getData(var search) async {
    setState(() {
      isLoading=true;
      _loader();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String ?token = prefs.getString('token');

    print(URL_LOGIC.notification);
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
    final headers = {'Content-Type': 'application/json',"Accept":"application/json"};
    http.Response response_offer = await http.get(
        Uri.parse(URL_LOGIC.notification)
      ,headers: {"Authorization":"$token"},
    )
        .timeout(Duration(seconds: 90), onTimeout: () {
      return Future.value(http.Response(json.encode(timeOutMessage), 500));
    }).catchError((err) {
      // nothing
    });
    data_offer = json.decode(response_offer.body);

    setState(() {
      print("all item>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//      print("data_offer  > $data_offer");
      data_offer = json.decode(response_offer.body);
//      print(data_offer["resultData"]);
      if(data_offer?["status"]==null){
      _All?.addAll(data_offer?["resultData"]["resultData"]??[]);
      totalRow=_All!.length;
      numpage++;

      print(data_offer.toString());

      if(data_offer?["errorStatus"].toString().trim()=="true"){

        errorStatus=true;

      }else if (data_offer?["errorStatus"].toString().trim()=="false") {
        errorStatus=false;
      }

//      count

//      print("totalItemsCount > ${data_offer["resultData"]["totalItemsCount"]}");
//      totalRow = data_offer["resultData"]["totalItemsCount"];
//      var x=  totalRow / 15 ;
//      test=x.toInt();
//
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
    final response = await http.post(
        Uri.parse(URL_LOGIC.refrechToken),
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
          appBar: AppBar(title: Text("التنبيهات  ",
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


          body: errorStatus == true ? Notfication_empty()
              :  RefreshIndicator(
            onRefresh: getRefrich,
            color: Colors.white,
            backgroundColor: Colors.black,
            child: Directionality(textDirection: TextDirection.rtl,
              child: Padding(
                  padding: EdgeInsets.only(left: 0, right: 0),
                  child:
                  Stack(

                    children: [

                     Padding(padding: EdgeInsets.only(left: 20,right: 20,top: 5),
                       child:  Text("حديثاً",
                           style: TextStyle(
                             fontFamily: 'Cairo',
                             color: Color(0xff000000),
                             fontSize: 14,
                             fontWeight: FontWeight.w600,
                             fontStyle: FontStyle.normal,


                           )
                       ),
                     ),



                      Padding(padding: EdgeInsets.only(top: 42),
                        child: listItem_new(),),

                      _loader(),

                    ],
                  )
              ),
            ),
          ),
        )
    );
  }



  Widget listItem_new() {
    if(totalRow==0){
      return Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: Wrap(
              direction: Axis.horizontal,
//              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Text("",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xff000000),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),


                new Image(image: AssetImage('assets/search.png'),
                  width: 114,height: 165,),
              ],
            ),
          )
      );
    }


    else{
      return  Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
//            height: 80,
            child: new ListView.builder(
//              shrinkWrap: true,
              padding: EdgeInsets.only(
                top: 0,
              ),
//              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                  crossAxisCount: 2,
//                  childAspectRatio: .80
//              ),
              // SliverGridDelegateWithFixedCrossAxisCount
              controller: controller,
              itemCount: _All == null ? 0 : _All!
                  .length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                return

                  Center(
                    child:
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20,top: 5,bottom: 5),
                      child:
                      Column(
                        children: [


                          Container(

                            child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: InkWell(
//                                    onTap: () =>
//                                        Navigator.push(context,
//                                            MaterialPageRoute(
//                                                builder: (context) =>
//                                                    Item_details_Archef_order(
//                                                      id: _All[index]["id"]
//                                                          .toString(),))
//                                        ),
                                    child: Column(
                                      children: <Widget>[


                                        // user name , sates order
                                        Row(
//                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [

                                            // user name

                                            new Image(image: AssetImage('assets/icon_notif.png'),
                                              width: 39,height: 39,),

                                            //  sates order
                                          Flexible(child:  Container(
                                            padding: EdgeInsets.only(left: 11,right: 11),
//                                             color: Colors.red,
                                            child:  Column(
//                                               crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [

                                                Text(_All?[index]["notificationContent"]!=null?'${_All?[index]["notificationContent"].toString()}'
                                                    :" ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontFamily: 'Cairo',
                                                  ),
                                                  overflow: TextOverflow.fade,
                                                  softWrap: true,

                                                  maxLines: 4,
                                                ),

                                              ],
                                            ),
                                          )
                                          ),
                                          ],
                                        ),

                                        SizedBox(height: 3,),
                                        Divider(height: 1,color: Colors.black,),

                                      ],
                                    )
                                )
                            ),
                          ),


                        ],
                      ),


                    ),
                  )
                ;
              },
            ),
          )
      )
      ;
    }

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
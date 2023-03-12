import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:willbond/item_deteals/Item_details.dart';

import '../URL_LOGIC.dart';

import 'package:http/http.dart' as http;

import '../homeWite.dart';

class Favorite extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return UiFavorite();
  }

}


class UiFavorite extends State<Favorite>{

  var visible=false;

  Map? data_offer;

  ScrollController? controller;
  List? _All = [];
//  final _saved = new Set<Object>();
  bool isLoading = false;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  int numpage = 0;
  int totalRow=0;
  int test=0;


  Future getRefrich() async {
    getData("");
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();
    getData("");
    controller = new ScrollController()
      ..addListener(_scrollListener);


    // Icon actionIcon = new Icon(Icons.search, color: Colors.white,);
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

  //>>>>>>>>>>>>      get data  >>>>>>>>>>>>
  Future getData(var search) async {
    setState(() {
      isLoading=true;
      _loader();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? token = prefs.getString('token');

    print(URL_LOGIC.getAll_favorite+"${numpage}"+"&size=15");
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
        Uri.parse(URL_LOGIC.getAll_favorite+"${numpage}"+"&size=10")
      ,headers: {"Authorization":"$token"},
    )
        .timeout(Duration(seconds: 90), onTimeout: () {
      return Future.value(http.Response(json.encode(timeOutMessage), 500));
    }).catchError((err) {
      // nothing
    });
    data_offer = json.decode(response_offer.body);
//    userData_offer = data_offer["bestseller"];
//    _All.addAll(data_offer["resultData"]);

    setState(() {
      isLoading = false ;
      _loader();
      if(data_offer?["status"]==null){
      print("all item>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print("data_offer  > $data_offer");
      data_offer = json.decode(response_offer.body);
      print(data_offer?["resultData"]);

      _All?.addAll(data_offer?["resultData"]["resultData"]??[]);
      numpage++;

      print(_All);

//      count

      print("totalItemsCount > ${data_offer?["resultData"]["totalItemsCount"]}");
      totalRow = data_offer?["resultData"]["totalItemsCount"];
      var x=  totalRow / 10 ;
      test=x.toInt();



      }else  if(data_offer?["status"].toString()=="401") {
        print(">>>>>>>+++++++++++++++++++>>>>>>>>>>>?????????????");
        setState(() {
//          retoke/n_list=1;
        });
        refrech_token();
        return;
      }
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



  //>>>>>>>>>_sendItemData_unfavorite >>>>>>>>
  Future<List?> _sendItemData_unfavorite() async {

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
        "itemsFavouriteList": _selecteCategorys
      };

      debugPrint("?????????");
      print("body is :"+body.toString());
      print("url is :"+URL_LOGIC.Un_favorite_page_favorite);

      final encoding = Encoding.getByName('utf-8');
      String jsonBody = json.encode(body);
      final headers = {'Content-Type': 'application/json',"Authorization":"$token"};
      final response = await http.post(Uri.parse(URL_LOGIC.Un_favorite_page_favorite),
        body:jsonBody,
        encoding: encoding,
        headers: headers,
      );
      var datauser = json.decode(response.body);
//      var code=datauser["code"];
//      var actions=datauser["action"];
      debugPrint(datauser.toString());


//      debugPrint("message >>> "+actions);

      Future.delayed(Duration(seconds: 3)).then((value) async {
        pr.hide();

        if(data_offer?["status"]==null){
//        _All.clear();
//        data_offer.clear();
//        numpage=0;
//        getData("");
        setState(() {
          for(int i=0 ; i<_selecteCategorys_index.length ;i++){
            _All?.removeAt(_selecteCategorys_index[i]);
          }

          _selecteCategorys_index.clear();
          _selecteCategorys.clear();
          visible=false;
        });
      }else  if(data_offer?["status"].toString()=="401") {
    print(">>>>>>>+++++++++++++++++++>>>>>>>>>>>?????????????");
    setState(() {
//          retoke/n_list=1;
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





  //>>>>>>>>>>>
//  List<int> selectedList = [];
  List _selecteCategorys = [];

  void _onCategorySelected(bool selected, category_id) {
    if (selected == true) {
      setState(() {
        _selecteCategorys.add(category_id);

        if(_selecteCategorys.length>0){
          visible=true;
        }else{
          visible=false;
        }

      });
    } else {
      setState(() {
        _selecteCategorys.remove(category_id);
        if(_selecteCategorys.length>0){
          visible=true;
        }else{
          visible=false;
        }
      });
    }
    print(_selecteCategorys.toString());
  }






  bool checkedValue=false;

  //>>>>>>>>>>
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Directionality(
        textDirection: TextDirection.rtl,
        child:
        Scaffold(
          backgroundColor: Color(0xfff3f1f1),
          appBar: AppBar(title:Text("المفضلة",
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Color(0xffffffff),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),
            textAlign: TextAlign.right,
          ),
            centerTitle: false,
            backgroundColor: Color(0xff212660),

              actions: <Widget>[
                Visibility(
                    visible: visible,
                    child: Padding(padding: EdgeInsets.only(left: 1, right: 5),
                        child: Container(
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Color(0xffffffff),),
                            tooltip: 'Show Snackbar',
                            onPressed: () {
                              _sendItemData_unfavorite();
//                            Navigator.push(context,MaterialPageRoute(builder: (context) => MAps(position_map: position_Map,)),);
                              print("map");
                            },
                          ),
                        )
                    ))
              ]
          ),

          body:data_offer==null? HomeWiting()
              :
//          _All.length <= 0? HomeWiting()
//              :
          RefreshIndicator(
            onRefresh: getRefrich,
            color: Colors.white,
            backgroundColor: Colors.black,
            child:Directionality(textDirection: TextDirection.rtl,
              child: Padding(
                  padding: EdgeInsets.only(left: 0, right: 0),
                  child:
                  Stack(

                    children: [

//                      Text("data"),
//                     //list item

                      Padding(padding: EdgeInsets.only(top: 0),child: listItem_new(),),

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Text("المفضلة فارغة يمكنك إضافة المزيد من الأصناف",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xff000000),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                ),


                new Image(image: AssetImage('assets/search.png'),
                  width: 114,height: 165,),

                SizedBox(height: 50,),


                InkWell(
                  onTap: ()=> Navigator.pop(context),
                  child:  Container(
                      margin: EdgeInsets.only(left: 70,right: 70),
                      height: 45,
                      decoration: BoxDecoration(
                        color: Color(0xff212660),
                        borderRadius: BorderRadius.circular(23),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x1a212660),
                            offset: Offset(0, 4),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ],
                      ),

                      child: Center(
                        child: Text('استعرض الأصناف',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Cairo',
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      )
                  ),
                )


              ],



            ),
          )
      );
    }else{
      return  Directionality(
            textDirection: TextDirection.rtl,
            child:

            Container(
//            height: 80,
              child: new GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  top: 5.0,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .80
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
                              Column(
                                children: [
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: CheckboxListTile(
                                      value: _selecteCategorys
                                          .contains(_All?[index]["id"]??0),
                                      onChanged: (bool? selected) {
                                        _onCategorySelected(selected!,
                                            _All![index]["id"]);

                                        _onCategorySelected_index(selected,
                                            index);
                                      },
                                      title: Text(""),

                                      checkColor: Color(0xffffffff),
                                      activeColor: Color(0xffc59400),
                                    ),
                                  ),


                                  Container(

                                    child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: InkWell(onTap: () =>
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Item_details(
                                                          id_item: _All![index]["items"]["id"]
                                                              .toString(),))
                                            ),
                                            child: Column(
                                              children: <Widget>[

                                                //_All[index]['colorLookup']['colorValue']
                                                //color conttener
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 5,),
                                                  child: Container(
                                                    width: 60,
                                                    height: 60,
                                                    decoration: new BoxDecoration(
                                                        color: Color(0xffebebeb),
                                                        borderRadius: BorderRadius
                                                            .circular(8)
                                                    ),

                                                    child: _All?[index]["items"]['colorLookup']["documentImagePath"]!=null? Container(
                                                      height: 59,
                                                      width: 59,
                                                      margin: EdgeInsets.all(11),
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: CachedNetworkImageProvider(
                                                            "${_All?[index]["items"]['colorLookup']["documentImagePath"]??""}",
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
                                                      height: 49,
                                                      width: 49,
                                                      margin: EdgeInsets.all(11),
                                                      decoration: BoxDecoration(

                                                        color: Color(int.parse(
                                                            "0xff${_All?[index]["items"]['colorLookup']['colorValue']??"000000"}")),
//                                                        color: Color(0xff+ int.parse(_All[index]["colorLookup"]["colorValue"], radix: 16)),
//                                                        color: Hexcolor("#"+_All[index]["colorLookup"]["colorValue"]),
                                                        borderRadius: BorderRadius
                                                            .circular(2),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Color(
                                                                int.parse(
                                                                    "0xff${_All?[index]["items"]['colorLookup']['colorValue']??"000000"}")),
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
//                                              Expanded(
//                                                child:
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .center,
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .center,
                                                    children: [

//                                                      Expanded(
//                                                          flex: 3 ,
//                                                          child:
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            left: 0,
                                                            right: 0,
                                                            top: 0),
                                                        child:
//                                                        Expanded(
//                                                            flex: 1,
//                                                            child:
                                                        Text(
                                                            _All?[index]["items"]['colorLookup']['description']??"",
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

                                                      ),
//                                                      ),

//                                                      Expanded(
//                                                          flex: 3,
//                                                          child:
                                                      Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                              left: 15,
                                                              right: 15,
                                                              top: 7),
                                                          child:
//                                                            Expanded(
//                                                                flex: 3,
//                                                                child:
                                                          Text(
                                                              _All?[index]["items"]['itemCode']??"",
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
//                                                      ),
                                                    ],
                                                  ),
                                                ),
//                                                flex: 3,
//                                              ),


//                                              Expanded(
//                                                  flex: 3,
//                                                  child:
                                                Padding(
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
                                                          "${_All?[index]["items"]['itemPricePerMetter']??""}",
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
//                                              ),


                                              ],
                                            )
                                        )
                                    ),
                                  ),


                                ],
                              ),


                            ),
                          ),
                        )
                    );
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


  List _selecteCategorys_index = [];

  void _onCategorySelected_index(bool selected, category_id) {
    if (selected == true) {
      setState(() {
        _selecteCategorys_index.add(category_id);

        if(_selecteCategorys_index.length>0){
          visible=true;
        }else{
          visible=false;
        }

      });
    } else {
      setState(() {
        _selecteCategorys_index.remove(category_id);
        if(_selecteCategorys_index.length>0){
          visible=true;
        }else{
          visible=false;
        }
      });
    }
    print(">>>>>>>++++++++>>>>>"+_selecteCategorys_index.toString());
  }
}
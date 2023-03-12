// ignore_for_file: non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:willbond/DatabaseHelper/DatabaseHelperFinal.dart';
import 'package:willbond/cart/Cart.dart';
import '../URL_LOGIC.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Item_details_cart extends StatefulWidget{

  Item_details_cart( {Key? key, this.id_item,this.cartuser}) : super(key: key);
  String? id_item;
  var cartuser;

  @override
  UIItem_details createState() => UIItem_details(id_item:id_item,cartuser: cartuser);

}


    /*


    يستخدم مع الجزئ الخاص ب بتعديل السله

     */




class UIItem_details extends State{
  int _languageIndex = -1;
  int _languageIndex_FireResistanceDegree = -1;


  var itemThicknessList=null;
  var id_itemThicknessList=null;

  var itemFireResistanceDegreeList=null;
  var id_itemFireResistanceDegreeList=null;


  int numOfItems = 1;
  UIItem_details( {Key? key, this.id_item, this.cartuser,});
  var id_item;
  var cartuser;


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
    
    print(">>>>>>>>>>>>>>>>${cartuser}");

    setState(() {

      numOfItems=int.parse(cartuser["num_ofItem"]);
      itemThicknessList=cartuser["itemThicknessList"];
      id_itemThicknessList=cartuser["id_itemThicknessList"];

      id_itemFireResistanceDegreeList=cartuser["id_itemFireResistanceDegreeList"];
      itemFireResistanceDegreeList=cartuser["itemFireResistanceDegreeList"];
    });



    getData("");
    controller = new ScrollController()
      ..addListener(_scrollListener);

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


  Future<Map<String, dynamic>?> getData(var search) async {

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

    // offer
//    final headers = {'Content-Type': 'application/json',"Accept":"application/json"};
    http.Response responseOffer = await http.get(
//      URL_LOGIC.find_by_id+"2",
        Uri.parse(URL_LOGIC.find_by_id+"${id_item}"),
      headers: {"Authorization":"$token"},
    )
        .timeout(Duration(seconds: 90), onTimeout: () {
      return Future.value(http.Response(json.encode(timeOutMessage), 500));
    }).catchError((err) {
      // nothing
    });
    data_offer = json.decode(responseOffer.body);
//    userData_offer = data_offer["bestseller"];
        ;

    setState(() {

      data_offer = json.decode(responseOffer.body);
      print(data_offer);
      print(data_offer["resultData"]["itemArea"]);
//      print(data_offer["resultData"]["itemArea"]);
//      _All=data_offer["resultData"];
//      userData_find_item=data_offer["resultData"]["colorLookup"];
//      arrayOfProductList.addAll(data_offer["resultData"]);
//
//      print("all  >  $userData_find_item");

      numpage++;

//      print(_All);


//      totalRow = data_offer["totalItemsCount"];
//      totalRow = data_offer["totalItemsCount"];
//      totalRow = data_offer["resultData"]["totalItemsCount"];
//      print("total${_All_totall[0]}");
//      var x=  totalRow / 15 ;
//      test=x.toInt();

//      isLoading = false ;
//      _loader();

//      isLoading = !isLoading;
    });

  }





  @override
  Widget build(BuildContext context) {
//    print(widget.);
//  var x;
    // TODO: implement build
    return
      Directionality(
          textDirection: TextDirection.rtl,
          child:
//    Scaffold(
//          backgroundColor: Color(0xfff3f1f1),
//          appBar: AppBar(
//            title: Text("",
//                style: TextStyle(
//                  fontFamily: 'Cairo',
//                  color: Color(0xffffffff),
//                  fontSize: 16,
//                  fontWeight: FontWeight.w400,
//                  fontStyle: FontStyle.normal,
//                )
//            ),
//
//            backgroundColor: Color(0xff212660),
//          ),
//
//          body:
//          ListView(
//            children: [
              Column(

                children: [



//                  detalesItem(),
               Container(
                 color: Colors.white,
                 child:  Row(
                   children: [
                     //color item
                     data_offer["resultData"]['colorLookup']['imageItem']!=null?  Container(
                       height: 59,
                       width: 59,
                       margin: EdgeInsets.all(11),
                       decoration: BoxDecoration(
                         image: DecorationImage(
                           image: CachedNetworkImageProvider(
                            data_offer["resultData"]['colorLookup']['imageItem'],
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

                       height: 65,
                       width: 65,
                       margin: EdgeInsets.all(11),
                       decoration: BoxDecoration(
                         color: Color(int.parse("0xff${data_offer["resultData"]['colorLookup']['colorValue']}")),
                         borderRadius: BorderRadius.circular(8),
                         boxShadow: [
                           BoxShadow(
//                            color: Color(0x26000000),
                             offset: Offset(0, 3),
                             blurRadius: 6,
                             spreadRadius: 0,
                           ),
                         ],
                       ),
                     ),

                     Description_item(),
                   ],
                 ),
               ),



//                  SizedBox(height: 18,),

                  num_Item_Need(),

                Container(
                  padding: EdgeInsets.all(21),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child:   Text("السمك المتاح",
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


                  Thickness(),

                  //درجة مقاومة للحريق
                  Container(
                    padding: EdgeInsets.all(21),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child:   Text("درجة مقاومة للحريق",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Color(0xff000000),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        )
                    ),
                  ),
                  FireResistanceDegree(),

                  //add to sqlite
                 InkWell(
                   onTap: () async =>{
                     if(id_itemThicknessList!=null){
                       if(id_itemFireResistanceDegreeList!=null){
                         save_inSqliute()
                       }else{
                         dilogerror("يجب اختيار درجة مقاومة للحريق")
                       }
//                       save_inSqliute()
                     }else{
                       dilogerror("يجب اختيار السمك")
                     }
                   },

                   child:  Container(
                     width: MediaQuery.of(context).size.width,
                     height: 55,
                     color: Color(0xff212660),
                     padding: EdgeInsets.only(left: 22),
                     child: Align(
                       alignment: Alignment.centerLeft,
                       child: Text("تم",
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
                 )

                ],
              )
//            ],
//          ),
//        )
    );
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
      width: MediaQuery.of(context).size.width-90,
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
          Padding(padding: EdgeInsets.only(left: 21,right: 21,top: 21),
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

//                Expanded(flex:1,
//                    child: Icon(Icons.favorite_border,size: 25,)
//                ),
              ],
            ),
          ),

          //Description
          Padding(padding: EdgeInsets.only(left: 21,right: 21,top: 21),
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
          Padding(padding: EdgeInsets.only(left: 21,right: 21,top: 21,bottom: 22),
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
      padding: EdgeInsets.all(20),
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

          SizedBox(height: 20,),

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

          SizedBox(height: 22,),
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
    print(" length  السمك المتاح >>>${data_offer['resultData']["itemThicknessList"].length}");
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
                      child: _buildWidget(
                          data_offer['resultData']["itemThicknessList"][index]["thicknessLookup"]["description"],
                          index,data_offer['resultData']["itemThicknessList"][index]["thicknessLookup"]["id"]
                      ),
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
  Widget _buildWidget(String language, int index,var id) {
    print(language);

    print("id select>>>${cartuser["id_itemThicknessList"]}");
    print("id select>>>${cartuser["itemThicknessList"]}");
    print("id >>>${id}");

    bool isSelected = _languageIndex == index;
    print("isSelected >>>${isSelected}");
    if(id.toString()==cartuser["id_itemThicknessList"]){
//      setState(() {
        print("????object");
        _languageIndex==index;
        isSelected = _languageIndex == index;
        isSelected = _languageIndex == index;
//      });
    }



    return Padding(padding: EdgeInsets.only(left: 10,right: 10),
      child:  Container(
        padding: EdgeInsets.only(left: 10,right: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: id.toString()==cartuser["id_itemThicknessList"]?Color(0xffc59400) : isSelected ? Color(0xffc59400) : Color(0xfff3f1f1)),
          color: isSelected ? Color(0xffc59400)
              : Color(0xfff3f1f1),
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
    print(
        " length  السمك المتاح >>>${data_offer['resultData']["itemFireResistanceDegreeList"]
            .length}");
//    print(">>>${data_offer['resultData']["itemThicknessList"][0]["id"].toString()}");
//    int _languageIndex = -1;
    if (data_offer['resultData']["itemFireResistanceDegreeList"].length > 0) {
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
                          index,
                          data_offer['resultData']["itemFireResistanceDegreeList"][index]["fireResistanceDegreeLookup"]["id"]
                      ),
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
  Widget _buildWidget_FireResistanceDegree(String language, int index,var id) {
    print(language);


    print("??id_itemFireResistanceDegreeList   "+cartuser["id_itemFireResistanceDegreeList"]);

    if(id.toString().trim()==cartuser["id_itemFireResistanceDegreeList"]){
//      setState(() {
      print("????object>>id_itemFireResistanceDegreeList");
      _languageIndex_FireResistanceDegree==index;
//        isSelected = _languageIndex == index;
//        isSelected = _languageIndex == index;
//      });
    }

    bool isSelected = _languageIndex_FireResistanceDegree == index;
    return Padding(padding: EdgeInsets.only(left: 10,right: 10),
      child:  Container(
        padding: EdgeInsets.only(left: 10,right: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: id.toString().trim()==cartuser["id_itemFireResistanceDegreeList"].toString().trim()?Color(0xffc59400) :
          isSelected ? Color(0xffc59400) :
          Color(0xfff3f1f1)),
          color:
          isSelected ? Color(0xffc59400):
          Color(0xfff3f1f1),
//        color: Colors.grey[900],
        ),
        child: Text(
          language,
          style: TextStyle(fontSize: 16, color:
          isSelected ? Colors.white
              : Colors.black),
        ),
      ),
    );
  }

  save_inSqliute() async {

    DatabaseHelperFinal helper = DatabaseHelperFinal();
    var userSaved = await helper.update(
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
        cartuser["id"].toString(),
      data_offer['resultData']['imageItem'].toString(),
    );
    dilogerror("save in database");
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => Cart()));
//    Navigator.of(context).pop('rerun_future');
//    print("save in database  $userSaved");

    print("save in database  $userSaved");
  }

  dilogerror(var string){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return   AlertDialog(
          title: null,
          content: Text(" $string "),
          actions: [
//            okButton,
          ],
        );
      },
    );
  }
}
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:willbond/DatabaseHelper/DatabaseHelperFinal.dart';
import 'package:willbond/Design_page_error_fether/Cart_empty.dart';
import 'package:willbond/cart/CartFinal.dart';
import 'package:willbond/item_deteals/Item_details_cart.dart';

import 'package:http/http.dart' as http;

import '../URL_LOGIC.dart';


class Cart extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return uiCart();
  }
}


class uiCart extends State<Cart>{

  //>
  int _languageIndex = -1;
  int _languageIndex_FireResistanceDegree = -1;


  var itemThicknessList=null;
  var id_itemThicknessList=null;

  var itemFireResistanceDegreeList=null;
  var id_itemFireResistanceDegreeList=null;


  int numOfItems = 1;
//  UIItem_details( {Key key, this.id_item, this.cartuser,});
  var id_item;
  var cartuser;

  //>>>

  var text_branch="العنوان";

  Future getRefrich() async {
    getdatabase();
    await Future.delayed(Duration(seconds: 1));
  }

  ScrollController? controller;
  List _All = <Object>[];
  List _All_totall = <Object>[];
  final _saved = new Set<Object>();
  bool isLoading = false;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  int numpage = 0;
  int totalRow=0;
  int test=0;

  List? cartAll;
  String? ling_all;

  @override
  void initState() {
    super.initState();
    getdatabase();
    controller = new ScrollController()
      ..addListener(_scrollListener);

    senddata();



  }

  List _listObject=  [];
  late Map<String, Object> object;
  double total=0;

  // to fetch data from sqlite
  void senddata() async{
    DatabaseHelperFinal databaseHelper = DatabaseHelperFinal();

    var xxx= await databaseHelper.getCount();

    print("result  $xxx");

    var user= await databaseHelper.getAllUsers();
    setState(() {

      for(int i=0 ; i<xxx! ; i++){

        total+=(double.parse(user[i]["num_ofItem"]) * double.parse(user[i]["priceItem"])) ;

        print("total>>====${total}");
        print("num====${user[i]["id_itemFireResistanceDegreeList"]}");

        object={
          "itemQuantity": user[i]["num_ofItem"],
          "itemPrice": user[i]["priceItem"],
          "itemFees": 30,
          "items": {
            "id": user[i]["idItem"]
          } ,
          "fireResistanceDegree" :{
            "id" : user[i]["id_itemFireResistanceDegreeList"]
          } ,
          "thickness" :{
            "id" : user[i]["id_itemThicknessList"]
          }

        };
        print("map====${object}");
        if(object!=null) {
          _listObject.add(object);
        }
      }

      print("list>>>>>>>>>>>]]]]]]]]]${_listObject}");
      print("list>>>>>>>>>>>]]]]]]]]]${_listObject.length}");

    });

    print("list>>>>>>>>>>>]]]]]]]]]${_listObject.length}");

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
      getdatabase();
    });
  }

  Map? data_offer;


double total_price=0.0;

  void getdatabase() async{
    DatabaseHelperFinal databaseHelper = DatabaseHelperFinal();
//    var x=databaseHelper.saveUser("idItem", "username", "colorItem", "codeItem", "priceItem", "num_ofItem",
//        "id_itemThicknessList", "itemThicknessList", "id_itemFireResistanceDegreeList", "itemFireResistanceDegreeList").toString();
    var xxx= await databaseHelper.getCount();

//    var deleat= await databaseHelper.dELETE();
//    print("deleat  $deleat");
    print("result  $xxx");

    var user= await databaseHelper.getAllUsers();
    setState(() {

      cartAll=user;

setState(() {
  for(int i=0 ;i<cartAll!.length ;i++){
    double re=double.parse(cartAll?[i]["priceItem"])*double.parse(cartAll?[i]["num_ofItem"]);
    total_price=re+total_price;
    print("@@@@@@@@@@@@@@@@@@@@");
    print(total_price.toString());
    print("@@@@@@@@@@@@@@@@@@@@");
  }
});


      print("user  $user");
      print("user  ${user.length}");


    });


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try{

      print("url is :"+URL_LOGIC.Un_favorite);

      final encoding = Encoding.getByName('utf-8');
//      String jsonBody = json.encode(body);
      final headers = {'Content-Type': 'application/json',"Authorization":"$token"};
      final response = await http.get(Uri.parse(URL_LOGIC.getAll_branch),
//        body:jsonBody,
//        encoding: encoding,
        headers: headers,
      );
      var datauser = json.decode(response.body);
//      var code=datauser["code"];
//      var actions=datauser["action"];
      debugPrint(datauser.toString());

      setState(() {

        _All=datauser["resultData"]["resultData"];
        print(">>>>>>>$_All");
      });

    }catch(exception) {
    }





  }






  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (cartAll!.length <= 0) {
      return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
          appBar: AppBar(title: Text("سلة المشتريات",
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


    body: Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Cart_Empity(),

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
//                new Image(
//                  image: AssetImage('assets/search.png'),
//                  width: 114,
//                  height: 165,
//                ),
              ],
            ),
    )
    )
    )
      );
    }
    else {
      return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
              appBar: AppBar(title: Text("سلة المشتريات",
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
                child: Stack(children: [
                  Container(
                    margin: EdgeInsets.only(top: 22),
                    padding: EdgeInsets.only(left: 11, right: 22),
                    alignment: Alignment.centerRight,
                    height: 45,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    decoration: BoxDecoration(
                      color: Color(0xfff1f1f1),
                    ),

                    child: Text("الأصناف",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Color(0xff000000),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,


                        )
                    ),
                  ),




                  //list item
                  Padding(padding: EdgeInsets.only(top: 75),
                    child: ListView(
                      children: [


                        listItem_new(),


//                  cartAll == null
                        Visibility(
                            visible: _listObject.length == 0 ? false : true,

                            child:
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 44,),
                                //text  "اختر عنوان التسليم
                                Padding(
                                  padding: EdgeInsets.only(left: 22, right: 22),
                                  child: Text("اختر عنوان التسليم",
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        color: Color(0xff000000),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,

                                      )
                                  ),
                                ),


                                SizedBox(height: 34,),


                                // branch location
                                InkWell(
                                  onTap: () =>
                                      _branch_list_settingModalBottomSheet(
                                          context),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 33, right: 33),
                                    padding: EdgeInsets.only(
                                        left: 33, right: 33),
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black12,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),

                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Text(text_branch,
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              color: Color(0xff000000),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.normal,


                                            )
                                        ),

                                        Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                ),


                                SizedBox(height: 44,),

                                //boutton done
                                InkWell(
                                  onTap: () =>
                                  {
                                    if(id_branch == null){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: null,
                                            content: Text("يجب اختيار فرع",
                                              textAlign: TextAlign.center,),
                                            actions: [
                                              //            okButton,
                                            ],
                                          );
                                        },
                                      ),
                                    } else
                                      if(_listObject.length <= 0){
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: null,
                                              content: Text("لايوجد بيانات",
                                                textAlign: TextAlign.center,),
                                              actions: [
                                                //            okButton,
                                              ],
                                            );
                                          },
                                        ),

                                      } else
                                        {
                                          _sendItemData(1)
                                        }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 45, right: 45),
//                        width: M,
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
                                ),


                                SizedBox(height: 24,),

                                InkWell(
                                  onTap: () =>
                                  {
                                    if(id_branch == null){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: null,
                                            content: Text("يجب اختيار فرع",
                                              textAlign: TextAlign.center,),
                                            actions: [
//            okButton,
                                            ],
                                          );
                                        },
                                      ),
                                    } else if(_listObject.length <= 0){
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: null,
                                              content: Text("لايوجد بيانات",
                                                textAlign: TextAlign.center,),
                                              actions: [
                                                //            okButton,
                                              ],
                                            );
                                          },
                                        ),

                                      } else if(id_branch != null)
                                        {
                                          _sendItemData(2)
                                        }
                                  },
                                  child: Center(
                                    child: Text("حفظ لوقت لاحق",
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          color: Color(0xff212660),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: 0.14,

                                        )
                                    ),
                                  ),
                                ),

                                SizedBox(height: 74,),



                              ],
                            )
                        ),

                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child:  Container(
                        margin: EdgeInsets.only(top: 22),
                        padding: EdgeInsets.only(left: 11, right: 22),
                        alignment: Alignment.centerRight,
                        height: 45,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        decoration: BoxDecoration(
                          color: Color(0xfff1f1f1),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text("الاجمالي",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: Color(0xff000000),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,


                                )
                            ),

                            Text(total_price.toString(),
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: Color(0xff000000),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,


                                )
                            ),


                          ],
                        )
                    ),
                  )
                ],),

              )
          )
      );
    }
  }

  Widget listItem_new() {
    print("all $cartAll");
    return
      Container(
        child:
            ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(
                top: 5.0,
              ),
              controller: controller,
              itemCount: cartAll == null ? 0 : cartAll!
                  .length,
              itemBuilder: (_, index) {
                return
//
                  Card(
                      child:
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: 130,
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
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[

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

                                                  child: cartAll![index]['imageItem']!=null?  Container(
                                                    height: 59,
                                                    width: 59,
                                                    margin: EdgeInsets.all(11),
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: CachedNetworkImageProvider(
                                                          cartAll?[index]['imageItem'],
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

                                                      color: Color(int.parse("0xff${cartAll?[index]['colorItem'] ?? 0xffbeb}")) ,
//                                                        color: Color(0xff+ int.parse(_All[index]["colorLookup"]["colorValue"], radix: 16)),
//                                                        color: Hexcolor("#"+_All[index]["colorLookup"]["colorValue"]),
                                                      borderRadius: BorderRadius
                                                          .circular(2),
                                                      boxShadow: [
                                                        BoxShadow(
//                                                      color: Color(int.parse(
//                                                          "0xff${_All[index]['colorLookup']['colorValue']}")),
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
                                                flex: 3,
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
                                                            //nameItem===codeItem==num_ofItem
                                                            Text(
                                                              "${cartAll?[index]['nameItem'] +"  "+ cartAll?[index]['codeItem']+"  "
                                                                  +cartAll?[index]['num_ofItem'] +"x "+"  "}"
                                                                  .toString(),
                                                              style: TextStyle(
//                                                              backgroundColor: Colors.deepPurple,
                                                                fontFamily: 'Cairo',
                                                                color: Color(
                                                                    0xff000000),
                                                                fontSize: 16,
                                                                fontWeight: FontWeight
                                                                    .w600,
                                                                fontStyle: FontStyle
                                                                    .normal,
                                                              ),
                                                              textDirection: TextDirection.rtl,
                                                              textAlign: TextAlign.right,
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
                                                                "  سمك  "+cartAll![index]['itemThicknessList']
                                                                    .toString()+" "+" درجة المقاومة "+" "+
                                                                    cartAll![index]['itemFireResistanceDegreeList']
                                                                        .toString(),
                                                                style: TextStyle(
                                                                  fontFamily: 'Cairo',
                                                                  color: Color(
                                                                      0xff000000),
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight
                                                                      .w600,
                                                                  fontStyle: FontStyle
                                                                      .normal,
                                                                ),
                                                                textDirection: TextDirection.rtl,
                                                              )

//                                                        ),
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
                                                                 "${ double.parse(cartAll![index]['priceItem'])*double.parse(cartAll![index]['num_ofItem'])}"
                                                                ,
                                                                style: TextStyle(
                                                                  fontFamily: 'Cairo',
                                                                  color: Color(
                                                                      0xff000000),
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight
                                                                      .w600,
                                                                  fontStyle: FontStyle
                                                                      .normal,
                                                                ),
                                                                textDirection: TextDirection.ltr,
                                                              )

//                                                        ),
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                            ],
                                          )
                                      )
                                  ),
                                ),


                                Container(
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [

                                      IconButton(icon:Icon(Icons.edit) ,
                                        onPressed: ()=>{
                                        setState(() {
////                                          getData(cartAll[index]["id"]);
//                                        Future.delayed(Duration(seconds: 8)).then((value) {
//                                          showDialog(
//                                            context: context,
//                                            builder: (BuildContext context) {
//                                              return   AlertDialog(
//                                                title: null,
//                                                content: Container(
//                                                  height: 300,
//                                                  child: cartUpdates( cartAll[index], cartAll[index]["idItem"],),
//                                                ),
//                                                actions: [
////            okButton,
//                                                ],
//                                              );
//                                            },
//                                          );
//                                        });


                                          _settingModalBottomSheet(context,cartAll?[index],cartAll?[index]["idItem"]);

                                        }),


//                                     deleate_item( cartAll[index]['id']),
                                        },
                                      ),

                                      SizedBox(width: 6,),

                                      IconButton(icon:Icon(Icons.delete) ,
                                        onPressed: ()=>{
                                          showAlertDialog( context,cartAll?[index]['id']),
//                                          deleate_item( cartAll[index]['id']),
                                        },
                                      ),



                                    ],
                                  ),
                                )

                              ],
                            ),

//                              ],
//                            )
                          ),
                        ),
                      ),
                  )
                ;
              },
            ),



      )
//        ]
//        )
//    )
        ;
  }


  ///       cancel item
  ///

  showAlertDialog(BuildContext context,var id) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("حذف",
          style: TextStyle(
        fontFamily: 'Cairo',
        color: Color(0xfffb0909),
        fontSize: 13,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        letterSpacing: 0.065,

      )),
      onPressed: () {
        deleate_item(id);
        Navigator.of(context).pop(false);
      },
    );


    Widget canselButton = FlatButton(
      child:Text("إلغاء",
          style: TextStyle(
            fontFamily: 'Cairo',
            color: Color(0xfffb0909),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            letterSpacing: 0.065,

          )
      ),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );


    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("حذف" ,style: TextStyle(
        fontFamily: 'Cairo',
        color: Color(0xff000000),
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
      ),
      textDirection: TextDirection.rtl,
      ),

      content: Text("هل أنت متأكد من حذف الصنف؟", style: TextStyle(
        fontFamily: 'Cairo',
        color: Color(0xff707070),
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,


      ),
        textDirection: TextDirection.rtl,
      ),
      actions: [
        okButton,
        canselButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  void deleate_item(var id) async{
    DatabaseHelperFinal databaseHelper = DatabaseHelperFinal();
    var xxx= await databaseHelper.dELETE(id);


    var user= await databaseHelper.getAllUsers();
    setState(() {
//      var user=  databaseHelper.getAllUsers();

      cartAll=user;

      print("user  $user");
      print("user  ${user.length}");

//    data_offer = json.decode(user.);
      _All.add(user);
      print(">>>>>>>$_All");
//    cartAll=user;
//    print("user  ${user[7]["colorItem"]}");
    });

  }


  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  //update list
  void _settingModalBottomSheet(context,cartuser,idItem) {
//    getData(idItem);
    showModalBottomSheet(
        context: context,
        elevation: 12,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0)),

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
//              alignment: WrapAlignment.center,
              children: <Widget>[

                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                       Item_details_cart(id_item: cartuser["idItem"],
                         cartuser: cartuser,),

                )
              ],
            ),
//            )
          );
        }
    );
  }






  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  //branch list
  void _branch_list_settingModalBottomSheet(context) {
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
//            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/4.5, right: MediaQuery.of(context).size.width/4.5, bottom: MediaQuery
//                .of(context)
//                .viewInsets
//                .bottom),
            child:
            new
            ListView(
              physics: ScrollPhysics(),
//              alignment: WrapAlignment.center,
              children: <Widget>[

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: list_branch(),


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


  var id_branch;
  int? selectedRadio;
  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  Widget list_branch(){

    return new ListView.builder(
      shrinkWrap: true,
physics: ScrollPhysics(),
//      padding: EdgeInsets.only(
//        top: 0.0,
//      ),
//      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//          crossAxisCount: 2,
//          childAspectRatio: .80
//      ),
      // SliverGridDelegateWithFixedCrossAxisCount
      controller: controller,
      itemCount: _All == null ? 0 : _All
          .length,
//      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (_, index) {
        return

          Card(
            color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(20)
                ),
//                      side: BorderSide(width: 5, color: Colors.white)
              ),
//              margin: EdgeInsets.all(12),
//              elevation: 1,
              child:
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 70,
                child: Center(
                  child:
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child:
                    Column(
                      children: [


                        Container(

                          child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: InkWell(
//                                  onTap: () =>
//                                  Navigator.push(context,
//                                      MaterialPageRoute(
//                                          builder: (context) =>
//                                              Item_details(
//                                                id_item: _All[index]["id"]
//                                                    .toString(),))
//                                  ),
                                  child: Column(
                                    children: <Widget>[

                                    RadioListTile(
                                    groupValue: selectedRadio,
                                    title: Text(_All[index]["description"].toString()),
                                    value: index,
                                    onChanged: (val) {
                                      setState(() {
                                        print(_All[index]["id"]);
                                        print(_All[index]["description"]);
                                        selectedRadio = int.parse(val.toString());
                                        setSelectedRadio(int.parse(val.toString()));
                                        id_branch=_All[index]["id"];
                                        Navigator.pop(context,true);

                                        text_branch=_All[index]["description"].toString();
                                      });
                                    },

                                  ),



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
    );
  }




  Future<List?> _sendItemData(var orderStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? token = prefs.getString('token');

    //to send order
    ProgressDialog pr = new ProgressDialog(context);
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.show();


//    Map<String,String> timeOutMessage = {'state':'timeout','content':'server is not responding'};
    // orderStatus ==1 >> add    ----- orderStatus ==2 >> save
    try{
      Map<String, dynamic> body = {
        "orderTotal": total,
        "branchLookup": {
          "id": id_branch
        },
        "orderStatus": {
          "id": orderStatus
        },
        "orderDetailsList":_listObject
      };

      debugPrint("?????????");
      print("body is : "+body.toString());
      print("url is : "+URL_LOGIC.send_order);

      final encoding = Encoding.getByName('utf-8');
      String jsonBody = json.encode(body);
//      final headers = {'Content-Type': 'application/json'};
      final headers = {'Content-Type': 'application/json','Authorization':'$token'};
      print("headers : "+headers.toString());
      final response = await http.post(Uri.parse(URL_LOGIC.send_order),
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
        if(datauser["status"]==null){
        if(datauser["errorStatus"]==false || datauser["errorStatus"]=="false"){
          print("object");

          DatabaseHelperFinal databaseHelper = DatabaseHelperFinal();

          var xxx= await databaseHelper.dELETE_All();
          getdatabase();
          Navigator.push(context,MaterialPageRoute(builder: (context) =>CartFinal()),);

//          setState(() {
//          _validate=false;
//          _validate_username=false;
//          if (_formKey.currentState.validate()) {
//            // If the form is valid, display a Snackbar.
////            Scaffold.of(context)
////                .showSnackBar(SnackBar(content: Text(datauser["errorResponsePayloadList"][0]["arabicMessage"])));
//          }
//          _formKey.currentState;
//            _validate=false;
//          });
        }else{
//          saveToken(datauser);
          print("login");

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

//          getRefrich_all();
        }
      });

    });


  }






  Future<Map<String, dynamic>?> getData(var id_item) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String ?token = prefs.getString('token');

    print(URL_LOGIC.find_by_id+"${id_item}");
    isLoading = true;
    setState(() {
      isLoading = true;
    });
    Map<String, String> timeOutMessage = {
      'state': 'timeout',
      'content': 'server is not responding'
    };

    http.Response response_offer = await http.get(
      Uri.parse(URL_LOGIC.find_by_id.toString()+"${id_item.toString()}"),
      headers: {"Authorization":"$token"},
    )
        .timeout(Duration(seconds: 90), onTimeout: () {
      return Future.value(http.Response(json.encode(timeOutMessage), 500));
    }).catchError((err) {
      // nothing
    });
    data_offer = json.decode(response_offer.body);
//    userData_offer = data_offer["bestseller"];
        ;

    setState(() {

      data_offer = json.decode(response_offer.body);
      print(data_offer);

      print(">>>>>>>>>>??????????????_______");
      setState(() {
        data_offer = json.decode(response_offer.body);
        print(data_offer.toString());
//        _settingModalBottomSheet("context", "cartuser", "idItem");
      });

      numpage++;


    });

  }


//   Widget cartUpdates(idItem,cartuser){
// //getData(id_item);
// data_offer==null?Text("data")
// :
// data_offer?["resultData"]==null?Text("data??")
// :
//         Directionality(
//             textDirection: TextDirection.rtl,
//             child:
//             Column(
//
//               children: [
//                 Text("data",style: TextStyle(color: Colors.black),),
//
//                 data_offer!["resultData"]==null?null
//                     :
//                 Container(
//                   color: Colors.white,
//                   child:  Row(
//                     children: [
//                       //color item
//                       data_offer["resultData"]['colorLookup']['imageItem']!=null?  Container(
//                         height: 59,
//                         width: 59,
//                         margin: EdgeInsets.all(11),
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             image: CachedNetworkImageProvider(
//                               data_offer["resultData"]['colorLookup']['imageItem'],
//                             ),
// //                                                              ),
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                       )
//                           :
//                       Container(
//
//                         height: 65,
//                         width: 65,
//                         margin: EdgeInsets.all(11),
//                         decoration: BoxDecoration(
//                           color: Color(int.parse("0xff${data_offer["resultData"]['colorLookup']['colorValue']}")),
//                           borderRadius: BorderRadius.circular(8),
//                           boxShadow: [
//                             BoxShadow(
// //                            color: Color(0x26000000),
//                               offset: Offset(0, 3),
//                               blurRadius: 6,
//                               spreadRadius: 0,
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       Description_item(),
//                     ],
//                   ),
//                 ),
//
//
//
// //                  SizedBox(height: 18,),
//
//                 num_Item_Need(),
//
//                 Container(
//                   padding: EdgeInsets.all(21),
//                   width: MediaQuery.of(context).size.width,
//                   color: Colors.white,
//                   child:   Text("السمك المتاح",
//                       style: TextStyle(
//                         fontFamily: 'Cairo',
//                         color: Color(0xff000000),
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         fontStyle: FontStyle.normal,
//                       )
//                   ),
//                 ),
//                 //list Thickness
//
//
//                 Thickness(),
//
//                 //درجة مقاومة للحريق
//                 Container(
//                   padding: EdgeInsets.all(21),
//                   width: MediaQuery.of(context).size.width,
//                   color: Colors.white,
//                   child:   Text("درجة مقاومة للحريق",
//                       style: TextStyle(
//                         fontFamily: 'Cairo',
//                         color: Color(0xff000000),
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         fontStyle: FontStyle.normal,
//                       )
//                   ),
//                 ),
//                 FireResistanceDegree(),
//
//                 //add to sqlite
//                 InkWell(
//                   onTap: () async =>{
//                     if(id_itemThicknessList!=null){
//                       if(id_itemFireResistanceDegreeList!=null){
//                         save_inSqliute()
//                       }else{
//                         dilogerror("يجب اختيار درجة مقاومة للحريق")
//                       }
// //                       save_inSqliute()
//                     }else{
//                       dilogerror("يجب اختيار السمك")
//                     }
//                   },
//
//                   child:  Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: 55,
//                     color: Color(0xff212660),
//                     padding: EdgeInsets.only(left: 22),
//                     child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text("تم",
//                         style: TextStyle(
//                           fontFamily: 'Cairo',
//                           color: Color(0xffffffff),
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           fontStyle: FontStyle.normal,
//                           letterSpacing: 0.07,
//                         ),
//                         textAlign: TextAlign.left,
//                       ),
//                     ),
//                   ),
//                 )
//
//               ],
//             )
// //            ],
// //          ),
// //        )
//         )
//      ;
//   }

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
                  child: Text("${data_offer?['resultData']['colorLookup']['description']}"
                      + "    "+"${data_offer?['resultData']['colorLookup']['code'].toString()}"
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
              child: Text("${data_offer?['resultData']['itemDescription']}",
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
                  Text("${data_offer?['resultData']['itemPricePerMetter']}",
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
          Text("   الإجمالي :  " +" ${numOfItems*data_offer?['resultData']['itemPricePerMetter'] } "+"  جنيه مصري  ",
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
    print(" length  السمك المتاح >>>${data_offer?['resultData']["itemThicknessList"].length}");
//    print(">>>${data_offer['resultData']["itemThicknessList"][0]["id"].toString()}");
//    int _languageIndex = -1;
    if(data_offer?['resultData']["itemThicknessList"].length > 0) {
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
                  itemCount: data_offer?['resultData']["itemThicknessList"] == null
                      ? 0
                      : data_offer?['resultData']["itemThicknessList"].length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: _buildWidget(
                          data_offer?['resultData']["itemThicknessList"][index]["thicknessLookup"]["description"],
                          index,data_offer?['resultData']["itemThicknessList"][index]["thicknessLookup"]["id"]
                      ),
                      onTap: () => setState(() => {
                        _languageIndex = index,
                        itemThicknessList=data_offer?['resultData']["itemThicknessList"][index]["thicknessLookup"]["description"],
                        id_itemThicknessList=data_offer?['resultData']["itemThicknessList"][index]["thicknessLookup"]["id"],
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
        " length  السمك المتاح >>>${data_offer?['resultData']["itemFireResistanceDegreeList"]
            .length}");
//    print(">>>${data_offer['resultData']["itemThicknessList"][0]["id"].toString()}");
//    int _languageIndex = -1;
    if (data_offer?['resultData']["itemFireResistanceDegreeList"].length > 0) {
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
                  itemCount: data_offer?['resultData']["itemFireResistanceDegreeList"] ==
                      null
                      ? 0
                      : data_offer?['resultData']["itemFireResistanceDegreeList"]
                      .length,
//            crossAxisCount: 2,
//            crossAxisSpacing: 10,
//            mainAxisSpacing: 10,
//            childAspectRatio: 2.4,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: _buildWidget_FireResistanceDegree(
                          data_offer?['resultData']["itemFireResistanceDegreeList"][index]["fireResistanceDegreeLookup"]["description"],
                          index,
                          data_offer?['resultData']["itemFireResistanceDegreeList"][index]["fireResistanceDegreeLookup"]["id"]
                      ),
                      onTap: () =>
                          setState(() =>
                          {
                            _languageIndex_FireResistanceDegree = index,
                            itemFireResistanceDegreeList=data_offer?['resultData']["itemFireResistanceDegreeList"][index]["fireResistanceDegreeLookup"]["description"],
                            id_itemFireResistanceDegreeList=data_offer?['resultData']["itemFireResistanceDegreeList"][index]["fireResistanceDegreeLookup"]["id"],
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
      data_offer?['resultData']['id'].toString(),
      data_offer?['resultData']['colorLookup']['description'].toString(),
      data_offer?['resultData']['colorLookup']['colorValue'].toString(),
      data_offer?['resultData']['colorLookup']['code'].toString(),
      data_offer?['resultData']['itemPricePerMetter'].toString(),
      numOfItems.toString(),
      id_itemThicknessList.toString(),
      itemThicknessList.toString(),
      id_itemFireResistanceDegreeList.toString(),
      itemFireResistanceDegreeList.toString(),
      cartuser["id"].toString(),
      data_offer?['resultData']['imageItem'].toString(),
    );
    dilogerror("save in database");
    Navigator.pop(context);
    Navigator.pop(context, () {
      setState(() {});
    });
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:willbond/feltter/filtterlist.dart';

import 'orders/DraftOrder.dart';
import 'orders/Running_Orders.dart';

class TrackOrder extends StatefulWidget{
  TrackOrder({Key? key, this.id}) : super(key: key);

  final int ?id;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UiTrackOrder();
  }

}


class UiTrackOrder extends State<TrackOrder>{
  int theriGroupVakue = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.id!=null){
      setState(() {
        theriGroupVakue = widget.id!;
      });
    }else{

    }
  }


//  int  colorSelectOne=;
//  int  colorSelectOne=;

  final Map<int, Widget> logoWidgets = <int,Widget>{

    0: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("طلبات مرسلة",
            style: TextStyle(
              fontFamily: 'Cairo',
              color: Color(0xff212660),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,


            )
        ),
    ),

    1: Padding(
      padding: EdgeInsets.all(8.0),
      child:Text("طلبات محفوظة",
          style: TextStyle(
            fontFamily: 'Cairo',
            color: Color(0xff212660),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,


          )
      )
    )
  };



  //>>>>>>>>>>> desgin home
  static Widget giveCenter(String yourText){
    if(yourText.toString().trim()=="Home Page") {
      return RuningOrder();
    }else{
      return DraftOrder();
    }
  }

  List<Widget> bodies = [
    giveCenter("Home Page"),
    giveCenter("Search Page")
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: Text("متابعة الطلبات",
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
//                Padding(padding: EdgeInsets.only(left: 0, right: 0),
//                    child: Container(
//                      decoration: BoxDecoration(
////                border: Border.all(color: Colors.blueAccent,),
////                  border: Border.all(color: Color(0xff4f008d),),
//                        shape: BoxShape.circle,
////                  color: Colors.white,
//
//                      ),
//                      child: IconButton(
//                        iconSize: 40,
//                        icon:  Image.asset('assets/filter_icon.png',color: Color(0xffffffff),fit: BoxFit.cover,),
//                        tooltip: 'Show Snackbar',
//                        onPressed: () {
//                          Navigator.push(context,MaterialPageRoute(builder: (context) => FiltterListHome()),);
////                scaffoldKey.currentState.showSnackBar(snackBar);
//                        },
//                      ),
//                    )
//                ),
              ],

            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 35.0),
              child: Padding(
                  padding: EdgeInsets.only(top: 15.0,bottom: 0.0),

                  child: Container(
                    color:Color(0xff212660),
                    child: Row(

                      children: <Widget>[
                        SizedBox(
                          width: 15.0,
                        ),

                        Expanded(
                          child: CupertinoSlidingSegmentedControl(
                            backgroundColor: Colors.white12,
//                  padding: EdgeInsets.only(top: 11,bottom: 11),
//                  borderColor:Color(0x1f767680),
//                  pressedColor:Color(0x1f767680) ,
//                  unselectedColor:Color(0x1f767680) ,
//                  selectedColor: Colors.white,
                            groupValue:theriGroupVakue,
                            onValueChanged: (changeFromGroupValue){
                              setState(() {
                                print("CupertinoSegmentedControl :  "+changeFromGroupValue.toString());
                                theriGroupVakue =int.parse(changeFromGroupValue.toString());
                              });
                            },
//                  children: logoWidgets,
                            children: logoWidgets,
                          ),
                        ),

                        SizedBox(
                          width: 15.0,
                        ),
                      ],
                    ),
                  )

              ),
            ),
          ),



          body:Container(

            child: Center(
              child: bodies[theriGroupVakue],
            ),
          ),

        )
    );
  }

}
import 'package:flutter/material.dart';


class Favorit_empty extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Ui_Favorit_Empity();
  }

}

class Ui_Favorit_Empity extends State<Favorit_empty>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        children: [

          Image(
            image: AssetImage('assets/cart_empity.png'),
            width: 120,
            height: 120,
          ),

          SizedBox(height: 50,),

          Text('!سلة المشتريات فارغة',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w600,
            ),
            textDirection: TextDirection.rtl,
          ),

          SizedBox(height: 5,),

          Text('لم تضف أي صنف للسلة للآن',
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontFamily: 'Cairo',
            ),
            textDirection: TextDirection.rtl,
          ),



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
    );
  }

}
import 'package:flutter/material.dart';
import 'package:willbond/HOME/Home.dart';


class  CartFinal extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UiCartFinal();
  }

}


class UiCartFinal extends State<CartFinal>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: Color(0xfff3f1f1),
            appBar: AppBar(title: Text("",
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
            ),

            body: ListView(
              children: [
                Column(
                  children: [
                    SizedBox(height: 58),

                    Padding(
                        padding: EdgeInsets.only(left: 55 ,right: 55),
                      child: Text("تم إرسال طلبك وسيتم مراجعته في أقرب وقت ممكن",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Color(0xff212660),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),





                    SizedBox(height: 58),




            Image(image: AssetImage('assets/imgperson.png')),



                    SizedBox(height: 58),


                   InkWell(
                     onTap:()=> {
                       Navigator.pop(context,true),
                       Navigator.pop(context,true)
//                     Navigator.of(context).pushReplacement(MaterialPageRoute(
//                     builder: (BuildContext context) =>  Home())),
                     },
                     child:  Container(
                         margin: EdgeInsets.only(left: 55,right: 55),
                         width: MediaQuery.of(context).size.width,
                         height: 45,
                         decoration: new BoxDecoration(
                             color: Color(0xff212660),
                             borderRadius: BorderRadius.circular(23)
                         ),

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
                         )
                     ),
                   )



                  ],
                )
              ],
            )

        )
    );
  }

}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'package:url_launcher/url_launcher.dart';
//import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
class CinnectUs extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UiCinnectUs();
  }

}

class UiCinnectUs extends State<CinnectUs>{
  String? url;

//   callphone(String call) async {
//     print("call");
//     url = "tel:$call";
//     if (await canLaunch(url)) {
//     await launch(url);
//     } else
//     {
//     throw 'Could not launch $url';
//     }
//  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Directionality(textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              title: Text("اتصل بنا",
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


            body:
            Padding(padding: EdgeInsets.all(17),
              child: ListView(
                children: [


                  SizedBox(
                    height: 17,
                  ),

                  Container(
                    padding: EdgeInsets.all(11),
                    // height: 216,
                    decoration: BoxDecoration(
                      color: Color(0xfffbfbfb),
                      border: Border.all(
                        color: Colors.black12,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),


                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text('الفرع الرئيسي',
                          style: TextStyle(
                            color: Color(0xde000000),
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                        ),


                        Divider(
                          color: Colors.black12,
                        ),

//                        Icon(Icons.add_call,color:Colors.white,)

                      SizedBox(height: 11,),

                        //العنوان
                        InkWell(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.location_on,color:Colors.black,),

                              Padding(padding: EdgeInsets.only(right: 11),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("العنوان",
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          color: Color(0xff000000),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal,
                                        )
                                    ),

                                    Text("22 عمارات المروة, أحمد تيسير بجوار كلية البنات, مصر الجديدة",
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          color: Color(0xff000000),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                        )
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 22,
                        ),



                        //رقم الجوال
                       callPhone("+202-26900177"),
                        SizedBox(
                          height: 12,
                        ),
                       callPhone("+202-24194139"),
                        SizedBox(
                          height: 12,
                        ),
                       callPhone("+202-24194137"),
                        SizedBox(
                          height: 12,
                        ),
                       email("info@wellbond.com.eg"),
                        SizedBox(
                          height: 12,
                        ),
                        location(),
                      ],
                    ),
                  ),


                  SizedBox(
                    height: 25,
                  ),

//                   Container(
//                     padding: EdgeInsets.all(11),
//                     height: 216,
//                     decoration: BoxDecoration(
//                       color: Color(0xfffbfbfb),
//                       border: Border.all(
//                         color: Colors.black12,
//                         width: 1,
//                       ),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//
//
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//
//                         Text('فروع أخرى',
//                           style: TextStyle(
//                             color: Color(0xde000000),
//                             fontFamily: 'Cairo',
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//
//
//                         Divider(
//                           color: Colors.black12,
//                         ),
//
// //                        Icon(Icons.add_call,color:Colors.white,)
//
//                         SizedBox(height: 11,),
//
//                         //العنوان
//                         InkWell(
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Icon(Icons.location_on,color:Colors.black,),
//
//                               Padding(padding: EdgeInsets.only(right: 11),
//
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text("العنوان",
//                                         style: TextStyle(
//                                           fontFamily: 'Cairo',
//                                           color: Color(0xff000000),
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w600,
//                                           fontStyle: FontStyle.normal,
//                                         )
//                                     ),
//
//                                     Text("مصر - القاهرة - شارع أحمد تيسير (بناية المروة)",
//                                         style: TextStyle(
//                                           fontFamily: 'Cairo',
//                                           color: Color(0xff000000),
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w400,
//                                           fontStyle: FontStyle.normal,
//                                         )
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//
//                         SizedBox(
//                           height: 22,
//                         ),
//
//
//
//                         //رقم الجوال
//                         InkWell(
// //                         onTap:
// ////                    _openMap(),
// //                             () async =>
// //                         {
// //                        url ='https://www.free-point.club/apps/api/clinets/facebook',
// //                           url = "tel:" + phoneString,
// //                           if (await canLaunch(url)) {
// //                             await launch(url),
// //                           } else
// //                             {
// //                               throw 'Could not launch $url',
// //                             }
// //                         },
// //                         onTap: () async =>{
// //                           print("object"),
// ////                         const number = '08592119XXXX', //set the number h
// //                            await FlutterPhoneDirectCaller.callNumber('0101 666  2216"'),
// //                         },
//                         onTap: () =>_launchCaller("(+20)102 986 111"),
//                           child:  Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Icon(Icons.phone_android,color:Colors.black,),
//
//                               Padding(padding: EdgeInsets.only(right: 11),
//
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text("رقم الجوال",
//                                         style: TextStyle(
//                                           fontFamily: 'Cairo',
//                                           color: Color(0xff000000),
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w600,
//                                           fontStyle: FontStyle.normal,
//                                         )
//                                     ),
//
//                                     Text(
//                                         "(+20)102 986 111",
//                                         // "(+20)102 986 111",
//                                         style: TextStyle(
//                                           fontFamily: 'Cairo',
//                                           color: Color(0xff000000),
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w400,
//                                           fontStyle: FontStyle.normal,
//                                         ),
//                                       textDirection: TextDirection.ltr,
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),

                ],
              ),
            )

        )
    );
  }


  _launchCaller(String phone) async {
    var url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  callPhone(String phone) {
    return InkWell(

      onTap: () =>_launchCaller(phone),
      child:  Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.call,color:Colors.black,),

          Padding(padding: EdgeInsets.only(right: 11),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text("رقم الهاتف",
                //     style: TextStyle(
                //       fontFamily: 'Cairo',
                //       color: Color(0xff000000),
                //       fontSize: 13,
                //       fontWeight: FontWeight.w600,
                //       fontStyle: FontStyle.normal,
                //     )
                // ),

                Text(
                  // "01016662216",
                  phone,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xff000000),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  email(String phone) {
    return InkWell(

      onTap: () => {
        Clipboard.setData(new ClipboardData(text: phone))
      },
      child:  Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.mail,color:Colors.black,),

          Padding(padding: EdgeInsets.only(right: 11),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text("رقم الهاتف",
                //     style: TextStyle(
                //       fontFamily: 'Cairo',
                //       color: Color(0xff000000),
                //       fontSize: 13,
                //       fontWeight: FontWeight.w600,
                //       fontStyle: FontStyle.normal,
                //     )
                // ),

                Text(
                  // "01016662216",
                  phone,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xff000000),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  location() {
    return InkWell(

      onTap: () => {
      },
      child:  Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.timelapse_outlined,color:Colors.black,),

          Padding(padding: EdgeInsets.only(right: 11),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text("رقم الهاتف",
                //     style: TextStyle(
                //       fontFamily: 'Cairo',
                //       color: Color(0xff000000),
                //       fontSize: 13,
                //       fontWeight: FontWeight.w600,
                //       fontStyle: FontStyle.normal,
                //     )
                // ),

                Text(
                  // "01016662216",
                  "الأحد - الخميس: 9 ص-5 م",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xff000000),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}
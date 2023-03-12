// import 'package:flutter/material.dart';
//
// import '../URL_LOGIC.dart';
// import '../progress_dialog.dart';
// import 'Login.dart';
//
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class SignUp extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//    return UISignUp();
//   }
//
// }
//
//
// class UISignUp extends State<SignUp>{
//
//   /*
//    "email":"admin@gmail.com",
//     "fullName":"Magdy Hassan" ,
//     "password":"123Aa" ,
//     "phoneNumber" :"01064179598",
//     "role":[
//         {
//             "id" : 1
//         }
//     ]
//    */
//   bool _validate = false;
//   bool _validate_username = false;
//   bool _validate_phone = false;
//   bool _validate_email = false;
//   bool _validate_address = false;
//
//   TextEditingController name=new TextEditingController();
//   TextEditingController phone=new TextEditingController();
//   TextEditingController address=new TextEditingController();
//
//   TextEditingController email=new TextEditingController();
//   TextEditingController password=new TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   ProgressDialog? pr;
//   Future<List?> _sendItemData() async {
//
//     //to send order
//     ProgressDialog pr;
//     pr = new ProgressDialog(context);
//     pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
//     pr.show();
// //    Map<String,String> timeOutMessage = {'state':'timeout','content':'server is not responding'};
//     try{
//       Map<String, dynamic> body = {
//         "email":email.text.toString().trim(),
//         "fullName":name.text.toString().trim(),
//         "password":password.text.toString().trim(),
//         "phoneNumber" :phone.text.toString().trim(),
//         "role":[
//           {
//             "id" :1
//           }
//         ]
//       };
//
//       debugPrint("?????????");
//       print("body is :"+body.toString());
//       print("url is :"+URL_LOGIC.signUp);
//
//       final encoding = Encoding.getByName('utf-8');
//       String jsonBody = json.encode(body);
//       final headers = {'Content-Type': 'application/json'};
//       final response = await http.post(
//           Uri.parse(URL_LOGIC.signUp),
//         body:jsonBody,
//         encoding: encoding,
//         headers: headers,
//       );
//       //"message":"You Logined To Your Account ."
//       var datauser = json.decode(response.body);
// //      var code=datauser["code"];
// //      var actions=datauser["action"];
//       debugPrint(datauser.toString());
//
//
// //      debugPrint("message >>> "+actions);
//
//
//
//       Future.delayed(Duration(seconds: 1)).then((value) {
//         pr.hide();
//
//         if(datauser["errorStatus"]==true || datauser["errorStatus"]=="true"){
//           print("object");
// //          setState(() {
//           _validate=false;
//           _validate_username=false;
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return   AlertDialog(
//                 title: null,
//                 content: Text("${datauser["errorResponsePayloadList"][0]["arabicMessage"]}",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontFamily: 'Cairo',
// //                      color: Color(0xffffffff),
//                       fontSize: 12,
//                       fontWeight: FontWeight.w400,
//                       fontStyle: FontStyle.normal,
//                     )),
//                 actions: [
// //            okButton,
//                 ],
//               );
//             },
//           );
//           if (_formKey.currentState!.validate()) {
//             // If the form is valid, display a Snackbar.
// //            Scaffold.of(context)
// //                .showSnackBar(SnackBar(content: Text(datauser["errorResponsePayloadList"][0]["arabicMessage"])));
//           }
// //          _formKey.currentState;
// //            _validate=false;
// //          });
//         }else if(datauser["errorStatus"]==false || datauser["errorStatus"]=="false"){
//           _validate=false;
//           _validate_username=false;
//
//           _validate_phone=false;
//           _validate_address=false;
//           _validate_email=false;
//           _validate_email=false;
// //          _formKey.currentState;
//           Navigator.push(
//             context, MaterialPageRoute(builder: (context) => Login()));
//         }else{
//           _validate=true;
//           _validate_username=true;
//
//           _validate_phone=true;
//           _validate_address=true;
//           _validate_email=true;
//           _validate_email=true;
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return   AlertDialog(
//                 title: null,
//                 content: Text("يجب التاكد من المدخلات"),
//                 actions: [
// //            okButton,
//                 ],
//               );
//             },
//           );
//         }
//
//
//       });
//
// //      if(datauser["code"]=="009"){
// //
// //        SharedPreferences prefs = await SharedPreferences.getInstance();
// //        prefs.setString('idUser', datauser["userid"]);
// //
// //        Navigator.push(
// //            context, MaterialPageRoute(builder: (context) => HomApp()));
// //      }else{
// //        showDilogFieldLogin(datauser["message"]);
// //      }
//
//
//
//     }catch(exception){
//       Future.delayed(Duration(seconds: 3)).then((value) {
//         pr.hide();
// //            _validate_username=true;
// //            _validate=true;
//         setState(() {
//           print("object ??"+exception.toString());
//           pr.hide().then((isHidden) {
//             print(isHidden);
//           });
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return   AlertDialog(
//                 title: null,
//                 content: Text("يرجي التاكد من الاتصال بل النترنت"),
//                 actions: [
// //            okButton,
//                 ],
//               );
//             },
//           );
// //            Navigator.pop(context, true);
//         });
//       });
//
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       backgroundColor: Color(0xff212660),
//       appBar: null,
//       body:
//       Directionality(
//           textDirection: TextDirection.rtl,
//           child: Padding(
//               padding: EdgeInsets.only(
//                   left: 17, right: 17, top: 35, bottom: 35),
//               child: Container(
//                   height: MediaQuery
//                       .of(context)
//                       .size
//                       .height,
//                   width: MediaQuery
//                       .of(context)
//                       .size
//                       .width,
//                   decoration: new BoxDecoration(
//                     color: Color(0xffffffff),
//                     borderRadius: BorderRadius.circular(15),
//                     boxShadow: [BoxShadow(
//                         color: Color(0x29000000),
//                         offset: Offset(0, 3),
//                         blurRadius: 6,
//                         spreadRadius: 0
//                     )
//                     ],
//                   ),
//                   child: Padding(padding: EdgeInsets.only(left: 17, right: 17),
//                     child: Form(
//                       key: _formKey,
//                       child:ListView(
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//
//                               Center(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisSize: MainAxisSize.max,
//                                   children: [
//
//                                     //حساب  جديد
//                                     Container(
//                                       margin: EdgeInsets.only(
//                                           left: 17, right: 17, top: 17, bottom: 5),
//                                       width: 100,
//                                       height: 100,
//                                       decoration: BoxDecoration(
// //                      color: Colors.black,
//                                         image: DecorationImage(
//                                             image: new AssetImage(
//                                                 'assets/logo.png'),
//                                             //image: NetworkImage('https://images.unsplash.com/photo-1547665979-bb809517610d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=675&q=80'),
//                                             fit: BoxFit.fill
//                                         ),
//                                       ),
// //                        child: Image(image: AssetImage('assets/logo.png'),fit: BoxFit.fill,height: 100,width: 100,)
//                                     ),
//                                     new Text("حساب  جديد",
//                                         style: TextStyle(
//                                           color: Color(0xff212660),
//                                           fontSize: 16,
//                                           fontFamily: 'Cairo',
//                                           fontWeight: FontWeight.w400,
//                                           fontStyle: FontStyle.normal,
//                                         )
//                                     ),
//                                   ],
//                                 ),
//                               ),
//
//
//                               SizedBox(height: 20,),
//
//                               //name
//                               TextFormField(
//                                 onEditingComplete: () => FocusScope.of(context).nextFocus(),
//                                 controller: name,
//                                 validator: (val) {
//                                   if (val!.isEmpty) {
//                                     return  'الاسم كاملاً';
//                                   }
//                                   return null;
//                                 },
//                                 decoration: InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   labelText: 'الاسم كاملاً',
//                                   hintText:  'الاسم كاملاً',
//                                   errorText: _validate_username ? "يرجي التاكد من الاسم كاملاً" : null,
//                                   hintStyle: TextStyle(
//                                     fontFamily: 'Cairo',
//                                     color: Color(0xff212660),
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w400,
//                                     fontStyle: FontStyle.normal,
//                                   )
//                                 ),
//                                   style: TextStyle(
//                                     fontFamily: 'Cairo',
//                                     color: Color(0xff212660),
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w400,
//                                     fontStyle: FontStyle.normal,
//                                   )
//                               ),
//
//                               SizedBox(height: 20,),
//
//
//                               //phone
//                               TextFormField(
//                                 onEditingComplete: () => FocusScope.of(context).nextFocus(),
//                                 controller: phone,
//                                 validator: (val) {
//                                   if (val!.isEmpty) {
//                                     return  'رقم الموبايلً';
//                                   }
//                                   return null;
//                                 },
//                                 decoration: InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   labelText: 'رقم الموبايل',
//                                   hintText:  'رقم الموبايل',
//                                   errorText: _validate_phone ? "يرجي التاكد من رقم الموبايل" : null,
//
//                                     hintStyle: TextStyle(
//                                       fontFamily: 'Cairo',
//                                       color: Color(0xff212660),
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w400,
//                                       fontStyle: FontStyle.normal,
//                                     )
//                                 ),
//                                   style: TextStyle(
//                                     fontFamily: 'Cairo',
//                                     color: Color(0xff212660),
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w400,
//                                     fontStyle: FontStyle.normal,
//                                   )
//                               ),
//
//                               SizedBox(height: 20,),
//
//                               //phone
//                               TextFormField(
//                                 onEditingComplete: () => FocusScope.of(context).nextFocus(),
//                                 controller: email,
//                                 validator: (val) {
//                                   if (val!.isEmpty) {
//                                     return  'البريد الالكتروني';
//                                   }
//                                   return null;
//                                 },
//                                 decoration: InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   labelText: 'البريد الالكتروني',
//                                   hintText:  'البريد الالكتروني',
//                                   errorText: _validate_email ? "يرجي التاكد من البريد الالكتروني" : null,
//                                     hintStyle: TextStyle(
//                                       fontFamily: 'Cairo',
//                                       color: Color(0xff212660),
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w400,
//                                       fontStyle: FontStyle.normal,
//                                     )
//                                 ),
//                                   style: TextStyle(
//                                     fontFamily: 'Cairo',
//                                     color: Color(0xff212660),
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w400,
//                                     fontStyle: FontStyle.normal,
//                                   )
//                               ),
//
//                               SizedBox(height: 20,),
//
//                               //address
//                               TextFormField(
//                                 onEditingComplete: () => FocusScope.of(context).nextFocus(),
//                                 controller: address,
//                                 validator: (val) {
//                                   if (val!.isEmpty) {
//                                     return  'العنوان';
//                                   }
//                                   return null;
//                                 },
//                                 decoration: InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   labelText: 'العنوان',
//                                   hintText:  'العنوان',
//                                   errorText: _validate_address ? "يرجي التاكد من العنوان" : null,
//                                     hintStyle: TextStyle(
//                                       fontFamily: 'Cairo',
//                                       color: Color(0xff212660),
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w400,
//                                       fontStyle: FontStyle.normal,
//                                     )
//                                 ),
//                                   style: TextStyle(
//                                     fontFamily: 'Cairo',
//                                     color: Color(0xff212660),
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w400,
//                                     fontStyle: FontStyle.normal,
//                                   )
//                               ),
//
//                               SizedBox(height: 20,),
//
//                               //password
//                               TextFormField(
//                                 onEditingComplete: () => FocusScope.of(context).nextFocus(),
//                                 controller: password,
//                                 obscureText: true,
//                                 validator: (val) {
//                                   if (val!.isEmpty) {
//                                     return  'الرقم السري';
//                                   }
//                                   return null;
//                                 },
//                                 decoration: InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   labelText: 'الرقم السري',
//                                   hintText:  'الرقم السري',
//                                   errorText: _validate ? "يرجي التاكد من الرقم السري" : null,
//                                     hintStyle: TextStyle(
//                                       fontFamily: 'Cairo',
//                                       color: Color(0xff212660),
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w400,
//                                       fontStyle: FontStyle.normal,
//                                     )
//                                 ),
//                                   style: TextStyle(
//                                     fontFamily: 'Cairo',
//                                     color: Color(0xff212660),
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                     fontStyle: FontStyle.normal,
//                                   )
//                               ),
//
//                               SizedBox(height: 11,),
//                               RichText(
//                                   text: new TextSpan(
//                                       children: [
//
//                                         new TextSpan(
//                                             text: "بمجرد تسجيلك في التطبيق فأنت موافق على ",
//                                             style: TextStyle(
//                                               fontFamily: 'Cairo',
//                                               color: Color(0xff000000),
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.w400,
//                                               fontStyle: FontStyle.normal,
//                                               letterSpacing: 0.325,
//
//                                             )
//                                         ),
//                                         new TextSpan(
//                                             text: "سياسة الخصوصية وشروط الاستخدام ",
//                                             style: TextStyle(
//                                               fontFamily: 'Cairo',
//                                               color: Color(0xff212660),
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.w400,
//                                               fontStyle: FontStyle.normal,
//                                               letterSpacing: 0.325,
//
//                                             )
//                                         ),
//                                       ]
//                                   )
//                               ),
//
//
//                               // login
//                               new Padding(
//                                 padding: EdgeInsets.only(
//                                     left: 15, right: 15, top: 60),
//                                 child: Material(
//                                     borderRadius: BorderRadius.circular(4.0),
//                                     color: Color(0xff212660),
//                                     elevation: 0.0,
//                                     child: MaterialButton(
//                                         onPressed: () {
//                                           if (_formKey.currentState!.validate()) {
//                                       _sendItemData();
//                                           }
// //                                check();
//                                         },
//                                         minWidth: MediaQuery
//                                             .of(context)
//                                             .size
//                                             .width,
//                                         child: Text("تسجيل",
//                                             style: TextStyle(
//                                               fontFamily: 'Cairo',
//                                               color: Color(0xffffffff),
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.w400,
//                                               fontStyle: FontStyle.normal,
// //                                              letterSpacing: 0.14,
//                                             )
//                                         )
//                                     )),
//                               ),
//
//
//                               SizedBox(height: 16,),
//                               InkWell(
//                                 onTap: () =>
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(builder: (context) =>
//                                           Login()),
//                                     ),
//                                 child: Center(
//                                   child: Text("تسجيل دخول",
//                                       style: TextStyle(
//                                         fontFamily: 'Cairo',
//                                         color: Color(0xff212660),
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w400,
//                                         fontStyle: FontStyle.normal,
//
//
//                                       )
//                                   ),
//                                 ),
//                               ),
//
//
//                               SizedBox(height: 90,),
//
//                             ],
//                           ),
//                         ],
//                       )
//
//                     ),
//                   )
//
//               )
//           )
//       ),
//     );
//   }
//
// }
// import 'dart:async';
// import 'dart:io';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart';
//
//
// class DatabaseHelper{
//   static Database _db;
//   final String cartTable = 'cartTable';
//   final String columnId = 'id';
//
//   //idItem,nameitem,colorItem,codeItem,priceItem,num_ofItem,id_itemThicknessList,itemThicknessList,
//   // id_itemFireResistanceDegreeList,itemFireResistanceDegreeList
//   final String idItem = 'idItem';
//   final String colorItem = 'colorItem';
//   final String nameItem = 'nameItem';
//   final String codeItem = 'codeItem';
//   final String priceItem = 'priceItem';
//   final String num_ofItem = 'num_ofItem';
//
//   final String id_itemThicknessList = 'id_itemThicknessList';
//   final String itemThicknessList = 'itemThicknessList';
//
//   final String id_itemFireResistanceDegreeList = 'id_itemFireResistanceDegreeList';
//   final String itemFireResistanceDegreeList = 'itemFireResistanceDegreeList';
//
//   Future<Database> get db async{
//     if(_db != null){
//       return _db;
//     }
//     _db = await intDB();
//     return _db;
//   }
//
// //  intDB() async{
// //    print("create table");
// //    String dbPath = await getDatabasesPath();
// //
// //    Directory documentDirectory = await getApplicationDocumentsDirectory();
// //    String path = join(documentDirectory.path , 'mydbwill.db');
// //    var myOwnDB = await openDatabase(
// //        path,
// //        version: 1,
// //        onCreate: _onCreate);
// //    return myOwnDB;
// //  }
//
//   intDB() async{
//     Directory documentDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentDirectory.path , 'mydbwillbound.db');
//     var myOwnDB = await openDatabase(
//         path,
//         version: 2,
//         onCreate: _onCreate);
//     return myOwnDB;
//   }
//
//   void _onCreate(Database db , int newVersion) async{
//     print(">>?");
//     var sql = "CREATE TABLE $cartTable ($columnId INTEGER PRIMARY KEY,"
//         " $idItem TEXT, $colorItem TEXT, $nameItem TEXT, $codeItem TEXT ,"
//         " $priceItem TEXT , $num_ofItem TEXT, "
//         " $id_itemThicknessList TEXT, $itemThicknessList TEXT,"
//         " $id_itemFireResistanceDegreeList TEXT , $itemFireResistanceDegreeList TEXT  )";
//     await db.execute(sql);
//   }
//
//
//
//   Future<int> saveUser( idItem,username,colorItem,codeItem,priceItem,num_ofItem,id_itemThicknessList,itemThicknessList
//       ,id_itemFireResistanceDegreeList,itemFireResistanceDegreeList) async{
//     print("start save");
//     var dbClient = await  db;
//     int result = await dbClient.insert("$cartTable",  {
//       'idItem':idItem,
//       'nameitem':username,
//       'colorItem':colorItem,
//       'codeItem':codeItem,
//       'priceItem':priceItem,
//       'num_ofItem':num_ofItem,
//       'id_itemThicknessList':id_itemThicknessList,
//       'itemThicknessList':itemThicknessList,
//       'id_itemFireResistanceDegreeList':id_itemFireResistanceDegreeList,
//       'itemFireResistanceDegreeList':itemFireResistanceDegreeList,
//     } );
//     return result;
//   }
//
//
//   Future<int> getCount(var idItem_fromitems) async{
//     var dbClient = await  db;
//     var sql = "SELECT COUNT(*) FROM $cartTable WHERE $idItem =$idItem_fromitems ";
//
//     return  Sqflite.firstIntValue(await dbClient.rawQuery(sql)) ;
//   }
//
//
// }
//

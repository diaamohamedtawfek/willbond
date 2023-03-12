

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelperFinal {

  static DatabaseHelperFinal? _databaseHelper;    // Singleton DatabaseHelper
  static Database? _database;                // Singleton Database

//  String noteTable = 'note_table';
//  String colId = 'id';
//  String colTitle = 'title';
//  String colDescription = 'description';
//  String colPriority = 'priority';
//  String colDate = 'date';


  final String cartTable = 'cartTablee';
  final String columnId = 'id';

  //idItem,nameitem,colorItem,codeItem,priceItem,num_ofItem,id_itemThicknessList,itemThicknessList,
  // id_itemFireResistanceDegreeList,itemFireResistanceDegreeList
  final String idItem = 'idItem';
  final String colorItem = 'colorItem';
  final String imageItem = 'imageItem';
  final String nameItem = 'nameItem';
  final String codeItem = 'codeItem';
  final String priceItem = 'priceItem';
  final String num_ofItem = 'num_ofItem';

  final String id_itemThicknessList = 'id_itemThicknessList';
  final String itemThicknessList = 'itemThicknessList';

  final String id_itemFireResistanceDegreeList = 'id_itemFireResistanceDegreeList';
  final String itemFireResistanceDegreeList = 'itemFireResistanceDegreeList';

  DatabaseHelperFinal._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelperFinal() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelperFinal._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'textcart.db';

    // Open/create the database at a given path
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute("CREATE TABLE $cartTable ($columnId INTEGER PRIMARY KEY,"
        " $idItem TEXT, $colorItem TEXT, $nameItem TEXT, $codeItem TEXT ,"
        " $priceItem TEXT , $num_ofItem TEXT, "
        " $id_itemThicknessList TEXT, $itemThicknessList TEXT , $imageItem TEXT,"
        " $id_itemFireResistanceDegreeList TEXT , $itemFireResistanceDegreeList TEXT)");
  }


  Future<dynamic> saveUser( idItem,username,colorItem,codeItem,priceItem,num_ofItem,id_itemThicknessList,itemThicknessList
      ,id_itemFireResistanceDegreeList,itemFireResistanceDegreeList,imageItem) async{
    print("start save");
//    var dbClient = await  db;

    var map = Map<String, dynamic>();
//    map['title'] = _title;
    map['idItem']=idItem;
    map ['nameitem']=username;
    map['colorItem']=colorItem;
    map ['codeItem']=codeItem;
    map ['priceItem']=priceItem;
    map ['num_ofItem']=num_ofItem;
    map['id_itemThicknessList']=id_itemThicknessList;
    map['itemThicknessList']=itemThicknessList;
    map['id_itemFireResistanceDegreeList']=id_itemFireResistanceDegreeList;
    map['itemFireResistanceDegreeList']=itemFireResistanceDegreeList;
    map['imageItem']=imageItem;

    Database db = await this.database;
    int result = await db.insert("$cartTable",  map
    );
    print("resjlt  $result");
    return result;
  }




  Future<int> update(idItem,username,colorItem,codeItem,priceItem,num_ofItem,id_itemThicknessList,itemThicknessList
      ,id_itemFireResistanceDegreeList,itemFireResistanceDegreeList, id_database,imageItem) async {

    var map = Map<String, dynamic>();
//    map['title'] = _title;
    map['idItem']=idItem;
    map ['nameitem']=username;
    map['colorItem']=colorItem;
    map ['codeItem']=codeItem;
    map ['priceItem']=priceItem;
    map ['num_ofItem']=num_ofItem;
    map['id_itemThicknessList']=id_itemThicknessList;
    map['itemThicknessList']=itemThicknessList;
    map['id_itemFireResistanceDegreeList']=id_itemFireResistanceDegreeList;
    map['itemFireResistanceDegreeList']=itemFireResistanceDegreeList;
    map['imageItem']=imageItem;
//    map['id']=id_database;
    dynamic xx=id_database;

    final db = await database;

    return await db.update(
      cartTable,
      map,
      where: "id = ?",
      whereArgs: [xx],
    );
  }





  Future<int?> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $cartTable');
    int? result = Sqflite.firstIntValue(x);
//    db.close();
    return result;
  }

  Future<Map?> getUser() async{
    Database db = await this.database;
    var dbClient =   db;
//    var dbClient = await  db;
    var sql = "SELECT * FROM $cartTable ";
    var result = await dbClient.rawQuery(sql);
    if(result.length == 0) return null;
    return  result.first ;
  }

  Future<List> getAllUsers() async{
    Database db = await this.database;
    var dbClient = await  db;
    var sql = "SELECT * FROM $cartTable";
    List result = await dbClient.rawQuery(sql);

//    db.close();

    return result.toList();
  }

//  DELETE FROM `movies` WHERE `movie_id` = 18;

  Future<List> dELETE(var id) async{
    Database db = await this.database;
    var dbClient =   db;
//    var dbClient = await  db;
    var sql = "DELETE  FROM $cartTable  WHERE id=$id";
    List result = await dbClient.rawQuery(sql);

//    db.close();

    return result.toList();
  }

  Future<List> dELETE_All() async{
    Database db = await this.database;
    var dbClient = await  db;
    var sql = "DELETE  FROM $cartTable";
    List result = await dbClient.rawQuery(sql);

//    db.close();

    return result.toList();
  }

// Update Operation: Update a Note object and save it to database
//  Future<int> updateNote(Note note) async {
//    var db = await this.database;
//    var result = await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
//    return result;
//  }

// Delete Operation: Delete a Note object from database
//  Future<int> deleteNote(int id) async {
//    var db = await this.database;
//    int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
//    return result;
//  }

// Get number of Note objects in database
//  Future<int> getCount() async {
//    Database db = await this.database;
//    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $noteTable');
//    int result = Sqflite.firstIntValue(x);
//    return result;
//  }

// Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
//  Future<List<Map>> getNoteList() async {
//
////    var noteMapList = await getNoteMapList(); // Get 'Map List' from database
//    int count = noteMapList.length;         // Count the number of map entries in db table
//
//    List<Map> noteList = List<Map>();
//    // For loop to create a 'Note List' from a 'Map List'
//    for (int i = 0; i < count; i++) {
//      noteList.add(Note.fromMapObject(noteMapList[i]));
//    }
//
//    return noteList;
//  }

}
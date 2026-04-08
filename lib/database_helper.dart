
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{

  DbHelper._();
  static final DbHelper getinstance = DbHelper._();

  static final TABLE_TASK = "table_task";
  static final COLUMN_ID = "id";
  static final COLUMN_TASK = "task";
  static final COLUMN_IS_DONE = "is_done";

  Database? mydb;
  
  Future<Database> getDB()async{

    if(mydb!=null){

      return mydb!;
    }else{

      mydb = await openDB();
      return mydb!;
    }

  }

  Future<Database> openDB()async{

    Directory dirpath = await getApplicationDocumentsDirectory();
    String dbPath = join(dirpath.path,"todoDB.db");

    return await openDatabase(dbPath, onCreate:(db,version){

      db.execute('''Create table $TABLE_TASK(

          $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
          $COLUMN_TASK TEXT,
          $COLUMN_IS_DONE INTEGER
      ) '''
      );

    },version: 1 );
  }

    // 1. INSERT

    Future<bool> addTask({required String task})async{

      var db = await getDB();

      int rowsaffected = await db.insert(TABLE_TASK,{
        COLUMN_TASK:task,
        COLUMN_IS_DONE:0
      });

      return rowsaffected>0;
    }

    // 2. Read

    Future<List<Map<String,dynamic>>> getallTask()async{

      var db = await getDB();
      return await db.query(TABLE_TASK);
    }

    // 3. Update Task

    Future<bool> updateTask({required int id, required String task})async{

      var db = await getDB();

      int rowsaffected = await db.update(TABLE_TASK, {
        COLUMN_TASK:task
      },where: "$COLUMN_ID=?",whereArgs: [id]);

      return rowsaffected>0;

    }
    // 4. Delete

    Future<bool> deleteTask({required int id})async{

      var db = await getDB();

      int rowsaffected = await db.delete(TABLE_TASK,where: "$COLUMN_ID =?",whereArgs: [id]);
      return rowsaffected>0;

    }

    // 5. Update Task status

    Future<void> updateTaskStatus({
      required int id,
      required int isdone,
    })async{

      var db = await getDB();

      await db.update(TABLE_TASK, {
        COLUMN_IS_DONE:isdone
      },where: "$COLUMN_ID=?",
      whereArgs: [id]);
    }
}
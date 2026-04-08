
import 'package:sqflite/sqflite.dart';

class DbHelper{

  DbHelper._();

  static final DbHelper getinstance = DbHelper._();

  Database? mydb;
}
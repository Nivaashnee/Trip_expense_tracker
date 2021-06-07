import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  //
  //Trips

  static Future<Database> databaseTrips() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'tripsDsss.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE trips(id TEXT PRIMARY KEY , name TEXT , description TEXT, currency TEXT)');
    }, version: 1);
  }

  static Future<void> insertTrip(String table, Map<String, Object> data) async {
    final db = await DBHelper.databaseTrips();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteTrips(
      String table, Map<String, Object> data) async {
    final dbTrip = await DBHelper.databaseTrips();

    dbTrip.delete(
      table,
      where: 'id = ?',
      whereArgs: [
        data['id'],
      ],
    );
  }

  static Future<void> updateTrips(
      String table, Map<String, Object> data) async {
    final db = await DBHelper.databaseTrips();

    db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [
        data['id'],
      ],
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getTrip(String table) async {
    final db = await DBHelper.databaseTrips();
    return db.query(table);
  }

  // // // // // // // // // // // // // //
  // Participants

  static Future<Database> databaseParticipants() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'participantssss.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE participants(pid TEXT PRIMARY KEY , tid TEXT , participant TEXT)');
    }, version: 1);
  }

  static Future<void> insertPart(String table, Map<String, Object> data) async {
    final db = await DBHelper.databaseParticipants();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

 //static Future<void> updateParticipants(
 //    String table, Map<String, Object> data) async {
 //  final db = await DBHelper.databaseParticipants();
 //
 //  db.update(
 //    table,
 //    data,
 //    where: 'tid = ?',
 //    whereArgs: [
 //      data['tid'],
 //    ],
 //    conflictAlgorithm: sql.ConflictAlgorithm.replace,
 //  );
 //}

  static Future<void> deleteTrPart(
      String table, Map<String, Object> data) async {
    final db = await DBHelper.databaseParticipants();

    db.delete(
      table,
      where: 'tid = ?',
      whereArgs: [
        data['tid'],
      ],
    );
  }

  static Future<List<Map<String, dynamic>>> getPart(String table) async {
    final db = await DBHelper.databaseParticipants();
    return db.query(table);
  }

  // // // // // // // // // // // // // // // //
  // Transactions

  static Future<Database> databaseTransaction() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'transactionsssss.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE transactions(tranId TEXT PRIMARY KEY , tid TEXT , transTitle TEXT, pid TEXT, paidBy TEXT, date TEXT, amount TEXT)');
    }, version: 1);
  }

  static Future<void> insertTransaction(
      String table, Map<String, Object> data) async {
    final db = await DBHelper.databaseTransaction();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteTrTrans(
      String table, Map<String, Object> data) async {
    final db = await DBHelper.databaseTransaction();

    db.delete(
      table,
      where: 'tid = ?',
      whereArgs: [
        data['tid'],
      ],
    );
  }

  static Future<void> deleteTransaction(
      String table, Map<String, Object> data) async {
    final db = await DBHelper.databaseTransaction();

    db.delete(
      table,
      where: 'tranId = ?',
      whereArgs: [
        data['tranId'],
      ],
    );
  }

  static Future<List<Map<String, dynamic>>> getTransaction(String table) async {
    final db = await DBHelper.databaseTransaction();
    return db.query(table);
  }

  // // // // // // // // // // // // // // // //
  // Participant acct

  static Future<Database> databaseParAcct() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'parAcctous.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE parAccts(id TEXT PRIMARY KEY , pid TEXT, transId TEXT, tid TEXT, amtToPay TEXT, amtPaid TEXT)');
    }, version: 1);
  }

  static Future<void> insertParAcct(
      String table, Map<String, Object> data) async {
    final db = await DBHelper.databaseParAcct();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteTrPartAcct(
      String table, Map<String, Object> data) async {
    final db = await DBHelper.databaseParAcct();

    db.delete(
      table,
      where: 'tid = ?',
      whereArgs: [
        data['tid'],
      ],
    );
  }

  static Future<void> deletePartAcct(
      String table, Map<String, Object> data) async {
    final db = await DBHelper.databaseParAcct();

    db.delete(
      table,
      where: 'transId = ?',
      whereArgs: [
        data['transId'],
      ],
    );
  }

  static Future<List<Map<String, dynamic>>> getParAcct(String table) async {
    final db = await DBHelper.databaseParAcct();
    return db.query(table);
  }
}

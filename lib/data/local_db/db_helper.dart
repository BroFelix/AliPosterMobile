import 'dart:io';

import 'package:ali_poster/data/model/order.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'Orders.db';
  static const _databaseVersion = 1;

  static const table = 'my_orders';

  static const columnId = 'id';
  static const columnCashierId = 'cashier_id';
  static const columnCashierName = 'cashier_name';
  static const columnClientPhone = 'client_phone';
  static const columnAddress = 'address';
  static const columnOT = 'ordered_time'; // delivered time
  static const columnDelivered = 'delivered';
  static const columnDeliveredTime = 'delivered_time';
  static const columnProducts = 'products';
  static const columnSent = 'sent';
  static const columnTotal = 'total';
  static const columnUnqId = 'unique_id';
  static const columnGuide = 'guide';
  static const columnWorker = 'worker';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table (
    $columnId INTEGER PRIMARY KEY,
    $columnCashierId INTEGER NOT NULL,
    $columnCashierName TEXT,
    $columnClientPhone TEXT,
    $columnAddress TEXT,
    $columnOT TEXT,
    $columnDelivered INTEGER,
    $columnDeliveredTime TEXT,
    $columnProducts TEXT,
    $columnSent INTEGER,
    $columnTotal INTEGER,
    $columnUnqId INTEGER,
    $columnGuide TEXT,
    $columnWorker INTEGER
    )
    ''');
  }

  Future<int> insert(Order order, {DateTime? deliveredTime}) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: int.parse(order.id),
      DatabaseHelper.columnCashierId: order.cashierId,
      DatabaseHelper.columnCashierName: order.cashierName,
      DatabaseHelper.columnClientPhone: order.clientPhone,
      DatabaseHelper.columnAddress: order.address,
      DatabaseHelper.columnOT: order.orderedTime,
      DatabaseHelper.columnDelivered: order.delivered ? 1 : 0,
      DatabaseHelper.columnDeliveredTime: (deliveredTime!.day.toString() +
          deliveredTime.month.toString() +
          deliveredTime.year.toString()),
      DatabaseHelper.columnProducts: order.products,
      DatabaseHelper.columnSent: order.sent ? 1 : 0,
      DatabaseHelper.columnTotal: order.total,
      DatabaseHelper.columnUnqId: order.uniqueId,
      DatabaseHelper.columnGuide: order.guide,
      DatabaseHelper.columnWorker: order.worker,
    };
    return await db.insert(table, row);
  }

  Future<int> totalCostOfOrders(DateTime dateTime) async {
    Database db = await instance.database;
    final allRows = await db.query(
      table,
      where: '$columnDeliveredTime = ?',
      whereArgs: [
        (dateTime.day.toString() +
            dateTime.month.toString() +
            dateTime.year.toString())
      ],
    );
    int total = 0;
    for (var element in allRows) {
      var order = Order.fromDB(element);
      total += order.total;
    }
    return total;
  }

  Future<List<Order>> filterQuery(DateTime dateTime) async {
    Database db = await instance.database;
    List<Order> orders = [];
    final allRows = await db.query(
      table,
      where: '$columnDeliveredTime = ?',
      whereArgs: [
        (dateTime.day.toString() +
            dateTime.month.toString() +
            dateTime.year.toString())
      ],
    );
    for (var element in allRows) {
      orders.add(Order.fromDB(element));
    }
    return orders;
  }

  Future<List<Order>> queryAllRows() async {
    Database db = await instance.database;
    List<Order> orders = [];
    final allRows = await db.query(table);
    for (var element in allRows) {
      orders.add(Order.fromDB(element));
    }
    return orders;
  }

  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $table'),
    );
  }

  Future<int> update(Order order, {DateTime? deliveredTime}) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: order.id,
      DatabaseHelper.columnCashierId: order.cashierId,
      DatabaseHelper.columnCashierName: order.cashierName,
      DatabaseHelper.columnClientPhone: order.clientPhone,
      DatabaseHelper.columnAddress: order.address,
      DatabaseHelper.columnOT: order.orderedTime,
      DatabaseHelper.columnDelivered: order.delivered,
      DatabaseHelper.columnProducts: order.products,
      DatabaseHelper.columnSent: order.sent,
      DatabaseHelper.columnTotal: order.total,
      DatabaseHelper.columnUnqId: order.uniqueId,
      DatabaseHelper.columnGuide: order.guide,
      DatabaseHelper.columnWorker: order.worker,
    };
    int id = row[columnId];
    return await db.update(
      table,
      row,
      where: '$columnId=?',
      whereArgs: [id],
    );
  }

  Future<int> delete(String id) async {
    Database db = await instance.database;
    int queryId = int.parse(id);
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [queryId],
    );
  }
}

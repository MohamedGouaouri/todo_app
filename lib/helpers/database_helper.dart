import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;
  DatabaseHelper._instance();

  String tasksTable = "task_table";
  String colId = "id";
  String colTitle = "title";
  String colDate = "date";
  String colStatus = "status";

  // get DB
  Future<Database?> get db async {
    if (_db == null) {
      _db = await _initDB();
    }
    return _db;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "todo_list.db";
    final todoListDb =
        await openDatabase(path, version: 1, onCreate: _createDB);
    return todoListDb;
  }

  void _createDB(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tasksTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDate Text, $colStatus INTEGER");
  }

  // get * from database
  Future<List<Map<String, dynamic>>> getTaskListMap() async {
    Database? db = await this.db;
    return await db!.query(tasksTable);
  }

  Future<List<Task>> getTaskList() async {
    final List<Map<String, dynamic>> taskListMap = await this.getTaskListMap();
    final List<Task> taskList = [];
    taskListMap.forEach((taskMap) {
      taskList.add(Task.fromMap(taskMap));
    });
    return taskList;
  }

  Future<int> insertTask(Task task) async {
    Database? db = await this.db;
    final int result = await db!.insert(tasksTable, task.toMap());
    return result;
  }

  Future<int> updateTask(Task task) async {
    Database? db = await this.db;
    final int result = await db!.update(tasksTable, task.toMap(),
        where: '$colId = ?', whereArgs: [task.id]);
    return result;
  }

  Future<int> deleteTask(id) async {
    Database? db = await this.db;
    final int result =
        await db!.delete(tasksTable, where: "$colId = ?", whereArgs: [id]);
    return result;
  }
}

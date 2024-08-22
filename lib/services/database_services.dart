import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/model/task.dart';

class DatabaseServices {
  static const int version = 1;
  static const String _dbname = 'toDo.db';
  static const String toDoTableName = 'toDoList';

  DatabaseServices() {
    openDB();
  }

  static Future<Database> openDB() async {
    String todoTableCreateSql =
        'CREATE TABLE IF NOT EXISTS $toDoTableName (id TEXT PRIMARY KEY, title TEXT, desc TEXT,priority TEXT,dueDate TEXT,dueTime TEXT,isCompleted INTEGER)';

    String path = join(await getDatabasesPath(), _dbname);

    try {
      Database database =
          await openDatabase(path, onCreate: (db, version) async {
        await db.execute(todoTableCreateSql);
      }, version: version);

      return database;
    } catch (e) {
      throw Exception('Failed to open database');
    }
  }

  Future<List<Task>> loadAllTodos() async {
    List<Task> newList = [];
    final todoList = await getAllTodos();
    for (var i in todoList) {
      newList.add(Task(
          id: i['id'],
          title: i['title'],
          description: i['desc'],
          priority: i['priority'],
          dueDate: i['dueDate'],
          dueTime: i['dueTime'],
          isCompleted: i['isCompleted'] == 1 ? true : false));
    }
    return newList;
  }

  /////////////////////// Create Todo //////////////////////////////

  Future<void> createNewTodo(
      {required String id,
      required String title,
      required String desc,
      required String priority,
      required String dueDate,
      required String dueTime,
      required int isCompleted}) async {
    try {
      final db = await openDB();
      await db.insert(toDoTableName, {
        'id': id,
        'title': title,
        'desc': desc,
        'priority': priority,
        'dueDate': dueDate,
        'dueTime': dueTime,
        'isCompleted': isCompleted
      });
    } catch (e) {
      return;
    }
  }

  /////////////////////// Update Todo //////////////////////////////

  Future<void> updateTodo(
      {required String id,
      required String newTitle,
      required String newDesc,
      required String newPriority,
      required String newDueDate,
      required String newDueTime,
      required int newIsCompleted}) async {
    try {
      final db = await openDB();
      await db.update(
          toDoTableName,
          {
            'id': id,
            'title': newTitle,
            'desc': newDesc,
            'priority': newPriority,
            'dueDate': newDueDate,
            'dueTime': newDueTime,
            'isCompleted': newIsCompleted
          },
          where: 'id = ?',
          whereArgs: [id]);
    } catch (e) {
      return;
    }
  }

  /////////////////////// Filter Todo //////////////////////////////

  Future<List<Task>> filterTodosByPrority(String priority) async {
    List<Task> filterTodos = [];
    final db = await openDB();
    final List<Map<String, dynamic>> filterResults = await db.query(
      toDoTableName, // Your table name
      where: 'priority = ?',
      whereArgs: [priority],
    );

    for (var i in filterResults) {
      filterTodos.add(Task(
          id: i['id'],
          title: i['title'],
          description: i['desc'],
          priority: i['priority'],
          dueDate: i['dueDate'],
          dueTime: i['dueTime'],
          isCompleted: i['isCompleted'] == 1 ? true : false));
    }

    return filterTodos;
  }

  Future<List<Task>> filterTodosByDueDate(String dueDate) async {
    List<Task> filterTodos = [];
    final db = await openDB();
    final List<Map<String, dynamic>> filterResults = await db.query(
      toDoTableName, // Your table name
      where: 'dueDate = ?',
      whereArgs: [dueDate],
    );

    for (var i in filterResults) {
      filterTodos.add(Task(
          id: i['id'],
          title: i['title'],
          description: i['desc'],
          priority: i['priority'],
          dueDate: i['dueDate'],
          dueTime: i['dueTime'],
          isCompleted: i['isCompleted'] == 1 ? true : false));
    }

    return filterTodos;
  }

  Future<List<Task>> filterTodosByTaskName(String taskName) async {
    List<Task> filterTodos = [];
    final db = await openDB();
    final List<Map<String, dynamic>> filterResults = await db.query(
      toDoTableName, // Your table name
      where: 'title = ?',
      whereArgs: [taskName],
    );

    for (var i in filterResults) {
      filterTodos.add(Task(
          id: i['id'],
          title: i['title'],
          description: i['desc'],
          priority: i['priority'],
          dueDate: i['dueDate'],
          dueTime: i['dueTime'],
          isCompleted: i['isCompleted'] == 1 ? true : false));
    }

    return filterTodos;
  }

  /////////////////////// Delete Todo //////////////////////////////

  Future<void> deleteTodo({required String todoId}) async {
    try {
      final db = await openDB();
      await db.delete(toDoTableName, where: 'id = ?', whereArgs: [todoId]);

      print('deleted');
    } catch (e) {
      return;
    }
  }

  /////////////////////// Fetch All Todo //////////////////////////////

  Future<List<Map<String, dynamic>>> getAllTodos() async {
    try {
      final db = await openDB();

      final result = await db.query(toDoTableName);

      return result;
    } catch (e) {
      return [];
    }
  }

 

  Future<void> completeTodo({required String todoId}) async {}
}

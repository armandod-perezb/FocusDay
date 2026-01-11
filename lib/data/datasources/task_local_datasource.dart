import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

class TaskLocalDataSource {
  static const String _databaseName = 'focus_day.db';
  static const int _databaseVersion = 1;
  static const String tableName = 'tasks';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        date TEXT NOT NULL,
        priority INTEGER NOT NULL,
        is_completed INTEGER NOT NULL,
        reminder_time TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  Future<List<TaskModel>> getAllTasks() async {
    final db = await database;
    final maps = await db.query(
      tableName,
      orderBy: 'date DESC, priority ASC',
    );

    return maps.map((map) => TaskModel.fromJson(map)).toList();
  }

  Future<List<TaskModel>> getTasksByDate(DateTime date) async {
    final db = await database;
    final startDate = DateTime(date.year, date.month, date.day);
    final endDate = startDate.add(const Duration(days: 1));

    final maps = await db.query(
      tableName,
      where: 'date >= ? AND date < ?',
      whereArgs: [
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
      orderBy: 'priority ASC, created_at ASC',
    );

    return maps.map((map) => TaskModel.fromJson(map)).toList();
  }

  Future<TaskModel?> getTaskById(String id) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return TaskModel.fromJson(maps.first);
  }

  Future<void> insertTask(TaskModel task) async {
    final db = await database;
    await db.insert(
      tableName,
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTask(TaskModel task) async {
    final db = await database;
    await db.update(
      tableName,
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> toggleTaskCompletion(String id) async {
    final db = await database;
    final task = await getTaskById(id);
    
    if (task != null) {
      await db.update(
        tableName,
        {
          'is_completed': task.isCompleted ? 0 : 1,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }
}

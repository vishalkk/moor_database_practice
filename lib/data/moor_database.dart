import 'package:moor_flutter/moor_flutter.dart';
import 'package:moor_generator/moor_generator.dart';

part 'moor_database.g.dart';

// class for table
class Tasks extends Table {
  // autoIncrement automatically sets this to be the primary key
  IntColumn get id => integer().autoIncrement()();

  // If the length constraint is not fulfilled, the Task will not
  // be inserted into the database and an exception will be thrown.
  TextColumn get name => text().withLength(min: 1, max: 50)();

  // DateTime is not natively supported by SQLite
  // Moor converts it to & from UNIX secondss
  DateTimeColumn get dueData => dateTime().nullable()();

  // Booleans are not supported as well, Moor converts them to integers
  // Simple default values are specified as Constants
  BoolColumn get completed => boolean().withDefault(const Constant(false))();

  // Custom primary keys defined as a set of columns
  // @override
  // Set<Column> get primaryKey => {id, name};

}

//Database class
// This annotation tells the code generator which tables this DB works with
@UseMoor(tables: [Tasks])
// _$AppDatabase is the name of the generated class
class AppDatabase extends _$AppDatabase {
  //[flutterQueryExcecutor] location of database files
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            // Good for debugging - prints SQL in the console
            path: 'db.sqlite',
            logStatements: true));

  // Bump this when changing tables and columns.
  // Migrations will be covered in the next part.

  @override
  int get schemaVersion => 1;

  //Writing Query
  // All tables have getters in the generated class - we can select the tasks table
  Future<List<Task>> getAllTasks() => select(tasks).get();

  // Moor supports Streams which emit elements when the watched data changes
  Stream<List<Task>> watchAllTask() => select(tasks).watch();

  Future insertTask(Task task) => into(tasks).insert(task);

  //update a task with matching primary key
  Future updateTask(Task task) => update(tasks).replace(task);
  Future deleteTask(Task task) => delete(tasks).delete(task);

  
}

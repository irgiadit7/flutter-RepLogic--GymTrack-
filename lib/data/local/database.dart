import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'database.g.dart';

class WorkoutSessions extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  DateTimeColumn get date => dateTime()();
  IntColumn get durationSeconds => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Exercises extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get targetMuscle => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkoutSets extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text().references(WorkoutSessions, #id)();
  TextColumn get exerciesId => text().references(Exercises, #id)();

  RealColumn get weight => real()();
  IntColumn get reps => integer()();
  RealColumn get rpe => real().nullable()();
  BoolColumn get isFailure => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [WorkoutSessions, Exercises, WorkoutSets])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'replogic.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

class Exercies extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  TextColumn get targetMuscle => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

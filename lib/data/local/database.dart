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
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Exercises extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get targetMuscle => text().nullable()();
  TextColumn get bodyPart => text().nullable()();
  TextColumn get category => text()();
  TextColumn get instructions => text().nullable()();
  TextColumn get youtubeUrl => text().nullable()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkoutSets extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId =>
      text().references(WorkoutSessions, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseId => text().references(Exercises, #id)();
  RealColumn get weight => real()();
  IntColumn get reps => integer()();
  RealColumn get rpe => real().nullable()();
  IntColumn get setType => integer().withDefault(const Constant(0))();
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [WorkoutSessions, Exercises, WorkoutSets])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 3) {}
      //WARN: RESET ALL DATA FROM STORE*
      await m.drop(exercises);
      await m.createTable(exercises);
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'replogic_v2.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

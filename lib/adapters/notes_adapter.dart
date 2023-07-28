import 'package:hive/hive.dart';

part 'notes_adapter.g.dart';

@HiveType(typeId: 1)
class Note{
  @HiveField(0)
  late String title;
  @HiveField(1)
  late String description;
  @HiveField(2)
  late String dateTime;
  @HiveField(3)
  int colors;

  Note({required this.title, required this.description, required this.dateTime, required this.colors});
}

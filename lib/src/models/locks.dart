import 'package:hive/hive.dart';

part 'locks.g.dart';

@HiveType(typeId: 2)
class Locks {
  @HiveField(0)
  bool value;

  Locks({required this.value});
}

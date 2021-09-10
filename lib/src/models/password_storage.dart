import 'package:hive/hive.dart';

part 'password_storage.g.dart';

@HiveType(typeId: 0)
class PasswordStorage {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;

  @HiveField(2)
  String username;

  @HiveField(3)
  String password;

  @HiveField(4)
  bool important;

  @HiveField(5)
  int click;

  @HiveField(6)
  String createAt;

  @HiveField(7)
  String updatedAt;

  PasswordStorage({
    required this.id,
    required this.title,
    required this.username,
    required this.password,
    this.important = false,
    this.click = 0,
    required this.createAt,
    required this.updatedAt,
  });
}

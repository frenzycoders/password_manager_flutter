import 'package:hive/hive.dart';
part 'updated_passwords.g.dart';

@HiveType(typeId: 5)
class UpdatedPasswords {
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

  @HiveField(8)
  String cloud_id;

  @HiveField(9)
  bool uploaded;
  
  UpdatedPasswords({
    required this.id,
    required this.title,
    required this.username,
    required this.password,
    required this.important,
    required this.click,
    required this.createAt,
    required this.updatedAt,
    required this.cloud_id,
    required this.uploaded,
  });
}

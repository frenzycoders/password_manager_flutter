import 'package:hive/hive.dart';
part 'deleted_passwords.g.dart';

@HiveType(typeId: 3)
class DeletedPasswords {
  @HiveField(0)
  String id;

  DeletedPasswords({required this.id});
}

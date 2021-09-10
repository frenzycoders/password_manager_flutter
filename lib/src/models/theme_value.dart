import 'package:hive/hive.dart';

part 'theme_value.g.dart';
@HiveType(typeId: 1)
class ThemeValue {
  @HiveField(0)
  String id;

  @HiveField(1)
  String value;

  ThemeValue({required this.id, this.value = 'light'});
}

// ignore_for_file: file_names

import 'package:hive/hive.dart';
part 'UserDetails.g.dart';

@HiveType(typeId: 8)
class UserDetails {
  @HiveField(0)
  String id;
  @HiveField(1)
  String email;
  @HiveField(2)
  String key;

  @HiveField(3)
  String eKey;
  UserDetails(
      {required this.id,
      required this.email,
      required this.key,
      this.eKey = ''});

  UserDetails.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        // ignore: prefer_if_null_operators
        key = json['key'] == null ? 'NON' : json['key'],
        eKey = '';
}

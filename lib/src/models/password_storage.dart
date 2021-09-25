import 'dart:convert';

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

  @HiveField(8)
  String cloud_id;

  @HiveField(9)
  bool uploaded;

  PasswordStorage({
    required this.id,
    required this.title,
    required this.username,
    required this.password,
    this.important = false,
    this.click = 0,
    required this.createAt,
    required this.updatedAt,
    this.cloud_id = '',
    this.uploaded = false,
  });

  PasswordStorage.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        username = json['username'],
        password = json['password'],
        click = int.parse(json['click']),
        cloud_id = json['_id'],
        uploaded = true,
        important = json['important'] == 'true' ? true : false,
        createAt = json['createdAt'],
        updatedAt = json['updatedAt'];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "username": username,
      "password": password,
      "click": click,
      "important": important,
      "createdAt": createAt,
      "updatedAt": updatedAt
    };
  }
}

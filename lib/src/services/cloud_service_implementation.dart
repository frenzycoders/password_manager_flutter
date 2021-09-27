// ignore_for_file: use_rethrow_when_possible

import 'dart:convert';

import 'package:get/get.dart';
import 'package:password_manager/src/HttpException.dart';
import 'package:password_manager/src/http/http_service.dart';
import 'package:password_manager/src/http/http_service_impl.dart';
import 'package:password_manager/src/models/UserDetails.dart';
import 'package:password_manager/src/models/password_storage.dart';
import 'package:password_manager/src/services/cloud_service.dart';

class CloudServiceImplementation implements CloudService {
  late HttpService _httpService;

  CloudServiceImplementation() {
    print('Cloud Controller');
    _httpService = Get.put(HttpImpl());
    _httpService.init();
  }

  @override
  Future<UserDetails> createSpace({required String email}) async {
    try {
      final response =
          await _httpService.postRequest('create-space', {}, {"email": email});
      if (response.statusCode == 500 || response.statusCode == 400) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        UserDetails userDetails =
            UserDetails.fromJSON(json.decode(response.body));
        return userDetails;
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<UserDetails> verifyUser({required email, required otp}) async {
    try {
      final response = await _httpService
          .postRequest('verify-user/' + email + '/' + otp, {}, {});
      if (response.statusCode == 404) {
        throw HttpException('Wrong OTP Please Try Again.');
      } else if (response.statusCode == 500) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        UserDetails userDetails =
            UserDetails.fromJSON(json.decode(response.body));
        return userDetails;
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<PasswordStorage> createPasswords(
      {required String key, required PasswordStorage data}) async {
    try {
      final response = await _httpService.postRequest(
        'create-password',
        {'x-key': key},
        {
          "id": data.id,
          "title": data.title,
          "username": data.username,
          "password": data.password,
          "click": data.click.toString(),
          "important": data.important.toString(),
          "createdAt": data.createAt,
          "updatedAt": data.updatedAt,
        },
      );

      if (response.statusCode == 404 || response.statusCode != 201) {
        throw HttpException('Server error or Token expire');
      } else {
        PasswordStorage password =
            PasswordStorage.fromJSON(json.decode(response.body)['password']);
        return password;
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<PasswordStorage>> fetchAllPasswords({required key}) async {
    try {
      List<PasswordStorage> pass = [];
      final response =
          await _httpService.getRequest('fetch-passwords', {'x-key': key}, {});

      if (response.statusCode == 404) {
        throw HttpException('Token Expire Login again.');
      } else if (response.statusCode == 500) {
        throw HttpException('Internal server error');
      } else {
        var password = json.decode(response.body)['passwords'];
        if (password.length > 0) {
          password.forEach((e) {
            PasswordStorage p = PasswordStorage.fromJSON(e);
            pass.add(p);
          });
          print(pass.length);
          return pass;
        } else {
          return [];
        }
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future updateClick(
      {required key, required PasswordStorage passwordStorage}) async {
    try {
      final response = await _httpService.patchRequest('update-click', {
        'x-key': key
      }, {
        "id": passwordStorage.cloud_id,
        "click": passwordStorage.click.toString(),
      });
      if (response.statusCode == 404) {
        throw HttpException('You can\'t update this password');
      } else if (response.statusCode == 500) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        return;
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future deletePassword({required key, required id}) async {
    try {
      final response = await _httpService.deleteRequest(
          url: 'delete-password/' + id, headers: {'x-key': key}, body: {});
      if (response.statusCode == 404) {
        throw HttpException('Token Expire or Wrong password access');
      } else if (response.statusCode == 500) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        return;
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future deleteMultiplePasswords(
      {required key, required List<String> ids}) async {
    try {
      final response =
          await _httpService.deleteRequest(url: 'delete-multilple', headers: {
        'x-key': key
      }, body: {
        "ids": jsonEncode(ids),
      });
      if (response.statusCode == 404) {
        throw HttpException('404');
      } else if (response.statusCode == 500) {
        throw HttpException(json.decode(response.body)['message']);
      } else if (response.statusCode == 200) {
        return;
      } else {
        throw HttpException(json.decode(response.body)['message']);
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future updateSinglePassword(
      {required key, required PasswordStorage passwordStorage}) async {
    try {
      final date = DateTime.now().toString();

      final response = await _httpService
          .patchRequest('update-password/' + passwordStorage.cloud_id, {
        'x-key': key
      }, {
        "title": passwordStorage.title,
        "username": passwordStorage.username,
        "password": passwordStorage.password,
        "click": passwordStorage.click.toString(),
        "important": passwordStorage.important.toString(),
        "createdAt": passwordStorage.createAt,
        "updatedAt": date,
      });
      if (response.statusCode == 404) {
        throw HttpException(json.decode(response.body)['message']);
      } else if (response.statusCode == 500) {
        throw HttpException(json.decode(response.body)['message']);
      }
      return;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future updateManyPasswords({required key, required String data}) async {
    try {
      final response = await _httpService
          .patchRequest('update-multiple', {'x-key': key}, {"data": data});
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        return;
      }
    } catch (e) {
      throw e;
    }
  }
}

// ignore_for_file: use_rethrow_when_possible
import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:password_manager/src/Controllers/settings_controller.dart';
import 'package:password_manager/src/models/password_storage.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:password_manager/src/Controllers/password_controller.dart';
import 'package:password_manager/src/HttpException.dart';
import 'package:password_manager/src/models/UserDetails.dart';
import 'package:password_manager/src/services/cloud_service.dart';
import 'package:password_manager/src/services/cloud_service_implementation.dart';
import 'package:encrypt/encrypt.dart';
import 'package:password_manager/src/models/updated_passwords.dart';
import 'package:password_manager/src/models/deleted_passwords.dart';

class CloudController extends GetxController {
  RxBool isLoading = false.obs;
  late PasswordController _passwordController;
  late SettingsController _settingsController;
  late CloudService _cloudService;
  late Box<UserDetails> user = Hive.box<UserDetails>('user_profile');
  Box emailBox = Hive.box('email');
  RxBool otpVerification = false.obs;
  Rx<UserDetails> profile = UserDetails(id: '', email: '', key: '').obs;

  CloudController() {
    _passwordController = Get.find<PasswordController>();
    _cloudService = Get.find<CloudServiceImplementation>();
    _settingsController = Get.find<SettingsController>();
    initUser();
  }
  initUser() {
    final userDetails = user.get('profile');
    if (userDetails != null) {
      profile.value = userDetails;
    }
  }

  Future ChangeKey(String key) async {
    profile.value.eKey = key;
    user.put('profile', profile.value);
  }

  Future createSpace({required email}) async {
    isLoading.value = true;
    try {
      UserDetails res = await _cloudService.createSpace(email: email);
      profile.value = res;
      isLoading.value = false;
      otpVerification.value = true;
    } on HttpException catch (e) {
      isLoading.value = false;
      throw HttpException(e.message);
    } catch (e) {
      isLoading.value = false;
      throw e;
    }
  }

  wrongEmail() async {
    user.delete('profile');
    profile.value = UserDetails(id: '', email: '', key: '');
    otpVerification.value = false;
  }

  Future verifyUser({required otp}) async {
    isLoading.value = true;
    try {
      UserDetails res =
          await _cloudService.verifyUser(email: profile.value.email, otp: otp);
      res.eKey = await _keyGenerator();
      profile.value = res;

      user.put('profile', res);
      _settingsController.enableDisableUploadToCloud();
      isLoading.value = false;
    } on HttpException catch (e) {
      isLoading.value = false;
      throw HttpException(e.message);
    } catch (e) {
      isLoading.value = false;
      throw e;
    }
  }

  syncPasswords() async {
    try {} catch (e) {}
  }

  storePassword(String title, String username, String password) async {
    if (_settingsController.uploadCloud.isTrue) {
      Encrypted encrypted = await encryptPassword(password);
      PasswordStorage passwordStorage = await _passwordController
          .addDataToStorage(title, username, encrypted.base64);

      if (await InternetConnectionChecker().hasConnection) {
        try {
          PasswordStorage newPwd = await createPassword(passwordStorage);
          await _passwordController.uploadedToCloudEdit(
              passwordStorage.id, newPwd.cloud_id);
        } on HttpException catch (e) {
          throw HttpException(e.message);
        } catch (e) {
          print(e);
          throw e;
        }
      }
    } else {
      _passwordController.addDataToStorage(title, username, password);
    }
  }

  copyString(data, Function message) async {
    FlutterClipboard.copy(data).then((value) => message());
  }

  copyPasswordToClipBoard({
    required Function message,
    required PasswordStorage passwordStorage,
  }) async {
    if (_settingsController.uploadCloud.isTrue) {
      String pwd =
          await decryptPassword(Encrypted.fromBase64(passwordStorage.password));
      FlutterClipboard.copy(pwd).then((value) {
        message();
      });
      if (await InternetConnectionChecker().hasConnection) {
        await _passwordController.increaseCount(passwordStorage.id);
        try {
          await clickUpddate(passwordStorage: passwordStorage);
        } on HttpException catch (e) {
          throw HttpException(e.message);
        } catch (e) {
          throw e;
        }
      } else {
        await _passwordController
            .addPasswordToUpdatedPasswordBox(UpdatedPasswords(
          id: passwordStorage.id,
          title: passwordStorage.title,
          username: passwordStorage.username,
          password: passwordStorage.password,
          createAt: passwordStorage.createAt,
          updatedAt: passwordStorage.updatedAt,
          click: passwordStorage.click,
          cloud_id: passwordStorage.cloud_id,
          important: passwordStorage.important,
          uploaded: passwordStorage.uploaded,
        ));
      }
    } else {
      FlutterClipboard.copy(passwordStorage.password).then((value) {
        message();
        _passwordController.increaseCount(passwordStorage.id);
      });
    }
  }

  Future<Encrypted> encryptPassword(String pwd) async {
    final plainText = pwd;
    Key key = Key.fromBase64(profile.value.eKey);

    IV iv = IV.fromLength(8);
    Encrypter encrypter = Encrypter(Salsa20(key));
    Encrypted encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted;
  }

  Future<String> decryptPassword(Encrypted enc) async {
    Key key = Key.fromBase64(profile.value.eKey);
    IV iv = IV.fromLength(8);
    Encrypter encrypter = Encrypter(Salsa20(key));
    String decrypted = encrypter.decrypt(enc, iv: iv);
    return decrypted;
  }

  Future<Encrypted> returnDecryptPwd(enc_pwd) async {
    Encrypted pwd = Encrypted.fromBase64(enc_pwd);
    return pwd;
  }

  Future<String> _keyGenerator() async {
    Key key = Key.fromLength(32);
    return key.base64;
  }

  Future<PasswordStorage> createPassword(PasswordStorage dat) async {
    try {
      PasswordStorage data = await _cloudService.createPasswords(
          key: profile.value.key, data: dat);
      return data;
    } on HttpException catch (e) {
      throw HttpException('Session key expired.');
    } catch (e) {
      throw e;
    }
  }

  Future fullRefresh() async {
    try {
      isLoading.value = true;
      try {
        await deleteAllPendingPasswords();
        await _passwordController.clearPendingDeleteBox();
      } on HttpException catch (e) {
        throw HttpException(e.message);
      } catch (e) {
        throw e;
      }
      try {
        await updateAllPendingPasswords();
        await _passwordController.clearUpdatedPasswordBox();
      } on HttpException catch (e) {
        throw HttpException(e.message);
      } catch (e) {
        throw e;
      }
      List<PasswordStorage> passwords =
          await _cloudService.fetchAllPasswords(key: profile.value.key);
      await _passwordController.cleanFullPasswordStorage();
      isLoading.value = false;
      if (passwords.isEmpty) {
        _passwordController.fetchPasswords();
      } else {
        for (var element in passwords) {
          _passwordController.createIncomingPasswordsFromServer(
              passwordStorage: element);
        }
      }
    } on HttpException catch (e) {
      isLoading.value = false;
      throw HttpException(e.message);
    } catch (e) {
      isLoading.value = false;
      throw e;
    }
  }

  // updatePasswords({required String}) async {
  //   try {} catch (e) {}
  // }

  clickUpddate({required PasswordStorage passwordStorage}) async {
    try {
      await _cloudService.updateClick(
          key: profile.value.key, passwordStorage: passwordStorage);
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      throw e;
    }
  }

  deleteRequest(
      {required key, required cloud_id, required Function message}) async {
    if (_settingsController.uploadCloud.isTrue) {
      if (await InternetConnectionChecker().hasConnection) {
        try {
          await deletePasswordFromCloud(id: cloud_id);
          await _passwordController.deletePassword(key);
          await _passwordController.deleteSinglePasswordFromUpdatedPasswordBox(
              id: key);
          message();
        } on HttpException catch (e) {
          throw HttpException(e.message);
        } catch (e) {
          throw e;
        }
      } else {
        await _passwordController
            .addPendigDeletePassword(DeletedPasswords(id: cloud_id));
        await _passwordController.deletePassword(key);
        message();
      }
    } else {
      await _passwordController.deletePassword(key);
      message();
    }
  }

  updateRequest(
      {required PasswordStorage passwordStorage,
      required Function message}) async {
    Encrypted enc_pws = await encryptPassword(passwordStorage.password);
    if (_settingsController.uploadCloud.isTrue) {
      passwordStorage.password = enc_pws.base64;
      if (await InternetConnectionChecker().hasConnection) {
        try {
          await updatePasswordToServer(passwordStorage: passwordStorage);
          await _passwordController.editDataToStorage(
            passwordStorage.id,
            passwordStorage.id,
            passwordStorage.username,
            passwordStorage.password,
          );
          message('Password Updated .');
        } on HttpException catch (e) {
          message(e.message);
        } catch (e) {
          message(e.toString());
        }
      } else {
        await _passwordController
            .addPasswordToUpdatedPasswordBox(UpdatedPasswords(
          id: passwordStorage.id,
          title: passwordStorage.title,
          username: passwordStorage.username,
          password: passwordStorage.password,
          important: passwordStorage.important,
          click: passwordStorage.click,
          createAt: passwordStorage.createAt,
          updatedAt: passwordStorage.updatedAt,
          cloud_id: passwordStorage.cloud_id,
          uploaded: passwordStorage.uploaded,
        ));
        await _passwordController.updatePasswordWithFullData(passwordStorage);
        message(
            'Password Updated in local database connect to internet and refresh it to sync your passwords');
      }
    } else {
      await _passwordController.editDataToStorage(
        passwordStorage.id,
        passwordStorage.title,
        passwordStorage.username,
        enc_pws.base64,
      );
      message('Password updated.');
    }
  }

  updatePasswordToServer({required PasswordStorage passwordStorage}) async {
    try {
      await _cloudService.updateSinglePassword(
          key: profile.value.key, passwordStorage: passwordStorage);
      return;
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      throw e;
    }
  }

  deletePasswordFromCloud({required id}) async {
    try {
      await _cloudService.deletePassword(key: profile.value.key, id: id);
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      throw e;
    }
  }

  deleteAllPendingPasswords() async {
    await _passwordController.fetchPendingDeletePasswords();
    if (_passwordController.pendingDeletePasswords.value.length > 0) {
      await _passwordController.fetchPendingDeletePasswords();
      List<String> ids = [];
      _passwordController.pendingDeletePasswords.value.forEach((element) {
        ids.add(element.id.toString());
      });
      try {
        await _cloudService.deleteMultiplePasswords(
            key: profile.value.key, ids: ids);
      } on HttpException catch (e) {
        throw HttpException(e.message);
      } catch (e) {
        throw e;
      }
    } else {
      return;
    }
  }

  updateAllPendingPasswords() async {
    await _passwordController.fetchPendingUpdatedPassword();
    if (_passwordController.pendingUpdatePasswords.value.length > 0) {
      List updatePassword = [];
      _passwordController.pendingUpdatePasswords.value.forEach((element) {
        updatePassword.add({
          "_id": element.cloud_id,
          "id": element.id,
          "title": element.title,
          "username": element.username,
          "password": element.password,
          "createdAt": element.createAt,
          "updatedAt": element.updatedAt,
          "click": element.click.toString(),
          "important": element.important.toString(),
        });
      });
      try {
        await _cloudService.updateManyPasswords(
            key: profile.value.key, data: jsonEncode(updatePassword));
        print('Hey');
      } on HttpException catch (e) {
        throw HttpException(e.message);
      } catch (e) {
        throw e;
      }
    } else {
      return;
    }
  }

  logoutSession() async {
    await user.delete('profile');
    profile.value = UserDetails(id: '', email: '', key: '');
    await _settingsController.logoutSession();
    await _settingsController.enableDisableUploadToCloud();
  }
}

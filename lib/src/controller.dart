import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:password_manager/src/models/password_storage.dart';
import './models/theme_value.dart';

class AppController extends GetxController {
  RxString theme = 'light'.obs;
  late Box<ThemeValue> themeBox;
  String themeName = 'theme';
  String storage = 'password';
  late Box<PasswordStorage> passwordBox;
  RxBool isLoading = false.obs;
  RxBool isAdded = false.obs;
  RxList passwords = [].obs;
  RxBool isSearch = false.obs;

  AppController() {
    themeBox = Hive.box<ThemeValue>(themeName);

    ThemeValue? themes = themeBox.get('app_theme');
    if (themes == null) {
      themeBox.put('app_theme', ThemeValue(id: 'app_theme', value: 'light'));
      theme.value = 'light';
    } else {
      theme.value = themes.value;
    }
    passwordBox = Hive.box<PasswordStorage>(storage);
    fetchPasswords();
  }

  fetchPasswords() async {
    List list = passwordBox.values.toList();
    list.sort((a, b) => b.click.compareTo(a.click));
    print(list[0].click);
    passwords.value = list;
  }

  changeToDark() {
    themeBox.put('app_theme', ThemeValue(id: 'app_theme', value: 'dark'));
    theme.value = 'dark';
  }

  changeToLight() {
    themeBox.put('app_theme', ThemeValue(id: 'app_theme', value: 'light'));
    theme.value = 'light';
  }

  customSnachBar(String message) {
    return SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
    );
  }

  messageDialogue(Widget title, Widget content, action, double elevation,
      BuildContext context) {
    print('here');
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: title, // To display the title it is optional
            content: content, // Message which will be pop up on the screen
            // Action widget which will provide the user to acknowledge the choice
            actions: action,
            elevation: elevation,
          );
        });
  }

  addDataToStorage(String title, String username, String password) async {
    isLoading.value = true;
    final currentTime = DateTime.now().toString();
    PasswordStorage passwordStorage = PasswordStorage(
      id: currentTime + "-" + username,
      title: title,
      username: username,
      password: password,
      createAt: currentTime,
      updatedAt: currentTime,
    );
    passwordBox.put(currentTime + "-" + username, passwordStorage);
    fetchPasswords();
    isAdded.value = true;
    isLoading.value = false;
  }

  deletePassword(id) {
    passwordBox.delete(id);
    fetchPasswords();
  }

  editDataToStorage(String id, String title, String username, String password) {
    isLoading.value = true;

    final currentTime = DateTime.now().toString();
    PasswordStorage passwordStorage = PasswordStorage(
      id: id,
      title: title,
      username: username,
      password: password,
      createAt: currentTime,
      updatedAt: currentTime,
    );
    passwordBox.put(id, passwordStorage);
    isAdded.value = true;
    isLoading.value = false;
    fetchPasswords();
  }

  increaseCount(id) {
    PasswordStorage passwordStorage = passwordBox.get(id) as PasswordStorage;
    passwordStorage.click = passwordStorage.click + 1;
    passwordBox.put(passwordStorage.id, passwordStorage);
    fetchPasswords();
  }

  enableSearchBar() {
    isSearch.value = true;
  }

  disableSearchBar() {
    isSearch.value = false;
  }

  filterByIndex(value) {
    List data = passwordBox.values.toList();
    List n = [];
    n = [];
    for (var element in data) {
      // ignore: avoid_print
      for (int i = 0; i < value.length; i++) {
        if (value[i] == element.username[i]) {
          n.add(element);
        }
      }
    }
    if (n.isNotEmpty) {
      passwords.value = [];
      passwords.value = n;
    } else {
      passwords.value = [];
    }
  }
}

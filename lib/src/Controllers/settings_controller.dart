import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';
import 'package:password_manager/src/models/locks.dart';
import '../models/theme_value.dart';

class SettingsController extends GetxController {
  RxString theme = 'light'.obs;
  late Box<ThemeValue> themeBox;
  String themeName = 'theme';
  RxBool isLoading = false.obs;
  RxBool isBioMetric = false.obs;
  RxBool faceBioMetric = false.obs;
  RxBool uploadCloud = false.obs;

  RxBool facelock = false.obs;
  RxBool fingerLock = false.obs;
  RxBool pinlock = false.obs;

  late LocalAuthentication localAuthentication;
  List<BiometricType> availableBiometrices = [];
  late Box<Locks> locks;
  late Box utilsBox;
  SettingsController() {
    themeBox = Hive.box<ThemeValue>(themeName);
    locks = Hive.box<Locks>('locks');
    openCloudBox();
    ThemeValue? themes = themeBox.get('app_theme');
    if (themes == null) {
      themeBox.put('app_theme', ThemeValue(id: 'app_theme', value: 'light'));
      theme.value = 'light';
    } else {
      theme.value = themes.value;
    }
    localAuthentication = LocalAuthentication();
    initBiometric();
    bioMetricValues();
  }

  openCloudBox() async {
    utilsBox = await Hive.openBox('utils');
    final value = utilsBox.get('cloud');
    if (value == null) {
      utilsBox.put('cloud', false);
    } else {
      uploadCloud.value = utilsBox.get('cloud');
    }
  }

  enableDisableUploadToCloud() {
    bool value = utilsBox.get('cloud');
    if (value) {
      utilsBox.put('cloud', false);
      uploadCloud.value = false;
    } else {
      utilsBox.put('cloud', true);
      uploadCloud.value = true;
    }
  }

  initBiometric() async {
    bool canCheckBiometric = await localAuthentication.canCheckBiometrics;
    availableBiometrices = await localAuthentication.getAvailableBiometrics();
    if (canCheckBiometric) {
      availableBiometrices.forEach((element) {
        if (element == BiometricType.fingerprint) isBioMetric.value = true;
        if (element == BiometricType.face) faceBioMetric.value = true;
      });
    }
  }

  bioMetricValues() async {
    var fingre = locks.get('fingerprint');
    // ignore: avoid_print
    // print(fingre!.value);
    if (fingre == null) {
      print('Null');
      locks.put('fingreprint', Locks(value: false));
    } else {
      fingerLock.value = fingre.value;
    }

    var face = locks.get('face');
    if (face == null) {
      locks.put('face', Locks(value: false));
    } else {
      facelock.value = face.value;
    }

    var pin = locks.get('pin');
    if (pin == null) {
      locks.put('pin', Locks(value: false));
    } else {
      pinlock.value = pin.value;
    }
  }

  enableFingrePrint() async {
    if (fingerLock.isTrue) {
      locks.put('fingerprint', Locks(value: false));
      fingerLock.value = false;
      var fingre = locks.get('fingerprint');
      print('After Change');
      print(fingre!.value);
    } else {
      locks.put('fingerprint', Locks(value: true));
      fingerLock.value = true;
    }
  }

  enableFaceLock() async {
    if (facelock.isTrue) {
      locks.put('face', Locks(value: false));
      facelock.value = false;
    } else {
      locks.put('face', Locks(value: true));
      facelock.value = true;
    }
  }

  enablePinLogin() async {
    if (pinlock.isTrue) {
      locks.put('pin', Locks(value: false));
      pinlock.value = false;
    } else {
      locks.put('pin', Locks(value: true));
      pinlock.value = true;
    }
  }

  Future<bool> requestBiometricAuth() async {
    bool isAuth = await localAuthentication.authenticate(
        localizedReason: 'Please verify yourself.');
    return isAuth;
  }

  savePinAndEnableIt(String pin) {
    themeBox.put('pin_password', ThemeValue(id: 'pin_password', value: pin));
    locks.put('pin', Locks(value: true));
    pinlock.value = true;
  }

  matchSavePin(String upin) {
    print(upin);
    var pin = themeBox.get('pin_password');
    if (pin == null)
      exit(0);
    else {
      if (pin.value == upin) {
        return true;
      } else {
        return false;
      }
    }
  }

  rightSlidePage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return page;
        },
        transitionsBuilder: (context, animation, secondAnimation, child) {
          return SlideTransition(
            position:
                animation.drive(Tween(begin: Offset(1, 0), end: Offset(0, 0))),
            child: child,
          );
        },
      ),
    );
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
      },
    );
  }

  changeToDark() {
    themeBox.put('app_theme', ThemeValue(id: 'app_theme', value: 'dark'));
    theme.value = 'dark';
  }

  changeToLight() {
    themeBox.put('app_theme', ThemeValue(id: 'app_theme', value: 'light'));
    theme.value = 'light';
  }
}

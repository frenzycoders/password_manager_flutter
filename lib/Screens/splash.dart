import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:password_manager/src/Controllers/settings_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  splashCounter() {
    return Timer(const Duration(microseconds: 100), () async {
      if (settingsController.fingerLock.isTrue ||
          settingsController.facelock.isTrue) {
        bool isValid = await settingsController.requestBiometricAuth();
        if (isValid) {
          if (settingsController.pinlock.isTrue) {
            Get.toNamed('/verification-pin');
          } else {
            Get.toNamed('/home');
          }
        }
      } else if (settingsController.pinlock.isTrue) {
        Get.toNamed('/verification-pin');
      } else {
        Get.toNamed('/home');
      }
    });
  }

  late SettingsController settingsController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settingsController = Get.find<SettingsController>();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    splashCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(
                color: Colors.purple,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: const Text('Initilazing.....'),
            )
          ],
        ),
      ),
    );
  }
}

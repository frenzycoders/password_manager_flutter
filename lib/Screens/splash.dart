import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  splashCounter() {
    return Timer(const Duration(seconds: 2), () {
      Get.offAndToNamed('/home');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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

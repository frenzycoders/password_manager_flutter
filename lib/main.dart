import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_manager/Screens/Home.dart';
import 'package:password_manager/Screens/splash.dart';
import 'package:password_manager/Themes.dart';
import 'package:password_manager/src/controller.dart';
import 'package:password_manager/src/models/password_storage.dart';
import './src/models/theme_value.dart';

void main() async {
  await Hive.initFlutter();
  String storage = 'password';
  String theme = 'theme';
  Hive.registerAdapter(PasswordStorageAdapter());
  await Hive.openBox<PasswordStorage>(storage);
  Hive.registerAdapter(ThemeValueAdapter());
  await Hive.openBox<ThemeValue>(theme);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppController _appController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(AppController());
    _appController = Get.find<AppController>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        title: 'Password Manager',
        debugShowCheckedModeBanner: false,
        theme: _appController.theme.value == 'light'
            ? CustomThemes.lightTheme
            : CustomThemes.darkTheme,
        getPages: [
          GetPage(name: '/splash', page: () => const SplashScreen()),
          GetPage(name: '/home', page: () => HomeScreen()),
        ],
        initialRoute: '/splash',
      );
    });
  }
}

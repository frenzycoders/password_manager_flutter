import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_manager/Screens/Home.dart';
import 'package:password_manager/Screens/settings/PinCreate.dart';
import 'package:password_manager/Screens/settings/Settings.dart';
import 'package:password_manager/Screens/settings/verificationPin.dart';
import 'package:password_manager/Screens/splash.dart';
import 'package:password_manager/Themes.dart';
import 'package:password_manager/src/Bindings/Cloud_binding.dart';
import 'package:password_manager/src/Bindings/password_binding.dart';
import 'package:password_manager/src/Controllers/settings_controller.dart';
import 'package:password_manager/src/models/UserDetails.dart';
import 'package:password_manager/src/models/deleted_passwords.dart';
import 'package:password_manager/src/models/locks.dart';
import 'package:password_manager/src/models/password_storage.dart';
import './src/models/theme_value.dart';
import './src/models/updated_passwords.dart';

void main() async {
  await Hive.initFlutter();
  String storage = 'password';
  String theme = 'theme';
  String locks = 'locks';
  String deleted = 'deleted_passwords';
  String updated = 'updated_passwords';
  String userDetails = 'user_profile';
  Hive.registerAdapter(PasswordStorageAdapter());
  await Hive.openBox<PasswordStorage>(storage);
  Hive.registerAdapter(ThemeValueAdapter());
  await Hive.openBox<ThemeValue>(theme);
  Hive.registerAdapter(LocksAdapter());
  await Hive.openBox<Locks>(locks);
  Hive.registerAdapter(DeletedPasswordsAdapter());
  await Hive.openBox<DeletedPasswords>(deleted);
  Hive.registerAdapter(UpdatedPasswordsAdapter());
  await Hive.openBox<UpdatedPasswords>(updated);
  Hive.registerAdapter(UserDetailsAdapter());
  await Hive.openBox<UserDetails>(userDetails);
  await Hive.openBox('email');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SettingsController _settingsController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(SettingsController());
    _settingsController = Get.find<SettingsController>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        title: 'Password Manager',
        debugShowCheckedModeBanner: false,
        theme: _settingsController.theme.value == 'light'
            ? CustomThemes.lightTheme
            : CustomThemes.darkTheme,
        getPages: [
          GetPage(
            name: '/splash',
            page: () => const SplashScreen(),
            bindings: [
              PasswordBinding(),
              CloudBinding(),
            ],
          ),
          GetPage(name: '/home', page: () => HomeScreen()),
          GetPage(name: '/settings', page: () => SettingsScreen()),
          GetPage(name: '/create-password', page: () => PinCreate()),
          GetPage(name: '/verification-pin', page: () => VerificationPin())
        ],
        initialRoute: '/splash',
      );
    });
  }
}

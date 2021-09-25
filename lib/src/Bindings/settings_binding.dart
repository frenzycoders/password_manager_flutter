import 'package:get/get.dart';
import 'package:password_manager/src/Controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    print('Binding Settings Controller for Global settings...');
    Get.put(SettingsController());
  }
}

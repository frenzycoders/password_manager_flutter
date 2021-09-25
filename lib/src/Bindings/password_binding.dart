import 'package:get/get.dart';
import 'package:password_manager/src/Controllers/password_controller.dart';

class PasswordBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    // ignore: avoid_print
    print('Binding Password Controller for Password Manager...');
    Get.put(PasswordController());
  }
}

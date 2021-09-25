// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:password_manager/src/Controllers/cloud_controller.dart';
import 'package:password_manager/src/services/cloud_service_implementation.dart';

class CloudBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    // ignore: avoid_print
    print('Binding api controller..');
    Get.put(CloudServiceImplementation());
    Get.put(CloudController());
  }
}

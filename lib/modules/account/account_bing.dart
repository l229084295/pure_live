import 'package:get/get.dart';
import 'package:pure_live/modules/account/account_controller.dart';

class AccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountController());
  }
}

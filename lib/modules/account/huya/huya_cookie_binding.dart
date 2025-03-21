import 'package:get/get.dart';
import 'package:pure_live/modules/account/huya/huya_cookie_controller.dart';

class HuyaCookieBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HuyaCookieController());
  }
}

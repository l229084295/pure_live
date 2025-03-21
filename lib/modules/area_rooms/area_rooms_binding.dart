import 'package:get/get.dart';
import 'package:pure_live/modules/area_rooms/area_rooms_controller.dart';

class AreaRoomsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AreaRoomsController(
            site: Get.arguments[0],
            subCategory: Get.arguments[1],
          ));
  }
}

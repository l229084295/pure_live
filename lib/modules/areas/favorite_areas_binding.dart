import 'package:get/get.dart';
import 'package:pure_live/modules/areas/favorite_areas_controller.dart';

class FavoriteAreasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoriteAreasController());
  }
}

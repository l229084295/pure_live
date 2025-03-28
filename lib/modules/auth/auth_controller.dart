import 'dart:async';
import 'package:get/get.dart';

class AuthController extends GetxController {
  bool shouldGoReset = false;
  late bool isLogin = false;
  String userId = '';
  @override
  void onInit() {
    super.onInit();
  }
}

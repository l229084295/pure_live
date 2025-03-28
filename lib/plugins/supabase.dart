import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pure_live/common/index.dart';
import 'package:pure_live/plugins/archethic.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pure_live/common/utils/supabase_policy.dart';

class SupaBaseManager {
  String supabaseUrl = '';
  String supabaseKey = '';
  static late SupaBaseManager _instance;
  static late SupabasePolicy supabasePolicy;
  static bool canUploadConfig = false;
  SupaBaseManager._internal();
  //单例模式，只创建一次实例
  static SupaBaseManager getInstance() {
    _instance = SupaBaseManager._internal();
    return _instance;
  }

  SupaBaseManager();
  Future initial() async {}

  signOut() {}

  Future<bool> loadUploadConfig() async {
    return false;
  }

  Future<void> uploadConfig() async {}

  Future<void> readConfig() async {}
}

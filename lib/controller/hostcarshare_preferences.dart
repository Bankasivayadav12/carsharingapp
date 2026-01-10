import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/host_response.dart';

class HostCarSharePreferencesController extends GetxController {
  final String baseUrl = "http://192.168.1.4:3000/api/lookups/car_share_preferences";

  // Store fetched preferences here
  RxList<HostCarShareModel> hostPreferences = <HostCarShareModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHostPreferences();  // Auto load
  }

  /// -------------------------------------------------------
  /// 🔥 Load Host Car Sharing Preferences
  /// -------------------------------------------------------
  Future<void> loadHostPreferences() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      //debugPrint("STATUS: ${response.statusCode}");
      //debugPrint("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        hostPreferences.value =
            data.map((e) => HostCarShareModel.fromJson(e)).toList();

       // debugPrint("Loaded Preferences: ${hostPreferences.length}");
      }
    } catch (e) {
      debugPrint("Preferences Load Error: $e");
    }
  }
}

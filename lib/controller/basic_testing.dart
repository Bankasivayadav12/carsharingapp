import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/test_model.dart';

class VehicleBasicController extends GetxController {
  RxBool isSubmitting = false.obs;

  // 🔥 Always use LOCAL IP (NOT localhost) for Flutter Mobile
  final String apiUrl =
      "http://192.168.1.4:3000/api/car_sharing/vehicles/create";

  Future<bool> submitVehicle(VehicleBasicModel model) async {
    try {
      isSubmitting.value = true;

      print("🚀 Sending Vehicle Data:");
      print(model.toJson());

      final url = Uri.parse(apiUrl);

      // ⏳ Added timeout to avoid long waiting
      final response = await http
          .post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(model.toJson()),
      )
          .timeout(const Duration(seconds: 12));

      print("📡 STATUS: ${response.statusCode}");
      print("📨 RESPONSE: ${response.body}");

      // Backend returns 201 → success
      if (response.statusCode == 201) {
        print("✅ Vehicle stored successfully.");
        return true;
      }

      // If backend sends custom error message
      print("❌ Failed storing vehicle: ${response.body}");
      return false;
    }

    // Internet or server issues
    on http.ClientException catch (e) {
      print("🌐 Network Error: $e");
      return false;
    } catch (e) {
      print("🔥 Unexpected Error: $e");
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}

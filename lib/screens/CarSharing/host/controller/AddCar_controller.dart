import 'dart:convert';
import 'package:f_demo/screens/CarSharing/host/controller/vehicle_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../add_car_page.dart';

class AddVehicleController extends GetxController {
  // Tracks if API is running → used for disabling button
  RxBool isSubmitting = false.obs;

  // API URL for creating a vehicle
  final String apiUrl =
      "http://192.168.1.2:3000/api/car_sharing/vehicles/create";

  // ============================================================
  // 🚀 SUBMIT VEHICLE API (POST REQUEST)
  // All logic inside controller — No service class needed
  // ============================================================
  Future<bool> submitVehicle({
    int? userId,
    int? vehicleId,
    String? trim,
    int? color,
    String? rideTypes,
    //String? greenCarId,
    bool? isDefault,
    String? plateNumber,
  }) async {

    // Prevent double-click / double API call
    if (isSubmitting.value) return false;

    // Mark API as running
    isSubmitting.value = true;

    // ----- Build request body -----
    final Map<String, dynamic> body = {
      "user_id": userId,
      "vehicle_id": vehicleId,
      "trim": trim,
      "color": color,
      "ride_types": rideTypes,
      //"green_car_type": greenCarId,
      "is_default": isDefault,
      "license_plate_num": plateNumber,
    };

    // Remove null fields → API will not receive empty values
    body.removeWhere((key, value) => value == null);

    print("🚀 SUBMIT VEHICLE API CALLED");
    print("➡ URL: $apiUrl");
    print("➡ REQUEST BODY: $body");

    try {
      // ----- CALLING THE API -----
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("📡 STATUS CODE: ${response.statusCode}");
      print("📨 RAW RESPONSE: ${response.body}");

      // SUCCESS = Status code 200
      if (response.statusCode == 200) {
        print("✅ VEHICLE ADDED SUCCESSFULLY");

        // Refresh vehicle list immediately
        final vehicleController = Get.find<VehicleController>();
        await vehicleController.loadVehicles(userId!);

        // Navigate back to AddCarPage (Your Cars screen)
        Get.off(() => AddCarPage());

        return true; // Return success
      } else {
        print("❌ FAILED TO ADD VEHICLE");
        return false;
      }

    } catch (e) {
      // Any error while calling API
      print("🔥 EXCEPTION ERROR: $e");
      return false;

    } finally {
      // Reset loading state after everything is done
      isSubmitting.value = false;
      print("🔄 isSubmitting reset to FALSE");
    }
  }
}

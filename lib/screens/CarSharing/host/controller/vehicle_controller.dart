import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/host_model.dart';

class VehicleController extends GetxController {
  // Base URL (Update if needed)
  final String baseUrl = "http://192.168.1.2:3000/api/car_sharing";

  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;
  RxList<VehicleResponse> vehicles = <VehicleResponse>[].obs;

  // =========================================================
  // 🚗 FETCH VEHICLES (API call inside controller itself)
  // =========================================================
  Future<void> loadVehicles(int userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final url = Uri.parse("$baseUrl/vehicles/$userId");

      print("🌐 Calling API: $url");

      final response = await http.get(url);

      print("📡 STATUS: ${response.statusCode}");
      print("📄 BODY: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is! List) {
          print("❌ ERROR: Response is not a list");
          vehicles.clear();
          return;
        }

        vehicles.value = decoded
            .map<VehicleResponse>((e) => VehicleResponse.fromJson(e))
            .toList();

        print("✔ Loaded ${vehicles.length} vehicles");

      } else {
        throw Exception("Server error: ${response.statusCode}");
      }

    } catch (e) {
      errorMessage.value = "Failed to load vehicles: $e";
      print("❌ CONTROLLER ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

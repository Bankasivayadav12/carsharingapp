import 'dart:convert';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;

import '../model/host_model.dart';

class CarModelController extends GetxController {
  // 🚀 API endpoint that returns search results for car models
  final String baseUrl = "http://192.168.1.2:3000/api/lookups/vehicles";

  // 🔄 Observable loading indicator
  RxBool isLoading = false.obs;

  // 📌 Holds the filtered list of vehicle models based on search query
  RxList<VehicleModel> suggestions = <VehicleModel>[].obs;

  // --------------------------------------------------------------
  // 🔍 Live Search Function
  // This function hits API every time the user types a character.
  // --------------------------------------------------------------
  Future<void> searchModels(String query) async {
    // If user clears input → hide suggestions immediately
    if (query.isEmpty) {
      suggestions.clear();
      return;
    }

    try {
      // Start loading
      isLoading.value = true;

      // 🔗 API call: Ex - /vehicles/tes
      final url = Uri.parse("$baseUrl/$query");

      // 🌐 Send GET request
      final response = await http.get(url);

      // ----------------------------------------------------------
      // If API returns 200 → parse results
      // ----------------------------------------------------------
      if (response.statusCode == 200) {
        // Decode JSON response body into List
        final List decoded = jsonDecode(response.body);

        // Convert each JSON entry into VehicleModel object
        suggestions.value =
            decoded.map((e) => VehicleModel.fromJson(e)).toList();
      }
      // ----------------------------------------------------------
      // If API returns non-200 → clear old suggestions
      // ----------------------------------------------------------
      else {
        suggestions.clear();
      }
    }
    // --------------------------------------------------------------
    // Handle Internet/Server errors
    // --------------------------------------------------------------
    catch (e) {
      print("Search Error: $e");
      suggestions.clear();
    }
    finally {
      // Stop loading indicator
      isLoading.value = false;
    }
  }
}

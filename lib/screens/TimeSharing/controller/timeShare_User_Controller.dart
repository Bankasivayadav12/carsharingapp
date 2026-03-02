import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

import '../model/timesharing_model.dart';

class TimeSharingVehicleController extends GetxController {

  final Dio _dio = Dio();

  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;
  RxList<TimeSharingVehicle> vehicles = <TimeSharingVehicle>[].obs;

  final String baseUrl =
      "http://192.168.1.2:3000/api/time_sharing/all";

  /// 🔥 MAIN METHOD YOU CALL FROM UI
  Future<void> loadVehicles() async {
  }

  /// 🔥 GET CURRENT LOCATION + CALL API
  Future<void> fetchVehiclesByCurrentLocation() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      /// 1️⃣ Permission
      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        errorMessage.value =
        "Location permission permanently denied";
        return;
      }

      /// 2️⃣ Get GPS
      Position position =
      await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double latitude = position.latitude;
      double longitude = position.longitude;

      print("📍 LAT: $latitude");
      print("📍 LONG: $longitude");

      /// 3️⃣ API Call
      final response = await _dio.get(
        "$baseUrl/$latitude/$longitude",
      );

      if (response.statusCode == 200) {

        final List data = response.data;

        vehicles.value = data
            .map((e) => TimeSharingVehicle.fromJson(e))
            .toList();

        print("✅ Loaded ${vehicles.length} vehicles");

      } else {
        errorMessage.value =
        "Server error: ${response.statusCode}";
      }

    } catch (e) {
      errorMessage.value =
      "Failed to load vehicles: $e";
      print("❌ ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }
}



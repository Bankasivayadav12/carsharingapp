import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class ShareCarController extends GetxController {
  final Dio dio = Dio();

  /// UI STATES
  RxBool isLoading = false.obs;
  Rx<dynamic> carData = Rx<dynamic>(null);

  /// 📍 SINGLE SOURCE OF TRUTH FOR LOCATION
  double? pickupLat;
  double? pickupLng;

  final String shareCarUrl =
      "http://192.168.1.2:3000/api/car_sharing/share_car";

  // ===============================================================
  // 📍 GET CURRENT LOCATION
  // ===============================================================
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission permanently denied");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // ===============================================================
  // 🚗 FETCH NEARBY CARS
  // ===============================================================
  Future<void> fetchNearbyCars(double lat, double lng) async {
    final url =
        "http://192.168.1.4:3000/api/car_sharing/all/$lat/$lng";

    try {
      final response = await dio.get(url);
      print("✅ NEARBY CARS RESPONSE:");
      print(response.data);
    } catch (e) {
      print("❌ FETCH NEARBY CARS ERROR: $e");
    }
  }

  // ===============================================================
  // 🚘 SHARE CAR API (FLEXIBLE PRICING)
  // ===============================================================
  Future<void> shareCar({
    required int id,
    required int userId,
    double? hourlyCost,
    double? dailyCost,
    double? weeklyCost,
    required String preferences,
    required String address, required double lat, required double long,
    DateTime? activeFrom,
    DateTime? activeTill,
  }) async {
    /// ❌ LOCATION CHECK
    if (pickupLat == null || pickupLng == null) {
      Get.snackbar("Error", "Pickup location not selected");
      return;
    }

    /// ❌ PRICE CHECK
    if (hourlyCost == null && dailyCost == null && weeklyCost == null) {
      Get.snackbar("Error", "Please enter at least one price");
      return;
    }

    if (activeFrom != null &&
        activeTill != null &&
        activeTill.isBefore(activeFrom)) {
      Get.snackbar("Error", "Active till must be after active from");
      return;
    }

    try {
      isLoading.value = true;

      /// ✅ BASE BODY
      final Map<String, dynamic> body = {
        "car_id": id,
        "user_id": userId,
        "preferences": preferences,
        "address": address,
        "lat": pickupLat,
        "long": pickupLng,
      };

      /// ✅ ADD ONLY PROVIDED PRICES
      if (hourlyCost != null) {
        body["hourly_cost"] = hourlyCost;
      }
      if (dailyCost != null) {
        body["daily_cost"] = dailyCost;
      }
      if (weeklyCost != null) {
        body["weekly_cost"] = weeklyCost;
      }

      /// ✅ ADD ACTIVE DATES (ONLY IF PROVIDED)
      if (activeFrom != null) {
        body["active_from"] = activeFrom.toIso8601String();
      }
      if (activeTill != null) {
        body["active_till"] = activeTill.toIso8601String();
      }

      print("📤 SHARE CAR REQUEST BODY:");
      print(body);

      final response = await dio.post(
        shareCarUrl,
        data: body,
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );

      print("✅ SHARE CAR RESPONSE:");
      print(response.data);

      carData.value = response.data;
    } catch (e) {
      print("❌ SHARE CAR ERROR: $e");
      carData.value = null;
      Get.snackbar("Error", "Failed to share car");
    } finally {
      isLoading.value = false;
    }
  }
}

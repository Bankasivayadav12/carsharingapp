import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ShareCarController extends GetxController {
  final Dio dio = Dio();

  RxBool isLoading = false.obs;
  Rx<dynamic> carData = Rx<dynamic>(null);

  final String shareCarUrl =
      "http://192.168.1.4:3000/api/car_sharing/share_car";

  Future<void> shareCar({
    required int id,
    required int userId,
    required double hourlyCost,
    required double dailyCost,
    required double weeklyCost,
    required String preferences,
    required String address,
    required double lat,
    required double long,
  }) async {
    try {
      isLoading.value = true;

      final body = {
        "car_id": id,
        "user_id": userId,
        "hourly_cost": hourlyCost,
        "daily_cost": dailyCost,
        "weekly_cost": weeklyCost,
        "preferences": preferences,
        "address": address,
        "lat": lat,
        "long": long,
      };

      print("📤 SHARE CAR REQUEST BODY:");
      print(body);

      final response = await dio.post(
        shareCarUrl,
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      // ✅ PRINT FULL RESPONSE
      print("✅ SHARE CAR RESPONSE STATUS: ${response.statusCode}");
      print("✅ SHARE CAR RESPONSE HEADERS: ${response.headers}");
      print("✅ SHARE CAR RESPONSE DATA:");
      print(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        carData.value = response.data;
      } else {
        carData.value = null;
      }
    } catch (e) {
      // ✅ DETAILED ERROR LOGGING
      if (e is DioException) {
        print("❌ DIO ERROR OCCURRED");
        print("❌ STATUS CODE: ${e.response?.statusCode}");
        print("❌ RESPONSE DATA: ${e.response?.data}");
        print("❌ RESPONSE HEADERS: ${e.response?.headers}");
        print("❌ ERROR MESSAGE: ${e.message}");
      } else {
        print("❌ UNKNOWN ERROR: $e");
      }

      carData.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}

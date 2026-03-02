import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../model/user_model.dart';

class UserDetailsController extends GetxController {

  final Dio _dio = Dio();

  RxBool isLoading = false.obs;
  RxBool isUserExists = false.obs;
  Rx<UserDetails?> userDetails = Rx<UserDetails?>(null);

  final String baseUrl =
      "http://192.168.1.2:3000/api/car_sharing";

  Future<void> checkUser(int userId) async {
    try {
      isLoading.value = true;

      final response = await _dio.get(
        "$baseUrl/$userId/user_details",
      );

      if (response.statusCode == 200) {
        final model =
        UserDetailsResponse.fromJson(response.data);

        if (model.success && model.data.isNotEmpty) {
          isUserExists.value = true;
          userDetails.value = model.data.first;
        } else {
          isUserExists.value = false;
        }
      }
    } catch (e) {
      print("❌ API Error: $e");
      isUserExists.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}


class UserCreateController extends GetxController {

  final Dio _dio = Dio();

  RxBool isLoading = false.obs;
  Rx<UserResponse?> userResponse = Rx<UserResponse?>(null);

  Future<bool> createUser({
    required int userId,
    required String licenseNumber,
    required String policyNumber,
  }) async {
    try {
      isLoading.value = true;

      print("📤 Sending Request:");
      print("User ID: $userId");
      print("License: $licenseNumber");
      print("Policy: $policyNumber");

      final response = await _dio.post(
        "http://192.168.1.2:3000/api/car_sharing/user/create",
        data: {
          "user_id": userId,
          "ins_policy_num": policyNumber,
          "driver_lic_num": licenseNumber,
        },
      );

      // ✅ PRINT STATUS
      print("📡 STATUS CODE: ${response.statusCode}");

      // ✅ PRINT FULL RAW RESPONSE
      print("📄 RAW RESPONSE: ${response.data}");

      if (response.statusCode == 200) {
        userResponse.value = UserResponse.fromJson(response.data);

        print("✅ Parsed UserResponse:");
        print(userResponse.value);

        return true;
      }

      return false;

    } catch (e) {
      print("❌ CREATE USER ERROR: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

}
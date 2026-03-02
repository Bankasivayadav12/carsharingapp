import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  static const String baseUrl = "http://192.168.1.2:3000/api/car_sharing/payment/paypal";

  /// CREATE PAYPAL ORDER
  static Future<Map<String, dynamic>> createPayPalOrder({
    required double amount,
    required int carId,
    required int userId,
    //required String durationType,
    //required int duration,
    required String pickupAddress,
    required String bookedFrom,
    required String bookedTill,
    double? pickupLat,
    double? pickupLong, required String id,
  }) async {
    final url = Uri.parse("$baseUrl/create-order");

    final bodyData = {
      "amount": amount,
      "car_id": carId,
      "user_id": userId,
      //"duration_type": durationType,
     // "duration": duration,
      "booked_user_pickup_address": pickupAddress,
      "booked_from": bookedFrom,
      "booked_till": bookedTill,
      "pickup_lat": pickupLat,
      "pickup_long": pickupLong,
    };

    print("➡️ REQUEST BODY:");
    print(bodyData);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(bodyData),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to create PayPal order");
    }

    return jsonDecode(response.body);
  }



  /// CAPTURE PAYPAL ORDER
  static Future<Map<String, dynamic>> capturePayPalOrder(String orderId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/capture-order"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"orderId": orderId}),
    );

    print("CAPTURE RESPONSE STATUS: ${response.statusCode}");
    print("CAPTURE RESPONSE BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to capture PayPal order");
    }

    return jsonDecode(response.body); // 🔥 MUST RETURN
  }


}

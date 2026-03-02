import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {

  static const String baseUrl =
      "http://192.168.1.2:3000/api/car_sharing/payment/paypal";

  /// CREATE PAYPAL ORDER (ONLY carId + amount)
  static Future<Map<String, dynamic>> createPayPalOrder({
    required double amount,
    required int carId,
  }) async {

    final url = Uri.parse("$baseUrl/create-order");

    final bodyData = {
      "amount": amount,
      "car_id": carId,
    };

    print("➡️ REQUEST BODY:");
    print(bodyData);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(bodyData),
    );

    print("CREATE ORDER STATUS: ${response.statusCode}");
    print("CREATE ORDER BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to create PayPal order");
    }

    return jsonDecode(response.body);
  }


  /// CAPTURE PAYPAL ORDER
  static Future<void> capturePayPalOrder(String orderId) async {

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
  }
}

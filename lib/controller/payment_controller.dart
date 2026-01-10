import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentController extends ChangeNotifier {
  String baseUrl = "https://yourdomain.com/api/paypal";

  // Create Order → return approval URL
  Future<String?> createOrder(String amount) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/create-order"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"amount": amount}),
      );

      final data = jsonDecode(res.body);

      if (data["id"] == null) return null;

      final approvalUrl = data["links"]
          .firstWhere((l) => l["rel"] == "approve")["href"];

      return approvalUrl;

    } catch (e) {
      print("Error creating order: $e");
      return null;
    }
  }

  // Capture order after approval
  Future<bool> captureOrder(String orderID) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/capture-order"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"orderID": orderID}),
      );

      final data = jsonDecode(res.body);

      return data["status"] == "COMPLETED";
    } catch (e) {
      print("Error capturing order: $e");
      return false;
    }
  }
}

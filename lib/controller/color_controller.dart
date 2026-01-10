import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/host_response.dart';

class ColorController extends GetxController {
  // 🔥 API endpoint (change only this URL when backend changes)
  final String baseUrl = "http://192.168.1.4:3000/api/lookups/colors";

  // 🔄 'isLoading' will show loading indicator when true
  RxBool isLoading = false.obs;
  RxBool hasLoaded = false.obs;

  // 🎨 List of colors fetched from the API stored in observable list
  RxList<ColorModel> colors = <ColorModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadColors();  // 🚀 Automatically fetch colors when controller loads
  }

  /// ------------------------------------------------------------
  /// 🔥 FUNCTION: Load Colors From API
  /// ------------------------------------------------------------
  Future<void> loadColors() async {
    try {
      isLoading.value = true;  // ⏳ Show loading state in UI

      // 🌐 Make GET API request
      final response = await http.get(Uri.parse(baseUrl));

      print("STATUS: ${response.statusCode}");  // 📝 Log status code
      print("BODY: ${response.body}");          // 📝 Log response body

      // ✅ API Success
      if (response.statusCode == 200) {
        // 🔍 Convert JSON response string → List<dynamic>
        final List decoded = jsonDecode(response.body);

        // 🎉 Convert list of JSON objects → List<ColorModel>
        colors.value = decoded.map((e) => ColorModel.fromJson(e)).toList();

        print("Loaded Colors: ${colors.length}");  // 👍 Print total count

      } else {
        // ❌ API Error (like 404, 500)
        print("Server Error: ${response.statusCode}");
      }

    } catch (e) {
      // ❗ Any network, parsing, or unexpected error
      print("Color Load Error: $e");

    } finally {
      isLoading.value = false;  // ⛔ Stop loading indicator
    }
  }
}

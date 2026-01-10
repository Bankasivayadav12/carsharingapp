import 'dart:convert';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../model/host_response.dart';

class CarSharingController extends GetxController {
  RxBool loading = false.obs;

  RxList<CarItem> cars = <CarItem>[].obs;
  RxList<CarItem> filteredCars = <CarItem>[].obs;
  RxList<String> suggestions = <String>[].obs;

  // BRAND & SEARCH
  RxString selectedBrand = "ALL".obs;
  RxString searchQuery = "".obs;

  // ------------------------------------------------------------------
  // GET LIVE LOCATION
  // ------------------------------------------------------------------
  Future<Position> _getLocation() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) await Geolocator.openLocationSettings();

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      perm = await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // ------------------------------------------------------------------
  // FETCH CARS FROM API
  // ------------------------------------------------------------------
  Future<void> fetchCarsAutomatically() async {
    loading.value = true;

    try {
      final pos = await _getLocation();
      final url =
          "http://192.168.1.4:3000/api/car_sharing/all/${pos.latitude}/${pos.longitude}";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        List<CarSharingResponse> parsed =
        data.map((e) => CarSharingResponse.fromJson(e)).toList();

        cars.value = parsed.first.jsonAgg;
        filteredCars.value = cars;
      }
    } catch (e) {
      print("API ERROR: $e");
    }

    loading.value = false;
  }

  // ------------------------------------------------------------------
  // BRAND FILTER (NEW updateBrand method)
  // ------------------------------------------------------------------
  void updateBrand(String brand) {
    selectedBrand.value = brand;
    applyFilters(); // re-filter results
  }

  // old function kept for safety
  void filterByBrand(String brand) {
    updateBrand(brand);
  }

  // ------------------------------------------------------------------
  // SEARCH + SUGGESTIONS
  // ------------------------------------------------------------------
  void search(String text) {
    searchQuery.value = text;

    if (text.isEmpty) {
      suggestions.clear();
      applyFilters();
      return;
    }

    suggestions.value = cars
        .where((c) {
      final name =
      "${c.vehicle?.make} ${c.vehicle?.model}".toLowerCase();
      return name.contains(text.toLowerCase());
    })
        .map((c) => "${c.vehicle?.make} ${c.vehicle?.model}")
        .toSet()
        .toList();

    applyFilters();
  }

  // ------------------------------------------------------------------
  // FINAL FILTER LOGIC
  // ------------------------------------------------------------------
  void applyFilters() {
    List<CarItem> temp = cars;

    // BRAND FILTER
    if (selectedBrand.value != "ALL") {
      temp = temp
          .where((c) =>
      (c.vehicle?.make ?? "").toLowerCase() ==
          selectedBrand.value.toLowerCase())
          .toList();
    }

    // SEARCH FILTER
    if (searchQuery.value.isNotEmpty) {
      temp = temp.where((c) {
        final full =
        "${c.vehicle?.make} ${c.vehicle?.model}".toLowerCase();
        return full.contains(searchQuery.value.toLowerCase());
      }).toList();
    }

    filteredCars.value = temp;
  }
}

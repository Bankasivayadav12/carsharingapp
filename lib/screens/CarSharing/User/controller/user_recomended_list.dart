import 'dart:convert';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../model/user_model.dart';
import '../../host/model/host_model.dart';


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
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception("Location services are disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception("Location permission denied");
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      throw Exception(
          "Location permission permanently denied. Enable it from settings.");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // ------------------------------------------------------------------
  // FETCH CARS FROM API
  // ------------------------------------------------------------------
  Future<void> fetchCarsAutomatically() async {
    loading.value = true;

    try {
      final pos = await _getLocation();
      final url =
          "http://192.168.1.2:3000/api/car_sharing/all/${pos.latitude}/${pos.longitude}";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          final parsed = data
              .map((e) => CarSharingResponse.fromJson(e))
              .toList();

          cars.value = parsed.first.jsonAgg;
          // 🔥 SORT BY HIGHEST AVAILABILITY
          cars.sort(compareByAvailability);
          filteredCars.value = List<CarItem>.from(cars);
        }
      }
    } catch (e) {
      print("API ERROR: $e");
    }

    loading.value = false;
  }

  // ------------------------------------------------------------------
  // BRAND FILTER
  // ------------------------------------------------------------------
  void updateBrand(String brand) {
    selectedBrand.value = brand;
    applyFilters();
  }

  void filterByBrand(String brand) {
    updateBrand(brand);
  }

  // ------------------------------------------------------------------
  // SEARCH + SUGGESTIONS (CITY / ADDRESS BASED)
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
      final address = (c.address ?? "").toLowerCase();
      return address.contains(text.toLowerCase());
    })
        .map((c) {
      final address = c.address ?? "";

      // 👉 extract city from "Area, City, State"
      final parts = address.split(",");
      return parts.length > 1
          ? parts[0].trim() // Secunderabad
          : address.trim();
    })
        .where((a) => a.isNotEmpty)
        .toSet()
        .toList();

    applyFilters();
  }

  // ------------------------------------------------------------------
  // FINAL FILTER LOGIC (CITY BASED)
  // ------------------------------------------------------------------
  void applyFilters() {
    List<CarItem> temp = cars;

    // BRAND FILTER (optional)
    if (selectedBrand.value != "ALL") {
      temp = temp
          .where((c) =>
      (c.vehicle?.make ?? "").toLowerCase() ==
          selectedBrand.value.toLowerCase())
          .toList();
    }

    // CITY / ADDRESS FILTER ✅
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();

      temp = temp.where((c) {
        final cityText = [
          c.address,

        ].whereType<String>().join(" ").toLowerCase();

        return cityText.contains(query);
      }).toList();
    }

    filteredCars.value = temp;
  }


  // availability duration like 1 hour/ 2 weeks / 3 days like that

  int compareByAvailability(CarItem a, CarItem b) {
    final aWeeks = a.availabilityInWeeks ?? 0;
    final bWeeks = b.availabilityInWeeks ?? 0;

    if (aWeeks != bWeeks) {
      return bWeeks.compareTo(aWeeks); // DESC
    }

    final aDays = a.availabilityInDays ?? 0;
    final bDays = b.availabilityInDays ?? 0;

    if (aDays != bDays) {
      return bDays.compareTo(aDays); // DESC
    }

    final aHours = a.availabilityInHours ?? 0;
    final bHours = b.availabilityInHours ?? 0;

    return bHours.compareTo(aHours); // DESC
  }

  // ------------------------------------------------------------------
  // AVAILABILITY LABEL (UI HELPER)
  // ------------------------------------------------------------------
  String availabilityDuration(CarItem car) {
    if ((car.availabilityInWeeks ?? 0) > 0) {
      return "${car.availabilityInWeeks} week${car.availabilityInWeeks! > 1 ? 's' : ''}";
    }
    if ((car.availabilityInDays ?? 0) > 0) {
      return "${car.availabilityInDays} day${car.availabilityInDays! > 1 ? 's' : ''}";
    }
    if ((car.availabilityInHours ?? 0) > 0) {
      return "${car.availabilityInHours} hour${car.availabilityInHours! > 1 ? 's' : ''}";
    }
    return "Not available";
  }
  String priceLabel(CarItem car) {
    num coins = 0;   // 👈 use num instead of int
    String period = "";

    // Priority: Weeks > Days > Hours
    if ((car.availabilityInWeeks ?? 0) > 0) {
      coins = car.weeklyCost ?? 0;
      period = "Per Week";
    } else if ((car.availabilityInDays ?? 0) > 0) {
      coins = car.dailyCost ?? 0;
      period = "Per Day";
    } else if ((car.availabilityInHours ?? 0) > 0) {
      coins = car.hourlyCost ?? 0;
      period = "Per Hr";
    } else {
      return "Not available";
    }

    double dollars = coins.toDouble() / 10;

    return "Coins-${coins.toInt()} $period\n\$${dollars.toStringAsFixed(2)} $period";
  }


}

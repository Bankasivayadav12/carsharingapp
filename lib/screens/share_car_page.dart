import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../controller/Share_Car_Controller.dart';
import '../controller/HostCarShare_Preferences.dart';

class ShareCarPage extends StatefulWidget {
  final Map<String, dynamic> car;

  ShareCarPage({super.key, required this.car});

  final HostCarSharePreferencesController prefController =
  Get.put(HostCarSharePreferencesController());

  @override
  State<ShareCarPage> createState() => _ShareCarPageState();
}

class _ShareCarPageState extends State<ShareCarPage> {
  final ShareCarController controller = Get.put(ShareCarController());

  final TextEditingController hourlyCtrl = TextEditingController();
  final TextEditingController dailyCtrl = TextEditingController();
  final TextEditingController weeklyCtrl = TextEditingController();
  final TextEditingController pickupCtrl = TextEditingController();

  double? currentLat;
  double? currentLng;

  List<int> selectedPrefIds = [];

  /// 🔑 EDIT MODE
  bool get isEdit => widget.car["is_active"] == true;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      _prefillFromCar();
    } else {
      _loadCurrentLocation();
    }
  }

  // ===============================================================
  // 🔄 PREFILL DATA (ACTIVE CAR)
  // ===============================================================
  void _prefillFromCar() {
    final car = widget.car;

    hourlyCtrl.text = car["hourly_cost"]?.toString() ?? "";
    dailyCtrl.text = car["daily_cost"]?.toString() ?? "";
    weeklyCtrl.text = car["weekly_cost"]?.toString() ?? "";

    pickupCtrl.text = car["address"] ?? "";

    // ✅ SET LAT/LONG FOR EDIT
    currentLat = car["lat"];
    currentLng = car["long"];

    if (car["preferences"] != null &&
        car["preferences"].toString().isNotEmpty) {
      selectedPrefIds = car["preferences"]
          .toString()
          .split(",")
          .map((e) => int.parse(e))
          .toList();
    }

    setState(() {});
  }


  // ===============================================================
  // 📍 LOCATION FOR NEW SHARE
  // ===============================================================
  Future<void> _loadCurrentLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentLat = pos.latitude;
    currentLng = pos.longitude;

    final placemarks =
    await placemarkFromCoordinates(pos.latitude, pos.longitude);

    final place = placemarks.first;
    pickupCtrl.text =
    "${place.street}, ${place.locality}, ${place.administrativeArea}";
    setState(() {});
  }

  // ===============================================================
  // UI
  // ===============================================================
  @override
  Widget build(BuildContext context) {
    final car = widget.car;

    return Scaffold(
      backgroundColor: const Color(0xfff7f8fa),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(isEdit ? "Edit Car Share" : "Share Your Car"),
      ),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title("Car"),
                  const SizedBox(height: 12),
                  _carPreview(car),

                  const SizedBox(height: 20),
                  Text(
                    "${car["name"] ?? ""} • ${car["number"] ?? ""}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 25),
                  _title("Pickup Location"),
                  const SizedBox(height: 10),
                  _pickupSearchField(),
                  const SizedBox(height: 10),
                  _currentLocationButton(),

                  const SizedBox(height: 25),
                  _title("Pricing"),
                  _field("Hourly Cost (\$)", hourlyCtrl),
                  _field("Daily Cost (\$)", dailyCtrl),
                  _field("Weekly Cost (\$)", weeklyCtrl),

                  const SizedBox(height: 25),
                  _title("Preferences"),
                  const SizedBox(height: 12),
                  _preferenceChips(),

                  const SizedBox(height: 30),
                  _submitButton(car),
                ],
              ),
            ),

            if (controller.isLoading.value)
              Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        );
      }),
    );
  }

  // ===============================================================
  // 📍 PICKUP SEARCH
  // ===============================================================
  Widget _pickupSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: pickupCtrl,
        googleAPIKey: "AIzaSyB08PuFrEY0Hp2GSz4MzGKx18TUSZR8HPI",
        debounceTime: 300,
        countries: const ["in"],
        isLatLngRequired: !isEdit,
        inputDecoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Search pickup location",
        ),
        itemClick: (Prediction p) {
          if (isEdit) return;
          pickupCtrl.text = p.description!;
        },
        getPlaceDetailWithLatLng: (place) {
          if (isEdit) return;
          currentLat = place.lat as double?;
          currentLng = place.lng as double?;
        },
      ),
    );
  }

  Widget _currentLocationButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.my_location, color: Colors.green),
        label: const Text(
          "Use Current Location",
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.green),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          try {
            controller.isLoading.value = true;

            //final pos = await controller.getCurrentLocation();

            /// Fill pickup search field
           // pickupCtrl.text =
           // "Lat: ${pos.latitude}, Lng: ${pos.longitude}";

            /// Save for API usage
           // controller.pickupLat = pos.latitude;
           // controller.pickupLng = pos.longitude;

          } catch (e) {
            Get.snackbar(
              "Location Error",
              e.toString(),
              backgroundColor: Colors.red.shade100,
            );
          } finally {
            controller.isLoading.value = false;
          }
        },
      ),
    );
  }


  // ===============================================================
  // 🚗 CAR PREVIEW
  // ===============================================================
  Widget _carPreview(Map<String, dynamic> car) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade200,
      ),
      child: Center(
        child: car["image"] != null && car["image"].toString().isNotEmpty
            ? Image.file(File(car["image"]), height: 120)
            : const Icon(Icons.directions_car,
            size: 60, color: Colors.black45),
      ),
    );
  }

  // ===============================================================
  // 💰 INPUT FIELD
  // ===============================================================
  Widget _field(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  // ===============================================================
  // ⚙️ PREFERENCES
  // ===============================================================
  Widget _preferenceChips() {
    return Obx(() {
      final prefs = widget.prefController.hostPreferences;

      if (prefs.isEmpty) {
        return const Text("Loading preferences...");
      }

      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: prefs.map((pref) {
          final selected = selectedPrefIds.contains(pref.id);
          return ChoiceChip(
            label: Text(pref.name),
            selected: selected,
            selectedColor: Colors.green,
            labelStyle:
            TextStyle(color: selected ? Colors.white : Colors.black),
            onSelected: (val) {
              setState(() {
                val
                    ? selectedPrefIds.add(pref.id)
                    : selectedPrefIds.remove(pref.id);
              });
            },
          );
        }).toList(),
      );
    });
  }

  // ===============================================================
  // 🚀 SUBMIT
  // ===============================================================
  Widget _submitButton(Map car) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () => _submitShareCar(car),
        child: Text(
          isEdit ? "Update Car" : "Share Car",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _submitShareCar(Map car) async {
    if (pickupCtrl.text.isEmpty ||
        hourlyCtrl.text.isEmpty ||
        dailyCtrl.text.isEmpty ||
        weeklyCtrl.text.isEmpty ||
        selectedPrefIds.isEmpty) {
      _toast("Please fill all details");
      return;
    }

    final hourly = double.tryParse(hourlyCtrl.text.trim());
    final daily = double.tryParse(dailyCtrl.text.trim());
    final weekly = double.tryParse(weeklyCtrl.text.trim());

    if (hourly == null || daily == null || weekly == null) {
      _toast("Please enter valid numeric values");
      return;
    }

    // ✅ CRITICAL CHECK
    if (currentLat == null || currentLng == null) {
      _toast("Location missing");
      return;
    }

    await controller.shareCar(
      id: car["id"],
      userId: 198,
      hourlyCost: hourly.roundToDouble(),
      dailyCost: daily.roundToDouble(),
      weeklyCost: weekly.roundToDouble(),
      preferences: selectedPrefIds.join(","),
      address: pickupCtrl.text.trim(),
      lat: currentLat!,   // ✅ FIXED
      long: currentLng!,  // ✅ FIXED
    );

    if (controller.carData.value != null) {
      _toast(isEdit ? "Car Updated Successfully" : "Car Shared Successfully");
      Navigator.pop(context, true);
    } else {
      _toast("Operation failed");
    }
  }

  Widget _title(String t) =>
      Text(t, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));

  void _toast(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

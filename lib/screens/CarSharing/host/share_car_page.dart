import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'controller/hostcarshare_preferences.dart';
import 'controller/share_car_controller.dart';


class ShareCarPage extends StatefulWidget {
  final Map<String, dynamic> car;

  ShareCarPage({super.key, required this.car});

  final HostCarSharePreferencesController prefController =
  Get.put(HostCarSharePreferencesController());

  @override
  State<ShareCarPage> createState() => _ShareCarPageState();





}


enum TripType { hourly, daily, weekly }
class _ShareCarPageState extends State<ShareCarPage> {
  final ShareCarController controller = Get.put(ShareCarController());

  late DateTime selectedStartDate;
  late DateTime selectedEndDate;

  DateTime? activeFrom;
  DateTime? activeTill;

  final TextEditingController startDateCtrl = TextEditingController();
  final TextEditingController startTimeCtrl = TextEditingController();


  final TextEditingController hourlyCtrl = TextEditingController();
  final TextEditingController dailyCtrl = TextEditingController();
  final TextEditingController weeklyCtrl = TextEditingController();
  final TextEditingController pickupCtrl = TextEditingController();
  final RxString selectedAvailability = "HOURLY".obs;

  DateTime? startDateTime;
  DateTime? endDateTime;

  Duration? tripDuration;
  double totalPriceCoins = 0;


  final endDateCtrl = TextEditingController();
  final endTimeCtrl = TextEditingController();

  final minCtrl = TextEditingController();
  final maxCtrl = TextEditingController();
  final selectedTripType = Rx<TripType?>(null);

  double? currentLat;
  double? currentLng;

  List<int> selectedPrefIds = [];

  /// 🔑 EDIT MODE
  bool get isEdit => widget.car["is_active"] == true;

  final TextEditingController aiPriceController = TextEditingController();
  @override
  void initState() {
    super.initState();

    selectedStartDate = DateTime.now();
    selectedEndDate = selectedStartDate.add(const Duration(hours: 1));

    startDateCtrl.text = _formatDate(selectedStartDate);
    endDateCtrl.text = _formatDate(selectedEndDate);

    startTimeCtrl.text = getNearest30MinTime();

    // End time should be 1 hour after start
    final startDateTime =
    _combineDateTime(selectedStartDate, startTimeCtrl.text);

    final endDateTime = startDateTime.add(const Duration(hours: 1));
    endTimeCtrl.text = _formatTime(endDateTime);
  }




  // ✅ Store full trip start datetime


    // ✅ Delay time formatting until context is ready


  // ===============================================================
  // 📍 LOCATION FOR NEW SHARE
  // ===============================================================
  // Future<void> _loadCurrentLocation() async {
  //   final permission = await Geolocator.requestPermission();
  //   if (permission == LocationPermission.denied ||
  //       permission == LocationPermission.deniedForever) {
  //     return;
  //   }
  //
  //   final pos = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //
  //   currentLat = pos.latitude;
  //   currentLng = pos.longitude;
  //
  //   final placemarks =
  //   await placemarkFromCoordinates(pos.latitude, pos.longitude);
  //
  //   final place = placemarks.first;
  //   pickupCtrl.text =
  //   "${place.street}, ${place.locality}, ${place.administrativeArea}";
  //   setState(() {});
  // }

  // ===============================================================
  // UI
  // ===============================================================
  @override
  Widget build(BuildContext context) {
    final car = widget.car;

    /// ===================== MAIN  UI section ========================//

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
                children: <Widget>[
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
                  _title("Trip Availability"),

                  const SizedBox(height: 16),

                  _titleSmall("Trip Start"),

                  Row(
                    children: [
                      Expanded(
                        child: _TripStratDateField(
                          label: "Date",
                          controller: startDateCtrl,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _TripStartTimeDropdown(
                          label: "Time",
                          controller: startTimeCtrl,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),


                  _titleSmall("Trip End"),
                  Row(
                    children: [
                      Expanded(
                        child: _endDateField(
                          label: "Date",
                          controller: endDateCtrl,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _endTimeDropdown(
                          label: "Time",
                          controller: endTimeCtrl,
                        ),
                      ),
                    ],
                  ),


                  const SizedBox(height: 25),
                  _title("Pricing"),

                  Obx(() {
                    final type = selectedTripType.value;

                    return Column(
                      children: [
                        // HOURLY → always visible
                        _pricingField("Hourly Cost (/Coins)", hourlyCtrl),

                        // DAILY → visible for daily & weekly
                        if (type == TripType.daily || type == TripType.weekly)
                          _pricingField("Daily Cost (/Coins)", dailyCtrl),

                        // WEEKLY → visible only for weekly
                        if (type == TripType.weekly)
                          _pricingField("Weekly Cost (/Coins)", weeklyCtrl),
                      ],
                    );
                  }),

                  const SizedBox(height: 25),

                  //_title("Ai Based Pricing"),

                  // aiPricingWidget(aiPriceController),  we want ai give price based on car


                  const SizedBox(height: 12),
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
  /// ===================== MAIN  UI section ========================//


  // ===============================================================//
  // 📍 PICKUP SEARCH
  // ===============================================================//
  Widget _pickupSearchField() {
    return GooglePlaceAutoCompleteTextField(
      textEditingController: pickupCtrl,
      googleAPIKey: "AIzaSyB08PuFrEY0Hp2GSz4MzGKx18TUSZR8HPI",
      debounceTime: 300,
      countries: const ["in"],
      isLatLngRequired: true,

      inputDecoration: InputDecoration(
        hintText: "Search pickup location",
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 16),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),

      itemClick: (Prediction p) {
        pickupCtrl.text = p.description!;
        pickupCtrl.selection = TextSelection.fromPosition(
          TextPosition(offset: p.description!.length),
        );
      },

      getPlaceDetailWithLatLng: (place) {
        controller.pickupLat = place.lat as double?;
        controller.pickupLng = place.lng as double?;

        debugPrint(
          "📍 PICKUP (SEARCH): "
              "${controller.pickupLat}, ${controller.pickupLng}",
        );
      },
    );
  }


  Widget _currentLocationButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.my_location, color: Colors.green),
        label: const Text(
          "Use Current Location",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
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

            final pos = await controller.getCurrentLocation();

            /// ✅ SAVE LAT / LNG
            controller.pickupLat = pos.latitude;
            controller.pickupLng = pos.longitude;

            final placemarks = await placemarkFromCoordinates(
              pos.latitude,
              pos.longitude,
            );

            final place = placemarks.first;

            pickupCtrl.text = [
              place.subLocality,
              place.locality,
              place.administrativeArea,
            ].where((e) => e != null && e.isNotEmpty).join(", ");

            /// ✅ FETCH NEARBY CARS
            controller.fetchNearbyCars(
              pos.latitude,
              pos.longitude,
            );

            debugPrint(
              "📍 PICKUP (CURRENT): "
                  "${controller.pickupLat}, ${controller.pickupLng}",
            );
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

  // ===============================================================//
  // 📍 PICKUP SEARCH
  // ===============================================================//

// =========   Trip start date and time availability widgets ============//


  Widget _TripStratDateField({
    required String label,
    required TextEditingController controller,
  }) {
    return GestureDetector(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedStartDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );

        if (picked != null) {
          setState(() {
            selectedStartDate = picked;

            controller.text =
            "${picked.day.toString().padLeft(2, '0')}-"
                "${picked.month.toString().padLeft(2, '0')}-"
                "${picked.year}";

            // 🔥 Reset start time (force user to select again)
            startTimeCtrl.clear();

            // 🔥 Reset startDateTime
            startDateTime = null;

            // 🔥 If end date is before start date → auto fix
            if (selectedEndDate.isBefore(selectedStartDate)) {
              selectedEndDate =
                  selectedStartDate.add(const Duration(hours: 1));

              endDateCtrl.text = _formatDate(selectedEndDate);
              endTimeCtrl.clear();
              endDateTime = null;
            }

            // 🔥 Recalculate type safely
            _calculateTripType();
          });
        }
      },
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              controller.text.isEmpty ? label : controller.text,
              style: TextStyle(
                fontSize: 14,
                color: controller.text.isEmpty
                    ? Colors.grey
                    : Colors.black,
              ),
            ),
            const Icon(Icons.calendar_today, size: 18),
          ],
        ),
      ),
    );
  }


  Widget _TripStartTimeDropdown({
    required String label,
    required TextEditingController controller,
  }) {
    final List<String> times =
    generateTimeSlots(selectedDate: selectedStartDate);

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,

        value: times.contains(controller.text)
            ? controller.text
            : null,

        hint: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),

        items: times.map((time) {
          return DropdownMenuItem<String>(
            value: time,
            child: Text(
              time,
              style: const TextStyle(fontSize: 14),
            ),
          );
        }).toList(),

        // ✅ CORRECT onChanged LOCATION
        onChanged: (value) {
          if (value == null) return;

          setState(() {
            controller.text = value;

            // 🔥 Create full start DateTime
            startDateTime =
                _combineDateTime(selectedStartDate, controller.text);

            // 🔥 Auto-adjust end time if invalid or empty
            if (endTimeCtrl.text.isEmpty ||
                endDateTime == null ||
                endDateTime!.isBefore(startDateTime!)) {

              final autoEnd =
              startDateTime!.add(const Duration(hours: 1));

              selectedEndDate = autoEnd;
              endDateCtrl.text = _formatDate(autoEnd);
              endTimeCtrl.text = _formatTime(autoEnd);
              endDateTime = autoEnd;
            }

            // 🔥 Recalculate trip type
            _calculateTripType();
          });
        },

        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),

        dropdownStyleData: DropdownStyleData(
          maxHeight: 250,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          elevation: 4,
        ),

        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down_rounded),
          iconSize: 22,
        ),
      ),
    );
  }

  List<String> generateTimeSlots({required DateTime selectedDate}) {
    List<String> times = [];
    final now = DateTime.now();

    for (int hour = 0; hour < 24; hour++) {
      for (int minute in [0, 30]) {
        DateTime slotTime =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day, hour, minute);

        // 🚫 If selected date is today, skip past time
        if (_isSameDay(selectedDate, now) && slotTime.isBefore(now)) {
          continue;
        }

        final h = hour % 12 == 0 ? 12 : hour % 12;
        final period = hour < 12 ? "AM" : "PM";
        final m = minute == 0 ? "00" : "30";

        times.add("$h:$m $period");
      }
    }

    return times;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  String getNearest30MinTime() {
    final now = DateTime.now();

    int minute = now.minute;
    int roundedMinute;

    if (minute < 15) {
      roundedMinute = 0;
    } else if (minute < 45) {
      roundedMinute = 30;
    } else {
      roundedMinute = 0;
      return formatTime(
        DateTime(now.year, now.month, now.day, now.hour + 1, 0),
      );
    }

    return formatTime(
      DateTime(now.year, now.month, now.day, now.hour, roundedMinute),
    );
  }

  String formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final period = time.hour >= 12 ? "PM" : "AM";

    return "$hour:${time.minute.toString().padLeft(2, '0')} $period";
  }

// =========   Trip start date and time availability widgets ============//



// =========   Trip End date and time availability widgets ============//
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  Widget _endDateField({
    required String label,
    required TextEditingController controller,
  }) {
    return GestureDetector(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedEndDate,
          firstDate: selectedStartDate, // 🔥 must be >= start
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );

        if (picked != null) {
          setState(() {
            selectedEndDate = picked;
            controller.text = _formatDate(picked);

            // 🔥 Reset end time
            endTimeCtrl.clear();
            endDateTime = null;

            // 🔥 If start and end same date
            if (_isSameDay(selectedStartDate, selectedEndDate)) {
              if (startTimeCtrl.text.isNotEmpty) {
                final minEnd =
                _combineDateTime(selectedStartDate, startTimeCtrl.text)
                    .add(const Duration(minutes: 30));

                // Auto adjust if needed
                selectedEndDate = minEnd;
                endDateCtrl.text = _formatDate(minEnd);
              }
            }

            // 🔥 Recalculate trip type
            _calculateTripType();
          });
        }
      },
      child: _buildDateContainer(label, controller),
    );
  }


  Widget _buildDateContainer(
      String label,
      TextEditingController controller,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            controller.text.isEmpty ? label : controller.text,
            style: TextStyle(
              fontSize: 14,
              color: controller.text.isEmpty
                  ? Colors.grey
                  : Colors.black,
            ),
          ),
          const Icon(Icons.calendar_today, size: 18),
        ],
      ),
    );
  }





  List<String> generateEndTimeSlots() {
    List<String> times = [];
    final now = DateTime.now();

    for (int hour = 0; hour < 24; hour++) {
      for (int minute in [0, 30]) {
        DateTime slot =
        DateTime(selectedEndDate.year, selectedEndDate.month, selectedEndDate.day, hour, minute);

        // 🚫 If same as start date → must be after start time
        if (_isSameDay(selectedEndDate, selectedStartDate)) {
          DateTime startDateTime = _combineDateTime(selectedStartDate, startTimeCtrl.text);
          if (slot.isBefore(startDateTime.add(const Duration(minutes: 30)))) {
            continue;
          }
        }

        // 🚫 If today → skip past time
        if (_isSameDay(selectedEndDate, now) && slot.isBefore(now)) {
          continue;
        }

        times.add(_formatTime(slot));
      }
    }

    return times;
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final period = time.hour >= 12 ? "PM" : "AM";

    return "$hour:${time.minute.toString().padLeft(2, '0')} $period";
  }

  DateTime _combineDateTime(DateTime date, String timeString) {
    if (timeString.isEmpty) {
      return date; // 🔥 prevent crash
    }

    final parts = timeString.split(' ');
    if (parts.length < 2) return date;

    final time = parts[0].split(':');
    if (time.length < 2) return date;

    int hour = int.tryParse(time[0]) ?? 0;
    int minute = int.tryParse(time[1]) ?? 0;

    final period = parts[1];

    if (period == "PM" && hour != 12) hour += 12;
    if (period == "AM" && hour == 12) hour = 0;

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  Widget _endTimeDropdown({
  required String label,
    required TextEditingController controller,
  }) {
    final times = generateEndTimeSlots();

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,

        value: times.contains(controller.text)
            ? controller.text
            : null,

        hint: Text(label,
            style: const TextStyle(color: Colors.grey)),

        items: times.map((time) {
          return DropdownMenuItem<String>(
            value: time,
            child: Text(time),
          );
        }).toList(),

        onChanged: (value) {
          setState(() {
            controller.text = value!;

            // ✅ Update full end datetime
            endDateTime =
                _combineDateTime(selectedEndDate, endTimeCtrl.text);

            _calculateTripType(); // 🔥 trigger price calculation
          });
        },


        buttonStyleData: ButtonStyleData(
          height: 53, // 🔥 smaller height
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),


        dropdownStyleData: DropdownStyleData(
          maxHeight: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }


  void _calculateTripType() {
    if (startDateTime == null || endDateTime == null) return;

    final diff = endDateTime!.difference(startDateTime!);
    if (diff.isNegative) return;

    tripDuration = diff;

    if (diff.inHours < 24) {
      selectedTripType.value = TripType.hourly;
    } else if (diff.inDays < 7) {
      selectedTripType.value = TripType.daily;
    } else {
      selectedTripType.value = TripType.weekly;
    }
  }





  Widget _pricingField(
      String label,
      TextEditingController ctrl, {
        bool enabled = true,
      }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StatefulBuilder(
        builder: (context, setState) {
          double coins = double.tryParse(ctrl.text) ?? 0;
          double dollars = coins / 10;

          return TextField(
            controller: ctrl,
            enabled: enabled,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {}); // refresh dollar display only
            },
            decoration: InputDecoration(
              labelText: label,
              filled: true,
              fillColor: enabled ? Colors.white : Colors.grey.shade200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),

              // 👇 Show converted dollar but DO NOT store it
              suffix: ctrl.text.isNotEmpty
                  ? Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  "\$${dollars.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  : null,
            ),
          );
        },
      ),
    );
  }




  Widget _titleSmall(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
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
          final selected = selectedPrefIds.contains(pref?.id ?? -1);
          return ChoiceChip(
            label: Text(pref?.name ?? ""),
            selected: selected,
            selectedColor: Colors.green,
            labelStyle:
            TextStyle(color: selected ? Colors.white : Colors.black),
            onSelected: (val) {
              setState(() {
                val
                    ? selectedPrefIds.add(pref.id ?? 0)
                    : selectedPrefIds.remove(pref.id ?? 0);
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

    // 🔥 BASIC FIELD CHECK
    if (pickupCtrl.text.isEmpty || selectedPrefIds.isEmpty) {
      _toast("Please fill all required details");
      return;
    }

    // 🔥 TRIP TIME CHECK
    if (startDateTime == null || endDateTime == null) {
      _toast("Please select trip start & end time");
      return;
    }

    if (endDateTime!.isBefore(startDateTime!)) {
      _toast("End time must be after start time");
      return;
    }

    // 🔥 PRICING CHECK BASED ON TRIP TYPE
    final type = selectedTripType.value;

    double? hourly;
    double? daily;
    double? weekly;

    if (type == TripType.hourly) {
      hourly = double.tryParse(hourlyCtrl.text.trim());
      if (hourly == null) {
        _toast("Please enter valid hourly price");
        return;
      }
    }

    if (type == TripType.daily || type == TripType.weekly) {
      daily = double.tryParse(dailyCtrl.text.trim());
      if (daily == null) {
        _toast("Please enter valid daily price");
        return;
      }
    }

    if (type == TripType.weekly) {
      weekly = double.tryParse(weeklyCtrl.text.trim());
      if (weekly == null) {
        _toast("Please enter valid weekly price");
        return;
      }
    }

    // 🔥 LOCATION CHECK
    if (controller.pickupLat == null || controller.pickupLng == null) {
      _toast("Location missing");
      return;
    }


    // 🚀 SUBMIT
    await controller.shareCar(
      id: car["id"],
      userId: 198,
      hourlyCost: hourly ?? 0,
      dailyCost: daily ?? 0,
      weeklyCost: weekly ?? 0,
      preferences: selectedPrefIds.join(","),
      address: pickupCtrl.text.trim(),
      lat: controller.pickupLat!,
      long: controller.pickupLng!,
      activeFrom: startDateTime,
      activeTill: endDateTime,
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

// generate time trip start time 30 min intervel


}

extension on Object? {
  get id => null;

  get name => null;
}

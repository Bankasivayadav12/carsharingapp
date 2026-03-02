import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:f_demo/screens/CarSharing/User/conform_booking.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'controller/user_recomended_list.dart';

import 'Chat_Screen.dart';
import 'model/user_model.dart';

class BookNowScreen extends StatefulWidget {
  final CarItem car;

  const BookNowScreen({super.key, required this.car});

  @override
  State<BookNowScreen> createState() => _BookNowScreenState();
}

class _BookNowScreenState extends State<BookNowScreen> {
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  TimeOfDay? selectedTime;
  TimeOfDay? selectedEndTime;
  DateTime? selectedDate;

  List<TimeOfDay> get availableEndTimes {
    if (_startDateTime == null || selectedEndDate == null) {
      return halfHourTimes;
    }

    final activeTill = widget.car.activeTill;

    return halfHourTimes.where((time) {
      final endDateTime = DateTime(
        selectedEndDate!.year,
        selectedEndDate!.month,
        selectedEndDate!.day,
        time.hour,
        time.minute,
      );

      // ✅ Must be after start time
      if (!endDateTime.isAfter(_startDateTime!)) return false;

      // ❌ Must NOT exceed availability
      if (endDateTime.isAfter(activeTill)) return false;

      return true;
    }).toList();
  }

  List<TimeOfDay> get halfHourTimes {
    List<TimeOfDay> times = [];

    for (int hour = 0; hour < 24; hour++) {
      times.add(TimeOfDay(hour: hour, minute: 0));
      times.add(TimeOfDay(hour: hour, minute: 30));
    }

    return times;
  }

  DateTime? availabilityEndDate;
  TimeOfDay? availabilityEndTime;

  DateTime? getAvailabilityEndDateTime() {
    if (availabilityEndDate == null || availabilityEndTime == null) return null;

    return DateTime(
      availabilityEndDate!.year,
      availabilityEndDate!.month,
      availabilityEndDate!.day,
      availabilityEndTime!.hour,
      availabilityEndTime!.minute,
    );
  }

  List<TimeOfDay> getAvailableTimes() {
    final now = DateTime.now();
    final availabilityEnd = widget.car.activeTill;

    return halfHourTimes.where((time) {
      if (selectedDate == null) return false;

      final startDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        time.hour,
        time.minute,
      );

      // ❌ Remove past times
      if (startDateTime.isBefore(now)) return false;

      // ❌ Must be at least 2 hours before availability end
      final lastAllowedStart =
      availabilityEnd.subtract(const Duration(hours: 2));

      if (startDateTime.isAfter(lastAllowedStart)) {
        return false;
      }

      return true;
    }).toList();
  }

  Duration? get tripDuration {
    if (_startDateTime == null || _endDateTime == null) return null;
    return _endDateTime!.difference(_startDateTime!);
  }


  final TextEditingController addressCtrl = TextEditingController();

  String? selectedAddress;
  double? selectedLat;
  double? selectedLng;

  bool isPickupExpanded = false;

  double pickupDistanceMiles = 0.0;
  double pickupCharge = 0.0;

  PaymentMethod selectedPaymentMethod = PaymentMethod.card;


  DateTime? get _endDateTime {
    if (selectedEndDate == null || selectedEndTime == null) return null;

    return DateTime(
      selectedEndDate!.year,
      selectedEndDate!.month,
      selectedEndDate!.day,
      selectedEndTime!.hour,
      selectedEndTime!.minute,
    );
  }

  DateTime? get _startDateTime {
    if (selectedDate == null || selectedTime == null) return null;

    return DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
  }

  /// RENT TYPE: Hour / Day
  String rentType = "Hour";

  /// Duration values
  double selectedHours = 1; // 1–24
  double selectedDays = 1; // 1–7

  bool collectFromPickup = false; // ✅ MUST be here


  late DateTime startDateTime;
  late TextEditingController dateCtrl;
  late TextEditingController timeCtrl;
  late final CarSharingController recommendedCtrl;
  late final CarSharingController carSharingController;

  int currentIndex = 0;


  final List<String> dummyCarImages = [
    "assets/images/benz_car.webp",
    "assets/images/benz_car.webp",
    "assets/images/benz_car.webp",
    "assets/images/benz_car.webp",
    "assets/images/benz_car.webp",
    "assets/images/benz_car.webp",
  ];

// Trip calculations

  double get totalTripCost {
    return baseTripCost + pickupCharge;
  }

  double get baseTripCost {
    if (tripDuration == null) return 0;
    return calculateBasePriceFromDuration(widget.car, tripDuration);
  }


  @override
  void initState() {
    super.initState();
    carSharingController = Get.find<CarSharingController>();
  }

  Widget build(BuildContext context) {
    final car = widget.car;

    List<String> carImages = [
      car.picVehicleImage ?? "",
      car.picVehicleReg ?? "",
      car.picVehicleIns ?? "",
      car.picVehicleInspection ?? "",
    ].where((e) => e.isNotEmpty).toList();

    if (carImages.isEmpty) {
      carImages.add("assets/images/benz_car.webp");
    }

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _bottomBookNow(),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _imageCarousel(carImages),
                    _carTitleSection(car),
                    _featuresGrid(car),

                    SizedBox(height: 20),

                    /// 🔹 Date & Time
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle1("Your trip"),
                          const SizedBox(height: 13),
                          _sectionTitle("Trip Start"),
                          const SizedBox(height: 8),

                          LayoutBuilder(
                            builder: (context, constraints) {
                              final double gap = 12;
                              final double itemWidth = (constraints.maxWidth -
                                  gap) / 2;

                              return Row(
                                children: [
                                  SizedBox(
                                    width: itemWidth,
                                    child: _datePickerBox(),
                                  ),
                                  SizedBox(width: gap),
                                  SizedBox(
                                    width: itemWidth,
                                    child: _timePickerBox(),
                                  ),
                                ],
                              );
                            },
                          ),


                        ],
                      ),),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 13),
                          _sectionTitle("Trip End"),
                          const SizedBox(height: 8),

                          LayoutBuilder(
                            builder: (context, constraints) {
                              final double gap = 12;
                              final double itemWidth = (constraints.maxWidth -
                                  gap) / 2;

                              return Row(
                                children: [
                                  SizedBox(
                                    width: itemWidth,
                                    child: _endDateBox(),
                                  ),
                                  SizedBox(width: gap),
                                  SizedBox(
                                    width: itemWidth,
                                    child: _endTimeBox(),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),),

                    const SizedBox(height: 22),

                    pickupReturnSection(),
                    const SizedBox(height: 12),

                    /// 🔹 Collect car toggle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _sectionTitle1("Take to pickup address"),
                          Switch(
                            value: collectFromPickup,
                            onChanged: (value) {
                              setState(() {
                                collectFromPickup = value;

                                if (!value) {
                                  pickupDistanceMiles = 0;
                                  pickupCharge = 0;
                                  addressCtrl.clear();
                                  selectedAddress = null;
                                  selectedLat = null;
                                  selectedLng = null;
                                }
                              });
                            },
                          ),
                        ],
                      ),),
                    const SizedBox(height: 12),

                    /// ✅ Show Pickup label + input ONLY when YES

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: collectFromPickup
                            ? Column(
                          key: const ValueKey("pickup"),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionTitle("Pickup Address"),

                            GooglePlaceAutoCompleteTextField(
                              textEditingController: addressCtrl,
                              googleAPIKey: "AIzaSyB08PuFrEY0Hp2GSz4MzGKx18TUSZR8HPI",
                              inputDecoration: InputDecoration(
                                hintText: "Search pickup location",
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),

                              debounceTime: 600,
                              // milliseconds
                              isLatLngRequired: true,

                              getPlaceDetailWithLatLng: (prediction) {
                                setState(() {
                                  selectedAddress = prediction.description;
                                  selectedLat =
                                      double.tryParse(prediction.lat ?? "");
                                  selectedLng =
                                      double.tryParse(prediction.lng ?? "");

                                  // ✅ Ensure both locations exist
                                  if (selectedLat != null &&
                                      selectedLng != null &&
                                      car.lat != null &&
                                      car.long != null) {
                                    // 📏 Distance in miles
                                    pickupDistanceMiles =
                                        _calculateDistanceMiles(
                                          car.lat!,
                                          car.long!,
                                          selectedLat!,
                                          selectedLng!,
                                        );

                                    // 💰 $2 per mile
                                    pickupCharge = pickupDistanceMiles * 2;
                                  }
                                });

                                debugPrint(
                                    "📍 Pickup Distance: ${pickupDistanceMiles
                                        .toStringAsFixed(2)} miles");
                                debugPrint("💰 Pickup Charge: \$${pickupCharge
                                    .toStringAsFixed(2)}");
                              },


                              itemClick: (prediction) {
                                addressCtrl.text = prediction.description ?? "";
                                addressCtrl.selection =
                                    TextSelection.fromPosition(
                                      TextPosition(
                                          offset: addressCtrl.text.length),
                                    );
                              },

                              itemBuilder: (context, index, prediction) {
                                return Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          color: Colors.green),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          prediction.description ?? "",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },

                              seperatedBuilder: const Divider(),

                              isCrossBtnShown: true,
                            ),

                            const SizedBox(height: 22),
                          ],
                        )
                            : const SizedBox.shrink(),
                      ),
                    ),

                    turoInfoSection(),
                    _hostSection(),
                    _turoVehicleFeatures(),
                    _reviewHeader(),
                    turoRatingSummary(),
                    _reviewList(),
                    _turoRulesOnRoad(),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ------------------------------
  // TOP APP BAR
  // ------------------------------
  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          _circleBtn(Icons.arrow_back_rounded, () {
            Navigator.pop(context);
          }),
          const Spacer(),
          const Text("Car Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          _circleBtn(Icons.more_horiz, () {}),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.grey.shade200,
        child: Icon(icon, color: Colors.black),
      ),
    );
  }

  // ------------------------------
  // IMAGE SLIDER
  // ------------------------------

  Widget _imageCarousel(List<String> images) {
    return SizedBox(
      height: 320,
      width: double.infinity,
      child: Stack(
        children: [

          // 🔹 Image Slider
          PageView.builder(
            itemCount: images.length,
            onPageChanged: (i) => setState(() => currentIndex = i),
            itemBuilder: (_, i) {
              return images[i].startsWith("http")
                  ? Image.network(
                images[i],
                fit: BoxFit.cover,
                width: double.infinity,
              )
                  : Image.asset(
                images[i],
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          ),

          // 🔹 Dark gradient bottom (Turo effect)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 🔹 Heart Button (Top Right)
          Positioned(
            top: 50,
            right: 16,
            child: Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                color: Colors.black,
              ),
            ),
          ),

          // 🔹 View Photos Button (Bottom Right)
          Positioned(
            bottom: 20,
            right: 16,
            child: GestureDetector(
              onTap: () => _showPhotoGallery(dummyCarImages),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.photo_library_outlined, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      "View ${dummyCarImages.length} photos",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  void _showPhotoGallery(List<String> images) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.95,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Column(
              children: [

                // 🔹 Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${images.length} Photos",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close),
                      )
                    ],
                  ),
                ),

                const Divider(),

                // 🔹 All Images in SingleChildScrollView
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      children: List.generate(images.length, (index) {
                        final img = images[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: GestureDetector(
                            onTap: () => _openFullPreview(images, index),
                            // 👈 OPEN PREVIEW
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: img.startsWith("http")
                                    ? Image.network(
                                  img,
                                  fit: BoxFit.cover,
                                )
                                    : Image.asset(
                                  img,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),


              ],
            );
          },
        );
      },
    );
  }

  void _openFullPreview(List<String> images, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                children: [
                  PageView.builder(
                    controller:
                    PageController(initialPage: index),
                    itemCount: images.length,
                    itemBuilder: (_, i) =>
                        Center(
                          child: Image.asset(
                            images[i],
                            fit: BoxFit.contain,
                          ),
                        ),
                  ),
                  Positioned(
                    top: 50,
                    right: 20,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 28),
                    ),
                  )
                ],
              ),
            ),
      ),
    );
  }

  // ------------------------------
  // IMAGE SLIDER
  // ------------------------------


  // ------------------------------
  // CAR TITLE + PRICE + RATING
  // ------------------------------

  Widget _carTitleSection(CarItem car) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🔹 Car Name
          Text(
            "${car.vehicle?.make ?? ''} ${car.vehicle?.model ?? ''}",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 8),

          // 🔹 Rating + Trips
          Row(
            children: const [
              Icon(Icons.star, size: 18, color: Colors.black),
              SizedBox(width: 4),
              Text(
                "4.97",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              SizedBox(width: 6),
              Text(
                "· 312 trips",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 🔹 Price
          Text(
            carSharingController.priceLabel(car),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          // 🔹 Cancellation Text
          const Text(
            "Free cancellation",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }


  // ------------------------------
  // HOST DETAILS
  // ------------------------------

  Widget _hostSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🟢 Profile Image
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.asset(
              "assets/images/benz_car.webp",
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 14),

          /// 🟢 Host Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Name
                const Text(
                  "Hela Quintin",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                /// Rating + Trips
                Row(
                  children: const [
                    Icon(Icons.star, color: Colors.orange, size: 16),
                    SizedBox(width: 4),
                    Text(
                      "4.98",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "(128 trips)",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                /// Verified
                Row(
                  children: const [
                    Icon(Icons.verified, color: Colors.blue, size: 16),
                    SizedBox(width: 4),
                    Text(
                      "Verified Host",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                /// Response time
                const Text(
                  "Responds within 1 hour",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          /// 🟢 Message Button
          Column(
            children: [
              _circleBtn(Icons.call, () {}),

              const SizedBox(height: 10),

              _circleBtn(Icons.message, () {
                Get.to(() =>
                    ChatScreen(
                      hostName: "Hela Quintin",
                      hostImage: "assets/images/benz_car.webp",
                    ));
              }),
            ],
          ),
        ],
      ),
    );
  }


  // ------------------------------
  // FEATURES GRID
  // ------------------------------

  Widget _featuresGrid(CarItem car) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 3),

          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2),
            children: [
              _featureBox("Capacity", "${car.numSeats ?? "--"} Seats"),
              _featureBox("Engine", "670 HP"),
              _featureBox("Max Speed", "250 km/h"),
              _featureBox("Advance", "Autopilot"),
              _featureBox("Single Charge", "405 Miles"),
              _featureBox("Advance", "Auto Parking"),
            ],
          )
        ],
      ),
    );
  }

  Widget _featureBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
              const TextStyle(color: Colors.grey, fontSize: 10)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  // ------------------------------
  // FEATURES GRID
  // ------------------------------


  Widget _sectionTitle(String text) {
    return Text(text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
  }

  Widget _sectionTitle1(String text) {
    return Text(text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }



  Widget _timePickerBox() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: _boxDecoration(),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<TimeOfDay>(
          isExpanded: true,
          value: selectedTime,
          hint: const Text(
            "Start Time",
            style: TextStyle(fontSize: 14),
          ),

          dropdownStyleData: DropdownStyleData(
            maxHeight: 240,
            offset: const Offset(0, 4), // small gap below field
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
          ), // 👈 force down

          items: getAvailableTimes().map((time) {
            return DropdownMenuItem<TimeOfDay>(
              value: time,
              child: Text(
                time.format(context),
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),

          onChanged: (TimeOfDay? newTime) {
            if (newTime == null || selectedDate == null) return;

            final startDateTime = DateTime(
              selectedDate!.year,
              selectedDate!.month,
              selectedDate!.day,
              newTime.hour,
              newTime.minute,
            );

            final availabilityEnd = widget.car.activeTill;
            final lastAllowedStart =
            availabilityEnd.subtract(const Duration(hours: 2));

            if (startDateTime.isAfter(lastAllowedStart)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Please select at least 2 hours before end trip availability",
                  ),
                ),
              );
              return; // ❌ Block selection
            }

            setState(() {
              selectedTime = newTime;
            });
          },
        ),
      ),
    );
  }

  Widget _datePickerBox() {
    return GestureDetector(
      onTap: pickDate,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: _boxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate == null
                  ? "Start Date"
                  : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!
                  .year}",
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.calendar_month),
          ],
        ),
      ),
    );
  }

  void pickTime() async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date first")),
      );
      return;
    }

    final TimeOfDay? picked =
    await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked == null) return;

    // ✅ Round to nearest 30 minutes
    int roundedMinutes;

    if (picked.minute < 15) {
      roundedMinutes = 0;
    } else if (picked.minute < 45) {
      roundedMinutes = 30;
    } else {
      roundedMinutes = 0;
    }

    int hour = picked.hour;

    // If minute was >=45 → move to next hour
    if (picked.minute >= 45) {
      hour = (hour + 1) % 24;
    }

    final TimeOfDay finalTime =
    TimeOfDay(hour: hour, minute: roundedMinutes);

    setState(() {
      selectedTime = finalTime;
    });
  }

  Widget _endDateBox() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: pickEndDate, // ✅ correct method
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          decoration: _boxDecoration(),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedEndDate == null
                      ? "End Date"
                      : "${selectedEndDate!.day}-${selectedEndDate!
                      .month}-${selectedEndDate!.year}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.calendar_month, size: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _endTimeBox() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: _boxDecoration(),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<TimeOfDay>(
          isExpanded: true,
          isDense: true,
          value: selectedEndTime,
          hint: const Text(
            "End Time",
            style: TextStyle(fontSize: 15),
          ),

          // 👇 Control popup behavior
          dropdownStyleData: DropdownStyleData(
            maxHeight: 240, // shows approx 5 items
            offset: const Offset(0, 4), // small gap below field
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            elevation: 4,
          ),

          // 👇 Control each row height
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),

          items: availableEndTimes.map((time) {
            return DropdownMenuItem<TimeOfDay>(
              value: time,
              child: Text(
                time.format(context),
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),

          onChanged: (TimeOfDay? newTime) {
            if (newTime == null || selectedEndDate == null) return;

            final endDateTime = DateTime(
              selectedEndDate!.year,
              selectedEndDate!.month,
              selectedEndDate!.day,
              newTime.hour,
              newTime.minute,
            );

            // ❌ Cannot exceed availability
            if (endDateTime.isAfter(widget.car.activeTill)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("End time exceeds car availability"),
                ),
              );
              return;
            }

            // ❌ Must be after start
            if (_startDateTime != null &&
                !endDateTime.isAfter(_startDateTime!)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("End time must be after start time"),
                ),
              );
              return;
            }

            setState(() {
              selectedEndTime = newTime;
            });
          },
        ),
      ),
    );
  }

  void pickEndDate() async {
    // 🚫 Start date & time must be selected first
    if (_startDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select start date & time first")),
      );
      return;
    }

    final DateTime start = _startDateTime!;
    final DateTime activeTill = widget.car.activeTill;

    // 🔒 Earliest end date must be AFTER start date-time
    final DateTime firstAllowedDate = DateTime(
      start.year,
      start.month,
      start.day,
    );

    // If start time is late in the day, end date may need to be next day
    final DateTime minEndDate =
    start.isAfter(firstAllowedDate) ? start : firstAllowedDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: minEndDate,
      firstDate: minEndDate,
      lastDate: activeTill,

      // 🔒 Disable invalid days
      selectableDayPredicate: (day) {
        final DateTime d = DateTime(day.year, day.month, day.day);
        return !d.isBefore(firstAllowedDate) && !d.isAfter(activeTill);
      },
    );

    if (picked == null) return;

    setState(() {
      selectedEndDate = picked;
      selectedEndTime = null; // 🔁 reset time when date changes
    });
  }

  void pickEndTime() async {
    // 🚫 End date must be selected first
    if (selectedEndDate == null || _startDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select end date first")),
      );
      return;
    }

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    final DateTime endDateTime = DateTime(
      selectedEndDate!.year,
      selectedEndDate!.month,
      selectedEndDate!.day,
      time.hour,
      time.minute,
    );

    // 🚫 End time must be AFTER start date & time
    if (!endDateTime.isAfter(_startDateTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("End time must be after start time"),
        ),
      );
      return;
    }

    // 🚫 End time must NOT exceed car availability
    if (endDateTime.isAfter(widget.car.activeTill)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("End time exceeds car availability"),
        ),
      );
      return;
    }

    // ✅ Valid end time
    setState(() {
      selectedEndTime = time;
    });
  }

  void pickDate() async {
    final DateTime activeTill = widget.car.activeTill;
    final DateTime today = DateTime.now();

    // Safety: if availability already expired
    if (activeTill.isBefore(today)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Car is no longer available")),
      );
      return;
    }

    DateTime? date = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,

      // 🔒 hard limit from API
      lastDate: activeTill,

      // 🔒 disable dates after activeTill
      selectableDayPredicate: (day) {
        final tillDate = DateTime(
          activeTill.year,
          activeTill.month,
          activeTill.day,
        );
        return !day.isAfter(tillDate);
      },
    );

    if (date == null) return;

    setState(() {
      selectedDate = date;
      selectedTime = null; // reset time when date changes
    });
  }



  double _calculateDistanceMiles(double lat1,
      double lon1,
      double lat2,
      double lon2,) {
    const earthRadiusMiles = 3958.8;

    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) * cos(_degToRad(lat2)) * sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusMiles * c;
  }

  double _degToRad(double deg) {
    return deg * (pi / 180);
  }

  Widget pickupReturnSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔹 Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Pickup & return location",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () {},
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// 🔹 Selected Location
          GestureDetector(
            onTap: () {
              setState(() {
                isPickupExpanded = !isPickupExpanded;
              });
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "On-site at Dallas/Fort Worth International Airport",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: isPickupExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(Icons.keyboard_arrow_down),
                )
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// 🔹 Expand Section
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: isPickupExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Pickup at Car Location
                _locationCard(
                  icon: Icons.directions_car,
                  title: "Farmers Branch, TX 75234",
                  subtitle:
                  "We’ll send you the exact address once your trip is booked.",
                ),

                const SizedBox(height: 14),

                const Text(
                  "PICKUP LOCATIONS",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 10),

                _locationCard(
                  icon: Icons.flight,
                  title: "Dallas/Fort Worth International Airport",
                  subtitle: "Airport",
                ),
              ],
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _locationCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget turoInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// ------------------ Trip Savings ------------------
          _sectionTitle1("Trip Savings"),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "3+ day discount",
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  "\$ 10",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// ------------------ Cancellation ------------------
          _sectionTitle1("Cancellation policy"),
          const SizedBox(height: 10),

          _infoRow(
            icon: Icons.thumb_up_alt_outlined,
            title: "Free cancellation",
            subtitle:
            "Full refund within 24 hours of booking. More flexible options available at checkout.",
          ),

          const SizedBox(height: 24),

          /// ------------------ Payment ------------------
          _sectionTitle1("Payment options"),
          const SizedBox(height: 10),

          _infoRow(
            icon: Icons.credit_card_outlined,
            title: "Flexible payment",
            subtitle:
            "\$0 due now when you choose the Refundable option at checkout.",
          ),

          const SizedBox(height: 24),

          /// ------------------ Distance ------------------
          _sectionTitle1("Distance included"),
          const SizedBox(height: 10),

          _infoRow(
            icon: Icons.speed_outlined,
            title: "600 mi",
            subtitle: "£0.54/mi fee for additional miles driven",
          ),

          const SizedBox(height: 24),

          /// ------------------ Insurance ------------------
          _sectionTitle1("Insurance"),
          const SizedBox(height: 10),

          _infoRow(
            icon: Icons.shield_outlined,
            title:
            "Insurance via ERS (Syndicate 218 at Lloyd’s) managed by IQUW Syndicate Management Limited.",
            subtitle: "",
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: Colors.black87),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }


  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
    );
  }


  // ======= Vehicle features available ============//

  Widget _turoVehicleFeatures() {
    final features = [
      {"icon": Icons.air, "title": "Air conditioning"},
      {"icon": Icons.bluetooth, "title": "Bluetooth"},
      {"icon": Icons.gps_fixed, "title": "GPS"},
      {"icon": Icons.usb, "title": "USB charger"},
      {"icon": Icons.chair, "title": "Heated seats"},
      {"icon": Icons.camera_alt_outlined, "title": "Backup camera"},
      {"icon": Icons.lock, "title": "Keyless entry"},
      {"icon": Icons.local_gas_station, "title": "Fuel efficient"},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Title
          const Text(
            "Vehicle features",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          /// Grid Layout (Turo style 2 column)
          GridView.builder(
            itemCount: features.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 18,
              crossAxisSpacing: 12,
              childAspectRatio: 4,
            ),
            itemBuilder: (context, index) {
              final item = features[index];
              return _featureItem(
                icon: item["icon"] as IconData,
                title: item["title"] as String,
              );
            },
          ),

          const SizedBox(height: 10),

          /// Show More Button (Optional)
          TextButton(
            onPressed: () {},
            child: const Text(
              "Show all features",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _featureItem({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.black,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  // ======= Vehicle features available ============//

  // ======= Rules on the road  ============//
  Widget _turoRulesOnRoad() {
    final rules = [
      {
        "icon": Icons.smoke_free,
        "title": "No smoking",
        "subtitle":
        "Smoking in the vehicle will result in a cleaning fee."
      },
      {
        "icon": Icons.pets,
        "title": "No pets",
        "subtitle":
        "Pets are not allowed unless approved by the host."
      },
      {
        "icon": Icons.speed,
        "title": "No off-roading",
        "subtitle":
        "Off-road driving is prohibited and may result in penalties."
      },
      {
        "icon": Icons.local_gas_station,
        "title": "Refuel before return",
        "subtitle":
        "Return the car with the same fuel level as pickup."
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Section Title
          const Text(
            "Rules on the road",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          /// Rules List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rules.length,
            separatorBuilder: (_, __) => const Divider(height: 28),
            itemBuilder: (context, index) {
              final rule = rules[index];
              return _ruleItem(
                icon: rule["icon"] as IconData,
                title: rule["title"] as String,
                subtitle: rule["subtitle"] as String,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _ruleItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// Icon
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.black,
          ),
        ),

        const SizedBox(width: 14),

        /// Text Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ======= Rules on the road  ============//


  // ------------------------------
  // REVIEWS SECTION
  // ------------------------------

  Widget turoRatingSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Big Rating
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "4.98",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.star, size: 18, color: Colors.black),
                      Icon(Icons.star, size: 18, color: Colors.black),
                      Icon(Icons.star, size: 18, color: Colors.black),
                      Icon(Icons.star, size: 18, color: Colors.black),
                      Icon(Icons.star_half, size: 18, color: Colors.black),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    "125 trips",
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              )
            ],
          ),

          const SizedBox(height: 20),

          /// Rating Breakdown
          ratingBar(5, 0.95),
          ratingBar(4, 0.04),
          ratingBar(3, 0.01),
          ratingBar(2, 0.0),
          ratingBar(1, 0.0),
        ],
      ),
    );
  }

  Widget ratingBar(int star, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text("$star"),
          const SizedBox(width: 4),
          const Icon(Icons.star, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 6,
                backgroundColor: Colors.grey.shade300,
                valueColor:
                const AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewHeader() {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text("Reviews & Rating",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          Text("See All",
              style: TextStyle(color: Colors.blue, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _reviewList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _turoReviewItem(
            name: "Mr. Jack",
            rating: 5.0,
            date: "January 2026",
            review:
            "The rental car was clean, reliable, and the service was quick. Pickup process was smooth and communication was excellent.",
          ),
          _turoReviewItem(
            name: "Robert",
            rating: 5.0,
            date: "December 2025",
            review:
            "Amazing ride. The car was smooth, very well maintained, and the host was friendly and professional.",
          ),
        ],
      ),
    );
  }

  Widget _turoReviewItem({
    required String name,
    required double rating,
    required String date,
    required String review,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),

        /// 👤 Profile + Name + Rating Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey,
              backgroundImage:
              AssetImage("assets/images/benz_car.webp"),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Name
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// Rating + Date
                  Row(
                    children: [
                      const Icon(Icons.star,
                          size: 14, color: Colors.black),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(width: 6),
                      const Text("•",
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(width: 6),
                      Text(
                        date,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  /// Verified badge (Turo style)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Verified renter",
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        /// 📝 Review Text
        Text(
          review,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 12),

        /// 👍 Helpful Button
        Row(
          children: [
            Icon(Icons.thumb_up_alt_outlined,
                size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 6),
            const Text(
              "Helpful",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            )
          ],
        ),

        const SizedBox(height: 20),
        const Divider(height: 1),
      ],
    );
  }

  // ------------------------------
  // REVIEWS SECTION
  // ------------------------------


  // ------------------------------
  // BOTTOM BOOK NOW BUTTON
  // ------------------------------

  Widget _bottomBookNow() {
    final double dollarValue = totalTripCost / 10;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 110,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -3))
        ],
      ),
      child: Column(
        children: [

          /// 💰 Show Price
          if (tripDuration != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Total Cost",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),

                  /// 🔥 Coins + Dollar (Side by Side - No Overflow)
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "${totalTripCost.toStringAsFixed(0)} Coins  •  \$${dollarValue.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          /// 🔘 Button
          Expanded(
            child: GestureDetector(
              onTap: tripDuration == null
                  ? null
                  : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConfirmBookingScreen(
                      car: widget.car,
                      startDateTime: _startDateTime!,
                      endDateTime: _endDateTime!,
                      totalCost: totalTripCost,
                      collectFromPickup: collectFromPickup,
                      pickupCharge: pickupCharge,
                      pickupDistance: pickupDistanceMiles,
                      pickupAddress: selectedAddress,
                    ),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: tripDuration == null
                      ? Colors.grey
                      : Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Book Now →",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  // ------------------------------
  // BOOKING DIALOG
  // ------------------------------


// ---------------------------------------------------------------------------
// CALCULATE BASE PRICE BASED ON RENT TYPE
// ---------------------------------------------------------------------------

  double calculateBasePriceFromDuration(CarItem car, Duration? duration) {
    if (duration == null) return 0;

    final int totalMinutes = duration.inMinutes;

    final double hourlyCost = car.hourlyCost ?? 0;
    final double dailyCost = car.dailyCost ?? 0;
    final double weeklyCost = car.weeklyCost ?? 0;

    const int minutesPerHour = 60;
    const int minutesPerDay = 24 * minutesPerHour;
    const int minutesPerWeek = 7 * minutesPerDay;

    // 🔥 CASE 1: Less than 24 hours (HOURLY)
    if (totalMinutes < minutesPerDay) {
      final hours = (totalMinutes / minutesPerHour).ceil();

      if (hourlyCost > 0) {
        return hours * hourlyCost;
      }

      // Fallback from daily
      if (dailyCost > 0) {
        return hours * (dailyCost / 24);
      }

      // Fallback from weekly
      if (weeklyCost > 0) {
        return hours * (weeklyCost / (7 * 24));
      }

      return 0;
    }

    // 🔥 CASE 2: Less than 7 days (DAILY)
    if (totalMinutes < minutesPerWeek) {
      final days = (totalMinutes / minutesPerDay).ceil();

      if (dailyCost > 0) {
        return days * dailyCost;
      }

      // fallback from hourly
      if (hourlyCost > 0) {
        return (days * 24) * hourlyCost;
      }

      return 0;
    }

    // 🔥 CASE 3: Weekly
    final weeks = (totalMinutes / minutesPerWeek).floor();
    final remainingMinutes = totalMinutes - (weeks * minutesPerWeek);
    final remainingDays = (remainingMinutes / minutesPerDay).ceil();

    double total = 0;

    if (weeklyCost > 0) {
      total += weeks * weeklyCost;
    } else if (dailyCost > 0) {
      total += (weeks * 7) * dailyCost;
    }

    if (dailyCost > 0) {
      total += remainingDays * dailyCost;
    }

    return total;
  }

  String getPriceText(CarItem car) {
    if (car.weeklyCost != null && car.weeklyCost! > 0) {
      return "\$${car.weeklyCost!.toStringAsFixed(2)}/week";
    }

    if (car.dailyCost != null && car.dailyCost! > 0) {
      return "\$${car.dailyCost!.toStringAsFixed(2)}/day";
    }

    if (car.hourlyCost != null && car.hourlyCost! > 0) {
      return "\$${car.hourlyCost!.toStringAsFixed(2)}/hr";
    }

    return "Price not available";
  }

// ---------------------------------------------------------------------------
// CALCULATE BASE PRICE BASED ON RENT TYPE
// ---------------------------------------------------------------------------

  // double calculateTotalCost() {
  //   final duration = getTripDuration();
  //   if (duration == null) return 0;
  //
  //   int days = duration.inDays;
  //   int remainingHours = duration.inHours - (days * 24);
  //
  //   double total = 0;
  //
  //   if (days > 0) {
  //     total += days * widget.car.costPerDay;
  //   }
  //
  //   if (remainingHours > 0) {
  //     total += remainingHours * widget.car.costPerHour;
  //   }
  //
  //   return total;
  // }
}
import 'package:f_demo/screens/CarSharing/User/Book_now_screen.dart';
import 'package:f_demo/screens/CarSharing/User/user_chatlist.dart';

import 'package:f_demo/screens/CarSharing/User/user_notification.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/user_recomended_list.dart';

import 'model/user_model.dart';


class UserCarsScreen extends StatefulWidget {
  const UserCarsScreen({super.key});

  @override
  State<UserCarsScreen> createState() => _UserCarsScreenState();
}

class _UserCarsScreenState extends State<UserCarsScreen> {
  final CarSharingController controller = Get.put(CarSharingController());

  // Filters State
  int selectedCarType = 0;
  RangeValues priceRange = const RangeValues(10, 230);
  int selectedRental = 0;
  int selectedCapacity = 4;
  int selectedFuel = 0;
  DateTime selectedDateTime = DateTime.now();
  final TextEditingController locationCtrl = TextEditingController();
  final TextEditingController searchCtrl = TextEditingController();


  final List<Map<String, dynamic>> dummyPopularCars = [
    {
      "name": "Tesla Model S",
      "image": "assets/images/tesla_car.png",
      "price": 120,
      "rating": 4.9,
    },
    {
      "name": "BMW M5",
      "image": "assets/images/bmw_car.png",
      "price": 150,
      "rating": 4.8,
    },

    {
      "name": "Mercedes C-Class",
      "image": "assets/images/benz_car.webp",
      "price": 140,
      "rating": 4.9,
    },
  ];



  void initState() {
    super.initState();
    controller.fetchCarsAutomatically(); // API loads silently
  }



  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [

              /// 🔥 FIXED TOP SECTION
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(13),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _topHeader(),
                    const SizedBox(height: 16),
                    _searchBar(),
                    const SizedBox(height: 16),
                    _brandChips(),
                  ],
                ),
              ),

              /// 🔥 SCROLLABLE CONTENT
              Expanded(
                child: Stack(
                  children: [

                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          _recommendSection(),
                          const SizedBox(height: 30),
                          _popularSection(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),

                    /// 🔥 AUTO SUGGESTION OVERLAY
                    if (controller.suggestions.isNotEmpty)
                      _suggestionsBox(),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }



  Widget _topHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade200,
            child: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => Get.to(() => UserChatListScreen()),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.green.shade50,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            GestureDetector(
              onTap: () => Get.to(() => const UserNotificationScreen()),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(
                  Icons.notifications_none,
                  color: Colors.black,
                  size: 22,
                ),
              ),
            ),

            const SizedBox(width: 10),

            TextButton(
              onPressed: () => _showHistoryBottomSheet(context),
              child: const Text(
                "History",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ),




          ],
        )
      ],
    );
  }

  // ------------------------------------------------------------------
  // SEARCH BAR
  // ------------------------------------------------------------------
  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: searchCtrl, // ✅ IMPORTANT
              onChanged: controller.search,
              decoration: const InputDecoration(
                hintText: "Search pickup location...",
                border: InputBorder.none,
              ),
            ),
          ),

          GestureDetector(
            onTap: () => _openPreferencesBottomSheet(),
            child: const Icon(Icons.tune, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------
  // AUTO-SUGGESTIONS POPUP
  // ------------------------------------------------------------------
  Widget _suggestionsBox() {
    return Positioned(
      left: 16,
      right: 16,
      top: 120,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        child: ListView(
          shrinkWrap: true,
          children: controller.suggestions
              .map(
                (s) => ListTile(
              title: Text(s),
              onTap: () {
                searchCtrl.text = s;
                controller.search(s);
                controller.suggestions.clear();
              },
            ),
          )
              .toList(),
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // BRAND CHIPS
  // ------------------------------------------------------------------
  Widget _brandChips() {
    final brands = [
      {"name": "ALL", "brand": "ALL", "icon": Icons.directions_car},
      {"name": "Airports & Stations", "brand": "Ford", "icon": Icons.airplanemode_on},
      {"name": "Monthly", "brand": "Tesla", "icon": Icons.calendar_month},
      {"name": "Brand", "brand": "BMW", "icon": Icons.car_rental},
      {"name": "Near by", "brand": "Honda", "icon": Icons.location_on},
      {"name": "Cities", "brand": "Volvo", "icon": Icons.location_city_outlined},
      {"name": "Delivered", "brand": "Volkswagen Beetle", "icon": Icons.send},
    ];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: brands.length,
        itemBuilder: (_, i) {
          final b = brands[i];
          final selected = controller.selectedBrand.value == b["brand"];

          return GestureDetector(
            onTap: () => controller.filterByBrand(b["brand"] as String),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? Colors.green : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected ? Colors.green : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  Icon(b["icon"] as IconData,
                      color: selected ? Colors.white : Colors.black),
                  const SizedBox(width: 6),
                  Text(
                    b["name"] as String,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------------
  // RECOMMENDED CARS GRID — FIXED ASPECT RATIO
  // ------------------------------------------------------------------
  Widget _recommendSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TITLE + DURATION DROPDOWN
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _title("Recommended for you"),
            ),

            PopupMenuButton<int>(
              tooltip: "Duration",
              offset: const Offset(0, 32), // ✅ DROPDOWN SHOWN LOWER
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) {
                // 🔥 Add filter logic here later if required
                // controller.filterByDuration(value);
              },
              itemBuilder: (context) => const [
                PopupMenuItem<int>(
                  value: 1,
                  child: Text("Hourly"),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Text("Daily"),
                ),
                PopupMenuItem<int>(
                  value: 3,
                  child: Text("Weekly"),
                ),
              ],
              child: Row(
                children: const [
                  Text(
                    "Duration",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ],
        ),


        const SizedBox(height: 14),


        /// LIST OF CAR CARDS
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.filteredCars.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (_, i) =>
              _recommendedCard(controller.filteredCars[i]),
        ),
      ],
    );
  }

  Widget _recommendedCard(CarItem car) {
    final String? apiImage = car.picVehicleImage;

    final bool hasValidNetworkImage = apiImage != null &&
        apiImage.isNotEmpty &&
        (apiImage.startsWith("http://") || apiImage.startsWith("https://"));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE + TOP RIGHT BADGE
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.8,
                child: ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
                  child: hasValidNetworkImage
                      ? Image.network(
                    apiImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      "assets/images/benz_car.webp",
                      fit: BoxFit.cover,
                    ),
                  )
                      : Image.asset(
                    "assets/images/benz_car.webp",
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              /// 🔔 AVAILABLE BADGE (TOP RIGHT)
              if ((car.availabilityInWeeks ?? 0) > 0 ||
                  (car.availabilityInDays ?? 0) > 0 ||
                  (car.availabilityInHours ?? 0) > 0)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(191),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Available · ${controller.availabilityDuration(car)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

            ],
          ),

          const SizedBox(height: 12),

          /// NAME + PRICE (SIDE BY SIDE)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LEFT SIDE (NAME + PLATE)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${car.vehicle?.make ?? ''} ${car.vehicle?.model ?? ''}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        car.licensePlateNum ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                /// RIGHT SIDE (PRICE)



                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(31),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    controller.priceLabel(car),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.green,
                    ),
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(height: 12),

          /// ADDRESS (FULL WIDTH)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on,
                  size: 18,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    car.address ?? 'Location not available',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          /// CTA BUTTON
          /// CTA BUTTON
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: (car.isBooked ?? false)
                      ? Colors.grey
                      : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: (car.isBooked ?? false)
                    ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "This car is already booked. Please choose another one.",
                      ),
                    ),
                  );
                }
                    : () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookNowScreen(car: car),
                  ),
                ),
                child: Text(
                  (car.isBooked ?? false) ? "Already Booked" : "Book Now",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  // ------------------------------------------------------------------
  // POPULAR CARS — NO OVERFLOW   SECTION -3
  // ------------------------------------------------------------------

  Widget _popularSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title("Popular Cars"),
        const SizedBox(height: 14),

        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dummyPopularCars.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) => _popularDummyCard(dummyPopularCars[i]),
          ),
        ),
      ],
    );
  }

  Widget _popularDummyCard(Map<String, dynamic> car) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),

      // 👇 VERY IMPORTANT — THIS REMOVES FLEX OVERFLOW
      width: MediaQuery.of(context).size.width * 0.78,
      child: Row(
        mainAxisSize: MainAxisSize.min, // ⛔ Prevent Row from expanding beyond width
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // =============================
          // FIXED SIZE IMAGE → NO OVERFLOW
          // =============================
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              car["image"],
              width: 135,     // 🔥 100% overflow-proof
              height: 70,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 50),

          // =============================
          // TEXT PART IN EXPANDED → SHRINKS SAFELY
          // =============================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // CAR NAME
                Text(
                  car["name"],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                // RATING
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      car["rating"].toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // PRICE
                Text(
                  "\$${car["price"]}/Day",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // ------------------------------------------------------------------
  // PREFERENCES BOTTOMSHEET
  // ------------------------------------------------------------------
  void _openPreferencesBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, bottomSetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.89,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                children: [
                  // ---------------- HEADER ----------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Preferences",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  // ---------------- CONTENT ----------------
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ---------------- CAR TYPE ----------------
                          _sectionTitle("Car Type"),
                          Wrap(
                            spacing: 10,
                            children: [
                              _chip("All", selectedCarType == 0,
                                      () => bottomSetState(() => selectedCarType = 0)),
                              _chip("Regular", selectedCarType == 1,
                                      () => bottomSetState(() => selectedCarType = 1)),
                              _chip("Luxury", selectedCarType == 2,
                                      () => bottomSetState(() => selectedCarType = 2)),
                            ],
                          ),

                          const Divider(height: 30),

                          // ---------------- PRICE RANGE ----------------
                          _sectionTitle("Price Range"),
                          RangeSlider(
                            values: priceRange,
                            min: 10,
                            max: 230,
                            divisions: 20,
                            activeColor: Colors.green,
                            labels: RangeLabels(
                              "\$${priceRange.start.toInt()}",
                              "\$${priceRange.end.toInt()}+",
                            ),
                            onChanged: (v) =>
                                bottomSetState(() => priceRange = v),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _priceBox("\$${priceRange.start.toInt()}"),
                              _priceBox("\$${priceRange.end.toInt()}+"),
                            ],
                          ),

                          const Divider(height: 30),

                          // ---------------- PICKUP DATE ----------------
                          _pickupDate(bottomSetState),

                          const Divider(height: 30),

                          // ---------------- SEATING CAPACITY ----------------
                          _sectionTitle("Seating Capacity"),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [2, 4, 5, 6, 7, 8].map((c) {
                              return _chip(
                                c == 8 ? "8+ Seater" : "$c Seater",
                                selectedCapacity == c,
                                    () => bottomSetState(() => selectedCapacity = c),
                              );
                            }).toList(),
                          ),

                          const Divider(height: 30),

                          // ---------------- FUEL TYPE ----------------
                          _sectionTitle("Fuel Type"),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _chip("Electric", selectedFuel == 0,
                                      () => bottomSetState(() => selectedFuel = 0)),
                              _chip("Petrol", selectedFuel == 1,
                                      () => bottomSetState(() => selectedFuel = 1)),
                              _chip("Diesel", selectedFuel == 2,
                                      () => bottomSetState(() => selectedFuel = 2)),
                              _chip("Hybrid", selectedFuel == 3,
                                     () => bottomSetState(() => selectedFuel = 3)),
                            ],

                          ),
                        ],
                      ),
                    ),
                  ),

                  // ---------------- APPLY BUTTON ----------------

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Apply Filters",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // PICKUP DATE ROW
  // ------------------------------------------------------------------
  Widget _pickupDate(void Function(void Function()) bottomSetState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Pickup Date",
            style: TextStyle(fontWeight: FontWeight.bold)),
        InkWell(
          onTap: () async {
            DateTime? date = await showDatePicker(
              context: context,
              initialDate: selectedDateTime,
              firstDate: DateTime(2020),
              lastDate: DateTime(2035),
            );
            if (date == null) return;

            TimeOfDay? time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(selectedDateTime),
            );
            if (time == null) return;

            bottomSetState(() {
              selectedDateTime = DateTime(
                date.year,
                date.month,
                date.day,
                time.hour,
                time.minute,
              );
            });
          },
          child: Row(
            children: [
              Text(
                "${selectedDateTime.day}/${selectedDateTime.month}/${selectedDateTime.year} • "
                    "${TimeOfDay.fromDateTime(selectedDateTime).format(context)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.calendar_month),
            ],
          ),
        ),
      ],
    );
  }
  // ------------------------------------------------------------------
  // SHARED WIDGETS
  // ------------------------------------------------------------------
    Widget _title(String text) {
      return Text(text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
    }

  Widget _chip(String text, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.green : Colors.white,
          border: Border.all(
              color: selected ? Colors.green : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _priceBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }


  void _showHistoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {

        // 🔥 Dummy Booking Data
        final bookings = [
          {
            "carName": "Mercedes Benz",
            "pickup": "Hyderabad",
            "amount": 285.34,
            "date": "10 Feb 2026 - 12 Feb 2026",
          },
          {
            "carName": "BMW X5",
            "pickup": "Gachibowli",
            "amount": 165.00,
            "date": "20 Jan 2026 - 22 Jan 2026",
          },
        ];

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (_, controller) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [

                  /// Top Drag Handle
                  Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const Text(
                    "Booking History",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {

                        final booking = bookings[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              Text(
                                booking["carName"] as String,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text("Pickup: ${booking["pickup"]}"),
                              Text("Date: ${booking["date"]}"),

                              const SizedBox(height: 6),

                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "\$${booking["amount"]}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

}

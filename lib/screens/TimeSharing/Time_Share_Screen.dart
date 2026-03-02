import 'dart:async';

import 'package:f_demo/screens/TimeSharing/timeShare_notification_screen.dart';
import 'package:f_demo/screens/TimeSharing/timesharing_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'controller/timeShare_User_Controller.dart';

import 'TimeShare_Booknow_Screen.dart';
import '../CarSharing/User/booking_history_screen.dart';
import 'model/timesharing_model.dart';


class TimeShareCarsListPage extends StatefulWidget {
  const TimeShareCarsListPage({super.key});


  @override
  State<TimeShareCarsListPage> createState() => _TimeShareCarsListPageState();
}

class _TimeShareCarsListPageState extends State<TimeShareCarsListPage> {
  final controller = Get.put(TimeSharingVehicleController());
  String selectedFilter = "All";
  String searchText = "";
  Timer? _debounce;

  final Color green = const Color(0xFF1DAA5B);
  final Color blackSmoke = const Color(0xFF1A1A1A);

  final List<String> filters = [
    "All",
    "Premium",
    "Economy",
    "Luxury",
    "SUV",
    "Xuv",
  ];

  @override
  void initState() {
    super.initState();
    controller.loadVehicles();
  }

  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: blackSmoke,
        centerTitle: true,

        title: const Text(
          "TimeShare Cars",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          /// 🔔 Notification
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_none),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Get.to(() => const NotificationScreen());
            },
          ),

          /// 💬 Chat
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
              Get.to(() => const TimeShareChatScreen());
            },
          ),

          /// 🕓 History
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Get.to(() => const BookingHistoryScreen());
            },
          ),

        ],

      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _searchBar(),
            const SizedBox(height: 18),
            _filterChips(),
            const SizedBox(height: 12),
            const Text(
              "Available Cars",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            /// 🔥 ONLY THIS PART IS REACTIVE
            Obx(() {

              if (controller.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final filteredCars = controller.vehicles.where((car) {

                final matchesSearch =
                "${car?.vehicle.make} ${car?.vehicle.model}"
                    .toLowerCase()
                    .contains(searchText.toLowerCase());

                final matchesFilter = selectedFilter == "All" ||
                    car?.rideTypes.toLowerCase() ==
                        selectedFilter.toLowerCase();

                return matchesSearch && matchesFilter;

              }).toList();

              if (filteredCars.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: Text("No Cars Found")),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredCars.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 240,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (_, index) {
                  return _carCard(filteredCars[index]);
                },
              );
            }),

            const SizedBox(height: 25),

            /// Featured Section (optional reactive)
            Obx(() {
              if (controller.vehicles.isEmpty) {
                return const SizedBox();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Featured Car",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _featuredCarCard(controller.vehicles.first),
                ],
              );
            }),

          ],
        ),
      ),

    );
  }


  // SEARCH BAR
  Widget _searchBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: green.withOpacity(0.4), width: 1),
      ),
      child: TextField(
        onChanged: (value) {

          if (_debounce?.isActive ?? false) {
            _debounce!.cancel();
          }

          _debounce = Timer(const Duration(milliseconds: 400), () {
            setState(() {
              searchText = value;
            });
          });

        },
        decoration: InputDecoration(
          hintText: "Search car (e.g. Tesla, BMW)...",
          border: InputBorder.none,
          icon: Icon(Icons.search, size: 22, color: green),
        ),
      ),
    );
  }



  // FILTER CHIPS
  Widget _filterChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, index) {
          final filter = filters[index];
          final bool isSelected = filter == selectedFilter;

          return GestureDetector(
            onTap: () => setState(() => selectedFilter = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(colors: [green, green.withOpacity(0.7)])
                    : null,
                color: isSelected ? null : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: green.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
                    : [],
              ),
              alignment: Alignment.center,
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : blackSmoke,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // FEATURED CAR
  Widget _featuredCarCard(TimeSharingVehicle car) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.black,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [

            /// Background Image
            Image.asset(
              "assets/images/benz_car.webp",
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            /// Green Overlay
            Container(
              width: double.infinity,
              height: double.infinity,
              //color: Colors.,
            ),

            /// Text + Button
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [

                  Expanded(
                    child: Text(
                      "${car.vehicle.year} ${car.vehicle.make} ${car.vehicle.model}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "View",
                      style: TextStyle(
                        color: green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }




  // CAR CARD  (NO OVERFLOW)
  Widget _carCard(TimeSharingVehicle car) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 1),
            color: Colors.black12.withOpacity(0.10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🚗 IMAGE (Use Network or Default Image)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: car.vehicleImageUrl != null
                ? Image.network(
              car.vehicleImageUrl!,
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            )
                : Image.asset(
              "assets/images/bmw_car.png",
              height: 60,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 20),

          /// 🚘 CAR NAME
          Text(
            "${car.vehicle.year} ${car.vehicle.make} ${car.vehicle.model}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: blackSmoke,
            ),
          ),

          const SizedBox(height: 2),

          /// 🚙 TYPE (Premium / Economy)
          Text(
            car.rideTypes,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 6),

          /// 💰 PRICE + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// Hourly Price
              Text(
                "\$${car.hourlyCost}/hr",
                style: TextStyle(
                  fontSize: 16,
                  color: green,
                  fontWeight: FontWeight.bold,
                ),
              ),

              /// Availability
              car.isBooked
                  ? const Text(
                "Booked",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              )
                  : const Text(
                "Available",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

         const SizedBox(height: 2,),

          /// 🟢 BOOK NOW BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: car.isBooked
                  ? null
                  : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        TimeShare_BookNowScreen(car: car),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: blackSmoke,
                minimumSize: const Size(double.infinity, 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Book Now",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



}

extension on Object? {
  get rideTypes => null;

  get vehicle => null;
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'AddCarForm.dart';
import 'controller/vehicle_controller.dart';
import 'model/host_model.dart';

class AddCarPage extends StatefulWidget {
  const AddCarPage({super.key});

  @override
  State<AddCarPage> createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  final VehicleController vehicleController = Get.find<VehicleController>();

  String? hostName = "Host";

  @override
  void initState() {
    super.initState();
    vehicleController.loadVehicles(198); // pass userId
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f5f7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        foregroundColor: Colors.lightGreen,
        title: const Text(
          "Add Your Car",
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerCard(),

            const SizedBox(height: 25),
            _addCarButton(),

            const SizedBox(height: 28),
            const Text(
              "Your Cars",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 14),

            /// ⭐ SHOW CAR LIST FROM API
            Obx(() {
              if (vehicleController.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (vehicleController.vehicles.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "No cars added yet.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return Column(
                children: vehicleController.vehicles
                    .map((car) => _carTile(car))
                    .toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade200.withOpacity(0.5),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withOpacity(0.3),
            child: const Icon(Icons.person, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "Welcome, ${hostName ?? ""}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        ],
      ),
    );
  }

  // ================= ADD BUTTON =================
  Widget _addCarButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.green, Colors.green],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ElevatedButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddVehiclePage(onSaved: (_) {}),
            ),
          );

          // 🔥 Refresh after returning
          vehicleController.loadVehicles(198);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          "➕  Add New Car",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }

  // ================= CAR TILE =================
  Widget _carTile(VehicleResponse car) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.green,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ---------------- LEFT IMAGE ----------------
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 110,
              height: 85,
              color: Colors.grey.shade100,
              child: Image.asset(
                "assets/images/benz_car.webp",   // 🔥 your asset image
                fit: BoxFit.cover,
              ),
            ),
          ),


          const SizedBox(width:70),

          // ---------------- RIGHT DETAILS ----------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CAR NAME
                Text(
                  car.vehicle?.name ?? "Unknown Car",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                // TRIM
                Row(
                  children: [
                    Icon(Icons.directions_car,
                        size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(
                      car.trim ?? "—",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // BADGES
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    if (car.rideTypes != null && car.rideTypes!.isNotEmpty)
                      _badge(
                        car.rideTypes!,
                        Colors.blue.shade50,
                        Colors.blue.shade700,
                      ),

                    if (car.greenCarType != null &&
                        car.greenCarType!.toString().isNotEmpty)
                      _badge(
                        "Green",
                        Colors.green.shade50,
                        Colors.green.shade700,
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                // LICENSE PLATE
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    car.licensePlateNum ?? "----",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _badge(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }

  Widget _placeholderCar() {
    return const Icon(
      Icons.directions_car_rounded,
      size: 40,
      color: Colors.grey,
    );
  }




}

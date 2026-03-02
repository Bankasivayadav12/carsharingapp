// host_register_page.dart

import 'dart:convert';
import 'dart:io';
import 'package:f_demo/screens/CarSharing/host/add_car_page.dart';
import 'package:f_demo/screens/CarSharing/host/host_earnings.dart';
import 'package:f_demo/screens/CarSharing/host/share_car_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controller/vehicle_controller.dart';
import 'host_chatlist.dart';
import 'host_notifications.dart';
import 'host_profile.dart';

class HostRegisterPage extends StatefulWidget {
  const HostRegisterPage({super.key});

  @override
  State<HostRegisterPage> createState() => _HostRegisterPageState();
}

class _HostRegisterPageState extends State<HostRegisterPage> {
  final Color primary = const Color(0xFF1DAA5B);

  final VehicleController vehicleController = Get.put(VehicleController());

  @override
  void initState() {
    super.initState();
    vehicleController.loadVehicles(198);
  }

  // ===============================================================
  // 🔥 TRENDY MESSAGE
  // ===============================================================

  void showTrendyMessage(String message, {bool success = true}) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) {
        return Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Center(
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 250),
              builder: (context, value, child) => Transform.translate(
                offset: Offset(0, -20 * (1 - value)),
                child: Opacity(opacity: value, child: child),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: success
                        ? [Colors.green.shade700, Colors.green.shade500]
                        : [Colors.red.shade700, Colors.red.shade500],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      success ? Icons.check_circle : Icons.error,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2), () => entry.remove());
  }

  // ===============================================================
  // CAR SAVER
  // ===============================================================

  List<Map<String, dynamic>> cars = [];

  Future<void> _saveCars() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List mapped = cars.map((c) {
      return {
        "name": c["name"],
        "number": c["number"],
        "image": c["image"] is File ? (c["image"] as File).path : c["image"],
        "id": c["id"],
      };
    }).toList();

    prefs.setString("cars_list", jsonEncode(mapped));
  }

  // ===============================================================
  // UI
  // ===============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff9fafb),
      body: Column(
        children: [
          _topHeader(),
          const SizedBox(height: 10),
          _actionButtonsRow(),
          const SizedBox(height: 20),
          _sectionHeader("Your Cars List", "View All"),
          const SizedBox(height: 10),

          Expanded(
            child: Obx(() {
              if (vehicleController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (vehicleController.vehicles.isEmpty) {
                return const Center(child: Text("No vehicles found"));
              }

              return ListView.builder(
                itemCount: vehicleController.vehicles.length,
                padding: const EdgeInsets.all(12),
                itemBuilder: (_, index) {
                  final v = vehicleController.vehicles[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _apiCarCard(v),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // 🔥 CAR CARD
  // ===============================================================

  Widget _apiCarCard(v) {
    return GestureDetector(
      onTap: () async {
        /// 🔵 ACTIVE CAR → SHOW POPUP → EDIT
        if (v.isActive == true) {
          final confirm = await _showEditConfirmDialog(context);

          if (!confirm) return;

          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ShareCarPage(
                car: {
                  "name": "${v.vehicle?.make} ${v.vehicle?.model}",
                  "number": v.licensePlateNum,
                  "image": v.picVehicleImage,
                  "id": v.id,
                },
              ),
            ),
          );

          if (result == true) {
            showTrendyMessage("Car Updated Successfully!");
            await vehicleController.loadVehicles(198);
            //=-------  have to put host id here  ---------+//
            vehicleController.vehicles.refresh();
          }
          return;
        }

        /// 🟢 NOT ACTIVE → SHARE FLOW
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ShareCarPage(
              car: {
                "name": "${v.vehicle?.make} ${v.vehicle?.model}",
                "number": v.licensePlateNum,
                "image": v.picVehicleImage,
                "id": v.id,
              },
            ),
          ),
        );

        if (result == true) {
          showTrendyMessage("Car Shared Successfully!");
          await vehicleController.loadVehicles(198);
          vehicleController.vehicles.refresh();
        }
      },

      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            /// IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/images/tesla_car.png",
                width: 130,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 40),

            /// DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${v.vehicle?.make ?? ''} ${v.vehicle?.model ?? ''}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Plate: ${v.licensePlateNum ?? 'N/A'}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: 120,
                    child: (v.isActive == true)
                        /// 🔵 ACTIVE STATE
                        ? Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade200, // 🔥 Your expanded color
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: null, // disabled
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      "Active",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),


                              const SizedBox(width: 8),

                              /// ✏️ EDIT ICON (ONLY WAY TO EDIT ACTIVE CAR)
                              GestureDetector(
                                onTap: () async {
                                  final confirm = await _showEditConfirmDialog(
                                    context,
                                  );

                                  if (!confirm) return;

                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ShareCarPage(
                                        car: {
                                          "id": v.id,
                                          "userId": 198,// 🔥 REQUIRED
                                          "is_active": v
                                              .isActive, // 🔥 REQUIRED FOR EDIT
                                          "name":
                                              "${v.vehicle?.make} ${v.vehicle?.model}",
                                          "number": v.licensePlateNum,
                                          "image": v.picVehicleImage,

                                          // 🔥 PREFILL DATA
                                          "hourly_cost": v.hourlyCost,
                                          "daily_cost": v.dailyCost,
                                          "weekly_cost": v.weeklyCost,
                                          "address": v.address,
                                          "preferences": v.prefsSel,
                                          "lat": v.lat,
                                          "long": v.long,
                                        },
                                      ),
                                    ),
                                  );

                                  if (result == true) {
                                    showTrendyMessage(
                                      "Car Updated Successfully!",
                                    );
                                    await vehicleController.loadVehicles(198);
                                    vehicleController.vehicles.refresh();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.edit, size: 18),
                                ),
                              ),
                            ],
                          )
                        /// 🟢 NOT ACTIVE → SHARE NOW
                        : ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ShareCarPage(
                                    car: {
                                      "name":
                                          "${v.vehicle?.make} ${v.vehicle?.model}",
                                      "number": v.licensePlateNum,
                                      "image": v.picVehicleImage,
                                      "id": v.id,
                                    },
                                  ),
                                ),
                              );

                              if (result == true) {
                                showTrendyMessage("Car Shared Successfully!");
                                await vehicleController.loadVehicles(198);
                                vehicleController.vehicles.refresh();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Share Now",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
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

  Future<bool> _showEditConfirmDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Your car is already shared ",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              content: const Text(
                "Do you really want to edit car share details?",
                style: TextStyle(fontSize: 14),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("No"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(backgroundColor: primary),
                  child: const Text("Yes"),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  // ===============================================================
  // HEADER
  // ===============================================================

  Widget _topHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          /// 🔙 BACK + CHAT BUTTON ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// BACK BUTTON (Left)
              GestureDetector(
                onTap: () => Get.back(),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),

              /// SPACER (push items to corners)
              Row(
                children: [
                  /// CHAT BUTTON (Center)
                  GestureDetector(
                    onTap: () => Get.to(() => ChatListScreen()),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ), // 🔥 spacing between chat & notifications
                  /// NOTIFICATION BUTTON (Right)
                  GestureDetector(
                    onTap: () => Get.to(() => HostNotificationsScreen()),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => Get.to(() => HostProfilePage()),
                    child: const CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage(
                        "assets/images/benz_car.webp",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 15),

          /// 🚗 CENTER IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              "assets/images/benz_car.webp",
              width: 250,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ===============================================================
  // ACTION BUTTONS
  // ===============================================================

  Widget _actionButtonsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _actionCard(Icons.add_circle, "Add Car", () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddCarPage()),
            );

            if (result != null) {
              cars.add(result);
              await _saveCars();
              showTrendyMessage("Car Added Successfully!");
              setState(() {});
            }
          }),

          _actionCard(Icons.wallet, "Earnings", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ManageCarPage(cars: [], onDelete: (index) {}),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _actionCard(IconData icon, String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        width: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // SECTION HEADER
  // ===============================================================

  Widget _sectionHeader(String title, String actionText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          Text(
            actionText,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

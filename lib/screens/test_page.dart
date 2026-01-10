import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/basic_testing.dart';
import '../model/test_model.dart';



class BasicVehiclePage extends StatefulWidget {
  @override
  _BasicVehiclePageState createState() => _BasicVehiclePageState();
}

class _BasicVehiclePageState extends State<BasicVehiclePage> {
  final ctrl = Get.put(VehicleBasicController());

  final trimCtrl = TextEditingController();
  final colorCtrl = TextEditingController();
  final rideTypeCtrl = TextEditingController();
  final greenCarCtrl = TextEditingController();
  final plateCtrl = TextEditingController();

  bool isDefault = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Vehicle (Basic)")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _input("Trim", trimCtrl),
            _input("Color (Number)", colorCtrl),
            _input("Ride Types (2,3)", rideTypeCtrl),
            _input("Green Car ID", greenCarCtrl),
            _input("License Plate", plateCtrl),

            Row(
              children: [
                Checkbox(
                    value: isDefault,
                    activeColor: Colors.green,
                    onChanged: (v) => setState(() => isDefault = v!)),
                Text("Set as default")
              ],
            ),

            const SizedBox(height: 20),

            Obx(() {
              return ElevatedButton(
                onPressed: ctrl.isSubmitting.value
                    ? null
                    : () async {
                  final model = VehicleBasicModel(
                    userId: 1,
                    vehicleId: 261,
                    trim: trimCtrl.text,
                    color: int.tryParse(colorCtrl.text) ?? 0,
                    rideTypes: rideTypeCtrl.text,
                    greenCarId: greenCarCtrl.text,

                  );

                  final ok = await ctrl.submitVehicle(model);

                  if (ok) {
                    Get.snackbar(
                      "Success",
                      "Vehicle stored successfully!",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    Navigator.pop(context);
                  } else {
                    Get.snackbar(
                      "Error",
                      "Failed to store vehicle",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: ctrl.isSubmitting.value
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Submit", style: TextStyle(color: Colors.white)),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:f_demo/screens/CarSharing/host/controller/AddCar_controller.dart';
import 'package:f_demo/screens/CarSharing/host/controller/color_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'controller/CarModel_Controller.dart';


class AddVehiclePage extends StatefulWidget {
  final Function(Map<String, dynamic>) onSaved;

  const AddVehiclePage({super.key, required this.onSaved});

  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage>
    with SingleTickerProviderStateMixin {
   final ColorController colorController = Get.put(ColorController());  //step-1  api calling
    late TabController tabController;

   final CarModelController carModelController = Get.put(CarModelController());

   final AddVehicleController addVehicleController = Get.put(AddVehicleController());




  // Controllers
  final TextEditingController modelCtrl = TextEditingController();
  final TextEditingController trimCtrl = TextEditingController();
  final TextEditingController insuranceNoCtrl = TextEditingController();
  final TextEditingController insuranceExpiryCtrl = TextEditingController();
  final TextEditingController licensePlateCtrl = TextEditingController();

  File? carImage;
  int? selectedModelId;


  // Documents
  File? insuranceDoc;
  File? inspectionDoc;
  File? registrationDoc;

  // Dropdown selections
  String? selectedColor;
  String? selectedGreenCarType;
  String? selectedRideType;


  bool setAsDefault = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    modelCtrl.addListener(() {
      setState(() {});
    });
  }

  Future pickImage(Function(File?) setter) async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) setter(File(img.path));
    setState(() {});
  }

  // -------------------------------------------------------
  // PAGE UI
  // -------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Add Vehicle",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        bottom: TabBar(
          controller: tabController,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.green,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "Vehicle Details"),
            Tab(text: "Vehicle Documents"),
          ],
        ),
      ),

      body: TabBarView(
        controller: tabController,
        children: [
          _vehicleDetailsTab(),
          _vehicleDocumentsTab(),
        ],
      ),
    );
  }




  // -------------------------------------------------------
  // VEHICLE DETAILS TAB (Redesigned)
  // -------------------------------------------------------
  Widget _vehicleDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- Upload Car Image Card ----------
          GestureDetector(
            onTap: () => pickImage((file) => carImage = file),
            child: Container(
              height: 170,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.grey.shade200,
                border: Border.all(color: Colors.grey.shade300),
                image: carImage != null
                    ? DecorationImage(
                  image: FileImage(carImage!),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: carImage == null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.camera_alt_rounded,
                      size: 42, color: Colors.black54),
                  SizedBox(height: 10),
                  Text("Tap to Upload Vehicle Image",
                      style: TextStyle(
                          color: Colors.black54, fontSize: 14)),
                ],
              )
                  : null,
            ),
          ),

          const SizedBox(height: 20),

          // ---------- Form Card ----------
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Column(
              children: [
                _modelSearchField(),
                _rowTwo("Trim", trimCtrl, "Color", _colorDropdown()),
                _input("Insurance Policy Number", insuranceNoCtrl),
                _dateInput("Insurance Expiry Date", insuranceExpiryCtrl),
                _input("License Number Plate", licensePlateCtrl),

                _dropdown(
                  "Green Car Type",
                  ["Hybrid", "Electric", "Petrol", "Diesel"],
                      (val) => selectedGreenCarType = val,
                ),

                const SizedBox(height: 16),

                _dropdown(
                  "Ride Type",
                  ["Economy", "Premium", "SUV"],
                      (val) => selectedRideType = val,
                ),

                Row(
                  children: [
                    Checkbox(
                      activeColor: Colors.green,
                      value: setAsDefault,
                      onChanged: (v) => setState(() => setAsDefault = v!),
                    ),
                    const Text("Set as default vehicle"),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ---------- SUBMIT BUTTON ----------
          Row(
            children: [
              Expanded(
                child: Obx(() {
                  final addCtrl = Get.find<AddVehicleController>();

                  return ElevatedButton(
                    onPressed: addCtrl.isSubmitting.value
                        ? null
                        : () async {
                      // VALIDATION ---------------------------
                      if (modelCtrl.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please enter Model")),
                        );
                        return;
                      }

                      if (trimCtrl.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please enter Trim")),
                        );
                        return;
                      }

                      if (selectedColor == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please select Color")),
                        );
                        return;
                      }

                      if (licensePlateCtrl.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please enter License Plate")),
                        );
                        return;
                      }

                      // 🚀 CALL API
                      final success = await addCtrl.submitVehicle(
                        userId: 198,
                        vehicleId: selectedModelId!,  // <-- Set your model ID here
                        trim: trimCtrl.text.trim(),
                        color: int.parse(selectedColor ?? "0"),
                        rideTypes: selectedRideType ?? "",
                        //greenCarId: selectedGreenCarType ?? "",
                        isDefault: setAsDefault,
                        plateNumber: licensePlateCtrl.text.trim(),
                      );

                      if (success) {
                        Get.snackbar("Success", "Vehicle Added Successfully");
                        Navigator.pop(context);
                      } else {
                        Get.snackbar("Error", "Failed to add vehicle.");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: addCtrl.isSubmitting.value
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      "Add Vehicle",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  );
                }),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Cancel"),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }




  // -------------------------------------------------------
  // VEHICLE DOCUMENT TAB (Redesigned)
  // -------------------------------------------------------
  Widget _vehicleDocumentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Upload Vehicle Documents"),

          const SizedBox(height: 12),

          _uploadBox(
            "Insurance Document",
            insuranceDoc,
                () => pickImage((f) => insuranceDoc = f),
          ),

          _uploadBox(
            "Inspection Report",
            inspectionDoc,
                () => pickImage((f) => inspectionDoc = f),
          ),

          _uploadBox(
            "Registration Document",
            registrationDoc,
                () => pickImage((f) => registrationDoc = f),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Add Vehicle",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  // --------------------------------------------------------
  // COMMON WIDGETS (Redesigned)
  // --------------------------------------------------------
  Widget _input(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 18,        // 🔥 Increase label text size
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          floatingLabelStyle: const TextStyle(
            fontSize: 20,        // 🔥 Increase floating label size
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _rowTwo(
      String l1, TextEditingController c1, String l2, Widget right) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration( // 🔥 Your fill color here
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _inputRow(l1, c1)),
            const SizedBox(width: 20),
            Expanded(child: right),
          ],
        ),
      ),
    );
  }


  Widget _inputRow(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        floatingLabelStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16, // 🔥 matches Dropdown height
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }



  Widget _colorDropdown() {
    return Obx(() {
      return DropdownButtonFormField<String>(
        value: selectedColor,
        isExpanded: true,
        menuMaxHeight: 250,

        decoration: InputDecoration(
          labelText: "Color",                     // ✅ Label stays
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          floatingLabelStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.green, width: 2),
          ),
        ),

        onTap: () async {},

        // ⭐ FIXED — No extra "Color" item inside dropdown
        items: colorController.colors.isEmpty
            ? [
          const DropdownMenuItem(
            value: null,
            child: Text("No Colors Found"),
          )
        ]
            : colorController.colors.map((c) {
          return DropdownMenuItem<String>(
            value: c.id.toString(),
            child: Text(c.name),
          );
        }).toList(),

        onChanged: (val) {
          setState(() {
            selectedColor = val;
          });
        },
      );
    });
  }




  Widget _modelSearchField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ✏️ INPUT FIELD
          TextField(
            controller: modelCtrl,
            onChanged: (value) {
              carModelController.searchModels(value);
              setState(() {});  // ⬅️ Required to rebuild suggestions when typing
            },
            decoration: InputDecoration(
              labelText: "Model",
              labelStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              floatingLabelStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.green,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.black,
                ),
              ),
            ),
          ),

          const SizedBox(height: 4),

          // 🔍 SUGGESTIONS DROPDOWN LIST
          Obx(() {
            final list = carModelController.suggestions.value;

            // 1️⃣ If no text typed → hide suggestions
            if (modelCtrl.text.trim().isEmpty) {
              return const SizedBox();
            }

            // 2️⃣ If no API results
            if (list.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: _suggestionBoxDecoration(),
                child: const Text("No models found"),
              );
            }

            // 3️⃣ Show suggestions
            return Container(
              height: 200,
              decoration: _suggestionBoxDecoration(),
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];

                  return ListTile(
                    dense: true,
                    title: Text(
                      item.name ?? "Unknown Model",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      selectedModelId = item.id;      // ✅ Save Model ID here
                      modelCtrl.text = item.name ?? "";
                      carModelController.suggestions.clear();
                      FocusScope.of(context).unfocus();
                      setState(() {});
                    },

                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }


// 🎨 Suggestion box styling
  BoxDecoration _suggestionBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    );
  }




  Widget _dropdown(
      String label, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          floatingLabelStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:  BorderSide(color: Colors.grey),
          ),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
  Widget _uploadBox(String label, File? file, VoidCallback pickFn) {
    return GestureDetector(
      onTap: pickFn,
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        height: 160, // 🔥 Same height for all
        width: double.infinity,

        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300, width: 1.2),


          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: file == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.upload_file_rounded,
                size: 40, color: Colors.black54),
            const SizedBox(height: 10),
            Text(label,
                style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500)),
          ],
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.file(
            file,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      ),
    );
  }


  Widget _dateInput(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: ctrl,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 18,        // 🔥 Increase label text size
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          floatingLabelStyle: const TextStyle(
            fontSize: 20,        // 🔥 Increase floating label size
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:  BorderSide(color: Colors.grey),
          ),
        ),
        onTap: () async {
          DateTime? date = await showDatePicker(
            context: context,
            firstDate: DateTime(2000),
            lastDate: DateTime(2050),
            initialDate: DateTime.now(),
          );
          if (date != null) {
            ctrl.text = "${date.day}-${date.month}-${date.year}";
          }
        },
      ),
    );
  }
}

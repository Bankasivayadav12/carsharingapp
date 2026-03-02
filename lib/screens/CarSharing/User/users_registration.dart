import 'dart:io';
import 'package:f_demo/screens/CarSharing/User/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'controller/carsharing_user_controller.dart';

class UserRegisterPage extends StatefulWidget {
  final int userId;

  const UserRegisterPage({super.key, required this.userId});

  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final licenseController = TextEditingController();
  final insurancePolicyController = TextEditingController();

  File? licenseImage;
  File? insuranceImage;

  final ImagePicker _picker = ImagePicker();

  final UserCreateController createController =
  Get.put(UserCreateController());

  @override
  void dispose() {
    licenseController.dispose();
    insurancePolicyController.dispose();
    super.dispose();
  }

  // -------------------------------------------------
  // 📸 Pick Image
  // -------------------------------------------------
  Future<void> pickImage(bool isLicense) async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isLicense) {
          licenseImage = File(pickedFile.path);
        } else {
          insuranceImage = File(pickedFile.path);
        }
      });
    }
  }

  // -------------------------------------------------
  // 📝 Register User
  // -------------------------------------------------
  void registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    if (licenseImage == null || insuranceImage == null) {
      Get.snackbar(
        "Error",
        "Please upload required documents",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (widget.userId == 0) {
      Get.snackbar("Error", "Invalid User ID");
      return;
    }

    bool success = await createController.createUser(
      userId: widget.userId,
      licenseNumber: licenseController.text.trim(),
      policyNumber: insurancePolicyController.text.trim(),
    );

    if (success) {
      Get.snackbar(
        "Success",
        "Registration Completed 🎉",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.off(() => UserCarsScreen());
    } else {
      Get.snackbar(
        "Error",
        "Failed to register",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // -------------------------------------------------
  // 🎨 Input Decoration
  // -------------------------------------------------
  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.green.shade700),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.green.shade600, width: 2),
      ),
    );
  }

  // -------------------------------------------------
  // 📦 Upload Box Widget
  // -------------------------------------------------
  Widget uploadBox(String title, File? image, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green.shade700,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.green.shade400),
            ),
            child: image == null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.upload_file,
                    size: 40, color: Colors.green.shade600),
                const SizedBox(height: 8),
                const Text("Tap to upload"),
              ],
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------
  // 🖥 UI
  // -------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade600,
              Colors.green.shade400,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: const [
                    Icon(Icons.directions_car,
                        size: 60, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      "Car Sharing Registration",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Form Section
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        TextFormField(
                          controller: licenseController,
                          decoration: inputDecoration(
                              "Driver License Number", Icons.credit_card),
                          validator: (v) =>
                          v!.isEmpty ? "Enter license number" : null,
                        ),

                        const SizedBox(height: 20),

                        uploadBox(
                          "Upload Driver License",
                          licenseImage,
                              () => pickImage(true),
                        ),

                        const SizedBox(height: 25),

                        Text(
                          "Insurance Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextFormField(
                          controller: insurancePolicyController,
                          decoration: inputDecoration(
                              "Policy Number", Icons.description),
                          validator: (v) =>
                          v!.isEmpty ? "Enter policy number" : null,
                        ),

                        const SizedBox(height: 20),

                        uploadBox(
                          "Upload Insurance Document",
                          insuranceImage,
                              () => pickImage(false),
                        ),

                        const SizedBox(height: 30),

                        Obx(() => ElevatedButton(
                          onPressed: createController.isLoading.value
                              ? null
                              : registerUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            padding:
                            const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: createController.isLoading.value
                              ? const CircularProgressIndicator(
                              color: Colors.white)
                              : const Text(
                            "Complete Registration",
                            style: TextStyle(fontSize: 16),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

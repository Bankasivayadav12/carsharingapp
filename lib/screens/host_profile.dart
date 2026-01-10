import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/HostCarShare_Preferences.dart';

class HostProfilePage extends StatelessWidget {
  HostProfilePage({super.key});

  final HostCarSharePreferencesController prefController =
  Get.put(HostCarSharePreferencesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Host Preferences"),
        backgroundColor: Colors.green,
      ),

      body: Obx(() {
        // Show loading text until data arrives
        if (prefController.hostPreferences.isEmpty) {
          return const Center(child: Text("Loading preferences..."));
        }

        // When data is loaded, show list
        return ListView.builder(
          itemCount: prefController.hostPreferences.length,
          itemBuilder: (context, index) {
            final pref = prefController.hostPreferences[index];

            return ListTile(
              title: Text(pref.name),
              //subtitle: Text("ID: ${pref.id}"),
            );
          },
        );
      }),
    );
  }
}

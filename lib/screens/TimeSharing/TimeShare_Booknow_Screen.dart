import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model/timesharing_model.dart';

class TimeShare_BookNowScreen extends StatefulWidget {
  final TimeSharingVehicle car;

  const TimeShare_BookNowScreen({
    super.key,
    required this.car,
  });

  @override
  State<TimeShare_BookNowScreen> createState() =>
      _TimeShare_BookNowScreenState();
}

class _TimeShare_BookNowScreenState
    extends State<TimeShare_BookNowScreen> {

  DateTime? pickupDateTime;
  DateTime? dropDateTime;

  bool withDriver = false;
  int waitingTime = 0;

  final TextEditingController pickupAddressController =
  TextEditingController();

  // Format DateTime
  String format(DateTime? time) =>
      time == null
          ? "Select Date & Time"
          : DateFormat("dd MMM yyyy • hh:mm a").format(time);

  // Date + Time Picker
  Future<DateTime?> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (date == null) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return null;

    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  @override
  Widget build(BuildContext context) {

    final car = widget.car;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
            "Book ${car.vehicle.make} ${car.vehicle.model}"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🚗 CAR IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: car.vehicleImageUrl != null
                  ? Image.network(
                car.vehicleImageUrl!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                "assets/images/bmw_car.png",
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 18),

            /// 🚘 TITLE
            Text(
              "${car.vehicle.year} ${car.vehicle.make} ${car.vehicle.model}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "${car.rideTypes} • ${car.vehicle.seatingCapacity} Seats",
              style: const TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 25),

            /// 🚗 Booking Type
            _title("Booking Type"),

            Row(
              children: [

                Expanded(
                  child: ChoiceChip(
                    label: const Text("Car Only"),
                    selected: !withDriver,
                    onSelected: (_) {
                      setState(() {
                        withDriver = false;
                        waitingTime = 0;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ChoiceChip(
                    label: const Text("Car + Driver"),
                    selected: withDriver,
                    onSelected: (_) {
                      setState(() {
                        withDriver = true;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// 📅 Pickup
            _title("Pickup Date & Time"),
            _selectorTile(
              label: format(pickupDateTime),
              icon: Icons.calendar_today,
              onTap: () async {
                final picked = await _pickDateTime();
                if (picked != null) {
                  setState(() {
                    pickupDateTime = picked;
                  });
                }
              },
            ),

            const SizedBox(height: 18),

            /// 📅 Drop
            _title("Drop Date & Time"),
            _selectorTile(
              label: format(dropDateTime),
              icon: Icons.event,
              onTap: () async {
                final picked = await _pickDateTime();
                if (picked != null) {
                  setState(() {
                    dropDateTime = picked;
                  });
                }
              },
            ),

            /// 📍 Pickup Address (Only If Driver)
            if (withDriver) ...[
              const SizedBox(height: 20),

              _title("Pickup Address"),

              TextField(
                controller: pickupAddressController,
                decoration: InputDecoration(
                  hintText: "Enter pickup location",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],

            /// ⏳ Waiting Time (Only If Driver)
            if (withDriver) ...[
              const SizedBox(height: 20),

              _title("Waiting Time (minutes)"),

              Slider(
                value: waitingTime.toDouble(),
                min: 0,
                max: 60,
                divisions: 6,
                activeColor: Colors.black,
                onChanged: (value) {
                  setState(() {
                    waitingTime = value.toInt();
                  });
                },
              ),

              Text("$waitingTime minutes"),
            ],

            const SizedBox(height: 25),

            /// 💰 Cost
            _title("Estimated Cost"),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade100,
              ),
              child: Column(
                children: [

                  _priceRow("Price per Hour",
                      "₹${car.hourlyCost}"),

                  const Divider(),

                  _priceRow(
                    "Total Estimate",
                    "₹${_calculateTotal(car.hourlyCost)}",
                    isBold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// ✅ Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  if (pickupDateTime == null ||
                      dropDateTime == null) {
                    _showError("Please select pickup and drop time");
                    return;
                  }

                  if (dropDateTime!
                      .isBefore(pickupDateTime!)) {
                    _showError("Drop time must be after pickup time");
                    return;
                  }

                  if (withDriver &&
                      pickupAddressController.text.isEmpty) {
                    _showError("Please enter pickup address");
                    return;
                  }

                  // 🔥 Call Booking API here

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Booking Confirmed")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                  const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Confirm Booking",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _selectorTile({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Text(label),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  Widget _title(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _priceRow(String label, String value,
      {bool isBold = false}) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontWeight:
                isBold ? FontWeight.bold : FontWeight.w500)),
        Text(value,
            style: TextStyle(
                fontWeight:
                isBold ? FontWeight.bold : FontWeight.w600)),
      ],
    );
  }

  String _calculateTotal(double pricePerHour) {

    if (pickupDateTime == null ||
        dropDateTime == null) return "0";

    final diff =
        dropDateTime!.difference(pickupDateTime!).inHours;

    if (diff <= 0) return "0";

    final baseCost = diff * pricePerHour;

    final driverCharge = withDriver ? 500 : 0;
    final waitingCost = withDriver ? waitingTime * 2 : 0;

    return (baseCost + driverCharge + waitingCost)
        .toStringAsFixed(0);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

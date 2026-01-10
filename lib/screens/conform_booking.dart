import 'package:flutter/material.dart';
import '../model/host_response.dart';
import 'payment_sucess_screen.dart';

class ConfirmBookingScreen extends StatefulWidget {
  final CarItem car;

  const ConfirmBookingScreen({super.key, required this.car});

  @override
  State<ConfirmBookingScreen> createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  final TextEditingController addressCtrl = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String paymentMethod = "Card";
  bool showCardFields = true;

  /// RENT TYPE: Hour / Day
  String rentType = "Hour";

  /// Duration values
  double selectedHours = 1;  // 1–24
  double selectedDays = 1;   // 1–7

  @override
  Widget build(BuildContext context) {
    final car = widget.car;

    double costPerHr = (car.hourlyCost ?? 0).toDouble();
    double basePrice = _calculateBasePrice(costPerHr);
    double tax = basePrice * 0.10;
    double total = basePrice + tax;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Confirm Booking",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF00A86B),
        foregroundColor: Colors.white,
        elevation: 3,
      ),

      bottomNavigationBar: _bottomPayButton(total),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _carDetailsCard(car),

            const SizedBox(height: 22),

            _sectionTitle("Pickup Address"),
            TextField(
              controller: addressCtrl,
              decoration: InputDecoration(
                hintText: "Enter pickup address",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 22),

            Row(
              children: [
                Expanded(child: _datePickerBox()),
                const SizedBox(width: 14),
                Expanded(child: _timePickerBox()),
              ],
            ),

            const SizedBox(height: 25),

            _sectionTitle("Select Duration"),

            const SizedBox(height: 12),
            _rentTypeTabs(),

            const SizedBox(height: 20),

            /// Show Hour Slider
            if (rentType == "Hour") _hourSlider(),

            /// Show Day Slider
            if (rentType == "Day") _daySlider(),

            const SizedBox(height: 25),

            _sectionTitle("Payment Method"),

            _paymentMethodTile(
              title: "Credit / Debit Card",
              icon: Icons.credit_card,
              selected: paymentMethod == "Card",
              onTap: () {
                setState(() {
                  paymentMethod = "Card";
                  showCardFields = true;
                });
              },
            ),

            if (showCardFields) _creditCardForm(),

            _paymentMethodTile(
              title: "Apple Pay",
              icon: Icons.phone_iphone,
              selected: paymentMethod == "Apple Pay",
              onTap: () {
                setState(() {
                  paymentMethod = "Apple Pay";
                  showCardFields = false;
                });
              },
            ),

            _paymentMethodTile(
              title: "Google Pay",
              icon: Icons.android,
              selected: paymentMethod == "Google Pay",
              onTap: () {
                setState(() {
                  paymentMethod = "Google Pay";
                  showCardFields = false;
                });
              },
            ),

            _paymentMethodTile(
              title: "PayPal",
              icon: Icons.account_balance_wallet,
              selected: paymentMethod == "PayPal",
              onTap: () {
                setState(() {
                  paymentMethod = "PayPal";
                  showCardFields = false;
                });
              },
            ),

            const SizedBox(height: 22),

            _sectionTitle("Payment Summary"),
            _priceRow("Base Price", "\$${basePrice.toStringAsFixed(2)}"),
            _priceRow("Tax (10%)", "\$${tax.toStringAsFixed(2)}"),
            const Divider(),
            _priceRow("Total", "\$${total.toStringAsFixed(2)}", bold: true),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CALCULATE BASE PRICE BASED ON RENT TYPE
  // ---------------------------------------------------------------------------

  double _calculateBasePrice(double hourlyCost) {
    if (rentType == "Hour") {
      return hourlyCost * selectedHours;
    } else {
      double costPerDay = hourlyCost * 24;
      return costPerDay * selectedDays;
    }
  }

  // ---------------------------------------------------------------------------
  // RENT TYPE TABS
  // ---------------------------------------------------------------------------

  Widget _rentTypeTabs() {
    return Row(
      children: [
        _rentTab("Hour"),
        const SizedBox(width: 12),
        _rentTab("Day"),
      ],
    );
  }

  Widget _rentTab(String type) {
    bool isSelected = rentType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            rentType = type;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF00A86B) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            type,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HOUR SLIDER
  // ---------------------------------------------------------------------------

  Widget _hourSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Hours: ${selectedHours.toInt()} hr",
            style: const TextStyle(fontSize: 16)),
        Slider(
          value: selectedHours,
          min: 1,
          max: 24,
          divisions: 23,
          label: "${selectedHours.toInt()}",
          activeColor: const Color(0xFF00A86B),
          onChanged: (v) {
            setState(() {
              selectedHours = v;
            });
          },
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // DAY SLIDER
  // ---------------------------------------------------------------------------

  Widget _daySlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Days: ${selectedDays.toInt()} day(s)",
            style: const TextStyle(fontSize: 16)),
        Slider(
          value: selectedDays,
          min: 1,
          max: 7,
          divisions: 6,
          label: "${selectedDays.toInt()}",
          activeColor: const Color(0xFF00A86B),
          onChanged: (v) {
            setState(() {
              selectedDays = v;
            });
          },
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // UI COMPONENTS BELOW (unchanged except auto-updating amounts)
  // ---------------------------------------------------------------------------

  Widget _sectionTitle(String text) {
    return Text(text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _carDetailsCard(CarItem car) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4)
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              car.picVehicleImage ?? "",
              width: 110,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Image.asset("assets/images/tesla_car.png", width: 110),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${car.vehicle?.make ?? ''} ${car.vehicle?.model ?? ''}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text("\$${car.hourlyCost}/hr",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
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
                  ? "Select Date"
                  : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.calendar_month),
          ],
        ),
      ),
    );
  }

  Widget _timePickerBox() {
    return GestureDetector(
      onTap: pickTime,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: _boxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedTime == null
                  ? "Select Time"
                  : selectedTime!.format(context),
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.access_time),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
    );
  }

  Widget _paymentMethodTile({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: selected ? const Color(0xFF00A86B) : Colors.grey.shade300,
            width: 1.4),
        color: selected ? const Color(0xFFEFFBF5) : Colors.white,
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 35, color: Colors.black87),
            const SizedBox(width: 16),
            Text(title,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w600)),
            const Spacer(),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? const Color(0xFF00A86B) : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _creditCardForm() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Card Number",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Expiry (MM/YY)",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "CVV",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _bottomPayButton(double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -3))
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00A86B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PaymentSuccessScreen(),
            ),
          );
        },
        child: Text(
          "Pay \$${total.toStringAsFixed(2)} →",
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight:FontWeight.bold),
        ),
      ),
    );
  }

  void pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  void pickTime() async {
    TimeOfDay? time =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) setState(() => selectedTime = time);
  }
}

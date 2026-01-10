import 'package:carsharingapp/screens/conform_booking.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../model/host_response.dart';
import 'Chat_Screen.dart';

class BookNowScreen extends StatefulWidget {
  final CarItem car;
  const BookNowScreen({super.key, required this.car});

  @override
  State<BookNowScreen> createState() => _BookNowScreenState();
}

class _BookNowScreenState extends State<BookNowScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final car = widget.car;

    List<String> carImages = [
      car.picVehicleImage ?? "",
      car.picVehicleReg ?? "",
      car.picVehicleIns ?? "",
      car.picVehicleInspection ?? "",
    ].where((e) => e.isNotEmpty).toList();

    if (carImages.isEmpty) {
      carImages.add("assets/images/benz_car.webp");
    }

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _bottomBookNow(),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _imageCarousel(carImages),
                    _carTitleSection(car),
                    _hostSection(),
                    _featuresGrid(car),
                    _reviewHeader(),
                    _reviewList(),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ------------------------------
  // TOP APP BAR
  // ------------------------------
  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          _circleBtn(Icons.arrow_back_rounded, () {
            Navigator.pop(context);
          }),
          const Spacer(),
          const Text("Car Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          _circleBtn(Icons.more_horiz, () {}),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.grey.shade200,
        child: Icon(icon, color: Colors.black),
      ),
    );
  }

  // ------------------------------
  // IMAGE SLIDER
  // ------------------------------
  Widget _imageCarousel(List<String> images) {
    return Column(
      children: [
        SizedBox(
          height: 240,
          child: PageView.builder(
            itemCount: images.length,
            onPageChanged: (i) => setState(() => currentIndex = i),
            itemBuilder: (_, i) => ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: images[i].startsWith("http")
                  ? Image.network(images[i], fit: BoxFit.cover)
                  : Image.asset(images[i], fit: BoxFit.cover),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            images.length,
                (i) => Container(
              margin: const EdgeInsets.only(right: 6),
              width: currentIndex == i ? 16 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: currentIndex == i ? Colors.black : Colors.grey,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        )
      ],
    );
  }

  // ------------------------------
  // CAR TITLE + PRICE + RATING
  // ------------------------------
  Widget _carTitleSection(CarItem car) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${car.vehicle?.make ?? ''} ${car.vehicle?.model ?? ''}",
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Row(
            children: const [
              Icon(Icons.star, color: Colors.orange),
              SizedBox(width: 4),
              Text("5.0"),
              SizedBox(width: 6),
              Text("(100+ Reviews)", style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "\$${car.hourlyCost ?? 0} / Day",
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text(
            "A car with high specs that are rented at an affordable price.",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ------------------------------
  // HOST DETAILS
  // ------------------------------
  Widget _hostSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage:
            AssetImage("assets/images/benz_car.webp"), // replace your image
            radius: 25,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Hela Quintin",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 3),
              Row(
                children: [
                  Icon(Icons.verified, color: Colors.blue, size: 18),
                  SizedBox(width: 5),
                  Text("Verified Host",
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              )
            ],
          ),
          const Spacer(),
          _circleBtn(Icons.call, () {}),
          const SizedBox(width: 8),
          _circleBtn(Icons.message, () {
            Get.to(()=> ChatScreen(
              hostName: "Hela Quintin",
              hostImage:"assets/images/benz_car.webp"
            ));
          }),
        ],
      ),
    );
  }

  // ------------------------------
  // FEATURES GRID
  // ------------------------------
  Widget _featuresGrid(CarItem car) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Car Features",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),

          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2),
            children: [
              _featureBox("Capacity", "${car.numSeats ?? "--"} Seats"),
              _featureBox("Engine", "670 HP"),
              _featureBox("Max Speed", "250 km/h"),
              _featureBox("Advance", "Autopilot"),
              _featureBox("Single Charge", "405 Miles"),
              _featureBox("Advance", "Auto Parking"),
            ],
          )
        ],
      ),
    );
  }

  Widget _featureBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
              const TextStyle(color: Colors.grey, fontSize: 10)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  // ------------------------------
  // REVIEWS SECTION
  // ------------------------------
  Widget _reviewHeader() {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text("Reviews (125)",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          Text("See All",
              style: TextStyle(color: Colors.blue, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _reviewList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _reviewItem("Mr. Jack",
              "The rental car was clean, reliable, and the service was quick…"),
          const SizedBox(height: 10),
          _reviewItem("Robert",
              "Amazing ride. The car was smooth, and host was friendly…"),
        ],
      ),
    );
  }

  Widget _reviewItem(String name, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage("assets/images/benz_car.webp")),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(width: 6),
                  const Icon(Icons.star,
                      color: Colors.orange, size: 16),
                  const Text("5.0"),
                ],
              ),
              Text(text,
                  style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        )
      ],
    );
  }

  // ------------------------------
  // BOTTOM BOOK NOW BUTTON
  // ------------------------------
  Widget _bottomBookNow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 70,
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -3))
      ]),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ConfirmBookingScreen(car: widget.car),
            ),
          );
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "Book Now →",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }


  // ------------------------------
  // BOOKING DIALOG
  // ------------------------------
  void _showBookedDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Booking Confirmed"),
        content: const Text("Your car has been successfully booked!"),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"))
        ],
      ),
    );
  }
}

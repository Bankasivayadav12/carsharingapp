import 'package:flutter/material.dart';

class ViewAllCarsPage extends StatelessWidget {
  const ViewAllCarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "All Cars",
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: carList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 240,     // height of each card
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemBuilder: (context, index) {
            final car = carList[index];
            return allCarsCard(
              context,
              carName: car["name"] ?? "",
              img: car["img"] ?? "",
              rating: car["rating"] ?? "0.0",
              price: car["price"] ?? "0",
            );
          },
        ),
      ),
    );
  }

  /// SINGLE CAR CARD
  Widget allCarsCard(
      BuildContext context, {
        required String carName,
        required String img,
        required String rating,
        required String price,
      }) {
    return GestureDetector(
      onTap: () {
        // Navigate to BOOK NOW screen
        // Replace with your screen
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                img,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            /// TEXT CONTENT
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    carName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.star,
                          size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "\$$price / Day",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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
}

/// SAMPLE CAR LIST DATA
List<Map<String, String>> carList = [
  {
    "name": "Ferrari LaFerrari",
    "img": "assets/images/bmw.jpeg",
    "rating": "5.0",
    "price": "100",
  },
  {
    "name": "Tesla Model S",
    "img": "assets/images/bmw.jpeg",
    "rating": "4.9",
    "price": "120",
  },
  {
    "name": "BMW M8",
    "img": "assets/images/bmw.jpeg",
    "rating": "5.0",
    "price": "90",
  },
  {
    "name": "Lamborghini Aventador",
    "img": "assets/images/bmw.jpeg",
    "rating": "4.8",
    "price": "300",
  },
  {
    "name": "Porsche 911",
    "img": "assets/images/bmw.jpeg",
    "rating": "4.7",
    "price": "150",
  },
  {
    "name": "Audi R8",
    "img": "assets/images/bmw.jpeg",
    "rating": "4.9",
    "price": "180",
  },
];


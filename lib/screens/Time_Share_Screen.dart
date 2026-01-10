import 'package:flutter/material.dart';
import 'TimeShare_Booknow_Screen.dart';

class TimeShareCarsListPage extends StatefulWidget {
  const TimeShareCarsListPage({super.key});

  @override
  State<TimeShareCarsListPage> createState() => _TimeShareCarsListPageState();
}

class _TimeShareCarsListPageState extends State<TimeShareCarsListPage> {
  String selectedFilter = "All";
  String searchText = "";

  final Color green = const Color(0xFF1DAA5B);
  final Color blackSmoke = const Color(0xFF1A1A1A);

  final List<String> filters = [
    "All",
    "Electric",
    "Sedan",
    "Luxury",
    "SUV",
    "Automatic",
  ];

  final List<Map<String, dynamic>> cars = [
    {
      "name": "Tesla Model S",
      "type": "Electric",
      "img": "assets/images/bmw.jpeg",
      "price": 25,
      "rating": 4.9,
    },
    {
      "name": "BMW i8",
      "type": "Luxury",
      "img": "assets/images/bmw.jpeg",
      "price": 30,
      "rating": 4.8,
    },
    {
      "name": "Audi A6",
      "type": "Sedan",
      "img": "assets/images/bmw.jpeg",
      "price": 22,
      "rating": 4.7,
    },
    {
      "name": "Mercedes C-Class",
      "type": "Luxury",
      "img": "assets/images/bmw.jpeg",
      "price": 28,
      "rating": 4.6,
    },
    {
      "name": "Range Rover Evoque",
      "type": "SUV",
      "img": "assets/images/bmw.jpeg",
      "price": 35,
      "rating": 4.9,
    },
    {
      "name": "Toyota Camry",
      "type": "Sedan",
      "img": "assets/images/bmw.jpeg",
      "price": 18,
      "rating": 4.5,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredCars = cars.where((car) {
      final matchesSearch = car["name"].toLowerCase().contains(
        searchText.toLowerCase(),
      );
      final matchesFilter =
          selectedFilter == "All" || car["type"] == selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "TimeShare Cars",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: blackSmoke,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _searchBar(),
            const SizedBox(height: 18),
            _filterChips(),
            const SizedBox(height: 20),

            Text(
              "Featured Car",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: blackSmoke,
              ),
            ),

            const SizedBox(height: 12),
            _featuredCarCard(),
            const SizedBox(height: 25),

            Text(
              "Available Cars Nearby",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackSmoke,
              ),
            ),

            const SizedBox(height: 14),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredCars.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68, // IMPORTANT - avoids overflow
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (_, index) {
                return _carCard(filteredCars[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  // SEARCH BAR
  Widget _searchBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: green.withOpacity(0.4), width: 1),
      ),
      child: TextField(
        onChanged: (value) => setState(() => searchText = value),
        decoration: InputDecoration(
          hintText: "Search cars...",
          border: InputBorder.none,
          icon: Icon(Icons.search, size: 22, color: green),
        ),
      ),
    );
  }

  // FILTER CHIPS
  Widget _filterChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, index) {
          final filter = filters[index];
          final bool isSelected = filter == selectedFilter;

          return GestureDetector(
            onTap: () => setState(() => selectedFilter = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(colors: [green, green.withOpacity(0.7)])
                    : null,
                color: isSelected ? null : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: green.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
                    : [],
              ),
              alignment: Alignment.center,
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : blackSmoke,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // FEATURED CAR
  Widget _featuredCarCard() {
    final featured = cars.first;

    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.black, // background behind image
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            // ✅ MAIN IMAGE (Correct orientation)
            Image.asset(
              featured["img"],
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            // ✅ GREEN DARK OVERLAY
            Container(
              width: double.infinity,
              height: double.infinity,
              color: green.withOpacity(0.35),
            ),

            // TEXT + BUTTON
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      featured["name"],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "View",
                      style: TextStyle(
                        color: green,
                        fontWeight: FontWeight.bold,
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



  // CAR CARD  (NO OVERFLOW)
  Widget _carCard(Map<String, dynamic> car) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Colors.black12.withOpacity(0.10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(9),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              car["img"],
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 6),

          // NAME
          Text(
            car["name"],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: blackSmoke,
            ),
          ),

          const SizedBox(height: 2),

          // TYPE
          Text(
            car["type"],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 6),

          // PRICE + RATING
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$${car["price"]}/hr",
                style: TextStyle(
                  fontSize: 13,
                  color: green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star, size: 12, color: green),
                  const SizedBox(width: 3),
                  Text("${car["rating"]}",
                      style: const TextStyle(fontSize: 11)),
                ],
              ),
            ],
          ),

          // 🔥 THIS FIXES THE OVERFLOW
          const Spacer(),

          // BOOK NOW BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TimeShare_BookNowScreen(car: car),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: blackSmoke,
                padding: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Book Now",
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

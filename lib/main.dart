// ------------------------------------------------------------
// 📦 IMPORTS
// ------------------------------------------------------------
import 'dart:async'; // ⏱️ For Timer
import 'package:carsharingapp/screens/Time_Share_Screen.dart';
import 'package:carsharingapp/screens/rent_to_own.dart';
import 'package:carsharingapp/screens/test_page.dart';
import 'package:carsharingapp/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';  // ⭐ ADD GETX
import 'utils/theme_colors.dart';
import 'screens/host_screen.dart';

// ------------------------------------------------------------
// 🏁 MAIN ENTRY POINT (with GetX Initialization)
// ------------------------------------------------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ⭐ Initialize GetX Service (if any)
  runApp(const RideALottApp());
}

// ------------------------------------------------------------
// 🌍 ROOT APPLICATION (Use GetMaterialApp)
// ------------------------------------------------------------
class RideALottApp extends StatelessWidget {
  const RideALottApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RideALott Sharing',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const HomePageContent(),
    );
  }
}

// ------------------------------------------------------------
// 🏡 HOME PAGE CONTENT – Hero + Auto Carousel + Buttons
// ------------------------------------------------------------
class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  final List<_HeroItem> _heroItems = [
    _HeroItem(
      title: "Share Your Car",
      subtitle: "Earn extra income by hosting your vehicle safely.",
      icon: Icons.directions_car_filled,
      gradient: [Color(0xFF4E54C8), Color(0xFF8F94FB)],
    ),
    _HeroItem(
      title: "Flexible Time Sharing",
      subtitle: "Rent cars only for the hours you actually need.",
      icon: Icons.access_time_filled,
      gradient: [Color(0xFF11998E), Color(0xFF38EF7D)],
    ),
    _HeroItem(
      title: "Safe & Secure Rides",
      subtitle: "Verified users, seamless booking, and support.",
      icon: Icons.verified_user,
      gradient: [Color(0xFFFF512F), Color(0xFFF09819)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel(); // just in case
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;

      int nextPage = _currentPage + 1;
      if (nextPage >= _heroItems.length) {
        nextPage = 0;
      }

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔝 APP BAR
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'RideALott Sharing',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      // 📄 BODY → Hero Section + Carousel + Buttons
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🌟 HERO TITLE + SUBTITLE
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Welcome to RideALott 👋",
                style: AppTheme.heading.copyWith(fontSize: 22),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Share, rent, and ride smarter with modern car & time sharing.",
                style: AppTheme.bodyText,
              ),
            ),

            const SizedBox(height: 20),

            // 🎠 HERO CAROUSEL (AUTO-SCROLLING)
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _heroItems.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = _heroItems[index];
                  final isActive = index == _currentPage;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: EdgeInsets.only(
                      right: 10,
                      left: index == 0 ? 0 : 10,
                      top: isActive ? 0 : 10,
                      bottom: isActive ? 0 : 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: item.gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                          color: Colors.black.withOpacity(0.18),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          // Icon / Illustration
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              item.icon,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Text content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.subtitle,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // ⭕ DOT INDICATOR
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _heroItems.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 18 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppTheme.primary
                        : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🔘 BUTTONS SECTION
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // 🚗 CAR SHARING → Opens Bottom Sheet
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      minimumSize: const Size(double.infinity, 55),
                    ),
                    onPressed: () {
                      _showShareSheet(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.directions_car, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          "Car Sharing",
                          style: AppTheme.buttonText,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ⏰ TIME SHARING → Direct Navigation to TimeSharePage
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.userOrange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      minimumSize: const Size(double.infinity, 55),
                    ),
                    onPressed: () {
                      Get.to(() => RentToOwnMainScreen()); // ⭐ DIRECT NAVIGATION
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.access_time, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          "Rent To Own",
                          style: AppTheme.buttonText,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.userGreen,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      minimumSize: const Size(double.infinity, 55),
                    ),
                    onPressed: () {
                      Get.to(() =>  TimeShareCarsListPage()); // ⭐ DIRECT NAVIGATION
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.access_time, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          "Time Sharing",
                          style: AppTheme.buttonText,
                        ),
                      ],
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

  // ------------------------------------------------------------
  // ⬆⬆ BOTTOM SHEET – Choose Host or User
  // ------------------------------------------------------------
  void _showShareSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.sheetBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Grabber
              Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: AppTheme.sheetHandle,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              Text(
                "Select Your Role",
                style: AppTheme.heading,
              ),
              const SizedBox(height: 20),

              // 🚗 HOST – CAR SHARING
              _bottomButton(
                icon: Icons.directions_car,
                label: "Host",
                color: AppTheme.useBlack,
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => HostRegisterPage()); // ⭐ USING GETX NAVIGATION
                },
              ),

              const SizedBox(height: 15),

              // ⏰ USER – TIME SHARING
              _bottomButton(
                icon: Icons.access_time,
                label: "User",
                color: AppTheme.userGreen,
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() =>  UserCarsScreen()); // ⭐ USING GETX NAVIGATION
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // ⭐ REUSABLE BUTTON FOR BOTTOM SHEET
  // ------------------------------------------------------------
  Widget _bottomButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Text(label, style: AppTheme.buttonText),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 📌 SMALL MODEL CLASS FOR HERO ITEMS
// ------------------------------------------------------------
class _HeroItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;

  _HeroItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Auth/login/login_screen.dart';


class LuxurySplashScreen extends StatefulWidget {
  const LuxurySplashScreen({super.key});

  @override
  State<LuxurySplashScreen> createState() => _LuxurySplashScreenState();
}

class _LuxurySplashScreenState extends State<LuxurySplashScreen>
    with SingleTickerProviderStateMixin {

  static const Color green = Color(0xFF6BCB3F);
  static const Color gradientStart = Color(0xFF0F9D8A);
  static const Color gradientEnd = Color(0xFF6BCB3F);

  late AnimationController _progressController;
  late PageController _pageController;

  Timer? _autoTimer;
  int _currentPage = 0;

  final List<Map<String, String>> splashData = [
    {
      "image": "assets/images/benz_car.webp",
      "title": "Premium cars,\nenjoy the luxury",
      "desc":
      "Luxury car rentals with daily and monthly options.\nDrive premium at affordable prices.",
    },
    {
      "image": "assets/images/bmw_car.png",
      "title": "Drive with comfort",
      "desc":
      "Experience smooth and safe rides with top class vehicles.",
    },
    {
      "image": "assets/images/Ferrari-car.png",
      "title": "Feel the speed",
      "desc":
      "High performance cars for your ultimate driving thrill.",
    },
  ];

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < splashData.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      } else {
        timer.cancel();
      }
    });
  }

  // 🔔📍 Permission Flow
  Future<void> _requestPermissions() async {

    // Notification
    bool? notification = await _showPermissionBottomSheet(
      title: "Enable Notifications",
      message:
      "RideALott would like to send ride updates, offers and important alerts.",
      icon: Icons.notifications_active_outlined,
    );

    if (notification == true) {
      await Permission.notification.request();
    }

    // Location
    bool? location = await _showPermissionBottomSheet(
      title: "Enable Location",
      message:
      "RideALott needs your location to find nearby cars and ensure smooth bookings.",
      icon: Icons.location_on_outlined,
    );

    if (location == true) {
      await Permission.locationWhenInUse.request();
    }
  }

  // 🔥 Premium Bottom Sheet
  Future<bool?> _showPermissionBottomSheet({
    required String title,
    required String message,
    required IconData icon,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // Icon
              CircleAvatar(
                radius: 35,
                backgroundColor: green.withOpacity(0.15),
                child: Icon(icon, size: 35, color: green),
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              // Allow Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text(
                    "Allow",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Not Now
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text(
                  "Not Now",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _startProgress() async {
    if (_currentPage < splashData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {

      await _progressController.animateTo(1.0);

      await _requestPermissions();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const SignInScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [gradientStart, gradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: splashData.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });

                    _progressController.animateTo(
                      (_currentPage + 1) / splashData.length,
                    );
                  },
                  itemBuilder: (context, index) {
                    final item = splashData[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [

                          const SizedBox(height: 60),

                          Expanded(
                            flex: 6,
                            child: Image.asset(
                              item["image"]!,
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 30),

                          Text(
                            item["title"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              height: 1.3,
                              fontFamily: "serif",
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Text(
                            item["desc"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              height: 1.6,
                            ),
                          ),

                          const SizedBox(height: 80),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                            (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _currentPage == index ? 22 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.white38,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    GestureDetector(
                      onTap: _startProgress,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [

                          SizedBox(
                            width: 55,
                            height: 55,
                            child: AnimatedBuilder(
                              animation: _progressController,
                              builder: (context, child) {
                                return CircularProgressIndicator(
                                  value: _progressController.value,
                                  strokeWidth: 4,
                                  backgroundColor: Colors.white24,
                                  valueColor:
                                  const AlwaysStoppedAnimation(green),
                                );
                              },
                            ),
                          ),

                          Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: green,
                              size: 24,
                            ),
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
      ),
    );
  }
}
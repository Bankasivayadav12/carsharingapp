// import 'package:carsharingapp/screens/Book_now_screen.dart';
// import 'package:carsharingapp/screens/View_all_cars.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:google_places_flutter/model/prediction.dart';
// import 'package:iconify_flutter/iconify_flutter.dart';
//
// class UserScreen extends StatefulWidget {
//   const UserScreen({super.key});
//
//   @override
//   State<UserScreen> createState() => _UserScreenPageState();
// }
//
// class _UserScreenPageState extends State<UserScreen> {
//   int selectedCarType = 0;
//   RangeValues priceRange = const RangeValues(10, 230);
//   int selectedRental = 0;
//   int selectedCapacity = 4;
//   int selectedFuel = 0;
//   int selectedBrandIndex = 0; // 0 = ALL
//   DateTime selectedDateTime = DateTime.now();
//
//   String _formattedTime(DateTime dt) {
//     return TimeOfDay.fromDateTime(dt).format(context);
//   }
//
//   String _monthName(int month) {
//     const months = [
//       "Jan",
//       "Feb",
//       "Mar",
//       "Apr",
//       "May",
//       "Jun",
//       "Jul",
//       "Aug",
//       "Sep",
//       "Oct",
//       "Nov",
//       "Dec",
//     ];
//     return months[month - 1];
//   }
//
//   // current location variables
//   bool isLocationLoaded = false;
//   final TextEditingController locationCtrl = TextEditingController();
//   String selectedLocation = "";
//
//   bool isLoadingLocation = false;
//
//   @override
//   void dispose() {
//     locationCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ---------------------------------------------------------
//               // TOP HEADER  (PART 1)
//               // ---------------------------------------------------------
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: CircleAvatar(
//                       radius: 20,
//                       backgroundColor: Colors.grey.shade100,
//                       child: const Padding(
//                         padding: EdgeInsets.only(left: 2),
//                         child: Icon(
//                           Icons.arrow_back_ios_new,
//                           color: Colors.black,
//                           size: 18,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 20,
//                         backgroundColor: Colors.grey.shade100,
//                         child: const Icon(
//                           Icons.notifications_none,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       const CircleAvatar(
//                         radius: 20,
//                         backgroundImage: AssetImage("assets/images/bmw.jpeg"),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 20),
//
//               // ---------------------------------------------------------
//               // SEARCH BAR (PART 2)
//               // ---------------------------------------------------------
//               Container(
//                 height: 50,
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.search, color: Colors.grey),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: TextField(
//                         decoration: InputDecoration(
//                           hintText: "Search your dream car....",
//                           border: InputBorder.none,
//                           hintStyle: TextStyle(color: Colors.grey.shade500),
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         showModalBottomSheet(
//                           context: context,
//                           isScrollControlled: true,
//                           backgroundColor: Colors.transparent,
//                           builder: (context) => buildFiltersBottomSheet(context),
//                         );
//                       },
//                       child: CircleAvatar(
//                         radius: 20,
//                         backgroundColor: Colors.grey.shade200,
//                         child: const Icon(Icons.tune, color: Colors.black),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               // ---------------------------------------------------------
//               // PART 3 — EXACT SCROLLABLE BRAND BAR
//               // ---------------------------------------------------------
//               SizedBox(
//                 height: 50,
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   physics: const BouncingScrollPhysics(),
//                   children: [
//                     brandChipScroller(
//                       "assets/icons/all_cars.png",
//                       "ALL",
//                       selectedBrandIndex == 0,
//                           () => setState(() => selectedBrandIndex = 0),
//                       width: 30,
//                       height: 30,
//                     ),
//                     brandChipScroller(
//                       "assets/icons/ferrari-icon.png",
//                       "Ferrari",
//                       selectedBrandIndex == 1,
//                           () => setState(() => selectedBrandIndex = 1),
//                       width: 30,
//                       height: 30,
//                     ),
//                     brandChipScroller(
//                       "assets/icons/tesla-icon.png",
//                       "Tesla",
//                       selectedBrandIndex == 2,
//                           () => setState(() => selectedBrandIndex = 2),
//                       width: 25,
//                       height: 25,
//                     ),
//                     brandChipScroller(
//                       "assets/icons/bmw-icon.png",
//                       "Bmw",
//                       selectedBrandIndex == 3,
//                           () => setState(() => selectedBrandIndex = 3),
//                       width: 35,
//                       height: 35,
//                     ),
//                     brandChipScroller(
//                       "assets/icons/lamborghini-icon.png",
//                       "Lambo",
//                       selectedBrandIndex == 4,
//                           () => setState(() => selectedBrandIndex = 4),
//                       width: 35,
//                       height: 35,
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               // ---------------------------------------------------------
//               // BEST CARS SECTION
//               // ---------------------------------------------------------
//               sectionHeader("Recommanded for you"),
//               const SizedBox(height: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: carCard(
//                           "Tesla Model S",
//                           "Chicago, USA",
//                           "100",
//                           "assets/images/bmw.jpeg",
//                           rating: "5.0",
//                           context: context,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: carCard(
//                           "Ferrari LaFerrari",
//                           "Washington DC",
//                           "100",
//                           "assets/images/bmw.jpeg",
//                           rating: "5.0",
//                           context: context,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: carCard(
//                           "Lamborghini Aventador",
//                           "Washington, DC",
//                           "100",
//                           "assets/images/bmw.jpeg",
//                           rating: "4.9",
//                           context: context,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: carCard(
//                           "BMW GTS3 M2",
//                           "New York, USA",
//                           "100",
//                           "assets/images/bmw.jpeg",
//                           rating: "5.0",
//                           context: context,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//
//               const SizedBox(height: 20),
//
//               // ---------------------------------------------------------
//               // POPULAR CARS
//               // ---------------------------------------------------------
//               sectionHeader("Our Popular Cars"),
//               const SizedBox(height: 10),
//               SizedBox(
//                 height: 120,
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   children: [
//                     popularCarItem(
//                       context,
//                       name: "Ferrari LaFerrari",
//                       price: "100",
//                       img: "assets/images/bmw.jpeg",
//                       rating: "5.0",
//                     ),
//                     popularCarItem(
//                       context,
//                       name: "BMW M8",
//                       price: "120",
//                       img: "assets/images/bmw.jpeg",
//                       rating: "4.9",
//                     ),
//                     popularCarItem(
//                       context,
//                       name: "Ferrari LaFerrari",
//                       price: "100",
//                       img: "assets/images/bmw.jpeg",
//                       rating: "5.0",
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ---------------------------------------------------------
//   Widget brandChip(String icon, String label) {
//     return Container(
//       margin: const EdgeInsets.only(right: 16),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 18,
//             backgroundColor: Colors.black,
//             child: Image.asset(icon, height: 20, color: Colors.white),
//           ),
//           const SizedBox(width: 6),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               color: Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ---------------------------------------------------------
//   Widget sectionHeader(String title) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }
//
//   // ---------------------------------------------------------
//   // UPDATED carCard
//   // ---------------------------------------------------------
//   Widget carCard(
//       String name,
//       String location,
//       String price,
//       String img, {
//         required String rating,
//         required BuildContext context,
//       }) {
//     return GestureDetector(
//       onTap: () {
//         // Open popup bottom sheet with multiple car images
//         showCarImages(
//           context,
//           [img, img, img, img],
//           carName: name,
//           rating: rating,
//           price: price,
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.grey.shade300),
//         ),
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: img.startsWith("http")
//                       ? Image.network(
//                     img,
//                     height: 110,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   )
//                       : Image.asset(
//                     img,
//                     height: 110,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 const Positioned(
//                   right: 8,
//                   top: 8,
//                   child: Icon(
//                     Icons.favorite_border,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//                 // Optional: Active badge
//                 Positioned(
//                   left: 8,
//                   top: 8,
//                   child: Container(
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.green.withOpacity(0.9),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Text(
//                       "Active",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               name,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             const SizedBox(height: 5),
//             Row(
//               children: [
//                 const Icon(Icons.location_on, color: Colors.orange, size: 16),
//                 const SizedBox(width: 5),
//                 Expanded(
//                   child: Text(
//                     location,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(fontSize: 15, color: Colors.blue),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 5),
//             Row(
//               children: [
//                 const Icon(Icons.star, color: Colors.orange, size: 16),
//                 const SizedBox(width: 4),
//                 Text(rating),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "\$$price/Day",
//                   style: const TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const BookNowScreen(car: {},),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     minimumSize: const Size(70, 30),
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                   ),
//                   child: const Text(
//                     "Book now",
//                     maxLines: 1,
//                     overflow: TextOverflow.fade,
//                     softWrap: false,
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ---------------------------------------------------------
//   // show car image here
//   // ---------------------------------------------------------
//   void showCarImages(
//       BuildContext context,
//       List<String> images, {
//         required String carName,
//         required String rating,
//         required String price,
//       }) {
//     PageController pageController = PageController();
//     int currentIndex = 0;
//
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierColor: Colors.black.withOpacity(0.5),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Center(
//               child: Stack(
//                 children: [
//                   // MAIN CARD
//                   Container(
//                     width: MediaQuery.of(context).size.width * 0.87,
//                     height: MediaQuery.of(context).size.height * 0.60,
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(22),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black,
//                           blurRadius: 15,
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 15),
//                         // IMAGE VIEWER
//                         Container(
//                           height: 260,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(18),
//                             boxShadow: const [
//                               BoxShadow(
//                                 color: Colors.black,
//                                 blurRadius: 10,
//                                 offset: Offset(0, 6),
//                               ),
//                             ],
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(18),
//                             child: PageView.builder(
//                               controller: pageController,
//                               itemCount: images.length,
//                               onPageChanged: (index) {
//                                 setState(() => currentIndex = index);
//                               },
//                               itemBuilder: (context, index) {
//                                 return AnimatedScale(
//                                   duration:
//                                   const Duration(milliseconds: 350),
//                                   scale: currentIndex == index ? 1 : 0.92,
//                                   child: images[index].startsWith("http")
//                                       ? Image.network(
//                                     images[index],
//                                     fit: BoxFit.cover,
//                                   )
//                                       : Image.asset(
//                                     images[index],
//                                     fit: BoxFit.cover,
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         // DOT INDICATORS
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: List.generate(
//                             images.length,
//                                 (index) => AnimatedContainer(
//                               duration:
//                               const Duration(milliseconds: 300),
//                               margin:
//                               const EdgeInsets.symmetric(horizontal: 4),
//                               width: currentIndex == index ? 18 : 8,
//                               height: 8,
//                               decoration: BoxDecoration(
//                                 color: currentIndex == index
//                                     ? Colors.black
//                                     : Colors.grey.shade400,
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         // CAR NAME, RATING, PRICE
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               carName,
//                               style: const TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.w800,
//                                 color: Colors.black,
//                                 letterSpacing: 0.2,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Row(
//                                   children: [
//                                     const Icon(
//                                       Icons.star_rounded,
//                                       size: 18,
//                                       color: Colors.black,
//                                     ),
//                                     const SizedBox(width: 4),
//                                     Text(
//                                       rating,
//                                       style: const TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(width: 14),
//                                 Container(
//                                   width: 5,
//                                   height: 5,
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey.shade500,
//                                     shape: BoxShape.circle,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 14),
//                                 Text(
//                                   "\$$price / day",
//                                   style: const TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.black87,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             Container(
//                               height: 1,
//                               width: double.infinity,
//                               color: Colors.grey.shade300,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   // CLOSE BUTTON
//                   Positioned(
//                     top: 20,
//                     right: 20,
//                     child: GestureDetector(
//                       onTap: () => Navigator.pop(context),
//                       child: Container(
//                         padding: const EdgeInsets.all(7),
//                         decoration: const BoxDecoration(
//                           color: Colors.white,
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black,
//                               blurRadius: 5,
//                             ),
//                           ],
//                         ),
//                         child: const Icon(
//                           Icons.close,
//                           color: Colors.black87,
//                           size: 22,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget brandChipScroller(
//       String imagePath,
//       String label,
//       bool isSelected,
//       VoidCallback onTap, {
//         double width = 26,
//         double height = 26,
//       }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(right: 14),
//         padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.green : Colors.white,
//           borderRadius: BorderRadius.circular(25),
//           border: Border.all(color: Colors.grey.shade300),
//         ),
//         child: Row(
//           children: [
//             Image.asset(
//               imagePath,
//               width: width,
//               height: height,
//               fit: BoxFit.contain,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: TextStyle(
//                 color: isSelected ? Colors.white : Colors.black,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 20,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildFiltersBottomSheet(BuildContext context) {
//     return StatefulBuilder(
//       builder: (context, bottomSetState) {
//         if (!isLocationLoaded) {
//           isLocationLoaded = true;
//           _getCurrentLocation(bottomSetState);
//         }
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.85,
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//           ),
//           child: Column(
//             children: [
//               // HEADER
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "Filters",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(
//                       Icons.close,
//                       size: 26,
//                       color: Colors.black,
//                     ),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // TYPE OF CARS
//                       const Text(
//                         "Type of Cars",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           typeChip("All", selectedCarType == 0, () {
//                             bottomSetState(() => selectedCarType = 0);
//                           }),
//                           typeChip("Regular cars", selectedCarType == 1, () {
//                             bottomSetState(() => selectedCarType = 1);
//                           }),
//                           typeChip("Luxury Cars", selectedCarType == 2, () {
//                             bottomSetState(() => selectedCarType = 2);
//                           }),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Divider(color: Colors.grey.shade300),
//
//                       // PRICE RANGE
//                       const Text(
//                         "Price Range",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       RangeSlider(
//                         values: priceRange,
//                         min: 10,
//                         max: 230,
//                         divisions: 20,
//                         activeColor: Colors.green,
//                         onChanged: (values) {
//                           bottomSetState(() => priceRange = values);
//                         },
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           priceBox("\$${priceRange.start.toInt()}"),
//                           priceBox("\$${priceRange.end.toInt()}+"),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Divider(color: Colors.grey.shade300),
//
//                       // PICKUP DATE
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             "Pickup Date",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () =>
//                                 _selectBottomSheetDate(context, bottomSetState),
//                             child: Row(
//                               children: [
//                                 Text(
//                                   "${selectedDateTime.day.toString().padLeft(2, '0')} "
//                                       "${_monthName(selectedDateTime.month)}, "
//                                       "${selectedDateTime.year}•${_formattedTime(selectedDateTime)}",
//                                   style: const TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 6),
//                                 const Icon(Icons.calendar_month, size: 22),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       Divider(color: Colors.grey.shade300),
//
//                       // PICKUP LOCATION
//                       const Text(
//                         "Pickup Car Location",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Container(
//                         height: 50,
//                         padding: const EdgeInsets.symmetric(horizontal: 14),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.grey.shade300),
//                         ),
//                         child: Row(
//                           children: [
//                             const Icon(
//                               Icons.location_on_outlined,
//                               color: Colors.grey,
//                               size: 20,
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: GooglePlaceAutoCompleteTextField(
//                                 textEditingController: locationCtrl,
//                                 googleAPIKey: "YOUR_GOOGLE_API_KEY",
//                                 debounceTime: 200,
//                                 isLatLngRequired: false,
//                                 countries: const ["in", "us"],
//                                 inputDecoration: const InputDecoration(
//                                   border: InputBorder.none,
//                                   enabledBorder: InputBorder.none,
//                                   focusedBorder: InputBorder.none,
//                                   isCollapsed: true,
//                                   contentPadding: EdgeInsets.zero,
//                                   hintText: "Shore Dr, Chicago 0062 USA",
//                                   hintStyle: TextStyle(
//                                     fontSize: 15,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                                 isCrossBtnShown: true,
//                                 itemClick: (prediction) {
//                                   locationCtrl.text = prediction.description!;
//                                   FocusScope.of(context).unfocus();
//                                 },
//                                 itemBuilder: (context, index, Prediction p) {
//                                   return ListTile(
//                                     leading: const Icon(
//                                       Icons.location_on,
//                                       color: Colors.green,
//                                     ),
//                                     title: Text(p.description ?? ""),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//
//                       // RENTAL TIME
//                       const Text(
//                         "Rental Time",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           rentalChip(
//                             "Hour",
//                             selectedRental == 0,
//                                 () => bottomSetState(() => selectedRental = 0),
//                           ),
//                           rentalChip(
//                             "Day",
//                             selectedRental == 1,
//                                 () => bottomSetState(() => selectedRental = 1),
//                           ),
//                           rentalChip(
//                             "Weekly",
//                             selectedRental == 2,
//                                 () => bottomSetState(() => selectedRental = 2),
//                           ),
//                           rentalChip(
//                             "Monthly",
//                             selectedRental == 3,
//                                 () => bottomSetState(() => selectedRental = 3),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Divider(color: Colors.grey.shade300),
//
//                       // SITTING CAPACITY
//                       const Text(
//                         "Sitting Capacity",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [2, 4, 6, 8]
//                             .map(
//                               (cap) => capacityChip(
//                             cap.toString(),
//                             selectedCapacity == cap,
//                                 () {
//                               bottomSetState(() => selectedCapacity = cap);
//                             },
//                           ),
//                         )
//                             .toList(),
//                       ),
//                       const SizedBox(height: 10),
//                       Divider(color: Colors.grey.shade300),
//
//                       // FUEL TYPE
//                       const SizedBox(height: 5),
//                       const Text(
//                         "Fuel Type",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           fuelChip(
//                             "Electric",
//                             selectedFuel == 0,
//                                 () => bottomSetState(() => selectedFuel = 0),
//                           ),
//                           fuelChip(
//                             "Petrol",
//                             selectedFuel == 1,
//                                 () => bottomSetState(() => selectedFuel = 1),
//                           ),
//                           fuelChip(
//                             "Diesel",
//                             selectedFuel == 2,
//                                 () => bottomSetState(() => selectedFuel = 2),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 40),
//                     ],
//                   ),
//                 ),
//               ),
//               // APPLY BUTTON
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context);
//                     // You can also navigate to ViewAllCars here:
//                     // Navigator.push(context, MaterialPageRoute(builder: (_) => const ViewAllCars()));
//                   },
//                   child: const Text(
//                     "Show 100+ Cars",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _selectBottomSheetDate(
//       BuildContext context,
//       void Function(void Function()) bottomSetState,
//       ) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: selectedDateTime,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );
//     if (pickedDate == null) return;
//
//     TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.fromDateTime(selectedDateTime),
//     );
//     if (pickedTime == null) return;
//
//     bottomSetState(() {
//       selectedDateTime = DateTime(
//         pickedDate.year,
//         pickedDate.month,
//         pickedDate.day,
//         pickedTime.hour,
//         pickedTime.minute,
//       );
//     });
//   }
//
//   Widget typeChip(String label, bool selected, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(right: 5),
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//         decoration: BoxDecoration(
//           color: selected ? Colors.green : Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: Colors.grey.shade900),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: selected ? Colors.white : Colors.black,
//             fontWeight: FontWeight.w600,
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget rentalChip(String label, bool selected, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//         decoration: BoxDecoration(
//           color: selected ? Colors.green : Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: Colors.grey.shade900),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: selected ? Colors.white : Colors.black,
//             fontWeight: FontWeight.w600,
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget capacityChip(String label, bool selected, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//         decoration: BoxDecoration(
//           color: selected ? Colors.green : Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(color: Colors.grey.shade400),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: selected ? Colors.white : Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 14,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget fuelChip(String label, bool selected, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
//         decoration: BoxDecoration(
//           color: selected ? Colors.green : Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(color: Colors.black),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: selected ? Colors.white : Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 14,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget colorOption(Color color, String label) {
//     return Column(
//       children: [
//         CircleAvatar(radius: 16, backgroundColor: color),
//         const SizedBox(height: 6),
//         Text(
//           label,
//           style: const TextStyle(fontSize: 13, color: Colors.black87),
//         ),
//       ],
//     );
//   }
//
//   Widget priceBox(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(fontWeight: FontWeight.bold),
//       ),
//     );
//   }
//
//   Future<void> _getCurrentLocation(Function bottomSetState) async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) return;
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       permission = await Geolocator.requestPermission();
//     }
//
//     Position pos = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//
//     List<Placemark> placemarks = await placemarkFromCoordinates(
//       pos.latitude,
//       pos.longitude,
//     );
//
//     Placemark place = placemarks.first;
//
//     String address =
//         "${place.street}, ${place.locality}, ${place.administrativeArea}";
//
//     bottomSetState(() {
//       selectedLocation = address;
//       locationCtrl.text = address;
//     });
//   }
//
//   Widget popularCarItem(
//       BuildContext context, {
//         required String name,
//         required String price,
//         required String img,
//         required String rating,
//       }) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.75,
//       height: 110,
//       margin: const EdgeInsets.only(right: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade300),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black,
//             blurRadius: 6,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Image.asset(
//               img,
//               width: 95,
//               height: 80,
//               fit: BoxFit.cover,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   name,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 15,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Row(
//                   children: [
//                     Text(
//                       rating,
//                       style: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     const Icon(
//                       Icons.star,
//                       size: 15,
//                       color: Colors.orange,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   "\$$price/Day",
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

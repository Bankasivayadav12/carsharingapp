import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
    const PaymentPage({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                ),
                title: const Text(
                    "Payment Summary",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                ),
            ),

            body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                        // ---------------- CAR SUMMARY ----------------
                        Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                    )
                                ],
                            ),
                            child: Row(
                                children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(
                                            "assets/images/bmw.jpeg",
                                            width: 95,
                                            height: 70,
                                            fit: BoxFit.cover,
                                        ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Expanded(
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Text("Tesla Model 3",
                                                    style: TextStyle(
                                                        fontSize: 18, fontWeight: FontWeight.bold)),
                                                SizedBox(height: 6),
                                                Text("Automatic • Electric",
                                                    style:
                                                    TextStyle(fontSize: 14, color: Colors.black54)),
                                            ],
                                        ),
                                    )
                                ],
                            ),
                        ),

                        const SizedBox(height: 20),

                        // ---------------- PRICE DETAILS ----------------
                        const Text(
                            "Trip Fare Details",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),

                        _priceTile("Base Rate", "\$25.00"),
                        _priceTile("Mileage Charges", "\$5.00"),
                        _priceTile("Service Fee", "\$1.50"),
                        _priceTile("State Tax", "\$0.90"),

                        const Divider(height: 30),
                        _priceTile("Total Amount", "\$32.40", isBold: true),

                        const SizedBox(height: 25),

                        // ---------------- PAYMENT METHODS ----------------
                        const Text(
                            "Payment Methods",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),

                        _paymentOption("Apple Pay", Icons.phone_iphone),
                        const SizedBox(height: 10),
                        _paymentOption("Pay Pal", Icons.account_balance_wallet),
                        const SizedBox(height: 10),
                        _paymentOption("Credit / Debit Card", Icons.credit_card),

                        const SizedBox(height: 20),

                        // ---------------- PROMO CODE ----------------
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                                children: [
                                    const Icon(Icons.local_offer, color: Colors.deepPurple),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                        child: TextField(
                                            decoration: InputDecoration(
                                                hintText: "Enter Promo Code",
                                                border: InputBorder.none),
                                        ),
                                    ),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Text("Apply"),
                                    )
                                ],
                            ),
                        ),

                        const SizedBox(height: 25),

                        // ---------------- PAY NOW BUTTON ----------------
                        SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                    ),
                                ),
                                child: const Text(
                                    "Pay \$32.40 →",
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                            ),
                        ),

                        const SizedBox(height: 40),
                    ],
                ),
            ),
        );
    }

    // ----------------- WIDGETS -----------------

    Widget _priceTile(String title, String amount, {bool isBold = false}) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Text(
                        title,
                        style: TextStyle(
                            fontSize: 15, fontWeight: isBold ? FontWeight.bold : null),
                    ),
                    Text(
                        amount,
                        style: TextStyle(
                            fontSize: 15, fontWeight: isBold ? FontWeight.bold : null),
                    ),
                ],
            ),
        );
    }

    Widget _paymentOption(String title, IconData icon) {
        return Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
                children: [
                    Icon(icon, size: 26, color: Colors.black),
                    const SizedBox(width: 14),
                    Text(
                        title,
                        style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                ],
            ),
        );
    }
}

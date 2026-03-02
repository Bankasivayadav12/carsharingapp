import 'package:flutter/material.dart';
import '../login/login_screen.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  final TextEditingController dobController = TextEditingController();

  static const Color green = Color(0xFF6BCB3F);
  static const Color fieldColor = Color(0xFFE6F3DD);
  static const Color gradientStart = Color(0xFF0F9D8A);
  static const Color gradientEnd = Color(0xFF6BCB3F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [

            // 🌍 World Map Background


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 20),

                    // 🔙 Back Button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.keyboard_double_arrow_left,
                        size: 28,
                      ),
                    ),

                    const SizedBox(height: 40),

                    const Text(
                      "Create an",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w300,
                      ),
                    ),

                    const Text(
                      "Account!",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: green,
                      ),
                    ),

                    const SizedBox(height: 35),

                    // 🔹 First Name
                    // 🔹 First Name
                    _buildField(Icons.person_outline, "First Name"),
                    const SizedBox(height: 18),

// 🔹 Last Name
                    _buildField(Icons.person_outline, "Last Name"),
                    const SizedBox(height: 18),

// 🔹 Date of Birth
                    TextField(
                      controller: dobController,
                      readOnly: true,
                      decoration: _inputDecoration(
                        icon: Icons.calendar_today_outlined,
                        hint: "Date of Birth",
                      ),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );

                        if (picked != null) {
                          dobController.text =
                          "${picked.day}/${picked.month}/${picked.year}";
                        }
                      },
                    ),
                    const SizedBox(height: 18),

// 🔹 Mobile Number
                    _buildField(Icons.phone_outlined, "Mobile Number"),
                    const SizedBox(height: 18),

// 🔹 Alternative Mobile Number
                    _buildField(Icons.phone_android_outlined, "Alternative Mobile Number"),
                    const SizedBox(height: 18),

// 🔹 Email Address
                    _buildField(Icons.email_outlined, "Email Address"),
                    const SizedBox(height: 18),

// 🔹 City
                    _buildField(Icons.location_city_outlined, "City"),
                    const SizedBox(height: 18),

// 🔹 Driving License
                    _buildField(Icons.credit_card_outlined, "Driving License Number"),
                    const SizedBox(height: 18),

// 🔹 Password
                    _buildPasswordField(
                      hint: "Password",
                      obscure: obscurePassword,
                      onToggle: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                    const SizedBox(height: 18),

// 🔹 Confirm Password
                    _buildPasswordField(
                      hint: "Confirm Password",
                      obscure: obscureConfirmPassword,
                      onToggle: () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                    ),
                    const SizedBox(height: 10),

                    _buildField(Icons.card_giftcard, "Invitation Code"),

                    const SizedBox(height: 18),


                    const SizedBox(height: 35),

                    // 🔥 Create Account Button
                    GestureDetector(
                      onTap: () {
                        // TODO: API call
                      },
                      child: Container(
                        height: 55,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [gradientStart, gradientEnd],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Text(
                            "CREATE ACCOUNT",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // 🔁 Already have account
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignInScreen(),
                            ),
                          );
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: "Already have an account? ",
                            children: [
                              TextSpan(
                                text: "Sign in",
                                style: TextStyle(
                                  color: green,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(IconData icon, String hint) {
    return TextField(
      decoration: _inputDecoration(icon: icon, hint: hint),
    );
  }

  Widget _buildPasswordField({
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      obscureText: obscure,
      decoration: _inputDecoration(
        icon: Icons.lock_outline,
        hint: hint,
        suffix: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required IconData icon,
    required String hint,
    Widget? suffix,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      hintText: hint,
      filled: true,
      fillColor: fieldColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
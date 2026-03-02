import 'package:flutter/material.dart';

import '../../../main.dart';
import '../signup/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  static const Color green = Color(0xFF6BCB3F);
  static const Color gradientStart = Color(0xFF0F9D8A);
  static const Color gradientEnd = Color(0xFF6BCB3F);

  bool isEmailLogin = true;
  bool rememberMe = false;
  bool obscurePassword = true;
  bool showOtpField = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final List<TextEditingController> otpControllers =
  List.generate(6, (_) => TextEditingController());

  final List<FocusNode> otpFocusNodes =
  List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();

    for (var controller in otpControllers) {
      controller.dispose();
    }

    for (var node in otpFocusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView( // ✅ FIX OVERFLOW
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),
              const SizedBox(height: 20),

              Stack(
                alignment: Alignment.center,
                children: [

                  /// 🔹 Center Logo + Text
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          "assets/images/logo_driver.webp",
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "RideALott",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6BCB3F),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Car Sharing",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6BCB3F),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              const Text(
                "Welcome",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
              ),


              const SizedBox(height: 15),

              /// LOGIN TOGGLE
              Container(
                height: 50,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Stack(
                  children: [

                    /// 🔥 Sliding Indicator
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      alignment:
                      isEmailLogin ? Alignment.centerLeft : Alignment.centerRight,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2 - 32,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF0F9D8A),
                              Color(0xFF6BCB3F),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6BCB3F).withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// 🔥 Buttons
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isEmailLogin = true;
                                showOtpField = false;
                              });
                            },
                            child: Center(
                              child: Text(
                                "Username",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color:
                                  isEmailLogin ? Colors.white : Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isEmailLogin = false;
                              });
                            },
                            child: Center(
                              child: Text(
                                "Phone",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color:
                                  !isEmailLogin ? Colors.white : Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// EMAIL LOGIN
              if (isEmailLogin) ...[
                _inputField(
                  controller: emailController,
                  hint: "User Name",
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 15),
                _inputField(
                  controller: passwordController,
                  hint: "Password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
              ],

              /// PHONE LOGIN
              if (!isEmailLogin) ...[
                _inputField(
                  controller: phoneController,
                  hint: "Mobile Number",
                  icon: Icons.phone_android,
                ),

                const SizedBox(height: 15),

                if (!showOtpField)
                  GestureDetector(
                    onTap: () {
                      if (phoneController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Enter mobile number"),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        showOtpField = true;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("OTP Sent Successfully"),
                        ),
                      );
                    },
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: green),
                      ),
                      child: const Text(
                        "Send OTP",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                if (showOtpField) ...[
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 45,
                        child: TextField(
                          controller: otpControllers[index],
                          focusNode: otpFocusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              otpFocusNodes[index + 1].requestFocus(); // ✅ NEXT
                            } else if (value.isEmpty && index > 0) {
                              otpFocusNodes[index - 1].requestFocus(); // ✅ BACK
                            }
                          },
                          decoration: const InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ],


              const SizedBox(height: 10),



              /// LOGIN BUTTON
              GestureDetector(
                onTap: () {
                  if (!isEmailLogin && showOtpField) {
                    String otp =
                    otpControllers.map((c) => c.text).join();
                    if (otp.length != 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Enter complete OTP"),
                        ),
                      );
                      return;
                    }
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Login Successful"),
                    ),
                  );
                },
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [gradientStart, gradientEnd],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomePageContent(),
                          ),
                        );
                      },
                      child: const Center(
                        child: Text(
                          "LOG IN",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  /// 🔹 LEFT SIDE (Sign Up)
                  Row(
                    children: [
                      Text(
                        "Don’t have account?",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(width: 6),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFF0F9D8A),
                              Color(0xFF6BCB3F),
                            ],
                          ).createShader(bounds),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// 🔹 RIGHT SIDE (Forgot Password)
                  GestureDetector(
                    onTap: () {
                      // Add navigation to Forgot Password screen
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade400)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("OR"),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade400)),
                ],
              ),

              const SizedBox(height: 15),

              /// GOOGLE LOGIN
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/google_icon.png",
                        height: 22,
                        width: 22,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Continue with Google",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }



  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? obscurePassword : false,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(icon, color: Colors.grey.shade600),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              obscurePassword
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: Colors.grey.shade600,
            ),
            onPressed: () {
              setState(() {
                obscurePassword = !obscurePassword;
              });
            },
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
        ),
      ),
    );
  }
}
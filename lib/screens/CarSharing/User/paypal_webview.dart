import 'package:f_demo/screens/CarSharing/User/payment_sucess_screen.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'controller/payment_controller.dart';

class PayPalWebViewScreen extends StatefulWidget {
  final String approvalUrl;
  final String orderId;

  const PayPalWebViewScreen({
    super.key,
    required this.approvalUrl,
    required this.orderId,
  });

  @override
  State<PayPalWebViewScreen> createState() => _PayPalWebViewScreenState();
}

class _PayPalWebViewScreenState extends State<PayPalWebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(

        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            print("NAVIGATED URL: ${request.url}");

            // ✅ SUCCESS URL (your return_url)
            if (request.url.contains("success")) {
              try {
                final captureResponse =
                await PaymentService.capturePayPalOrder(widget.orderId);

                if (!mounted) return NavigationDecision.prevent;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentSuccessScreen(captureResponse: captureResponse,

                    ),
                  ),
                );
              } catch (e) {
                print("CAPTURE ERROR: $e");

                if (mounted) {
                  Navigator.pop(context, false);
                }
              }

              return NavigationDecision.prevent;
            }


            // ❌ CANCEL URL
            if (request.url.contains("cancel")) {
              if (mounted) Navigator.pop(context, false);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),



      )
      ..loadRequest(Uri.parse(widget.approvalUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pay with PayPal"),
        backgroundColor: const Color(0xFF00A86B),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
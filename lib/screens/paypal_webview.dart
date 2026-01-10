import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controller/payment_controller.dart';


class PayPalWebView extends StatefulWidget {
  final String url;
  final PaymentController paymentController;

  const PayPalWebView({
    super.key,
    required this.url,
    required this.paymentController,
  });

  @override
  State<PayPalWebView> createState() => _PayPalWebViewState();
}

class _PayPalWebViewState extends State<PayPalWebView> {
  late final WebViewController webController;

  @override
  void initState() {
    super.initState();

    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (nav) {
            if (nav.url.contains("paypal-success")) {
              final orderID = nav.url.split("token=").last;
              capture(orderID);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> capture(String orderID) async {
    bool success = await widget.paymentController.captureOrder(orderID);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "Payment Successful!" : "Payment Failed"),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pay with PayPal")),
      body: WebViewWidget(controller: webController),
    );
  }
}

import 'package:flutter/material.dart';
import '../services/niubiz_service.dart';
import '../screens/niubiz_webview.dart';

class NiubizButton extends StatelessWidget {
  final NiubizService niubizService;
  final double amount;
  final String purchaseNumber;

  NiubizButton({
    required this.niubizService,
    required this.amount,
    required this.purchaseNumber,
  });

  void _startPayment(BuildContext context) async {
    try {
      final accessToken = await niubizService.fetchAccessToken();
      final sessionToken =
          await niubizService.fetchSessionToken(accessToken, amount);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NiubizWebView(
            sessionToken: sessionToken,
            amount: amount,
            purchaseNumber: purchaseNumber,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _startPayment(context),
      child: Text('Iniciar Pago Niubiz'),
    );
  }
}

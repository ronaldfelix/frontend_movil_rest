import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'payment_screen.dart';

class PaymentButton extends StatefulWidget {
  final double amount;
  final String purchaseNumber;

  const PaymentButton({
    required this.amount,
    required this.purchaseNumber,
    Key? key,
  }) : super(key: key);

  @override
  _PaymentButtonState createState() => _PaymentButtonState();
}

class _PaymentButtonState extends State<PaymentButton> {
  bool isLoading = false;

  Future<String> _getSessionToken(double amount) async {
    final url = Uri.parse(
        'http://192.168.1.200:8080/api/niubiz/generate-session-token');

    // Cuerpo del request para obtener el token
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amount,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return body['sessionToken'];
    } else {
      throw Exception('Error al obtener el token: ${response.body}');
    }
  }

  void _startPayment() async {
    setState(() {
      isLoading = true;
    });

    try {
      final sessionToken = await _getSessionToken(widget.amount);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            sessionToken: sessionToken,
            merchantId: '456879852',
            purchaseNumber: widget.purchaseNumber,
            amount: widget.amount,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : _startPayment,
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text('Iniciar Pago'),
    );
  }
}

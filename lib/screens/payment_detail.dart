import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentDetailScreen extends StatefulWidget {
  final String purchaseNumber;

  const PaymentDetailScreen({Key? key, required this.purchaseNumber})
      : super(key: key);

  @override
  _PaymentDetailScreenState createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  Map<String, dynamic>? paymentDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPaymentDetails();
  }

  Future<void> fetchPaymentDetails() async {
    final url = Uri.parse('http://192.168.1.200:8080/api/niubiz/response');
    try {
      // Construir el cuerpo de la solicitud
      final body = json.encode({"id": widget.purchaseNumber});

      // Realizar la solicitud POST
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          paymentDetails = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load payment details');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching payment details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Pago'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : paymentDetails != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Número de Compra: ${paymentDetails!['purchaseNumber']}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Monto: S/ ${paymentDetails!['amount']}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Código de Autorización: ${paymentDetails!['authorizationCode']}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Estado: ${paymentDetails!['status']}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Descripción: ${paymentDetails!['actionDescription']}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Fecha de Transacción: ${paymentDetails!['transactionDate']}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: Text(
                  'No se pudo cargar el detalle del pago',
                  style: TextStyle(fontSize: 16),
                )),
    );
  }
}

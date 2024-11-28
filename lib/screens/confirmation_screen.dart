import 'package:com_restaurante_frontend_movil/services/niubiz_service.dart';
import 'package:flutter/material.dart';

class ConfirmationScreen extends StatelessWidget {
  final String purchaseNumber;
  final double amount;

  const ConfirmationScreen({
    Key? key,
    required this.purchaseNumber,
    required this.amount,
  }) : super(key: key);

  Future<void> _authorizeTransaction(BuildContext context) async {
    try {
      await NiubizService.authorizeTransaction(
        purchaseNumber: purchaseNumber,
        amount: amount,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pago autorizado con éxito')),
      );
      // Redirige o muestra una pantalla de éxito
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al autorizar el pago: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmación del Pago')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _authorizeTransaction(context),
          child: const Text('Autorizar Transacción'),
        ),
      ),
    );
  }
}

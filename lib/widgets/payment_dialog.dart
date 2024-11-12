import 'package:flutter/material.dart';
import '../services/niubiz_service.dart';

class PaymentDialog extends StatelessWidget {
  final VoidCallback onPaymentSuccess;

  const PaymentDialog({Key? key, required this.onPaymentSuccess})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController cardNumberController = TextEditingController();
    final TextEditingController expirationController = TextEditingController();
    final TextEditingController cvvController = TextEditingController();

    Future<void> _processPayment(BuildContext context) async {
      final accessToken = await NiubizService.getAccessToken();

      if (accessToken != null) {
        onPaymentSuccess();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pago procesado exitosamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al procesar el pago')),
        );
      }
    }

    return AlertDialog(
      title: const Text('Información de Pago'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: cardNumberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Número de Tarjeta'),
          ),
          TextField(
            controller: expirationController,
            keyboardType: TextInputType.number,
            decoration:
                const InputDecoration(labelText: 'Fecha de Expiración (MM/AA)'),
          ),
          TextField(
            controller: cvvController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'CVV'),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            _processPayment(context);
          },
          child: const Text('Pagar'),
        ),
      ],
    );
  }
}

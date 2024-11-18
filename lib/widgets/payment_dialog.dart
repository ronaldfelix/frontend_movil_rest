import 'package:flutter/material.dart';
import '../services/niubiz_service.dart';

class PaymentDialog extends StatelessWidget {
  final VoidCallback onPaymentSuccess;

  const PaymentDialog({super.key, required this.onPaymentSuccess});

  @override
  Widget build(BuildContext context) {
    final TextEditingController cardNumberController = TextEditingController();
    final TextEditingController expirationController = TextEditingController();
    final TextEditingController cvvController = TextEditingController();

    Future<void> processPayment(BuildContext context) async {
      try {
        print("Iniciando proceso de pago...");
        print("Número de tarjeta: ${cardNumberController.text}");
        print("Fecha de expiración: ${expirationController.text}");
        print("CVV: ${cvvController.text}");

        final accessToken = await NiubizService.getAccessToken();

        if (accessToken != null) {
          print("Access Token recibido exitosamente.");

          const double requestedAmount = 10.5; // Monto simulado
          const String purchaseNumber = "000001"; // Generar dinámicamente
          final sessionResponse = await NiubizService.createSessionToken(
              accessToken, requestedAmount);

          if (sessionResponse != null &&
              sessionResponse.containsKey('sessionKey')) {
            final String sessionKey = sessionResponse['sessionKey'];

            final authorizationResponse =
                await NiubizService.authorizeTransaction(
                    accessToken, sessionKey, purchaseNumber, requestedAmount);

            if (authorizationResponse != null) {
              NiubizService.validatePaymentResponse(
                  authorizationResponse, requestedAmount);

              onPaymentSuccess();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pago procesado exitosamente')),
              );
            } else {
              print("Error: No se pudo autorizar la transacción.");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error al procesar el pago')),
              );
            }
          } else {
            print("Error: No se pudo crear el Token de Sesión.");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error al procesar el pago')),
            );
          }
        } else {
          print("Error: No se pudo obtener el Access Token.");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al procesar el pago')),
          );
        }
      } catch (e) {
        print("Excepción durante el proceso de pago: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error inesperado al procesar el pago')),
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
            processPayment(context);
          },
          child: const Text('Pagar'),
        ),
      ],
    );
  }
}

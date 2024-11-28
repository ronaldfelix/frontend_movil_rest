import 'dart:convert';
import 'package:flutter/material.dart';

class ConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> response;

  const ConfirmationScreen({
    Key? key,
    required this.response,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String status = 'Estado desconocido';
    String description = 'Descripción no disponible';
    String transactionId = 'No disponible';

    try {
      // Si el campo "error" contiene un JSON anidado, procesarlo
      if (response.containsKey('error')) {
        final errorString = response['error'];

        // Verificar si el error es un JSON rodeado de comillas adicionales
        final startIndex = errorString.indexOf("{");
        final endIndex = errorString.lastIndexOf("}");
        if (startIndex != -1 && endIndex != -1) {
          final errorJsonString =
              errorString.substring(startIndex, endIndex + 1);
          final errorBody = jsonDecode(utf8.decode(errorJsonString.codeUnits));
          final nestedData = errorBody['data'];

          status = nestedData?['STATUS'] ?? 'Estado desconocido';
          description = nestedData?['ACTION_DESCRIPTION'] ??
              errorBody['errorMessage'] ??
              'Descripción no disponible';
          transactionId = nestedData?['SIGNATURE'] ?? 'No disponible';
        }
      } else {
        // Procesar casos estándar
        final dataMap = response['dataMap'];
        final data = response['data'];

        status = dataMap?['STATUS'] ?? data?['STATUS'] ?? 'Estado desconocido';
        description = dataMap?['ACTION_DESCRIPTION'] ??
            data?['ACTION_DESCRIPTION'] ??
            'Descripción no disponible';
        transactionId = dataMap?['TRANSACTION_ID'] ??
            data?['TRANSACTION_ID'] ??
            'No disponible';
      }
    } catch (e) {
      // Manejo de errores
      print("Error al procesar la respuesta: $e");
    }

    final isAuthorized = status == "Authorized";

    final actionButtonText =
        isAuthorized ? "Volver a Comprar" : "Intentar de Nuevo";

    return Scaffold(
      appBar: AppBar(title: const Text('Confirmación del Pago')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isAuthorized ? "Transacción Exitosa" : "Transacción Fallida",
              style: TextStyle(
                fontSize: 24,
                color: isAuthorized ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Text("ID Transacción: $transactionId"),
            const SizedBox(height: 8),
            Text("Estado: $status"),
            const SizedBox(height: 8),
            Text(
              "Descripción: $description",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(actionButtonText),
            ),
          ],
        ),
      ),
    );
  }
}

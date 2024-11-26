import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRButton extends StatelessWidget {
  final List<Map<String, dynamic>> order;

  const QRButton({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.qr_code),
      onPressed: () {
        // Format the order items into a readable string format for QR
        String dataToEncode = order.map((item) {
          return 'Nombre: ${item['nombre']}, Cantidad: ${item['cantidad']}, Precio: S/.${item['precio']}';
        }).join("\n");

        // Show QR dialog
        showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "QR de tu pedido",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: QrImageView(
                            data: dataToEncode,
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Cerrar"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

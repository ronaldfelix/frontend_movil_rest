import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../config/database_helper.dart';

class QRButton extends StatelessWidget {
  const QRButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.qr_code),
      onPressed: () async {
        // Obtener orden items de la database
        List<String> items = await DatabaseHelper().getOrderItems();
        String dataToEncode = items.join(", ");

        // Mostarr qr
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            title: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Text("QR de la orden"),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
            content: Center(
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
          ),
        );
      },
    );
  }
}

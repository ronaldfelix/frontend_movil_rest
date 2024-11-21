import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/niubiz_service.dart';

class NiubizButton extends StatefulWidget {
  final double amount;

  const NiubizButton({super.key, required this.amount});

  @override
  State<NiubizButton> createState() => _NiubizButtonState();
}

class _NiubizButtonState extends State<NiubizButton> {
  late final MethodChannel _channel;

  @override
  void initState() {
    super.initState();
    _channel = const MethodChannel('niubiz_button');
    _initializeButton();
  }

  Future<void> _initializeButton() async {
    try {
      final String? accessToken = await NiubizService.getAccessToken();
      if (accessToken != null) {
        final String? sessionToken =
            await NiubizService.createSessionToken(accessToken, widget.amount);
        if (sessionToken != null) {
          await _channel.invokeMethod('initialize', {
            'sessionToken': sessionToken,
            'merchantId': "456879852",
            'amount': widget.amount.toString(),
            'expirationMinutes': 15,
          });
        } else {
          print("Error al obtener token de sesión.");
        }
      } else {
        print("Error al obtener token de acceso.");
      }
    } catch (e) {
      print("Error inicializando el botón Niubiz: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: UiKitView(
        viewType: 'niubiz_button',
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }
}

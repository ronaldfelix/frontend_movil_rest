import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../screens/confirmation_screen.dart';

import '../services/niubiz_service.dart';

class PaymentScreen extends StatefulWidget {
  final String sessionToken;
  final String merchantId;
  final String purchaseNumber;
  final double amount;

  const PaymentScreen({
    required this.sessionToken,
    required this.merchantId,
    required this.purchaseNumber,
    required this.amount,
    super.key,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print('Página cargando: $url');
          },
          onPageFinished: (String url) async {
            print('Página cargada: $url');
            if (url.contains('response-form')) {
              await _handlePaymentValidation();
            }
          },
          onWebResourceError: (WebResourceError error) {
            print('Error al cargar recurso: $error');
          },
        ),
      )
      ..loadHtmlString(_generateHtml());
  }

  Future<void> _handlePaymentValidation() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      final response = await NiubizService.authorizeTransaction(
        purchaseNumber: widget.purchaseNumber,
        amount: widget.amount,
      );

      Navigator.pop(context); // Cerrar pantalla de carga

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationScreen(response: response),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Cerrar pantalla de carga
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al procesar el pago: $e")),
      );
    }
  }

  String _generateHtml() {
    return '''
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Formulario de Pago</title>
    </head>
    <body>
      <form action="http://192.168.1.200:8080/api/niubiz/response-form?id=${widget.purchaseNumber}" method="POST">
        <script
          src="https://static-content-qas.vnforapps.com/v2/js/checkout.js?qa=true"
          data-sessiontoken="${widget.sessionToken}"
          data-channel="web"
          data-merchantid="${widget.merchantId}"
          data-merchantlogo="http://192.168.1.200:8080/images/helado_vainilla.jpg"
          data-formbuttoncolor="#D80000"
          data-purchasenumber="${widget.purchaseNumber}"
          data-amount="${widget.amount.toStringAsFixed(2)}"
          data-expirationminutes="20"
          data-timeouturl="http://192.168.1.200:8080/api/niubiz/timeout"
          data-showamount="true">
        </script>
      </form>
    </body>
    </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Pago'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}

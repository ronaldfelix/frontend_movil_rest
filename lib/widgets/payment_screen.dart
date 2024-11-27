import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
    Key? key,
  }) : super(key: key);

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
          onPageFinished: (String url) {
            print('Página cargada: $url');
          },
          onWebResourceError: (WebResourceError error) {
            print('Error al cargar recurso: $error');
          },
        ),
      )
      ..loadHtmlString(_generateHtml());
  }

  String _generateHtml() {
    // URL de tu backend para procesar la respuesta de Niubiz
    final responseUrl =
        "http://192.168.1.200:8080/api/niubiz/response?id=${widget.purchaseNumber}";

    return '''
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Formulario de Pago</title>
    </head>
    <body>
      <form action="$responseUrl" method="post">
        <script
          src="https://static-content-qas.vnforapps.com/v2/js/checkout.js?qa=true"
          data-sessiontoken="${widget.sessionToken}"
          data-channel="web"
          data-merchantid="${widget.merchantId}"
          data-merchantlogo="assets/logo.png"
          data-formbuttoncolor="#D80000"
          data-purchasenumber="${widget.purchaseNumber}"
          data-amount="${widget.amount.toStringAsFixed(2)}"
          data-expirationminutes="20"
          data-timeouturl="http://192.168.1.200:8080/api/niubiz/timeout">
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

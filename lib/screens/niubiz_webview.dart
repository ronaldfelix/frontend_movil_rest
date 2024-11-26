import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NiubizWebView extends StatefulWidget {
  final String sessionToken;
  final double amount;
  final String purchaseNumber;

  NiubizWebView({
    required this.sessionToken,
    required this.amount,
    required this.purchaseNumber,
  });

  @override
  State<NiubizWebView> createState() => _NiubizWebViewState();
}

class _NiubizWebViewState extends State<NiubizWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Inicialización del controlador del WebView
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('Comenzó a cargar: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Terminó de cargar: $url');
          },
          onWebResourceError: (error) {
            debugPrint('Error en la carga: ${error.description}');
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
            'https://apisandbox.vnforappstest.com/api.ecommerce/v2/ecommerce/payment?sessionKey=${widget.sessionToken}&channel=web&amount=${widget.amount}&purchaseNumber=${widget.purchaseNumber}'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulario de Pago Niubiz')),
      body: WebViewWidget(controller: _controller),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  final String sessionToken;
  final double amount;
  final String purchaseNumber;

  WebViewPage({
    required this.sessionToken,
    required this.amount,
    required this.purchaseNumber,
  });

  @override
  Widget build(BuildContext context) {
    final String htmlContent = '''
      <html>
      <head>
        <link rel="stylesheet" href="https://pocpaymentserve.s3.amazonaws.com/payform.min.css">
      </head>
      <body>
        <script src="https://pocpaymentserve.s3.amazonaws.com/payform.min.js"></script>
        <script type="text/javascript">
          var configuration = {
            callbackurl: 'https://your-callback-url.com',
            sessionkey: '$sessionToken',
            channel: 'web',
            merchantid: '341198210',
            purchasenumber: '$purchaseNumber',
            amount: $amount,
            language: 'es',
            font: 'https://fonts.googleapis.com/css?family=Montserrat:400&display=swap'
          };
          payform.setConfiguration(configuration);
        </script>
      </body>
      </html>
    ''';

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(htmlContent);

    return Scaffold(
      appBar: AppBar(title: Text('Formulario de Pago')),
      body: WebViewWidget(controller: controller),
    );
  }
}

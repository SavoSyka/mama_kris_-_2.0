import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PaymentWebViewPage extends StatefulWidget {
  const PaymentWebViewPage({
    super.key,
    required this.url,
    required this.callback,
  });

  final String url;
  final void Function(WebViewRequest) callback;

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  String _currentUrl = '';

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            debugPrint("📄 onPageStarted: $url");
            _currentUrl = url;
          },
          onPageFinished: (url) async {
            debugPrint("✅ onPageFinished: $url");
            _currentUrl = url;

            try {
              final jsResult = await _controller
                  .runJavaScriptReturningResult("window.location.href");
              debugPrint("🧪 JS window.location.href: $jsResult");
            } catch (e) {
              debugPrint("❌ Ошибка JS: $e");
            }
          },
          onNavigationRequest: (request) async {
            debugPrint("🔁 onNavigationRequest: ${request.url}");
            final uri = Uri.tryParse(request.url);

            if (uri != null && !uri.scheme.contains('http')) {
              try {
                await launchUrlString(
                  request.url,
                  mode: LaunchMode.externalApplication,
                );
              } catch (e) {
                debugPrint("❌ Ошибка открытия внешнего URL: $e");
              }
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onUrlChange: (change) async {
            final currentUrl = change.url;
            debugPrint('🔍 onUrlChange → $currentUrl');

            if (currentUrl == null) return;

            if (currentUrl.contains("payments.v2/success") ||
                currentUrl.contains("payments/success")) {
              debugPrint("✅ Успех: URL содержит 'success'");
              widget.callback(WebViewRequest.success);
            } else if (currentUrl.contains("payments.v2/fail") ||
                currentUrl.contains("payments/fail")) {
              debugPrint("❌ Неудача: URL содержит 'fail'");
              widget.callback(WebViewRequest.fail);
            } else {
              debugPrint(
                  "⚠️ URL не содержит ключевых слов. Не вызываем callback.");
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00A80E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser, color: Colors.white),
            onPressed: () async {
              if (_currentUrl.isNotEmpty) {
                await launchUrlString(_currentUrl,
                    mode: LaunchMode.externalApplication);
              }
            },
          ),
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}

enum WebViewRequest {
  success('success'),
  fail('fail');

  const WebViewRequest(this.value);
  final String value;
}
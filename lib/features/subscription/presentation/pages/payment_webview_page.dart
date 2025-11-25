// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:url_launcher/url_launcher_string.dart';

// class PaymentWebViewPage extends StatefulWidget {
//   const PaymentWebViewPage({
//     super.key,
//     required this.url,
//     required this.callback,
//   });

//   final String url;
//   final void Function(WebViewRequest) callback;

//   @override
//   State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
// }

// class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
//   late final WebViewController _controller;
//   String _currentUrl = '';

//   @override
//   void initState() {
//     super.initState();

//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (url) {
//             debugPrint("📄 onPageStarted: $url");
//             _currentUrl = url;
//           },
//           onPageFinished: (url) async {
//             debugPrint("✅ onPageFinished: $url");
//             _currentUrl = url;

//             try {
//               final jsResult = await _controller
//                   .runJavaScriptReturningResult("window.location.href");
//               debugPrint("🧪 JS window.location.href: $jsResult");
//             } catch (e) {
//               debugPrint("❌ Ошибка JS: $e");
//             }
//           },
//           onNavigationRequest: (request) async {
//             debugPrint("🔁 onNavigationRequest: ${request.url}");
//             final uri = Uri.tryParse(request.url);

//             if (uri != null && !uri.scheme.contains('http')) {
//               try {
//                 await launchUrlString(
//                   request.url,
//                   mode: LaunchMode.externalApplication,
//                 );
//               } catch (e) {
//                 debugPrint("❌ Ошибка открытия внешнего URL: $e");
//               }
//               return NavigationDecision.prevent;
//             }

//             return NavigationDecision.navigate;
//           },
//           onUrlChange: (change) async {
//             final currentUrl = change.url;
//             debugPrint('\\n\n🔍 onUrlChange → $currentUrl');

//             if (currentUrl == null) return;

//             if (currentUrl.contains("payments.v2/success") ||
//                 currentUrl.contains("payments/success")) {
//               debugPrint("\n\n✅  ✅ ✅ ✅ ✅ ✅ ✅  Успех: URL содержит 'success \n\n'");
//               widget.callback(WebViewRequest.success);
//             } else if (currentUrl.contains("payments.v2/fail") ||
//                 currentUrl.contains("payments/fail")) {
//               debugPrint("❌ Неудача: URL содержит 'fail'");
//               widget.callback(WebViewRequest.fail);
//             } else {
//               debugPrint(
//                   "⚠️ URL не содержит ключевых слов. Не вызываем callback.");
//             }
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(widget.url));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF00A80E),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.open_in_browser, color: Colors.white),
//             onPressed: () async {
//               if (_currentUrl.isNotEmpty) {
//                 await launchUrlString(_currentUrl,
//                     mode: LaunchMode.externalApplication);
//               }
//             },
//           ),
//         ],
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: WebViewWidget(controller: _controller),
//       ),
//     );
//   }
// }

// enum WebViewRequest {
//   success('success'),
//   fail('fail');

//   const WebViewRequest(this.value);
//   final String value;
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/custom_iphone_loader.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';
import 'package:mama_kris/features/subscription/application/cubit/subscription_status_cubit.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PaymentWebViewPage extends StatefulWidget {
  const PaymentWebViewPage({
    super.key,
    required this.url,
    // required this.callback,
    this.onSuccess, // optional: if you want direct VoidCallback
    this.onFail, // optional: if you want direct VoidCallback
  });

  final String url;
  // final void Function(WebViewRequest) callback;
  final VoidCallback? onSuccess;
  final VoidCallback? onFail;

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  bool _hasCalledSuccess = false; // Prevent double callbacks

  @override
  void initState() {
    super.initState();

    _loadUserTypeAndSetupTabs();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => debugPrint("Started: $url"),

          onPageFinished: (url) => debugPrint("Finished: $url"),

          onUrlChange: (UrlChange change) async {
            final String? url = change.url;
            if (url == null) return;

            debugPrint("URL → $url");

            // 1. REAL SUCCESS — highest priority — stop everything!
            if (url.contains('ym=success') ||
                url.contains('/success') ||
                RegExp(r'#A1004').hasMatch(url)) {
              if (!_hasCalledSuccess) {
                _hasCalledSuccess = true;
                debugPrint(
                  "  ✅✅✅✅✅✅ ✅✅✅✅✅✅REAL SUCCESS DETECTED (A1004 or ym=success)",
                );

                context.read<SubscriptionStatusCubit>().startPolling();

                // Close WebView + go to checking page
                if (mounted) {
                  debugPrint(
                    "  ✅✅✅✅✅✅ ✅✅✅✅✅✅REAL SUCCESS DETECTED (A1004 or ym=success)",
                  );

                  // Navigator.of(context).pop(); // close WebView
                  // context.pushNamed(RouteName.paymentCheckingPage);
                }
              }
              return;
            }

            // 2. ONLY treat as real fail if:
            //    - ym=fail AND no success came after
            //    - OR user actually landed on your fail page AND stayed there
            if (url.contains('ym=fail') || url.contains('/fail')) {
              // Wait a bit — sometimes success comes right after fake fail
              Future.delayed(const Duration(seconds: 3), () {
                if (mounted && !_hasCalledSuccess) {
                  debugPrint("REAL FAILURE CONFIRMED");
                  widget.onFail?.call();
                }
              });
              return;
            }

            // 3. Ignore all #A1005, #A1006, #A1007 — they are FAKE during SberPay!
            if (RegExp(r'#A100[567]').hasMatch(url)) {
              debugPrint(
                " 🙈🙈🙈🙈REAL SUCCESS DETECTED (A1004 or ym=success)",
              );

              debugPrint(
                "IGNORING intermediate bank error #A1005/A1006/A1007 — normal for SberPay",
              );
              return; // ← DO NOT call onFail!
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            final uri = Uri.tryParse(request.url);
            // Open tg://, app links, etc. in external apps
            if (uri != null && !['http', 'https'].contains(uri.scheme)) {
              launchUrlString(
                request.url,
                mode: LaunchMode.externalApplication,
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  bool _isApplicant = false;

  Future<void> _loadUserTypeAndSetupTabs() async {
    final bool isAppl = await sl<AuthLocalDataSource>().getUserType();

    setState(() {
      _isApplicant = isAppl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00A80E),
        title: const Text("Оплата", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser, color: Colors.white),
            onPressed: () async {
              final current = await _controller.currentUrl();
              if (current != null) {
                await launchUrlString(
                  current,
                  mode: LaunchMode.externalApplication,
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocListener<SubscriptionStatusCubit, SubscriptionStatusState>(
          listener: (context, state) {
            if (state is SubscriptionStatusSuccess && state.hasSubscription) {
              if (_isApplicant) {
                context.goNamed(RouteName.homeApplicant);
              } else {
                context.goNamed(RouteName.homeEmploye);
              }
            }
          },
          child: WebViewWidget(controller: _controller),
        ),
      ),
    );
  }
}

enum WebViewRequest { success, fail }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../theme/app_colors.dart';

Future<bool> openGiftCardTarget({
  required bool isWeb,
  required Uri uri,
  required Future<bool> Function(Uri) launchOnWeb,
  required Future<void> Function() openNativeWebView,
}) async {
  if (isWeb) return launchOnWeb(uri);
  await openNativeWebView();
  return true;
}

class GiftCardRedemptionWebView extends StatefulWidget {
  final String url;

  const GiftCardRedemptionWebView({super.key, required this.url});

  @override
  State<GiftCardRedemptionWebView> createState() =>
      _GiftCardRedemptionWebViewState();
}

class _GiftCardRedemptionWebViewState extends State<GiftCardRedemptionWebView> {
  late final WebViewController _controller;
  int _progress = 0;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) return;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) setState(() => _progress = progress);
          },
          onPageStarted: (_) {
            if (mounted) setState(() => _hasError = false);
          },
          onWebResourceError: (error) {
            if ((error.isForMainFrame ?? true) && mounted) {
              setState(() => _hasError = true);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (kIsWeb) {
      return const Scaffold(
        body: Center(
          child: Text('Opening gift card...'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Gift Card'),
        leading: IconButton(
          tooltip: 'Close',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ),
      body: Column(
        children: [
          if (_progress < 100 && !_hasError)
            LinearProgressIndicator(
              value: _progress == 0 ? null : _progress / 100,
              color: AppColors.success,
            ),
          Expanded(
            child: _hasError
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wifi_off, size: 36),
                          const SizedBox(height: 12),
                          Text(
                            'Unable to load the gift-card page. Check your connection and try again.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _hasError = false;
                                _progress = 0;
                              });
                              _controller.reload();
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Try again'),
                          ),
                        ],
                      ),
                    ),
                  )
                : WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
  }
}

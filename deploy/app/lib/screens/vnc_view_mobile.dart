import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../theme/app_theme.dart';

typedef VncStatusCallback = void Function(Map<String, dynamic> data);

class VncView extends StatefulWidget {
  final String wsUrl;
  final String jwtToken;
  final VncStatusCallback onStatus;

  const VncView({
    super.key,
    required this.wsUrl,
    required this.jwtToken,
    required this.onStatus,
  });

  @override
  State<VncView> createState() => _VncViewState();
}

class _VncViewState extends State<VncView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.background)
      ..addJavaScriptChannel(
        'VncStatus',
        onMessageReceived: (msg) {
          try {
            final data = jsonDecode(msg.message) as Map<String, dynamic>;
            widget.onStatus(data);
          } catch (_) {}
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => _connect(),
        ),
      )
      ..loadFlutterAsset('assets/vnc/vnc.html');
  }

  void _connect() {
    final escapedUrl = widget.wsUrl.replaceAll("'", "\\'");
    final escapedToken = widget.jwtToken.replaceAll("'", "\\'");
    _controller.runJavaScript("connectVnc('$escapedUrl', '$escapedToken')");
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}

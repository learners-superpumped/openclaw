import 'dart:convert';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

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
  late final String _viewType;
  html.EventListener? _messageListener;

  @override
  void initState() {
    super.initState();
    _viewType = 'vnc-iframe-${identityHashCode(this)}';

    _messageListener = (html.Event event) {
      if (event is html.MessageEvent) {
        try {
          final raw = event.data;
          if (raw is String) {
            final data = jsonDecode(raw) as Map<String, dynamic>;
            if (data.containsKey('type')) {
              widget.onStatus(data);
            }
          }
        } catch (_) {}
      }
    };
    html.window.addEventListener('message', _messageListener!);

    final hashParams = [
      'wsUrl=${Uri.encodeComponent(widget.wsUrl)}',
      'token=${Uri.encodeComponent(widget.jwtToken)}',
    ].join('&');

    // web/vnc/vnc.html is served at /vnc/vnc.html in both debug and release
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      return html.IFrameElement()
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allow = 'clipboard-read; clipboard-write'
        ..src = 'vnc/vnc.html#$hashParams';
    });
  }

  @override
  void dispose() {
    if (_messageListener != null) {
      html.window.removeEventListener('message', _messageListener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}

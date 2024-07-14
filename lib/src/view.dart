import 'package:flutter/material.dart';

import 'controller.dart';

typedef InAppScannerViewBuilder = Widget Function(
  BuildContext context,
  InAppScannerController controller,
);

class InAppScannerBuilder extends StatefulWidget {
  final InAppScannerController controller;
  final InAppScannerViewBuilder builder;
  final bool autoInitMode;
  final bool autoDisposeMode;

  const InAppScannerBuilder({
    super.key,
    required this.controller,
    required this.builder,
    this.autoInitMode = false,
    this.autoDisposeMode = false,
  });

  @override
  State<InAppScannerBuilder> createState() => _InAppScannerBuilderState();
}

class _InAppScannerBuilderState extends State<InAppScannerBuilder> {
  @override
  void initState() {
    super.initState();
    if (widget.autoInitMode) widget.controller.init();
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.autoDisposeMode) widget.controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.controller);
  }
}

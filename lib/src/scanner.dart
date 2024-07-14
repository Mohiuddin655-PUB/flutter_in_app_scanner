import 'package:flutter/material.dart';

import '../in_app_scanner.dart';

class InAppScannerView extends StatelessWidget {
  final InAppScannerController controller;

  const InAppScannerView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.isCameraInitialized && controller.cameraController != null) {
      return CameraPreview(controller.cameraController!);
    } else {
      return const SizedBox.shrink();
    }
  }
}

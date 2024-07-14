## in_app_scanner

A Flutter widget for barcode scanning and image capturing using a single camera.

## Features

- Capture images using the device's camera.
- Scan barcodes from captured images.
- Display the captured barcode result.

## Getting started

### Prerequisites

- Flutter SDK installed on your machine.
- Device with a camera (physical device recommended for testing).

### Installation

Add the following dependencies to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  in_app_scanner: ^1.0.0 #use latest version
```

Run `flutter pub get` to install the dependencies.

## Usage

Create a new widget by extending `InAppScannerBuilder`:

```dart
import 'package:flutter/material.dart';
import 'package:in_app_scanner/in_app_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: _Page(),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return const _Scanner();
                },
              ),
            );
          },
          child: const Text("Scan"),
        ),
      ),
    );
  }
}

class _Scanner extends StatelessWidget {
  const _Scanner();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppScannerBuilder(
        controller: InAppScannerController(),
        autoInitMode: true,
        autoDisposeMode: true,
        builder: (context, controller) {
          return ListenableBuilder(
            listenable: controller,
            builder: (context, child) {
              if (controller.isCameraInitialized) {
                return Column(
                  children: [
                    Expanded(
                      child: InAppScannerView(
                        controller: controller,
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        },
      ),
    );
  }
}
```

The `InAppScannerBuilder` widget provides the functionality to capture and scan barcodes and
the `InAppScannerView` widget provides the camera preview

## Additional information

For more information on how to contribute to the package, file issues, or seek support, please visit
the <a href="https://github.com/Mohiuddin655-PUB/flutter_in_app_scanner.git">GitHub repository</a>.

Contributions are welcome! Feel free to submit pull requests or file issues.

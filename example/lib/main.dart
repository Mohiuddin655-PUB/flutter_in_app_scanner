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

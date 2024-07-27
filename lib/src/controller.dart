import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_scanner/in_app_scanner.dart';

class InAppScannerController extends ChangeNotifier {
  final List<BarcodeFormat> formats;

  CameraController? _controller;

  CameraController? get cameraController => _controller;

  BarcodeScanner? _scanner;

  BarcodeScanner? get scanner => _scanner;

  InAppScannerFlags _flag = InAppScannerFlags.camera;

  String? _barcode;

  bool get isScanned => _barcode != null && _barcode!.isNotEmpty;

  String? get barcode => _barcode;

  List<CameraDescription>? _cameras;

  List<CameraDescription>? get cameras => _cameras;

  CameraDescription? _camera;

  CameraDescription? get activeCamera => _camera;

  bool _isCameraInitialized = false;

  bool get isCameraInitialized => _isCameraInitialized;

  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  double get cameraAspectRatio => _controller?.value.aspectRatio ?? 0;

  InAppScannerController({
    this.formats = const [BarcodeFormat.all],
    InAppScannerFlags flag = InAppScannerFlags.camera,
  }) : _flag = flag;

  Future<void> init() async {
    _scanner?.close();
    _controller?.dispose();
    _scanner = BarcodeScanner(formats: formats);
    _cameras = await availableCameras();
    _camera = _cameras?.firstOrNull;
    _controller = CameraController(
      _camera!,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _controller?.initialize();
    _isCameraInitialized = true;
    notifyListeners();
    _flagging();
  }

  void setFlag(InAppScannerFlags flag) {
    _flag = flag;
    _flagging();
    notifyListeners();
  }

  Future<void> _flagging() async {
    switch (_flag) {
      case InAppScannerFlags.barcode:
        return _scanBarcode();
      case InAppScannerFlags.camera:
        return;
    }
  }

  Future<void> _scanBarcode() async {
    if (_isProcessing || isScanned) return;
    _isProcessing = true;
    notifyListeners();
    _barcode = await scanBarcode();
    _isProcessing = false;
    notifyListeners();
    _scanBarcode();
  }

  Future<String?> scanBarcode([String? path]) async {
    path ??= (await _controller!.takePicture()).path;
    final inputImage = InputImage.fromFilePath(path);
    final barcodes = await _scanner?.processImage(inputImage);
    if (barcodes != null && barcodes.isNotEmpty) {
      final result = barcodes.first.rawValue;
      if (result != null && result.isNotEmpty) {
        return result;
      }
    }
    return null;
  }

  Future<void> rescanBarcode() async {
    if (_flag == InAppScannerFlags.barcode) {
      _barcode = null;
      return _scanBarcode();
    } else {
      log("InAppScanner error: $_flag didn't match ${InAppScannerFlags.barcode}");
    }
  }

  Future<File?> takePicture() async {
    final x = await _controller?.takePicture();
    if (x != null) {
      return File(x.path);
    } else {
      return null;
    }
  }

  void switchCamera(
    Future<CameraDescription?> Function(
      List<CameraDescription> cameras,
    ) callback,
  ) async {
    final camera = await callback.call(_cameras ?? []);
    if (camera != null) {
      _camera = camera;
      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    _scanner?.close();
  }
}

enum InAppScannerFlags { camera, barcode }

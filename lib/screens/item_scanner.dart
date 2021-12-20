import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cheapest_item_calculator/models/item.dart';
import 'package:cheapest_item_calculator/services/database.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class ItemScanner extends StatefulWidget {
  const ItemScanner({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  _ItemScannerState createState() => _ItemScannerState();
}

class _ItemScannerState extends State<ItemScanner> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  int selectedCamera = 0;
  List<File> capturedImages = [];

  @override
  void initState() {
    super.initState();
    initializeCamera(selectedCamera);
  }

  void initializeCamera(int cameraIndex) async {
    _controller = CameraController(
      widget.cameras[cameraIndex],
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capture Barcode'),
      ),
      body: Column(children: [
        Wrap(
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.height) * 0.7,
                child: FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the Future is complete, display the preview.
                      return CameraPreview(_controller);
                    } else {
                      // Otherwise, display a loading indicator.
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.lightBlue,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.camera_alt),
                    onPressed: () => getItemFromBarcode(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  void getItemFromBarcode() async {
    String barcode = await decodeBarcode();
    bool itemPresent = await DatabaseService().checkDocument(barcode);
    Item returnItem;
    if (itemPresent) {
      print('Item is present in the database');
      returnItem = await DatabaseService().getDocument(barcode);
    } else {
      print('Item is NOT present in the database');
      returnItem = Item(barcode: int.parse(barcode), category: "", name: "", units: 0, uom: "", price: 0, priceperuom: 0);
    }
    Navigator.pop(
      context,
      returnItem,
    );
  }

  Future<String> decodeBarcode() async {
    String barcodeValue = "";

    await _initializeControllerFuture;

    var xFile = await _controller.takePicture();
    final inputImage = InputImage.fromFilePath(xFile.path);
    final barcodeScanner = GoogleMlKit.vision.barcodeScanner();
    final List<Barcode> barcodes =
        await barcodeScanner.processImage(inputImage);

    for (Barcode barcode in barcodes) {
      barcodeValue = barcode.value.displayValue!;
    }

    barcodeScanner.close();

    return barcodeValue;
  }
}

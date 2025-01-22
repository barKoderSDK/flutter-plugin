import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:barkoder_flutter/barkoder_flutter.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late Barkoder _barkoder;

  bool _isScanningActive = false;
  String _barkoderVersion = '';

  List<DecoderResult> _decoderResults = [];
  List<Uint8List?> _resultThumbnailImages = [];
  Uint8List? _resultImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      // _barkoder.stopScanning();
      // _updateState(null, false);
    }
  }

  void _onBarkoderViewCreated(barkoder) async {
    _barkoder = barkoder;

    String barkoderVersion = await _barkoder.getVersion;
    _setActiveBarcodeTypes();
    _setBarkoderSettings();

    // _barkoder.configureBarkoder(BarkoderConfig(
    //   imageResultEnabled: true,
    //   decoder: DekoderConfig(qr: BarcodeConfig(enabled: true)),
    // ));

    if (!mounted) return;

    setState(() {
      _barkoderVersion = barkoderVersion;
    });
  }

  void _setActiveBarcodeTypes() {
    _barkoder.setBarcodeTypeEnabled(BarcodeType.qr, true);
    _barkoder.setBarcodeTypeEnabled(BarcodeType.ean13, true);
    _barkoder.setBarcodeTypeEnabled(BarcodeType.upcA, true);
    _barkoder.setBarcodeTypeEnabled(BarcodeType.code128, true);
  }

  void _setBarkoderSettings() {
    _barkoder.setImageResultEnabled(true);
    _barkoder.setLocationInImageResultEnabled(true);
    _barkoder.setMaximumResultsCount(200);
    _barkoder.setRegionOfInterestVisible(true);
    _barkoder.setPinchToZoomEnabled(true);
    _barkoder.setBarcodeThumbnailOnResultEnabled(true);
    _barkoder.setRegionOfInterest(5, 5, 90, 90);

    // When using image scan it is recommended to use rigorous decoding speed
    // _barkoder.setDecodingSpeed(DecodingSpeed.rigorous);
  }

  void _updateState(BarkoderResult? barkoderResult, bool scanningIsActive) {
    if (!mounted) return;

    setState(() {
      _isScanningActive = scanningIsActive;

      if (barkoderResult != null) {
        _decoderResults.clear();
        _resultThumbnailImages.clear();
        _resultImage?.clear();

        _decoderResults.addAll(barkoderResult.decoderResults);

        if (barkoderResult.resultThumbnails != null) {
          _resultThumbnailImages.addAll(barkoderResult.resultThumbnails!);
        }

        if (barkoderResult.resultImage != null) {
          _resultImage = barkoderResult.resultImage!;
        }
      } else {
        // Clear all values if no result
        _decoderResults.clear();
        _resultThumbnailImages.clear();
        _resultImage = null;
      }
    });
  }

  void _scanPressed() {
    if (_isScanningActive) {
      _barkoder.stopScanning();
    } else {
      _barkoder.startScanning((result) {
        _updateState(result, false);
      });
    }

    _updateState(null, !_isScanningActive);
  }

  void _scanImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    _barkoder.stopScanning();

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      String base64Image = base64Encode(bytes);

      _barkoder.scanImage((result) {
        if (result.decoderResults.isEmpty) {
          // Only show dialog if no results were found
          _showNoResultsDialog();
        }

        _updateState(result, false);
      }, base64Image);
    } else {
      _updateState(null, true);
    }

    _updateState(null, !_isScanningActive);
  }

  void _showNoResultsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No barcodes or MRZ detected :("),
          content: const Text(
              "Please ensure the image you've selected contains at least one barcode, or choose a different image.\nAlso, verify that the barcode type you're trying to scan is enabled"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF0022),
        title: Text('Barkoder Sample (v$_barkoderVersion)'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Stack(
                  children: <Widget>[
                    // Camera preview
                    BarkoderView(
                      licenseKey: '',
                      onBarkoderViewCreated: _onBarkoderViewCreated,
                    ),

                    // Placeholder Text
                    if (!_isScanningActive && _resultImage == null)
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Press the button to start scanning',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        ),
                      ),

                    // Display scanned image on top of preview
                    if (_resultImage != null)
                      Align(
                        alignment: Alignment.center,
                        child: Image.memory(
                          _resultImage!,
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _decoderResults.isNotEmpty
                      ? _decoderResults.length + 1
                      : 0,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Card(
                        margin: const EdgeInsets.all(10.0),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              '${_decoderResults.length} result${_decoderResults.length > 1 ? 's' : ''} found',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    final result = _decoderResults[index - 1];
                    final thumbnailImage = _resultThumbnailImages.isNotEmpty &&
                            index - 1 < _resultThumbnailImages.length
                        ? _resultThumbnailImages[index - 1]
                        : null;

                    return Card(
                      margin: const EdgeInsets.all(10.0),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              "Result",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(result.textualData),
                            const Divider(),
                            const Text(
                              "Type",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(result.barcodeTypeName),
                            if (result.extra != null &&
                                result.extra!.isNotEmpty) ...[
                              const Divider(),
                              const Text(
                                "Extras",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(result.extra?.toString() ?? ''),
                            ],
                            if (thumbnailImage != null) ...[
                              const Divider(),
                              const Text(
                                "Thumbnail",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              Image.memory(
                                thumbnailImage,
                                fit: BoxFit.contain,
                                width: 100,
                                height: 100,
                              ),
                            ],
                            if (result.mrzImages != null &&
                                result.mrzImages!.isNotEmpty) ...[
                              const Divider(),
                              const Text(
                                "MRZ Images",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              Column(
                                children: result.mrzImages!.map((mrzImage) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          mrzImage.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        Image.memory(
                                          mrzImage.value,
                                          fit: BoxFit.contain,
                                          width: 200,
                                          height: 200,
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: _scanImage,
            child: const Icon(Icons.photo),
            backgroundColor: Colors.white,
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            tooltip: _isScanningActive ? 'Stop scan' : 'Start scan',
            onPressed: _scanPressed,
            backgroundColor: _isScanningActive ? Colors.red : Colors.white,
            child: const Icon(Icons.qr_code_scanner),
          ),
        ],
      ),
    );
  }
}

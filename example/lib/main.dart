import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:barkoder_flutter/barkoder_flutter.dart';

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

  String _resultValue = '';
  String _typeValue = '';
  String _extrasValue = '';
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
      _barkoder.stopScanning();
      _updateState(null, false);
    }
  }

  void _onBarkoderViewCreated(barkoder) async {
    _barkoder = barkoder;

    String barkoderVersion = await _barkoder.getVersion;
    _setActiveBarcodeTypes();
    _setBarkoderSettings();

    // or use configuration object
    _barkoder.configureBarkoder(BarkoderConfig(
      imageResultEnabled: true,
      decoder: DekoderConfig(qr: BarcodeConfig(enabled: true)),
    ));

    if (!mounted) return;

    setState(() {
      _barkoderVersion = barkoderVersion;
    });
  }

  void _setActiveBarcodeTypes() {
    _barkoder.setBarcodeTypeEnabled(BarcodeType.qr, true);
    _barkoder.setBarcodeTypeEnabled(BarcodeType.ean13, true);
    _barkoder.setBarcodeTypeEnabled(BarcodeType.upcA, true);
  }

  void _setBarkoderSettings() {
    _barkoder.setImageResultEnabled(true);
    _barkoder.setLocationInImageResultEnabled(true);
    _barkoder.setRegionOfInterestVisible(true);
    _barkoder.setPinchToZoomEnabled(true);
    _barkoder.setRegionOfInterest(5, 5, 90, 90);
  }

  void _updateState(BarkoderResult? result, bool scanninIsActive) {
    if (!mounted) return;

    setState(() {
      _isScanningActive = scanninIsActive;

      if (result != null) {
        _resultValue = result.textualData;
        _typeValue = result.barcodeTypeName;
        _extrasValue = result.extra?.toString() ?? '';

        if (result.resultImageAsBase64 != null) {
          _resultImage =
              const Base64Decoder().convert(result.resultImageAsBase64!);
        } else {
          _resultImage = null;
        }
      } else {
        _resultValue = '';
        _typeValue = '';
        _extrasValue = '';
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

  void _showFullResult() {
    if (_resultValue != '') {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Result'),
          content: Text(_resultValue),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF0022),
        title: Text('Barkoder Sample (v$_barkoderVersion)'),
      ),
      body: Column(
        children: [
          Expanded(
              child: Stack(children: <Widget>[
            const Align(
                alignment: Alignment.center,
                child: Text('Press the button to start scanning',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 20))),
            if (_resultImage != null)
              Align(
                  alignment: Alignment.center,
                  child: Image.memory(_resultImage!)),
            BarkoderView(
                licenseKey: 'KEY',
                onBarkoderViewCreated: _onBarkoderViewCreated),
          ])),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _showFullResult,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5.0),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                "Result",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              _resultValue,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            )
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                margin: const EdgeInsets.only(right: 5.0),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 5.0),
                                      child: Text(
                                        "Type",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(_typeValue)
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                margin: const EdgeInsets.only(left: 5.0),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 5.0),
                                      child: Text(
                                        "Extras",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(_extrasValue)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: _isScanningActive ? 'Stop scan' : 'Start scan',
        onPressed: _scanPressed,
        backgroundColor: _isScanningActive ? Colors.red : Colors.black,
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
}

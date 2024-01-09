import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:convert';

import 'barkoder_flutter_models.dart';

export 'barkoder_flutter_models.dart';
export 'barkoder_flutter_view.dart';

class Barkoder {
  static const MethodChannel _methodChannel = MethodChannel('barkoder_flutter');

  static final Stream<dynamic> _scanningResultsStream =
      const EventChannel('barkoder_flutter_scanningResultsEvent')
          .receiveBroadcastStream();
  StreamSubscription<dynamic>? _scanningResultsStreamSubscription;

  bool _isBarkoderViewNotMounted = true;

  Barkoder() {
    _isBarkoderViewNotMounted = false;
  }

  void releaseBarkoder() {
    _isBarkoderViewNotMounted = true;
  }

//region BarkoderView APIs

  Future<double> getMaxZoomFactor() {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel
        .invokeMethod('getMaxZoomFactor')
        .then((zoomFactor) => zoomFactor as double);
  }

  Future<void> setZoomFactor(double zoomFactor) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setZoomFactor', zoomFactor);
  }

  Future<bool> isFlashAvailable() {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel
        .invokeMethod('isFlashAvailable')
        .then((isAvailable) => isAvailable as bool);
  }

  Future<void> setFlashEnabled(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setFlashEnabled', enabled);
  }

  Future<void> startCamera() {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('startCamera');
  }

  Future<void> startScanning(void Function(BarkoderResult) resultsCallback) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    _clearScanningResultsStreamSubscription();
    _scanningResultsStreamSubscription = _scanningResultsStream.listen(
        (result) =>
            resultsCallback.call(BarkoderResult.fromJsonString(result)));

    return _methodChannel.invokeMethod('startScanning');
  }

  Future<void> stopScanning() {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    _clearScanningResultsStreamSubscription();
    return _methodChannel.invokeMethod('stopScanning');
  }

  Future<void> pauseScanning() {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    _clearScanningResultsStreamSubscription();
    return _methodChannel.invokeMethod('pauseScanning');
  }

//endregion BarkoderView APIs

//region BarkoderConfig APIs

  Future<String> get getLocationLineColorHex async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getLocationLineColorHex');
  }

//todo accept with/without # on iOS, android is implemented (impl for all setter APIs)
  Future<void> setLocationLineColor(String hexColor) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setLocationLineColor', hexColor);
  }

  Future<double> get getLocationLineWidth async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getLocationLineWidth');
  }

  Future<void> setLocationLineWidth(double lineWidth) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setLocationLineWidth', lineWidth);
  }

  Future<String> get getRoiLineColorHex async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getRoiLineColorHex');
  }

  Future<void> setRoiLineColor(String hexColor) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setRoiLineColor', hexColor);
  }

  Future<double> get getRoiLineWidth async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getRoiLineWidth');
  }

  Future<void> setRoiLineWidth(double lineWidth) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setRoiLineWidth', lineWidth);
  }

  Future<String> get getRoiOverlayBackgroundColorHex async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getRoiOverlayBackgroundColorHex');
  }

  Future<void> setRoiOverlayBackgroundColor(String hexColor) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setRoiOverlayBackgroundColor', hexColor);
  }

  Future<bool> get isCloseSessionOnResultEnabled async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('isCloseSessionOnResultEnabled');
  }

  Future<void> setCloseSessionOnResultEnabled(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setCloseSessionOnResultEnabled', enabled);
  }

  Future<bool> get isImageResultEnabled async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('isImageResultEnabled');
  }

  Future<void> setImageResultEnabled(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setImageResultEnabled', enabled);
  }

  Future<bool> get isLocationInImageResultEnabled async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('isLocationInImageResultEnabled');
  }

  Future<void> setLocationInImageResultEnabled(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setLocationInImageResultEnabled', enabled);
  }

  Future<List<double>> get getRegionOfInterest async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel
        .invokeMethod('getRegionOfInterest')
        .then((value) {
      return List.from(value);
    });
  }

  Future<void> setRegionOfInterest(
      double left, double top, double width, double height) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setRegionOfInterest',
        {'left': left, 'top': top, 'width': width, 'height': height});
  }

  Future<int> get getThreadsLimit async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getThreadsLimit');
  }

  Future<void> setThreadsLimit(int threadsLimit) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setThreadsLimit', threadsLimit);
  }

  Future<bool> get isLocationInPreviewEnabled async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('isLocationInPreviewEnabled');
  }

  Future<void> setLocationInPreviewEnabled(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setLocationInPreviewEnabled', enabled);
  }

  Future<bool> get isPinchToZoomEnabled async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('isPinchToZoomEnabled');
  }

  Future<void> setPinchToZoomEnabled(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setPinchToZoomEnabled', enabled);
  }

  Future<bool> get isRegionOfInterestVisible async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('isRegionOfInterestVisible');
  }

  Future<void> setRegionOfInterestVisible(bool visible) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setRegionOfInterestVisible', visible);
  }

  Future<BarkoderResolution> get getBarkoderResolution async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel
        .invokeMethod('getBarkoderResolution')
        .then((index) {
      return BarkoderResolution.values[index];
    });
  }

  Future<void> setBarkoderResolution(BarkoderResolution resolution) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setBarkoderResolution', resolution.index);
  }

  Future<bool> get isBeepOnSuccessEnabled async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('isBeepOnSuccessEnabled');
  }

  Future<void> setBeepOnSuccessEnabled(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setBeepOnSuccessEnabled', enabled);
  }

  Future<bool> get isVibrateOnSuccessEnabled async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('isVibrateOnSuccessEnabled');
  }

  Future<void> setVibrateOnSuccessEnabled(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setVibrateOnSuccessEnabled', enabled);
  }

  Future<void> showLogMessages(bool show) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('showLogMessages', show);
  }

//endregion BarkoderConfig APIs

//region Barkoder APIs

  Future<bool> isBarcodeTypeEnabled(BarcodeType type) async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod(
        'isBarcodeTypeEnabled', type.index);
  }

  Future<void> setBarcodeTypeEnabled(BarcodeType type, bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setBarcodeTypeEnabled', {'type': type.index, 'enabled': enabled});
  }

  Future<List<int>> getBarcodeTypeLengthRange(BarcodeType type) async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel
        .invokeMethod('getBarcodeTypeLengthRange', type.index)
        .then((value) {
      return List.from(value);
    });
  }

  Future<void> setBarcodeTypeLengthRange(BarcodeType type, int min, int max) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setBarcodeTypeLengthRange',
        {'type': type.index, 'min': min, 'max': max});
  }

  Future<MsiChecksumType> get getMsiChecksumType async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel
        .invokeMethod('getMsiChecksumType')
        .then((index) {
      return MsiChecksumType.values[index];
    });
  }

  Future<void> setMsiChecksumType(MsiChecksumType checksumType) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setMsiChecksumType', checksumType.index);
  }

  Future<Code39ChecksumType> get getCode39ChecksumType async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel
        .invokeMethod('getCode39ChecksumType')
        .then((index) {
      return Code39ChecksumType.values[index];
    });
  }

  Future<void> setCode39ChecksumType(Code39ChecksumType checksumType) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setCode39ChecksumType', checksumType.index);
  }

  Future<Code11ChecksumType> get getCode11ChecksumType async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel
        .invokeMethod('getCode11ChecksumType')
        .then((index) {
      return Code11ChecksumType.values[index];
    });
  }

  Future<void> setCode11ChecksumType(Code11ChecksumType checksumType) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setCode11ChecksumType', checksumType.index);
  }

  Future<String> get getEncodingCharacterSet async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getEncodingCharacterSet');
  }

  Future<void> setEncodingCharacterSet(String characterSet) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setEncodingCharacterSet', characterSet);
  }

  Future<DecodingSpeed> get getDecodingSpeed async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getDecodingSpeed').then((index) {
      return DecodingSpeed.values[index];
    });
  }

  Future<void> setDecodingSpeed(DecodingSpeed decodingSpeed) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setDecodingSpeed', decodingSpeed.index);
  }

  Future<FormattingType> get getFormattingType async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getFormattingType').then((index) {
      return FormattingType.values[index];
    });
  }

  Future<void> setFormattingType(FormattingType formattingType) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setFormattingType', formattingType.index);
  }

  Future<String> get getVersion async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getVersion');
  }

  Future<void> setMaximumResultsCount(int maximumResultsCount) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setMaximumResultsCount', maximumResultsCount);
  }

  Future<double> get getMaximumResultsCount async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getMaximumResultsCount');
  }

  Future<void> setDuplicatesDelayMs(int duplicatesDelayMs) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setDuplicatesDelayMs', duplicatesDelayMs);
  }

  Future<int> get getDuplicatesDelayMs async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getDuplicatesDelayMs');
  }

  Future<void> setMulticodeCachingEnabled(bool multicodeCachingEnabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setMulticodeCachingEnabled', multicodeCachingEnabled);
  }

  Future<void> setMulticodeCachingDuration(int multicodeCachingDuration) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setMulticodeCachingDuration', multicodeCachingDuration);
  }

//endregion Barkoder APIs

  Future<void> configureBarkoder(BarkoderConfig barkoderConfig) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'configureBarkoder', jsonEncode(barkoderConfig));
  }

  void _clearScanningResultsStreamSubscription() {
    _scanningResultsStreamSubscription?.cancel();
    _scanningResultsStreamSubscription = null;
  }
}

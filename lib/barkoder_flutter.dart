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

  /// Retrieves the maximum available zoom factor for the device's camera.
  ///
  /// Returns a [Future] that completes with the maximum zoom factor.
  ///
  /// Example usage:
  /// ```dart
  /// double maxZoom = await getMaxZoomFactor();
  /// print('Maximum zoom factor: $maxZoom');
  /// ```
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

  /// Sets the zoom factor for the device's camera, adjusting the level of zoom during barcode scanning.
  ///
  /// [zoomFactor]: The zoom factor to set.
  ///
  /// Example usage:
  /// ```dart
  /// double zoom = 2.0;
  /// await setZoomFactor(zoom);
  /// print('Zoom factor set to: $zoom');
  /// ```
  Future<void> setZoomFactor(double zoomFactor) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setZoomFactor', zoomFactor);
  }

  /// Checks whether the device has a built-in flash (torch) that can be used for illumination during barcode scanning.
  ///
  /// Returns a [Future] that completes with a boolean indicating whether the flash is available.
  ///
  /// Example usage:
  /// ```dart
  /// bool flashAvailable = await _barkoder.isFlashAvailable();
  /// print('Flash available: $flashAvailable');
  /// ```
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

  /// Enables or disables the device's flash (torch) for illumination during barcode scanning.
  ///
  /// [enabled]: A boolean indicating whether to enable the flash.
  ///
  /// Example usage:
  /// ```dart
  /// bool flashEnabled = true;
  /// await _barkoder.setFlashEnabled(flashEnabled);
  /// print('Flash enabled: $flashEnabled');
  /// ```
  Future<void> setFlashEnabled(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setFlashEnabled', enabled);
  }

  /// Starts the camera.
  ///
  /// Example usage:
  /// ```dart
  /// await _barkoder.startCamera();
  /// print('Camera started successfully');
  /// ```
  Future<void> startCamera() {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('startCamera');
  }

  /// Initiates the barcode scanning process, allowing the application to detect and decode barcodes from the device's camera feed.
  ///
  /// [resultsCallback]: A function to handle the scanning results.
  ///
  /// Example usage:
  /// ```dart
  /// _barkoder.startScanning((result) {
  ///   _updateState(result, false);
  /// });
  /// print('Scanning started');
  /// ```
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

  /// Halts the barcode scanning process, stopping the camera from capturing and processing barcode information.
  ///
  /// Example usage:
  /// ```dart
  /// await _barkoder.stopScanning();
  /// print('Scanning stopped');
  /// ```
  Future<void> stopScanning() {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    _clearScanningResultsStreamSubscription();
    return _methodChannel.invokeMethod('stopScanning');
  }

  /// Temporarily suspends the barcode scanning process, pausing the camera feed without completely stopping the scanning session.
  ///
  /// Example usage:
  /// ```dart
  /// await _barkoder.pauseScanning();
  /// print('Scanning paused');
  /// ```
  Future<void> pauseScanning() {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    _clearScanningResultsStreamSubscription();
    return _methodChannel.invokeMethod('pauseScanning');
  }

  /// Retrieves the hexadecimal color code representing the line color used to indicate the location of detected barcodes.
  ///
  /// Returns a [Future] that completes with the color of the location line in hexadecimal format.
  ///
  /// Example usage:
  /// ```dart
  /// String lineColor = await _barkoder.getLocationLineColorHex();
  /// print('Location line color: $lineColor');
  /// ```
  Future<String> get getLocationLineColorHex async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getLocationLineColorHex');
  }

  /// Sets the color of the lines used to indicate the location of detected barcodes on the camera feed.
  ///
  /// [hexColor]: The color to set for the location line in hexadecimal format.
  ///
  /// Example usage:
  /// ```dart
  /// String lineColor = '#FF0000'; // Red color
  /// _barkoder.setLocationLineColor(lineColor);
  /// print('Location line color set to: $lineColor');
  /// ```
  Future<void> setLocationLineColor(String hexColor) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setLocationLineColor', hexColor);
  }

  /// Retrieves the current width setting for the lines indicating the location of detected barcodes on the camera feed.
  ///
  /// Returns a [Future] that completes with the width of the location line.
  ///
  /// Example usage:
  /// ```dart
  /// double lineWidth = await _barkoder.getLocationLineWidth();
  /// print('Location line width: $lineWidth');
  /// ```
  Future<double> get getLocationLineWidth async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getLocationLineWidth');
  }

  /// Sets the width of the lines indicating the location of detected barcodes on the camera feed.
  ///
  /// [lineWidth]: The width to set for the location line.
  ///
  /// Example usage:
  /// ```dart
  /// double lineWidth = 2.0;
  /// _barkoder.setLocationLineWidth(lineWidth);
  /// print('Location line width set to: $lineWidth');
  /// ```
  Future<void> setLocationLineWidth(double lineWidth) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setLocationLineWidth', lineWidth);
  }

  /// Retrieves the hexadecimal color code representing the line color of the Region of Interest (ROI) on the camera preview.
  ///
  /// Returns a [Future] that completes with the color of the ROI line in hexadecimal format.
  ///
  /// Example usage:
  /// ```dart
  /// String lineColor = await _barkoder.getRoiLineColorHex();
  /// print('ROI line color: $lineColor');
  /// ```
  Future<String> get getRoiLineColorHex async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getRoiLineColorHex');
  }

  /// Sets the width of the lines outlining the Region of Interest (ROI) for barcode scanning on the camera feed.
  ///
  /// [hexColor]: The color to set for the ROI line in hexadecimal format.
  ///
  /// Example usage:
  /// ```dart
  /// String lineColor = '#00FF00'; // Green color
  /// _barkoder.setRoiLineColor(lineColor);
  /// print('ROI line color set to: $lineColor');
  /// ```
  Future<void> setRoiLineColor(String hexColor) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setRoiLineColor', hexColor);
  }

  /// Retrieves the current width setting for the lines outlining the Region of Interest (ROI) on the camera preview.
  ///
  /// Returns a [Future] that completes with the width of the ROI line.
  ///
  /// Example usage:
  /// ```dart
  /// double lineWidth = await _barkoder.getRoiLineWidth();
  /// print('ROI line width: $lineWidth');
  /// ```
  Future<double> get getRoiLineWidth async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getRoiLineWidth');
  }

  /// Sets the width of the region of interest (ROI) line.
  ///
  /// [lineWidth]: The width to set for the ROI line.
  ///
  /// Example usage:
  /// ```dart
  /// double lineWidth = 2.0;
  /// _barkoder.setRoiLineWidth(lineWidth);
  /// print('ROI line width set to: $lineWidth');
  /// ```
  Future<void> setRoiLineWidth(double lineWidth) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setRoiLineWidth', lineWidth);
  }

  /// Retrieves the hexadecimal color code representing the background color of the overlay within the Region of Interest (ROI) on the camera preview.
  ///
  /// Returns a [Future] that completes with the background color of the ROI overlay in hexadecimal format.
  ///
  /// Example usage:
  /// ```dart
  /// String backgroundColor = await _barkoder.getRoiOverlayBackgroundColorHex();
  /// print('ROI overlay background color: $backgroundColor');
  /// ```
  Future<String> get getRoiOverlayBackgroundColorHex async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getRoiOverlayBackgroundColorHex');
  }

  /// Sets the background color of the overlay within the Region of Interest (ROI) for barcode scanning on the camera feed.
  ///
  /// [hexColor]: The color to set for the ROI overlay background in hexadecimal format.
  ///
  /// Example usage:
  /// ```dart
  /// String backgroundColor = '#FFA500'; // Orange color
  /// _barkoder.setRoiOverlayBackgroundColor(backgroundColor);
  /// print('ROI overlay background color set to: $backgroundColor');
  /// ```
  Future<void> setRoiOverlayBackgroundColor(String hexColor) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setRoiOverlayBackgroundColor', hexColor);
  }

  /// Checks if the session is closed on result enabled.
  ///
  /// Returns a [Future] that completes with a boolean indicating whether the session is closed on result enabled.
  ///
  /// Example usage:
  /// ```dart
  /// bool closeSessionEnabled = await _barkoder.isCloseSessionOnResultEnabled;
  /// print('Close session on result enabled: $closeSessionEnabled');
  /// ```
  Future<bool> get isCloseSessionOnResultEnabled async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('isCloseSessionOnResultEnabled');
  }

  /// Enables or disables the automatic closing of the scanning session upon detecting a barcode result.
  ///
  /// [enabled]: A boolean indicating whether to enable closing the session on result.
  ///
  /// Example usage:
  /// ```dart
  /// bool closeSessionEnabled = true;
  /// _barkoder.setCloseSessionOnResultEnabled(closeSessionEnabled);
  /// print('Close session on result enabled: $closeSessionEnabled');
  /// ```
  Future<void> setCloseSessionOnResultEnabled(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setCloseSessionOnResultEnabled', enabled);
  }

  /// Checks if image result is enabled.
  ///
  /// Returns a [Future] that completes with a boolean indicating whether image result is enabled.
  ///
  /// Example usage:
  /// ```dart
  /// bool imageResultEnabled = await _barkoder.isImageResultEnabled;
  /// print('Image result enabled: $imageResultEnabled');
  /// ```
  Future<bool> get isImageResultEnabled async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('isImageResultEnabled');
  }

  /// Enables or disables the capturing and processing of image data when a barcode is successfully detected.
  ///
  /// [enabled]: A boolean indicating whether to enable image result.
  ///
  /// Example usage:
  /// ```dart
  /// bool imageResultEnabled = true;
  /// _barkoder.setImageResultEnabled(imageResultEnabled);
  /// print('Image result enabled: $imageResultEnabled');
  /// ```
  Future<void> setImageResultEnabled(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setImageResultEnabled', enabled);
  }

  /// Checks if location in image result is enabled.
  ///
  /// Returns a [Future] that completes with a boolean indicating whether location in image result is enabled.
  ///
  /// Example usage:
  /// ```dart
  /// bool locationInImageResultEnabled = await _barkoder.isLocationInImageResultEnabled;
  /// print('Location in image result enabled: $locationInImageResultEnabled');
  /// ```
  Future<bool> get isLocationInImageResultEnabled async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('isLocationInImageResultEnabled');
  }

  /// Enables or disables the inclusion of barcode location information within the image data result.
  ///
  /// [enabled]: A boolean indicating whether to enable location in image result.
  ///
  /// Example usage:
  /// ```dart
  /// bool locationInImageResultEnabled = true;
  /// _barkoder.setLocationInImageResultEnabled(locationInImageResultEnabled);
  /// print('Location in image result enabled: $locationInImageResultEnabled');
  /// ```
  Future<void> setLocationInImageResultEnabled(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setLocationInImageResultEnabled', enabled);
  }

  /// Retrieves the region of interest (ROI).
  ///
  /// Returns a [Future] that completes with a list of doubles representing the region of interest [left, top, width, height].
  ///
  /// Example usage:
  /// ```dart
  /// List<double> roi = await _barkoder.getRegionOfInterest;
  /// print('Region of interest: $roi');
  /// ```
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

  /// Defines the Region of Interest (ROI) on the camera preview for barcode scanning, specifying an area where the application focuses on detecting barcodes.
  ///
  /// [left]: The left coordinate of the ROI.
  /// [top]: The top coordinate of the ROI.
  /// [width]: The width of the ROI in percentage.
  /// [height]: The height of the ROI in percentage.
  ///
  /// Example usage:
  /// ```dart
  /// double left = 10.0;
  /// double top = 10.0;
  /// double width = 80.0;
  /// double height = 8.0;
  /// _barkoder.setRegionOfInterest(left, top, width, height);
  /// print('Region of interest set');
  /// ```
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

  /// Retrieves the threads limit.
  ///
  /// Returns a [Future] that completes with an integer representing the threads limit.
  ///
  /// Example usage:
  /// ```dart
  /// int threadsLimit = await _barkoder.getThreadsLimit;
  /// print('Threads limit: $threadsLimit');
  /// ```
  Future<int> get getThreadsLimit async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getThreadsLimit');
  }

  /// Sets the threads limit.
  ///
  /// [threadsLimit]: The number of threads to set as the limit.
  ///
  /// Example usage:
  /// ```dart
  /// int threadsLimit = 2;
  /// _barkoder.setThreadsLimit(threadsLimit);
  /// print('Threads limit set to: $threadsLimit');
  /// ```
  Future<void> setThreadsLimit(int threadsLimit) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setThreadsLimit', threadsLimit);
  }

  /// Checks if location in preview is enabled.
  ///
  /// Returns a [Future] that completes with a boolean indicating whether location in preview is enabled.
  ///
  /// Example usage:
  /// ```dart
  /// bool locationInPreviewEnabled = await _barkoder.isLocationInPreviewEnabled;
  /// print('Location in preview enabled: $locationInPreviewEnabled');
  /// ```
  Future<bool> get isLocationInPreviewEnabled async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('isLocationInPreviewEnabled');
  }

  /// Enables or disables the display of barcode location information on the camera preview.
  ///
  /// [enabled]: A boolean indicating whether to enable location in preview.
  ///
  /// Example usage:
  /// ```dart
  /// bool locationInPreviewEnabled = true;
  /// _barkoder.setLocationInPreviewEnabled(locationInPreviewEnabled);
  /// print('Location in preview enabled: $locationInPreviewEnabled');
  /// ```
  Future<void> setLocationInPreviewEnabled(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setLocationInPreviewEnabled', enabled);
  }

  /// Checks if pinch to zoom is enabled.
  ///
  /// Returns a [Future] that completes with a boolean indicating whether pinch to zoom is enabled.
  ///
  /// Example usage:
  /// ```dart
  /// bool pinchToZoomEnabled = await _barkoder.isPinchToZoomEnabled;
  /// print('Pinch to zoom enabled: $pinchToZoomEnabled');
  /// ```
  Future<bool> get isPinchToZoomEnabled async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('isPinchToZoomEnabled');
  }

  /// Enables or disables the pinch-to-zoom feature for adjusting the zoom level during barcode scanning.
  ///
  /// [enabled]: A boolean indicating whether to enable pinch to zoom.
  ///
  /// Example usage:
  /// ```dart
  /// bool pinchToZoomEnabled = true;
  /// _barkoder.setPinchToZoomEnabled(pinchToZoomEnabled);
  /// print('Pinch to zoom enabled: $pinchToZoomEnabled');
  /// ```
  Future<void> setPinchToZoomEnabled(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setPinchToZoomEnabled', enabled);
  }

  /// Checks if the region of interest (ROI) is visible.
  ///
  /// Returns a [Future] that completes with a boolean indicating whether the ROI is visible.
  ///
  /// Example usage:
  /// ```dart
  /// bool roiVisible = await _barkoder.isRegionOfInterestVisible;
  /// print('Region of interest visible: $roiVisible');
  /// ```
  Future<bool> get isRegionOfInterestVisible async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('isRegionOfInterestVisible');
  }

  /// Sets the visibility of the Region of Interest (ROI) on the camera preview.
  ///
  /// [visible]: A boolean indicating whether to make the ROI visible.
  ///
  /// Example usage:
  /// ```dart
  /// bool roiVisible = true;
  /// await _barkoder.setRegionOfInterestVisible(roiVisible);
  /// print('Region of interest set to visible: $roiVisible');
  /// ```
  Future<void> setRegionOfInterestVisible(bool visible) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setRegionOfInterestVisible', visible);
  }

  /// Retrieves the resolution for barcode scanning.
  ///
  /// Returns a [Future] that completes with a BarkoderResolution enum value.
  ///
  /// Example usage:
  /// ```dart
  /// BarkoderResolution resolution = await _barkoder.getBarkoderResolution;
  /// print('Barkoder resolution: $resolution');
  /// ```
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

  /// Sets the resolution for barcode scanning.
  ///
  /// [resolution]: The BarkoderResolution enum value to set.
  ///
  /// Example usage:
  /// ```dart
  /// BarkoderResolution resolution = BarkoderResolution.HIGH;
  /// await _barkoder.setBarkoderResolution(resolution);
  /// print('Barkoder resolution set to: $resolution');
  /// ```
  Future<void> setBarkoderResolution(BarkoderResolution resolution) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setBarkoderResolution', resolution.index);
  }

  /// Retrieves the value indicating whether a beep sound is played on successful barcode scanning.
  ///
  /// Returns a [Future] that completes with a boolean indicating whether beep on success is enabled.
  ///
  /// Example usage:
  /// ```dart
  /// bool beepOnSuccessEnabled = await _barkoder.isBeepOnSuccessEnabled;
  /// print('Beep on success enabled: $beepOnSuccessEnabled');
  /// ```
  Future<bool> get isBeepOnSuccessEnabled async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('isBeepOnSuccessEnabled');
  }

  /// Enables or disables the audible beep sound upon successfully decoding a barcode.
  ///
  /// [enabled]: A boolean indicating whether to enable beep on success.
  ///
  /// Example usage:
  /// ```dart
  /// bool beepOnSuccessEnabled = true;
  /// await _barkoder.setBeepOnSuccessEnabled(beepOnSuccessEnabled);
  /// print('Beep on success enabled: $beepOnSuccessEnabled');
  /// ```
  Future<void> setBeepOnSuccessEnabled(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setBeepOnSuccessEnabled', enabled);
  }

  /// Retrieves the value indicating whether vibration is enabled on successful barcode scanning.
  ///
  /// Returns a [Future] that completes with a boolean indicating whether vibrate on success is enabled.
  ///
  /// Example usage:
  /// ```dart
  /// bool vibrateOnSuccessEnabled = await _barkoder.isVibrateOnSuccessEnabled;
  /// print('Vibrate on success enabled: $vibrateOnSuccessEnabled');
  /// ```
  Future<bool> get isVibrateOnSuccessEnabled async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('isVibrateOnSuccessEnabled');
  }

  /// Enables or disables the device vibration upon successfully decoding a barcode..
  ///
  /// [enabled]: A boolean indicating whether to enable vibrate on success.
  ///
  /// Example usage:
  /// ```dart
  /// bool vibrateOnSuccessEnabled = true;
  /// await _barkoder.setVibrateOnSuccessEnabled(vibrateOnSuccessEnabled);
  /// print('Vibrate on success enabled: $vibrateOnSuccessEnabled');
  /// ```
  Future<void> setVibrateOnSuccessEnabled(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setVibrateOnSuccessEnabled', enabled);
  }

  /// Sets whether to show log messages.
  ///
  /// [show]: A boolean indicating whether to show log messages.
  ///
  /// Example usage:
  /// ```dart
  /// bool showLogs = true;
  /// _barkoder.showLogMessages(showLogs);
  /// print('Log messages visibility set to: $showLogs');
  /// ```
  Future<void> showLogMessages(bool show) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('showLogMessages', show);
  }

  /// Retrieves whether multi-code caching is enabled.
  ///
  /// Returns a [Future] that completes with a boolean indicating whether multicode caching is enabled.
  ///
  /// Example usage:
  /// ```dart
  /// bool multicodeCachingEnabled = await _barkoder.getMulticodeCachingEnabled;
  /// print('Multicode caching enabled: $multicodeCachingEnabled');
  /// ```
  Future<bool> get getMulticodeCachingEnabled async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getMulticodeCachingEnabled');
  }

  /// Sets whether multi-code caching is enabled.
  ///
  /// [enabled]: A boolean indicating whether to enable multicode caching.
  ///
  /// Example usage:
  /// ```dart
  /// bool multicodeCachingEnabled = true;
  /// await _barkoder.setMulticodeCachingEnabled(multicodeCachingEnabled);
  /// print('Multicode caching enabled: $multicodeCachingEnabled');
  /// ```
  Future<void> setMulticodeCachingEnabled(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setMulticodeCachingEnabled', enabled);
  }

  /// Retrieves the caching duration (in milliseconds) for multi-code results.
  ///
  /// Returns a [Future] that completes with an integer representing the multicode caching duration in milliseconds.
  ///
  /// Example usage:
  /// ```dart
  /// int cachingDuration = await _barkoder.getMulticodeCachingDuration;
  /// print('Multicode caching duration: $cachingDuration');
  /// ```
  Future<int> get getMulticodeCachingDuration async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getMulticodeCachingDuration');
  }

  /// Sets the caching duration (in milliseconds) for multi-code results.
  ///
  /// [multicodeCachingDuration]: An integer representing the multicode caching duration in milliseconds.
  ///
  /// Example usage:
  /// ```dart
  /// int cachingDuration = 5000; // 5 seconds
  /// await _barkoder.setMulticodeCachingDuration(cachingDuration);
  /// print('Multicode caching duration set to: $cachingDuration');
  /// ```
  Future<void> setMulticodeCachingDuration(int multicodeCachingDuration) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setMulticodeCachingDuration', multicodeCachingDuration);
  }

  /// Sets whether to enable barcode thumbnail on result.
  ///
  /// [enabled]: A boolean indicating whether to enable barcode thumbnail on result.
  ///
  /// Example usage:
  /// ```dart
  /// bool thumbnailEnabled = true;
  /// await _barkoder.setBarcodeThumbnailOnResultEnabled(thumbnailEnabled);
  /// print('Barcode thumbnail on result enabled: $thumbnailEnabled');
  /// ```
  Future<void> setBarcodeThumbnailOnResultEnabled(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setBarcodeThumbnailOnResultEnabled', enabled);
  }

  /// Checks if the barcode thumbnail on result is enabled.
  ///
  /// Returns a [Future] that completes with a boolean indicating whether barcode thumbnail on result is enabled.
  ///
  /// Example usage:
  /// ```dart
  /// bool thumbnailEnabled = await _barkoder.isBarcodeThumbnailOnResultEnabled;
  /// print('Barcode thumbnail on result enabled: $thumbnailEnabled');
  /// ```
  Future<bool> get isBarcodeThumbnailOnResultEnabled async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel
        .invokeMethod('isBarcodeThumbnailOnResultEnabled');
  }

  /// Sets the threshold between duplicate scans.
  ///
  /// [thresholdBetweenDuplicatesScans]: An integer representing the threshold in seconds between duplicate scans.
  ///
  /// Example usage:
  /// ```dart
  /// int threshold = 1; // 100 milliseconds
  /// _barkoder.setThresholdBetweenDuplicatesScans(threshold);
  /// print('Threshold between duplicate scans set to: $threshold milliseconds');
  /// ```
  Future<void> setThresholdBetweenDuplicatesScans(
      int thresholdBetweenDuplicatesScans) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setThresholdBetweenDuplicatesScans', thresholdBetweenDuplicatesScans);
  }

  /// Retrieves the threshold between duplicate scans.
  ///
  /// Returns a [Future] that completes with an integer representing the threshold between duplicate scans.
  ///
  /// Example usage:
  /// ```dart
  /// int threshold = await _barkoder.getThresholdBetweenDuplicatesScans;
  /// print('Threshold between duplicate scans: $threshold milliseconds');
  /// ```
  Future<int> get getThresholdBetweenDuplicatesScans async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel
        .invokeMethod('getThresholdBetweenDuplicatesScans');
  }

//endregion BarkoderConfig APIs

//region Barkoder APIs

  /// Checks if a specific barcode type is enabled.
  ///
  /// [type]: The BarcodeType to check.
  ///
  /// Returns a [Future] that completes with a boolean indicating whether the specified barcode type is enabled.
  ///
  /// Example usage:
  /// ```dart
  /// BarcodeType type = BarcodeType.code128;
  /// bool isEnabled = await _barkoder.isBarcodeTypeEnabled(type);
  /// print('Barcode type $type is enabled: $isEnabled');
  /// ```
  Future<bool> isBarcodeTypeEnabled(BarcodeType type) async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod(
        'isBarcodeTypeEnabled', type.index);
  }

  /// Sets whether a specific barcode type is enabled.
  ///
  /// [type]: The BarcodeType to enable or disable.
  /// [enabled]: A boolean indicating whether to enable or disable the specified barcode type.
  ///
  /// Example usage:
  /// ```dart
  /// BarcodeType type = BarcodeType.code128;
  /// bool isEnabled = true;
  /// _barkoder.setBarcodeTypeEnabled(type, isEnabled);
  /// print('Barcode type $type set to enabled: $isEnabled');
  /// ```
  Future<void> setBarcodeTypeEnabled(BarcodeType type, bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setBarcodeTypeEnabled', {'type': type.index, 'enabled': enabled});
  }

  /// Retrieves the length range of a specific barcode type.
  ///
  /// [type]: The BarcodeType to retrieve the length range for.
  ///
  /// Returns a [Future] that completes with a List<int> representing the minimum and maximum length of the specified barcode type.
  ///
  /// Example usage:
  /// ```dart
  /// BarcodeType type = BarcodeType.code128;
  /// List<int> lengthRange = await _barkoder.getBarcodeTypeLengthRange(type);
  /// print('Length range of barcode type $type: $lengthRange');
  /// ```
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

  /// Sets the length range for the specified barcode type.
  ///
  /// [type]: The BarcodeType to set the length range for.
  /// [min]: The minimum length for the barcode type.
  /// [max]: The maximum length for the barcode type.
  ///
  /// Example usage:
  /// ```dart
  /// BarcodeType type = BarcodeType.code128;
  /// int minLength = 6;
  /// int maxLength = 20;
  /// await _barkoder.setBarcodeTypeLengthRange(type, minLength, maxLength);
  /// print('Length range set for barcode type $type: min=$minLength, max=$maxLength');
  /// ```
  Future<void> setBarcodeTypeLengthRange(BarcodeType type, int min, int max) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setBarcodeTypeLengthRange',
        {'type': type.index, 'min': min, 'max': max});
  }

  /// Retrieves the MSI checksum type.
  ///
  /// Returns a [Future] that completes with a MsiChecksumType enum value representing the checksum type used for MSI barcodes.
  ///
  /// Example usage:
  /// ```dart
  /// MsiChecksumType checksumType = await _barkoder.getMsiChecksumType;
  /// print('MSI checksum type: $checksumType');
  /// ```
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

  /// Sets the MSI checksum type.
  ///
  /// [checksumType]: The MsiChecksumType to set.
  ///
  /// Example usage:
  /// ```dart
  /// MsiChecksumType checksumType = MsiChecksumType.mod10;
  /// await _barkoder.setMsiChecksumType(checksumType);
  /// print('MSI checksum type set to: $checksumType');
  /// ```
  Future<void> setMsiChecksumType(MsiChecksumType checksumType) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setMsiChecksumType', checksumType.index);
  }

  /// Retrieves the checksum type for Code 39 barcodes.
  ///
  /// Returns a [Future] that completes with a Code39ChecksumType enum value representing the checksum type used for Code39 barcodes.
  ///
  /// Example usage:
  /// ```dart
  /// Code39ChecksumType checksumType = await _barkoder.getCode39ChecksumType;
  /// print('Code39 checksum type: $checksumType');
  /// ```
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

  /// Sets the Code39 checksum type.
  ///
  /// [checksumType]: The Code39ChecksumType to set.
  ///
  /// Example usage:
  /// ```dart
  /// Code39ChecksumType checksumType = Code39ChecksumType.enabled;
  /// _barkoder.setCode39ChecksumType(checksumType);
  /// print('Code39 checksum type set to: $checksumType');
  /// ```
  Future<void> setCode39ChecksumType(Code39ChecksumType checksumType) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setCode39ChecksumType', checksumType.index);
  }

  /// Retrieves the Code11 checksum type.
  ///
  /// Returns a [Future] that completes with a Code11ChecksumType enum value representing the checksum type used for Code11 barcodes.
  ///
  /// Example usage:
  /// ```dart
  /// Code11ChecksumType checksumType = await _barkoder.getCode11ChecksumType;
  /// print('Code11 checksum type: $checksumType');
  /// ```
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

  /// Sets the Code11 checksum type.
  ///
  /// [checksumType]: The Code11ChecksumType to set.
  ///
  /// Example usage:
  /// ```dart
  /// Code11ChecksumType checksumType = Code11ChecksumType.single;
  /// await _barkoder.setCode11ChecksumType(checksumType);
  /// print('Code11 checksum type set to: $checksumType');
  /// ```
  Future<void> setCode11ChecksumType(Code11ChecksumType checksumType) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setCode11ChecksumType', checksumType.index);
  }

  /// Retrieves the character set used for encoding barcode data.
  ///
  /// Returns a [Future] that completes with a String representing the encoding character set.
  ///
  /// Example usage:
  /// ```dart
  /// String characterSet = await _barkoder.getEncodingCharacterSet;
  /// print('Encoding character set: $characterSet');
  /// ```
  Future<String> get getEncodingCharacterSet async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getEncodingCharacterSet');
  }

  /// Sets the encoding character set for barcode scanning.
  ///
  /// [characterSet]: The encoding character set to set.
  ///
  /// Example usage:
  /// ```dart
  /// String characterSet = 'utf-8';
  /// _barkoder.setEncodingCharacterSet(characterSet);
  /// print('Encoding character set set to: $characterSet');
  /// ```
  Future<void> setEncodingCharacterSet(String characterSet) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setEncodingCharacterSet', characterSet);
  }

  /// Retrieves the current decoding speed setting for barcode scanning.
  ///
  /// Returns a [Future] that completes with a DecodingSpeed enum value representing the decoding speed.
  ///
  /// Example usage:
  /// ```dart
  /// DecodingSpeed speed = await _barkoder.getDecodingSpeed;
  /// print('Decoding speed: $speed');
  /// ```
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

  /// Sets the decoding speed for barcode scanning.
  ///
  /// [decodingSpeed]: The DecodingSpeed to set.
  ///
  /// Example usage:
  /// ```dart
  /// DecodingSpeed speed = DecodingSpeed.fast;
  /// _barkoder.setDecodingSpeed(speed);
  /// print('Decoding speed set to: $speed');
  /// ```
  Future<void> setDecodingSpeed(DecodingSpeed decodingSpeed) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setDecodingSpeed', decodingSpeed.index);
  }

  /// Retrieves the formatting type used for presenting decoded barcode data.
  ///
  /// Returns a [Future] that completes with a FormattingType enum value representing the formatting type.
  ///
  /// Example usage:
  /// ```dart
  /// FormattingType type = await _barkoder.getFormattingType;
  /// print('Formatting type: $type');
  /// ```
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

  /// Sets the formatting type for barcode scanning.
  ///
  /// [formattingType]: The FormattingType to set.
  ///
  /// Example usage:
  /// ```dart
  /// FormattingType type = FormattingType.gs1;
  /// _barkoder.setFormattingType(type);
  /// print('Formatting type set to: $type');
  /// ```
  Future<void> setFormattingType(FormattingType formattingType) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setFormattingType', formattingType.index);
  }

  /// Retrieves the version of the Barkoder library.
  ///
  /// Returns a [Future] that completes with a String representing the version of the Barkoder library.
  ///
  /// Example usage:
  /// ```dart
  /// String version = await _barkoder.getVersion;
  /// print('Barkoder library version: $version');
  /// ```
  Future<String> get getVersion async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getVersion');
  }

  /// Retrieves the value indicating whether deblurring is enabled for UPC/EAN barcodes.
  ///
  /// Returns a [Future] that completes with a boolean indicating whether UPC/EAN deblur is enabled.
  ///
  /// Example usage:
  /// ```dart
  /// bool isEnabled = await _barkoder.isUpcEanDeblurEnabled;
  /// print('UPC/EAN deblur enabled: $isEnabled');
  /// ```
  Future<bool> get isUpcEanDeblurEnabled async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('isUpcEanDeblurEnabled');
  }

  /// Sets whether the deblurring feature for UPC/EAN barcodes is enabled.
  ///
  /// [enabled]: A boolean indicating whether to enable or disable UPC/EAN deblur.
  ///
  /// Example usage:
  /// ```dart
  /// bool isEnabled = true;
  /// await _barkoder.setUpcEanDeblurEnabled(isEnabled);
  /// print('UPC/EAN deblur enabled set to: $isEnabled');
  /// ```
  Future<void> setUpcEanDeblurEnabled(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setUpcEanDeblurEnabled', enabled);
  }

  /// Sets the maximum number of results to be returned from barcode scanning.
  ///
  /// [maximumResultsCount]: The maximum number of results to be returned.
  ///
  /// Example usage:
  /// ```dart
  /// int maxResults = 10;
  /// await _barkoder.setMaximumResultsCount(maxResults);
  /// print('Maximum results count set to: $maxResults');
  /// ```
  Future<void> setMaximumResultsCount(int maximumResultsCount) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setMaximumResultsCount', maximumResultsCount);
  }

  /// Retrieves the maximum number of results to be returned from barcode scanning at once.
  ///
  /// Returns a [Future] that completes with a double representing the maximum number of results to be returned.
  ///
  /// Example usage:
  /// ```dart
  /// double maxResults = await _barkoder.getMaximumResultsCount;
  /// print('Maximum results count: $maxResults');
  /// ```
  Future<double> get getMaximumResultsCount async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getMaximumResultsCount');
  }

  /// Checks if the detection of misshaped 1D barcodes is enabled.
  ///
  /// Returns a [Future] that completes with a boolean indicating whether misshaped 1D barcodes are enabled.
  ///
  /// Example usage:
  /// ```dart
  /// bool isEnabled = await _barkoder.isMisshaped1DEnabled;
  /// print('Misshaped 1D barcodes enabled: $isEnabled');
  /// ```
  Future<bool> get isMisshaped1DEnabled async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('isMisshaped1DEnabled');
  }

  /// Sets the delay in milliseconds for considering duplicate barcodes during scanning.
  ///
  /// [duplicatesDelayMs]: The delay in milliseconds for detecting duplicate scans.
  ///
  /// Example usage:
  /// ```dart
  /// int delayMs = 500; // 500 milliseconds
  /// _barkoder.setDuplicatesDelayMs(delayMs);
  /// print('Duplicates detection delay set to: $delayMs milliseconds');
  /// ```
  Future<void> setDuplicatesDelayMs(int duplicatesDelayMs) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod(
        'setDuplicatesDelayMs', duplicatesDelayMs);
  }

  /// Sets whether the detection of misshaped 1D barcodes is enabled.
  ///
  /// [enabled]: A boolean indicating whether to enable or disable misshaped 1D barcodes.
  ///
  /// Example usage:
  /// ```dart
  /// bool isEnabled = true;
  /// _barkoder.setMisshaped1DEnabled(isEnabled);
  /// print('Misshaped 1D barcodes enabled set to: $isEnabled');
  /// ```
  Future<void> setMisshaped1DEnabled(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setMisshaped1DEnabled', enabled);
  }

  /// Retrieves the delay in milliseconds for considering duplicate barcodes during scanning.
  ///
  /// Returns a [Future] that completes with an integer representing the delay in milliseconds for detecting duplicate scans.
  ///
  /// Example usage:
  /// ```dart
  /// int delayMs = await _barkoder.getDuplicatesDelayMs;
  /// print('Duplicates detection delay: $delayMs milliseconds');
  /// ```
  Future<int> get getDuplicatesDelayMs async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('getDuplicatesDelayMs');
  }

  /// Sets whether Vehicle Identification Number (VIN) restrictions are enabled.
  ///
  /// [enabled]: A boolean indicating whether to enable or disable VIN restrictions.
  ///
  /// Example usage:
  /// ```dart
  /// bool isEnabled = true;
  /// _barkoder.setEnableVINRestrictions(isEnabled);
  /// print('VIN restrictions enabled set to: $isEnabled');
  /// ```
  Future<void> setEnableVINRestrictions(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setEnableVINRestrictions', enabled);
  }

  /// Checks if VIN restrictions are enabled.
  ///
  /// Returns a [Future] that completes with a boolean indicating whether VIN restrictions are enabled.
  ///
  /// Example usage:
  /// ```dart
  /// bool isEnabled = await _barkoder.isVINRestrictionsEnabled;
  /// print('VIN restrictions enabled: $isEnabled');
  /// ```
  Future<bool> get isVINRestrictionsEnabled async {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return await _methodChannel.invokeMethod('isVINRestrictionsEnabled');
  }

  /// Sets whether the Direct Part Marking (DPM) mode for Datamatrix barcodes is enabled.
  Future<void> setDatamatrixDpmModeEnabled(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setDatamatrixDpmModeEnabled', enabled);
  }

  Future<void> setEnableMisshaped1DEnabled(bool enabled) {
    if (_isBarkoderViewNotMounted) {
      return Future.error(PlatformException(
          code: BarkoderErrors.barkoderViewNotMounted,
          message: BarkoderErrors.barkodeViewNotMountedDesc));
    }

    return _methodChannel.invokeMethod('setEnableMisshaped1DEnabled', enabled);
  }

  /// Configures the Barkoder functionality based on the provided configuration.
  ///
  /// [barkoderConfig]: The BarkoderConfig object containing the configuration settings.
  ///
  /// Example usage:
  /// ```dart
  /// BarkoderConfig config = BarkoderConfig(
  ///   pinchToZoomEnabled: true,
  ///   beepOnSuccessEnabled: true,
  ///   // Add other configuration settings here
  /// );
  /// _barkoder.configureBarkoder(config);
  /// print('Barkoder configured successfully.');
  /// ```
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

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'barkoder_flutter.dart';

class BarkoderView extends StatelessWidget {
  final String licenseKey;
  final void Function(Barkoder) onBarkoderViewCreated;

  const BarkoderView(
      {super.key,
      required this.licenseKey,
      required this.onBarkoderViewCreated});

  @override
  Widget build(BuildContext context) {
    final inputParams = {"licenseKey": licenseKey};
    const paramsDecoder = StandardMessageCodec();
    final Barkoder barkoder = Barkoder();

    const String viewTypeId = "BarkoderNativeView";

    if (Platform.isIOS) {
      return UiKitView(
          viewType: viewTypeId,
          layoutDirection: TextDirection.ltr,
          creationParams: inputParams,
          creationParamsCodec: paramsDecoder,
          onPlatformViewCreated: (id) =>
              {onBarkoderViewCreated.call(barkoder)});
    } else {
      return PlatformViewLink(
        viewType: viewTypeId,
        surfaceFactory: (context, controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (params) {
          return PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: viewTypeId,
            layoutDirection: TextDirection.ltr,
            creationParams: inputParams,
            creationParamsCodec: paramsDecoder,
            onFocus: () {
              params.onFocusChanged(true);
            },
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..addOnPlatformViewCreatedListener(
                (id) => onBarkoderViewCreated.call(barkoder))
            ..create();
        },
      );
    }
  }
}

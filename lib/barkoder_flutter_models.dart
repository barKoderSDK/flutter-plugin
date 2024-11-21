import 'dart:convert';
import 'dart:typed_data';

class BarkoderResult {
  List<DecoderResult> decoderResults;
  List<Uint8List>? resultThumbnails;
  Uint8List? resultImage;

  BarkoderResult({
    required this.decoderResults,
    this.resultThumbnails,
    this.resultImage,
  });

  factory BarkoderResult.fromJson(Map<String, dynamic> json) {
    List<DecoderResult> decoderResults = (json['decoderResults'] as List)
        .map((result) => DecoderResult.fromJson(result))
        .toList();
    return BarkoderResult(
      decoderResults: decoderResults,
      resultThumbnails: json['resultThumbnailsAsBase64'] != null
          ? (json['resultThumbnailsAsBase64'] as List<dynamic>)
              .map((thumbnail) => Base64Decoder().convert(thumbnail))
              .toList()
          : null,
      resultImage: json['resultImageAsBase64'] != null
          ? Base64Decoder().convert(json['resultImageAsBase64'])
          : null,
    );
  }

  @override
  String toString() {
    return '{$decoderResults, $resultThumbnails, $resultImage}';
  }
}

class DecoderResult {
  late int barcodeType;
  late String barcodeTypeName;
  late String binaryDataAsBase64;
  late String textualData;
  String? characterSet;
  Map<String, dynamic>? extra;
  List<MRZImage>? mrzImages;

  DecoderResult({
    required this.barcodeType,
    required this.barcodeTypeName,
    required this.binaryDataAsBase64,
    required this.textualData,
    this.characterSet,
    this.extra,
    this.mrzImages,
  });

  DecoderResult.fromJson(Map<String, dynamic> resultMap) {
    barcodeType = resultMap['barcodeType'];
    barcodeTypeName = resultMap['barcodeTypeName'];
    binaryDataAsBase64 = resultMap['binaryDataAsBase64'];
    textualData = resultMap['textualData'];
    characterSet = resultMap['characterSet'];
    if (resultMap.containsKey('extra')) extra = json.decode(resultMap['extra']);
    if (resultMap.containsKey('mrzImagesAsBase64')) {
      mrzImages = (resultMap['mrzImagesAsBase64'] as List<dynamic>)
          .map((imageData) => MRZImage.fromJson(imageData))
          .toList();
    }
  }

  static List<DecoderResult> fromJsonString(String jsonString) {
    List<dynamic> resultList = json.decode(jsonString);
    return resultList
        .map((resultMap) => DecoderResult.fromJson(resultMap))
        .toList();
  }

  @override
  String toString() {
    return '{$barcodeType, $barcodeTypeName, $binaryDataAsBase64, $textualData, $characterSet, $extra, $mrzImages';
  }
}

class MRZImage {
  final String name;
  final Uint8List value;

  MRZImage({required this.name, required this.value});

  factory MRZImage.fromJson(Map<String, dynamic> json) {
    return MRZImage(
      name: json['name'] as String,
      value: base64Decode(json['base64'] as String),
    );
  }
}

enum BarcodeType {
  aztec,
  aztecCompact,
  qr,
  qrMicro,
  code128,
  code93,
  code39,
  codabar,
  code11,
  msi,
  upcA,
  upcE,
  upcE1,
  ean13,
  ean8,
  pdf417,
  pdf417Micro,
  datamatrix,
  code25,
  interleaved25,
  itf14,
  iata25,
  matrix25,
  datalogic25,
  coop25,
  code32,
  telepen,
  dotcode,
  idDocument;
}

enum FormattingType { disabled, automatic, gs1, aamva }

enum MsiChecksumType {
  disabled,
  mod10,
  mod11,
  mod1010,
  mod1110,
  mod11IBM,
  mod1110IBM
}

enum Code39ChecksumType { disabled, enabled }

enum Code11ChecksumType { disabled, single, double }

enum DecodingSpeed { fast, normal, slow, rigorous }

enum BarkoderResolution { normal, high }

class BarkoderErrors {
  static const String barkodeViewNotMountedDesc = "Barkoder is not mounted";
  static const String barkoderViewNotMounted = "0";
  static const String barkoderViewDestroyed = "1";
  static const String invalidResolution = "2";
  static const String threadsLimitNotSet = "3";
  static const String roiNotSet = "4";
  static const String colorNotSet = "5";
  static const String barcodeTypeNotFounded = "6";
  static const String barcodeTypeNotSupported = "7";
  static const String decodingSpeedNotFounded = "8";
  static const String formattingTypeNotFounded = "9";
  static const String lengthRangeNotValid = "10";
  static const String checksumTypeNotFounded = "11";
  static const String barkoderConfigIsNotValid = "12";
}

class BarkoderConfig {
  String? locationLineColor;
  double? locationLineWidth;
  String? roiLineColor;
  double? roiLineWidth;
  String? roiOverlayBackgroundColor;
  bool? closeSessionOnResultEnabled;
  bool? imageResultEnabled;
  bool? locationInImageResultEnabled;
  bool? locationInPreviewEnabled;
  bool? pinchToZoomEnabled;
  bool? regionOfInterestVisible;
  BarkoderResolution? barkoderResolution;
  bool? beepOnSuccessEnabled;
  bool? vibrateOnSuccessEnabled;
  bool? enableVINRestrictions;
  DekoderConfig? decoder;

  BarkoderConfig(
      {this.locationLineColor,
      this.locationLineWidth,
      this.roiLineColor,
      this.roiLineWidth,
      this.roiOverlayBackgroundColor,
      this.closeSessionOnResultEnabled,
      this.imageResultEnabled,
      this.locationInImageResultEnabled,
      this.locationInPreviewEnabled,
      this.pinchToZoomEnabled,
      this.regionOfInterestVisible,
      this.barkoderResolution,
      this.beepOnSuccessEnabled,
      this.vibrateOnSuccessEnabled,
      this.enableVINRestrictions,
      this.decoder});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> filteredConfigAsJson = {
      "locationLineColor": locationLineColor,
      "locationLineWidth": locationLineWidth,
      "roiLineColor": roiLineColor,
      "roiLineWidth": roiLineWidth,
      "roiOverlayBackgroundColor": roiOverlayBackgroundColor,
      "closeSessionOnResultEnabled": closeSessionOnResultEnabled,
      "imageResultEnabled": imageResultEnabled,
      "locationInImageResultEnabled": locationInImageResultEnabled,
      "locationInPreviewEnabled": locationInPreviewEnabled,
      "pinchToZoomEnabled": pinchToZoomEnabled,
      "regionOfInterestVisible": regionOfInterestVisible,
      "barkoderResolution": barkoderResolution?.index,
      "beepOnSuccessEnabled": beepOnSuccessEnabled,
      "vibrateOnSuccessEnabled": vibrateOnSuccessEnabled,
      "enableVINRestrictions": enableVINRestrictions,
      "decoder": decoder?.toMap()
    };

    filteredConfigAsJson.removeWhere((key, value) => value == null);

    return filteredConfigAsJson;
  }
}

class DekoderConfig {
  BarcodeConfig? aztec;
  BarcodeConfig? aztecCompact;
  BarcodeConfigWithDpmMode? qr;
  BarcodeConfigWithDpmMode? qrMicro;
  BarcodeConfigWithLength? code128;
  BarcodeConfigWithLength? code93;
  Code39BarcodeConfig? code39;
  BarcodeConfigWithLength? codabar;
  Code11BarcodeConfig? code11;
  MSIBarcodeConfig? msi;
  BarcodeConfig? upcA;
  BarcodeConfig? upcE;
  BarcodeConfig? upcE1;
  BarcodeConfig? ean13;
  BarcodeConfig? ean8;
  BarcodeConfig? pdf417;
  BarcodeConfig? pdf417Micro;
  BarcodeConfigWithDpmMode? datamatrix;
  BarcodeConfig? code25;
  BarcodeConfig? interleaved25;
  BarcodeConfig? itf14;
  BarcodeConfig? iata25;
  BarcodeConfig? matrix25;
  BarcodeConfig? datalogic25;
  BarcodeConfig? coop25;
  BarcodeConfig? code32;
  BarcodeConfig? telepen;
  BarcodeConfig? dotcode;
  IdDocumentBarcodeConfig? idDocument;
  GeneralSettings? general;

  DekoderConfig(
      {this.aztec,
      this.aztecCompact,
      this.qr,
      this.qrMicro,
      this.code128,
      this.code93,
      this.code39,
      this.codabar,
      this.code11,
      this.msi,
      this.upcA,
      this.upcE,
      this.upcE1,
      this.ean13,
      this.ean8,
      this.pdf417,
      this.pdf417Micro,
      this.datamatrix,
      this.code25,
      this.interleaved25,
      this.itf14,
      this.iata25,
      this.matrix25,
      this.datalogic25,
      this.coop25,
      this.code32,
      this.telepen,
      this.dotcode,
      this.idDocument,
      this.general});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> filteredMap = {
      'Aztec': aztec?.toMap(),
      'Aztec Compact': aztecCompact?.toMap(),
      'QR': qr?.toMap(),
      'QR Micro': qrMicro?.toMap(),
      'Code 128': code128?.toMap(),
      'Code 93': code93?.toMap(),
      'Code 39': code39?.toMap(),
      'Codabar': codabar?.toMap(),
      'Code 11': code11?.toMap(),
      'MSI': msi?.toMap(),
      'Upc-A': upcA?.toMap(),
      'Upc-E': upcE?.toMap(),
      'Upc-E1': upcE1?.toMap(),
      'Ean-13': ean13?.toMap(),
      'Ean-8': ean8?.toMap(),
      'PDF 417': pdf417?.toMap(),
      'PDF 417 Micro': pdf417Micro?.toMap(),
      'Datamatrix': datamatrix?.toMap(),
      'Code 25': code25?.toMap(),
      'Interleaved 2 of 5': interleaved25?.toMap(),
      'ITF 14': itf14?.toMap(),
      'IATA 25': iata25?.toMap(),
      'Matrix 25': matrix25?.toMap(),
      'Datalogic 25': datalogic25?.toMap(),
      'COOP 25': coop25?.toMap(),
      'Code 32': code32?.toMap(),
      'Telepen': telepen?.toMap(),
      'Dotcode': dotcode?.toMap(),
      'ID Document': idDocument?.toMap(),
      'general': general?.toMap()
    };

    filteredMap.removeWhere((key, value) => value == null);

    return filteredMap;
  }
}

class BarcodeConfig {
  bool? enabled;

  BarcodeConfig({this.enabled});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> filteredMap = {"enabled": enabled};

    filteredMap.removeWhere((key, value) => value == null);

    return filteredMap;
  }
}

class BarcodeConfigWithLength {
  bool? enabled;
  int? _minLength;
  int? _maxLength;

  BarcodeConfigWithLength({this.enabled});

  BarcodeConfigWithLength.setLengthRange(
      {this.enabled, required minLength, required maxLength})
      : _minLength = minLength,
        _maxLength = maxLength;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> filteredMap = {
      "enabled": enabled,
      "minimumLength": _minLength,
      "maximumLength": _maxLength
    };

    filteredMap.removeWhere((key, value) => value == null);

    return filteredMap;
  }

  setLengthRange(int minLength, int maxLength) {
    _minLength = minLength;
    _maxLength = maxLength;
  }
}

class MSIBarcodeConfig {
  bool? enabled;
  int? _minLength;
  int? _maxLength;
  MsiChecksumType? checksum;

  MSIBarcodeConfig({this.enabled, this.checksum});

  MSIBarcodeConfig.setLengthRange(
      {this.enabled, required minLength, required maxLength, this.checksum})
      : _minLength = minLength,
        _maxLength = maxLength;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> filteredMap = {
      "enabled": enabled,
      "minimumLength": _minLength,
      "maximumLength": _maxLength,
      "checksum": checksum?.index
    };

    filteredMap.removeWhere((key, value) => value == null);

    return filteredMap;
  }

  setLengthRange(int minLength, int maxLength) {
    _minLength = minLength;
    _maxLength = maxLength;
  }
}

class Code39BarcodeConfig {
  bool? enabled;
  int? _minLength;
  int? _maxLength;
  Code39ChecksumType? checksum;

  Code39BarcodeConfig({this.enabled, this.checksum});

  Code39BarcodeConfig.setLengthRange(
      {this.enabled, required minLength, required maxLength, this.checksum})
      : _minLength = minLength,
        _maxLength = maxLength;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> filteredMap = {
      "enabled": enabled,
      "minimumLength": _minLength,
      "maximumLength": _maxLength,
      "checksum": checksum?.index
    };

    filteredMap.removeWhere((key, value) => value == null);

    return filteredMap;
  }

  setLengthRange(int minLength, int maxLength) {
    _minLength = minLength;
    _maxLength = maxLength;
  }
}

class Code11BarcodeConfig {
  bool? enabled;
  int? _minLength;
  int? _maxLength;
  Code11ChecksumType? checksum;

  Code11BarcodeConfig({this.enabled, this.checksum});

  Code11BarcodeConfig.setLengthRange(
      {this.enabled, required minLength, required maxLength, this.checksum})
      : _minLength = minLength,
        _maxLength = maxLength;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> filteredMap = {
      "enabled": enabled,
      "minimumLength": _minLength,
      "maximumLength": _maxLength,
      "checksum": checksum?.index
    };

    filteredMap.removeWhere((key, value) => value == null);

    return filteredMap;
  }

  setLengthRange(int minLength, int maxLength) {
    _minLength = minLength;
    _maxLength = maxLength;
  }
}

class BarcodeConfigWithDpmMode {
  bool? enabled;
  int? dpmMode;
  int? _minLength;
  int? _maxLength;

  BarcodeConfigWithDpmMode({this.enabled, this.dpmMode});

  BarcodeConfigWithDpmMode.setLengthRange(
      {this.enabled, required minLength, required maxLength})
      : _minLength = minLength,
        _maxLength = maxLength;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> filteredMap = {
      "enabled": enabled,
      "minimumLength": _minLength,
      "maximumLength": _maxLength,
      "dpmMode": dpmMode
    };

    filteredMap.removeWhere((key, value) => value == null);

    return filteredMap;
  }

  setLengthRange(int minLength, int maxLength) {
    _minLength = minLength;
    _maxLength = maxLength;
  }
}

enum IdDocumentMasterChecksumType { disabled, enabled }

class IdDocumentBarcodeConfig {
  bool? enabled;
  IdDocumentMasterChecksumType? masterChecksum;

  IdDocumentBarcodeConfig({this.enabled, this.masterChecksum});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> filteredMap = {
      "enabled": enabled,
      "masterChecksum": masterChecksum?.index
    };

    filteredMap.removeWhere((key, value) => value == null);

    return filteredMap;
  }
}

class GeneralSettings {
  int? threadsLimit;
  DecodingSpeed? decodingSpeed;
  double? roiX;
  double? roiY;
  double? roiWidth;
  double? roiHeight;
  FormattingType? formattingType;
  String? encodingCharacterSet;
  int? maximumResultsCount;
  int? duplicatesDelayMs;
  int? multicodeCachingDuration;
  bool? multicodeCachingEnabled;

  GeneralSettings(
      {this.threadsLimit,
      this.decodingSpeed,
      this.roiX,
      this.roiY,
      this.roiWidth,
      this.roiHeight,
      this.formattingType,
      this.encodingCharacterSet,
      this.maximumResultsCount,
      this.duplicatesDelayMs,
      this.multicodeCachingDuration,
      this.multicodeCachingEnabled});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> filteredMap = {
      "maxThreads": threadsLimit,
      "decodingSpeed": decodingSpeed?.index,
      "roi_x": roiX,
      "roi_y": roiY,
      "roi_w": roiWidth,
      "roi_h": roiHeight,
      "formattingType": formattingType?.index,
      "encodingCharacterSet": encodingCharacterSet,
      "maximumResultsCount": maximumResultsCount,
      "duplicatesDelayMs": duplicatesDelayMs,
      "multicodeCachingDuration": multicodeCachingDuration,
      "multicodeCachingEnabled": multicodeCachingEnabled
    };

    filteredMap.removeWhere((key, value) => value == null);

    return filteredMap;
  }

  setROI(double x, double y, double width, double height) {
    roiX = x;
    roiY = y;
    roiWidth = width;
    roiHeight = height;
  }
}

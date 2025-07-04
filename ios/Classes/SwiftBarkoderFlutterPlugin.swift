import Flutter
import UIKit
import Foundation
import BarkoderSDK
import Barkoder

public class SwiftBarkoderFlutterPlugin: NSObject, FlutterPlugin {
        
    private static var VIEW_ID = "BarkoderNativeView"
        
    public static func register(with registrar: FlutterPluginRegistrar) {
        let viewFactory = BarkoderViewFactory(messenger: registrar.messenger())
        registrar.register(viewFactory, withId: SwiftBarkoderFlutterPlugin.VIEW_ID)
    }
        
}

public class BarkoderViewFactory: NSObject, FlutterPlatformViewFactory {
    let messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        
        super.init()
    }
    
    public func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return BarkoderPlatformView(
            messenger: messenger,
            frame: frame,
            viewId: viewId,
            args: args
        )
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
}

public class BarkoderPlatformView: NSObject, FlutterPlatformView {
    
    private static var BARKODER_CHANNEL_NAME = "barkoder_flutter"
    private static var SCANNING_RESULTS_EVENT_NAME = "barkoder_flutter_scanningResultsEvent";
    
    let viewId: Int64
    let messenger: FlutterBinaryMessenger
    let channel: FlutterMethodChannel
    let scanningResultsEvent: FlutterEventChannel
    var scanningResultsEventSink: FlutterEventSink?
    var barkoderView: BarkoderView
    
    init(
        messenger: FlutterBinaryMessenger,
        frame: CGRect,
        viewId: Int64,
        args: Any?
    ) {
        self.messenger = messenger
        self.viewId = viewId
        self.channel = FlutterMethodChannel(
            name: BarkoderPlatformView.BARKODER_CHANNEL_NAME,
            binaryMessenger: messenger
        )
        self.scanningResultsEvent = FlutterEventChannel(
            name: BarkoderPlatformView.SCANNING_RESULTS_EVENT_NAME,
            binaryMessenger: messenger
        )
        
        self.barkoderView = BarkoderView()
        
        super.init()
        
        createBarkoderConfig(args)
        setMethodCallHandler()
        scanningResultsEvent.setStreamHandler(self)
    }
    
    public func view() -> UIView {
        return barkoderView
    }
    
    private func setMethodCallHandler() {
        channel.setMethodCallHandler { [weak self] call, result in
            switch call.method {
            case "setZoomFactor":
                self?.setZoomFactor(call, result: result)
            case "setFlashEnabled":
                self?.setFlashEnabled(call, result: result)
            case "startCamera":
                self?.startCamera(result)
            case "stopScanning":
                self?.stopScanning(result)
            case "pauseScanning":
                self?.pauseScanning(result)
            case "freezeScanning":
                self?.freezeScanning(result)
            case "unfreezeScanning":
                self?.unfreezeScanning(result)
            case "setLocationLineColor":
                self?.setLocationLineColor(call, result: result)
            case "setLocationLineWidth":
                self?.setLocationLineWidth(call, result: result)
            case "setRoiLineColor":
                self?.setRoiLineColor(call, result: result)
            case "setRoiLineWidth":
                self?.setRoiLineWidth(call, result: result)
            case "setRoiOverlayBackgroundColor":
                self?.setRoiOverlayBackgroundColor(call, result: result)
            case "setCloseSessionOnResultEnabled":
                self?.setCloseSessionOnResultEnabled(call, result: result)
            case "setImageResultEnabled":
                self?.setImageResultEnabled(call, result: result)
            case "setLocationInImageResultEnabled":
                self?.setLocationInImageResultEnabled(call, result: result)
            case "setRegionOfInterest":
                self?.setRegionOfInterest(call, result: result)
            case "setThreadsLimit":
                self?.setThreadsLimit(call, result: result)
            case "setLocationInPreviewEnabled":
                self?.setLocationInPreviewEnabled(call, result: result)
            case "setPinchToZoomEnabled":
                self?.setPinchToZoomEnabled(call, result: result)
            case "setRegionOfInterestVisible":
                self?.setRegionOfInterestVisible(call, result: result)
            case "setBarkoderResolution":
                self?.setBarkoderResolution(call, result: result)
            case "setBeepOnSuccessEnabled":
                self?.setBeepOnSuccessEnabled(call, result: result)
            case "setVibrateOnSuccessEnabled":
                self?.setVibrateOnSuccessEnabled(call, result: result)
            case "showLogMessages":
                self?.showLogMessages(call, result: result)
            case "setBarcodeTypeLengthRange":
                self?.setBarcodeTypeLengthRange(call, result: result)
            case "setEncodingCharacterSet":
                self?.setEncodingCharacterSet(call, result: result)
            case "setDecodingSpeed":
                self?.setDecodingSpeed(call, result: result)
            case "setFormattingType":
                self?.setFormattingType(call, result: result)
            case "startScanning":
                self?.startScanning(result)
            case "scanImage":
                self?.scanImage(call, result: result)
            case "setBarcodeTypeEnabled":
                self?.setBarcodeTypeEnabled(call, result: result)
            case "setMulticodeCachingEnabled":
                self?.setMulticodeCachingEnabled(call, result: result)
            case "setMulticodeCachingDuration":
                self?.setMulticodeCachingDuration(call, result: result)
            case "setBarcodeThumbnailOnResultEnabled":
                self?.setBarcodeThumbnailOnResultEnabled(call, result: result)
            case "setThresholdBetweenDuplicatesScans":
                self?.setThresholdBetweenDuplicatesScans(call, result: result)
            case "setUpcEanDeblurEnabled":
                self?.setUpcEanDeblurEnabled(call, result: result)
            case "setMisshaped1DEnabled":
                self?.setMisshaped1DEnabled(call, result: result)
            case "setEnableVINRestrictions":
                self?.setEnableVINRestrictions(call, result: result)
            case "isFlashAvailable":
                self?.isFlashAvailable(result)
            case "isCloseSessionOnResultEnabled":
                self?.isCloseSessionOnResultEnabled(result)
            case "isImageResultEnabled":
                self?.isImageResultEnabled(result)
            case "isLocationInImageResultEnabled":
                self?.isLocationInImageResultEnabled(result)
            case "isLocationInPreviewEnabled":
                self?.isLocationInPreviewEnabled(result)
            case "isPinchToZoomEnabled":
                self?.isPinchToZoomEnabled(result)
            case "isRegionOfInterestVisible":
                self?.isRegionOfInterestVisible(result)
            case "isBeepOnSuccessEnabled":
                self?.isBeepOnSuccessEnabled(result)
            case "isVibrateOnSuccessEnabled":
                self?.isVibrateOnSuccessEnabled(result)
            case "getVersion":
                self?.getVersion(result)
            case "getLibVersion":
                self?.getLibVersion(result)
            case "getLocationLineColorHex":
                self?.getLocationLineColorHex(result)
            case "getRoiLineColorHex":
                self?.getRoiLineColorHex(result)
            case "getRoiOverlayBackgroundColorHex":
                self?.getRoiOverlayBackgroundColorHex(result)
            case "getMaxZoomFactor":
                self?.getMaxZoomFactor(result)
            case "getCurrentZoomFactor":
                self?.getCurrentZoomFactor(result)
            case "getLocationLineWidth":
                self?.getLocationLineWidth(result)
            case "getRoiLineWidth":
                self?.getRoiLineWidth(result)
            case "getRegionOfInterest":
                self?.getRegionOfInterest(result)
            case "configureBarkoder":
                self?.configureBarkoder(call, result: result)
            case "isBarcodeTypeEnabled":
                self?.isBarcodeTypeEnabled(call, result: result)
            case "getBarcodeTypeLengthRange":
                self?.getBarcodeTypeLengthRange(call, result: result)
            case "getMsiChecksumType":
                self?.getMsiChecksumType(result)
            case "setMsiChecksumType":
                self?.setMsiChecksumType(call, result: result)
            case "getCode39ChecksumType":
                self?.getCode39ChecksumType(result)
            case "setCode39ChecksumType":
                self?.setCode39ChecksumType(call, result: result)
            case "getCode11ChecksumType":
                self?.getCode11ChecksumType(result)
            case "setCode11ChecksumType":
                self?.setCode11ChecksumType(call, result: result)
            case "getEncodingCharacterSet":
                self?.getEncodingCharacterSet(result)
            case "getDecodingSpeed":
                self?.getDecodingSpeed(result)
            case "getFormattingType":
                self?.getFormattingType(result)
            case "getThreadsLimit":
                self?.getThreadsLimit(result)
            case "getMulticodeCachingEnabled":
                self?.getMulticodeCachingEnabled(result)
            case "getMulticodeCachingDuration":
                self?.getMulticodeCachingDuration(result)
            case "isUpcEanDeblurEnabled":
                self?.isUpcEanDeblurEnabled(result)
            case "isMisshaped1DEnabled":
                self?.isMisshaped1DEnabled(result)
            case "isVINRestrictionsEnabled":
                self?.isVINRestrictionsEnabled(result)
            case "setMaximumResultsCount":
                self?.setMaximumResultsCount(call, result: result)
            case "getMaximumResultsCount":
                self?.getMaximumResultsCount(result)
            case "isBarcodeThumbnailOnResultEnabled":
                self?.isBarcodeThumbnailOnResultEnabled(result)
            case "getThresholdBetweenDuplicatesScans":
                self?.getThresholdBetweenDuplicatesScans(result)
            case "getBarkoderResolution":
                self?.getBarkoderResolution(result)
            case "setDatamatrixDpmModeEnabled":
                self?.setDatamatrixDpmModeEnabled(call, result: result)
            case "isDatamatrixDpmModeEnabled":
                self?.isDatamatrixDpmModeEnabled(result)
            case "setQrDpmModeEnabled":
                self?.setQrDpmModeEnabled(call, result: result)
            case "isQrDpmModeEnabled":
                self?.isQrDpmModeEnabled(result)
            case "setQrMicroDpmModeEnabled":
                self?.setQrMicroDpmModeEnabled(call, result: result)
            case "isQrMicroDpmModeEnabled":
                self?.isQrMicroDpmModeEnabled(result)
            case "setEnableMisshaped1DEnabled":
                self?.setEnableMisshaped1DEnabled(call, result: result)
            case "setIdDocumentMasterChecksumEnabled":
                self?.setIdDocumentMasterChecksumEnabled(call, result: result)
            case "isIdDocumentMasterChecksumEnabled":
                self?.isIdDocumentMasterChecksumEnabled(result)
            case "setUPCEexpandToUPCA":
                self?.setUPCEexpandToUPCA(call, result: result)
            case "setUPCE1expandToUPCA":
                self?.setUPCE1expandToUPCA(call, result: result)
            case "setCustomOption":
                self?.setCustomOption(call, result: result)
            case "setScanningIndicatorColor":
                self?.setScanningIndicatorColor(call, result: result)
            case "getScanningIndicatorColorHex":
                self?.getScanningIndicatorColorHex(result)
            case "setScanningIndicatorWidth":
                self?.setScanningIndicatorWidth(call, result: result)
            case "getScanningIndicatorWidth":
                self?.getScanningIndicatorWidth(result)
            case "setScanningIndicatorAnimation":
                self?.setScanningIndicatorAnimation(call, result: result)
            case "getScanningIndicatorAnimation":
                self?.getScanningIndicatorAnimation(result)
            case "setScanningIndicatorAlwaysVisible":
                self?.setScanningIndicatorAlwaysVisible(call, result: result)
            case "isScanningIndicatorAlwaysVisible":
                self?.isScanningIndicatorAlwaysVisible(result)
            case "setDynamicExposure":
                self?.setDynamicExposure(call, result: result)
            case "setCentricFocusAndExposure":
                self?.setCentricFocusAndExposure(call, result: result)
            case "setEnableComposite":
                self?.setEnableComposite(call, result: result)
            case "setVideoStabilization":
                self?.setVideoStabilization(call, result: result)
            case "setCamera":
                self?.setCamera(call, result: result)
            case "setShowDuplicatesLocations":
                self?.setShowDuplicatesLocations(call, result: result)
            case "setARMode":
                self?.setARMode(call, result: result)
            case "setARResultDisappearanceDelayMs":
                self?.setARResultDisappearanceDelayMs(call, result: result)
            case "setARLocationTransitionSpeed":
                self?.setARLocationTransitionSpeed(call, result: result)
            case "setAROverlayRefresh":
                self?.setAROverlayRefresh(call, result: result)
            case "setARSelectedLocationColor":
                self?.setARSelectedLocationColor(call, result: result)
            case "setARNonSelectedLocationColor":
                self?.setARNonSelectedLocationColor(call, result: result)
            case "setARSelectedLocationLineWidth":
                self?.setARSelectedLocationLineWidth(call, result: result)
            case "setARNonSelectedLocationLineWidth":
                self?.setARNonSelectedLocationLineWidth(call, result: result)
            case "setARLocationType":
                self?.setARLocationType(call, result: result)
            case "setARDoubleTapToFreezeEnabled":
                self?.setARDoubleTapToFreezeEnabled(call, result: result)
            case "setARImageResultEnabled":
                self?.setARImageResultEnabled(call, result: result)
            case "setARBarcodeThumbnailOnResultEnabled":
                self?.setARBarcodeThumbnailOnResultEnabled(call, result: result)
            case "setARHeaderHeight":
                self?.setARHeaderHeight(call, result: result)
            case "setARHeaderShowMode":
                self?.setARHeaderShowMode(call, result: result)
            case "setARHeaderMaxTextHeight":
                self?.setARHeaderMaxTextHeight(call, result: result)
            case "setARHeaderMinTextHeight":
                self?.setARHeaderMinTextHeight(call, result: result)
            case "setARHeaderTextColorSelected":
                self?.setARHeaderTextColorSelected(call, result: result)
            case "setARHeaderTextColorNonSelected":
                self?.setARHeaderTextColorNonSelected(call, result: result)
            case "setARHeaderHorizontalTextMargin":
                self?.setARHeaderHorizontalTextMargin(call, result: result)
            case "setARHeaderVerticalTextMargin":
                self?.setARHeaderVerticalTextMargin(call, result: result)
            case "setARHeaderTextFormat":
                self?.setARHeaderTextFormat(call, result: result)
            case "getShowDuplicatesLocations":
                self?.getShowDuplicatesLocations(result)
            case "getARMode":
                self?.getARMode(result)
            case "getARResultDisappearanceDelayMs":
                self?.getARResultDisappearanceDelayMs(result)
            case "getARLocationTransitionSpeed":
                self?.getARLocationTransitionSpeed(result)
            case "getAROverlayRefresh":
                self?.getAROverlayRefresh(result)
            case "getARSelectedLocationColor":
                self?.getARSelectedLocationColor(result)
            case "getARNonSelectedLocationColor":
                self?.getARNonSelectedLocationColor(result)
            case "getARSelectedLocationLineWidth":
                self?.getARSelectedLocationLineWidth(result)
            case "getARNonSelectedLocationLineWidth":
                self?.getARNonSelectedLocationLineWidth(result)
            case "getARLocationType":
                self?.getARLocationType(result)
            case "isARDoubleTapToFreezeEnabled":
                self?.isARDoubleTapToFreezeEnabled(result)
            case "isARImageResultEnabled":
                self?.isARImageResultEnabled(result)
            case "isARBarcodeThumbnailOnResultEnabled":
                self?.isARBarcodeThumbnailOnResultEnabled(result)
            case "getARHeaderHeight":
                self?.getARHeaderHeight(result)
            case "getARHeaderShowMode":
                self?.getARHeaderShowMode(result)
            case "getARHeaderMaxTextHeight":
                self?.getARHeaderMaxTextHeight(result)
            case "getARHeaderMinTextHeight":
                self?.getARHeaderMinTextHeight(result)
            case "getARHeaderTextColorSelected":
                self?.getARHeaderTextColorSelected(result)
            case "getARHeaderTextColorNonSelected":
                self?.getARHeaderTextColorNonSelected(result)
            case "getARHeaderHorizontalTextMargin":
                self?.getARHeaderHorizontalTextMargin(result)
            case "getARHeaderVerticalTextMargin":
                self?.getARHeaderVerticalTextMargin(result)
            case "getARHeaderTextFormat":
                self?.getARHeaderTextFormat(result)
            default:
                break
            }
        }
    }
    
}

extension BarkoderPlatformView: FlutterStreamHandler {
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        scanningResultsEventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        // NO-OP
        return nil
    }

}

extension BarkoderPlatformView {
    
    private func createBarkoderConfig(_ args: Any?) {
        // In order to perform scanning, config property need to be set before
        // If license key is not valid you will receive results with asterisks inside
        if let arguments = args as? [String: Any],
           let licenseKey = arguments["licenseKey"] as? String {
            barkoderView.config = BarkoderConfig(licenseKey: licenseKey) { licenseResult in
                print("Licensing SDK: \(licenseResult)")
            }
        }
    }
    
}

extension BarkoderPlatformView: BarkoderResultDelegate {
    public func scanningFinished(_ decoderResults: [DecoderResult], thumbnails: [UIImage]?, image: UIImage?) {
        let barkoderResultsToJsonString = Util.barkoderResultsToJsonString(decoderResults, thumbnails: thumbnails, image: image)
        scanningResultsEventSink?(barkoderResultsToJsonString)
    }
    
}

// MARK: - Setters

extension BarkoderPlatformView {
    
    private func setZoomFactor(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let zoomFactor = call.arguments as? Float else {
            return
        }

        barkoderView.setZoomFactor(zoomFactor)
        
        result(nil)
    }
    
    private func setFlashEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else {
            return
        }

        barkoderView.setFlash(enabled)
        
        result(nil)
    }
    
    private func startCamera(_ result: @escaping FlutterResult) {
        barkoderView.startCamera()
        
        result(nil)
    }
    
    private func stopScanning(_ result: @escaping FlutterResult) {
        barkoderView.stopScanning()
        
        result(nil)
    }
    
    private func pauseScanning(_ result: @escaping FlutterResult) {
        barkoderView.pauseScanning()
        
        result(nil)
    }
    
    private func freezeScanning(_ result: @escaping FlutterResult) {
        barkoderView.freezeScanning()
        
        result(nil)
    }
    
    private func unfreezeScanning(_ result: @escaping FlutterResult) {
        barkoderView.unfreezeScanning()
        
        result(nil)
    }
    
    private func setLocationLineColor(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let hexColor = call.arguments as? String else {
            return
        }
        
        barkoderView.config?.locationLineColor = UIColor(hexString: hexColor, result: result)
        
        result(nil)
    }
    
    private func setLocationLineWidth(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let lineWidth = call.arguments as? Float else {
            return
        }

        barkoderView.config?.locationLineWidth = lineWidth
        
        result(nil)
    }
    
    private func setRoiLineColor(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let hexColor = call.arguments as? String else {
            return
        }

        barkoderView.config?.roiLineColor = UIColor(hexString: hexColor, result: result)
        
        result(nil)
    }
    
    private func setRoiLineWidth(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let lineWidth = call.arguments as? Float else {
            return
        }

        barkoderView.config?.roiLineWidth = lineWidth
        
        result(nil)
    }
    
    private func setRoiOverlayBackgroundColor(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let hexColor = call.arguments as? String else {
            return
        }

        barkoderView.config?.roiOverlayBackgroundColor = UIColor(hexString: hexColor, result: result)
        
        result(nil)
    }
    
    private func setCloseSessionOnResultEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else {
            return
        }

        barkoderView.config?.closeSessionOnResultEnabled = enabled
        
        result(nil)
    }
    
    private func setImageResultEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else {
            return
        }

        barkoderView.config?.imageResultEnabled = enabled
        
        result(nil)
    }
    
    private func setLocationInImageResultEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else {
            return
        }

        barkoderView.config?.locationInImageResultEnabled = enabled
        
        result(nil)
    }
    
    private func setRegionOfInterest(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
            let left = arguments["left"] as? CGFloat,
            let width = arguments["width"] as? CGFloat,
            let top = arguments["top"] as? CGFloat,
            let height = arguments["height"] as? CGFloat
        else {
            return
        }
        
        let roi = CGRect(
            x: left,
            y: top,
            width: width,
            height: height
        )
        
        do {
            try barkoderView.config?.setRegionOfInterest(roi)

            result(nil)
        } catch {
            result(
                FlutterError(
                    code: BarkoderFlutterErrors.ROI_NOT_SET.errorCode,
                    message: BarkoderFlutterErrors.ROI_NOT_SET.errorMessage,
                    details: nil
                )
            )
        }
    }
    
    private func setThreadsLimit(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let threadsLimit = call.arguments as? Int else {
            return
        }
        
        do {
            try barkoderView.config?.setThreadsLimit(threadsLimit)
            result(nil)
        } catch {
            result(
                FlutterError(
                    code: BarkoderFlutterErrors.THREADS_LIMIT_NOT_SET.errorCode,
                    message: BarkoderFlutterErrors.THREADS_LIMIT_NOT_SET.errorMessage,
                    details: nil
                )
            )
        }
    }
    
    private func setLocationInPreviewEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else {
            return
        }
        
        barkoderView.config?.locationInPreviewEnabled = enabled
        
        result(nil)
    }
    
    private func setPinchToZoomEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else {
            return
        }
        
        barkoderView.config?.pinchToZoomEnabled = enabled
        
        result(nil)
    }
    
    private func setRegionOfInterestVisible(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else {
            return
        }
        
        barkoderView.config?.regionOfInterestVisible = enabled
        
        result(nil)
    }

    private func setBarkoderResolution(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let index = call.arguments as? Int else {
            return
        }

        if let barkoderResolution = BarkoderView.BarkoderResolution.init(rawValue: index) {
            barkoderView.config?.barkoderResolution = barkoderResolution
            
            result(nil)
        } else {
            result(
                FlutterError(
                    code: BarkoderFlutterErrors.INVALID_RESOLUTION.errorCode,
                    message: BarkoderFlutterErrors.INVALID_RESOLUTION.errorMessage,
                    details: nil
                )
            )
        }
    }
    
    private func setBeepOnSuccessEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else {
            return
        }
        
        barkoderView.config?.beepOnSuccessEnabled = enabled
        
        result(nil)
    }
    
    private func setVibrateOnSuccessEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else {
            return
        }
        
        barkoderView.config?.vibrateOnSuccessEnabled = enabled
        
        result(nil)
    }
    
    private func showLogMessages(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let show = call.arguments as? Bool else {
            return
        }
        
        // TODO: - Logic about log messages
        
        result(nil)
    }
    
    private func setBarcodeTypeLengthRange(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let typeRawValue = arguments["type"] as? UInt32,
              let min = arguments["min"] as? UInt32,
              let max = arguments["max"] as? UInt32
        else {
            return
        }
                                
        guard let specificConfig = SpecificConfig(decoderType: .init(rawValue: typeRawValue)) else {
            result(
                FlutterError(
                    code: BarkoderFlutterErrors.BARCODE_TYPE_NOT_FOUNDED.errorCode,
                    message: BarkoderFlutterErrors.BARCODE_TYPE_NOT_FOUNDED.errorMessage,
                    details: nil
                )
            )
            return
        }
                
        switch specificConfig.decoderType() {
        case Code128, Code93, Code39, Code11, Msi, Codabar:
            specificConfig.setLengthRangeWithMinimum(Int32(min), maximum: Int32(max))
            
            result(nil)
        default:
            result(
                FlutterError(
                    code: BarkoderFlutterErrors.BARCODE_TYPE_NOT_SUPPORTED.errorCode,
                    message: BarkoderFlutterErrors.BARCODE_TYPE_NOT_SUPPORTED.errorMessage,
                    details: nil
                )
            )
        }

    }
    
    private func setEncodingCharacterSet(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let characterSet = call.arguments as? String else {
            return
        }

        barkoderView.config?.decoderConfig?.encodingCharacterSet = characterSet
        
        result(nil)
    }
    
    private func setDecodingSpeed(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let index = call.arguments as? Int else {
            return
        }

        barkoderView.config?.decoderConfig?.decodingSpeed = DecodingSpeed.init(UInt32(index))
        
        result(nil)
    }
    
    private func setFormattingType(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let index = call.arguments as? Int else {
            return
        }

        barkoderView.config?.decoderConfig?.formatting = Formatting.init(UInt32(index))
        
        result(nil)
    }
    
    private func startScanning(_ result: @escaping FlutterResult) {
        try? barkoderView.startScanning(self)
        
        result(nil)
    }
    
    private func configureBarkoder(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let barkoderConfigAsJsonString = call.arguments as? String,
            let barkoderConfig = barkoderView.config else {
            return
        }
        
        let barkoderJsonData: Data
        
        // Converting from String -> Data
        // Converting from Data -> Dictionary
        // Changing values for colors from hexes to decimal values
        // Converting from Dictionary -> Data with utf8 encoding
        do {
            let barkoderConfigAsData = Data(barkoderConfigAsJsonString.utf8)
            
            var barkoderConfigAsDictionary = try JSONSerialization.jsonObject(with: barkoderConfigAsData, options: []) as? [String: Any]
            
            if let colorHexCode = barkoderConfigAsDictionary?["roiLineColor"] as? String {
                barkoderConfigAsDictionary?["roiLineColor"] = Util.parseColor(hexColor: colorHexCode)
            }
            
            if let colorHexCode = barkoderConfigAsDictionary?["locationLineColor"] as? String {
                barkoderConfigAsDictionary?["locationLineColor"] = Util.parseColor(hexColor: colorHexCode)
            }

            if let colorHexCode = barkoderConfigAsDictionary?["roiOverlayBackgroundColor"] as? String {
                barkoderConfigAsDictionary?["roiOverlayBackgroundColor"] = Util.parseColor(hexColor: colorHexCode)
            }
            
            if let colorHexCode = barkoderConfigAsDictionary?["scanningIndicatorColor"] as? String {
                barkoderConfigAsDictionary?["scanningIndicatorColor"] = Util.parseColor(hexColor: colorHexCode)
            }
            
            if let colorHexCode = barkoderConfigAsDictionary?["selectedLocationColor"] as? String {
                barkoderConfigAsDictionary?["selectedLocationColor"] = Util.parseColor(hexColor: colorHexCode)
            }

            if let colorHexCode = barkoderConfigAsDictionary?["nonSelectedLocationColor"] as? String {
                barkoderConfigAsDictionary?["nonSelectedLocationColor"] = Util.parseColor(hexColor: colorHexCode)
            }

            if let colorHexCode = barkoderConfigAsDictionary?["headerTextColorSelected"] as? String {
                barkoderConfigAsDictionary?["headerTextColorSelected"] = Util.parseColor(hexColor: colorHexCode)
            }

            if let colorHexCode = barkoderConfigAsDictionary?["headerTextColorNonSelected"] as? String {
                barkoderConfigAsDictionary?["headerTextColorNonSelected"] = Util.parseColor(hexColor: colorHexCode)
            }
            
            let jsonData = try JSONSerialization.data(withJSONObject: barkoderConfigAsDictionary as Any, options: .prettyPrinted)
            
            let convertedBarkoderConfigAsString = String(data: jsonData, encoding: .utf8) ?? ""
            
            barkoderJsonData = Data(convertedBarkoderConfigAsString.utf8)
        } catch {
            result(
                FlutterError(
                    code: BarkoderFlutterErrors.BARKODER_CONFIG_IS_NOT_VALID.errorCode,
                    message: BarkoderFlutterErrors.BARKODER_CONFIG_IS_NOT_VALID.errorMessage,
                    details: error.localizedDescription
                )
            )
            return
        }
        
        BarkoderHelper.applyConfigSettingsFromJson(
            barkoderConfig,
            jsonData: barkoderJsonData
        ) { [weak self] config, error in
                if let error = error {
                    result(
                        FlutterError(
                            code: BarkoderFlutterErrors.BARKODER_CONFIG_IS_NOT_VALID.errorCode,
                            message: BarkoderFlutterErrors.BARKODER_CONFIG_IS_NOT_VALID.errorMessage,
                            details: error.localizedDescription
                        )
                    )
                } else {
                    self?.barkoderView.config = config
                    result(nil)
                }
            }
    }

    private func setCode11ChecksumType(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let index = call.arguments as? UInt32 else {
            return
        }

        barkoderView.config?.decoderConfig?.code11.checksum = .init(index)
        
        result(nil)
    }
    
    private func setMsiChecksumType(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let index = call.arguments as? UInt32 else {
            return
        }

        barkoderView.config?.decoderConfig?.msi.checksum = .init(index)
        
        result(nil)
    }
    
    private func setCode39ChecksumType(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let index = call.arguments as? UInt32 else {
            return
        }

        barkoderView.config?.decoderConfig?.code39.checksum = .init(index)
        
        result(nil)
    }
    
    private func setBarcodeTypeEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let arguments = call.arguments as? [String: Any] {
            if let enabled = arguments["enabled"] as? Bool,
               let typeRawValue = arguments["type"] as? UInt32 {
                guard let decoderConfig = barkoderView.config?.decoderConfig else { return }
                                
                guard let specificConfig = SpecificConfig(decoderType: .init(rawValue: typeRawValue)) else {
                    result(
                        FlutterError(
                            code: BarkoderFlutterErrors.BARCODE_TYPE_NOT_FOUNDED.errorCode,
                            message: BarkoderFlutterErrors.BARCODE_TYPE_NOT_FOUNDED.errorMessage,
                            details: nil
                        )
                    )
                    return
                }
                
                switch specificConfig.decoderType() {
                case Aztec:
                    decoderConfig.aztec.enabled = enabled
                case AztecCompact:
                    decoderConfig.aztecCompact.enabled = enabled
                case QR:
                    decoderConfig.qr.enabled = enabled
                case QRMicro:
                    decoderConfig.qrMicro.enabled = enabled
                case Code128:
                    decoderConfig.code128.enabled = enabled
                case Code93:
                    decoderConfig.code93.enabled = enabled
                case Code39:
                    decoderConfig.code39.enabled = enabled
                case Codabar:
                    decoderConfig.codabar.enabled = enabled
                case Code11:
                    decoderConfig.code11.enabled = enabled
                case Msi:
                    decoderConfig.msi.enabled = enabled
                case UpcA:
                    decoderConfig.upcA.enabled = enabled
                case UpcE:
                    decoderConfig.upcE.enabled = enabled
                case UpcE1:
                    decoderConfig.upcE1.enabled = enabled
                case Ean13:
                    decoderConfig.ean13.enabled = enabled
                case Ean8:
                    decoderConfig.ean8.enabled = enabled
                case PDF417:
                    decoderConfig.pdf417.enabled = enabled
                case PDF417Micro:
                    decoderConfig.pdf417Micro.enabled = enabled
                case Datamatrix:
                    decoderConfig.datamatrix.enabled = enabled
                case Code25:
                    decoderConfig.code25.enabled = enabled
                case Interleaved25:
                    decoderConfig.interleaved25.enabled = enabled
                case ITF14:
                    decoderConfig.itf14.enabled = enabled
                case IATA25:
                    decoderConfig.iata25.enabled = enabled
                case Matrix25:
                    decoderConfig.matrix25.enabled = enabled
                case Datalogic25:
                    decoderConfig.datalogic25.enabled = enabled
                case COOP25:
                    decoderConfig.coop25.enabled = enabled
                case Code32:
                    decoderConfig.code32.enabled = enabled
                case Telepen:
                    decoderConfig.telepen.enabled = enabled
				case Dotcode:
					decoderConfig.dotcode.enabled = enabled
                case IDDocument:
                    decoderConfig.idDocument.enabled = enabled
                case Databar14:
                    decoderConfig.databar14.enabled = enabled
                case DatabarLimited:
                    decoderConfig.databarLimited.enabled = enabled
                case DatabarExpanded:
                    decoderConfig.databarExpanded.enabled = enabled
                case PostalIMB:
                    decoderConfig.postalIMB.enabled = enabled
                case Postnet:
                    decoderConfig.postnet.enabled = enabled
                case Planet:
                    decoderConfig.planet.enabled = enabled
                case AustralianPost:
                    decoderConfig.australianPost.enabled = enabled
                case RoyalMail:
                    decoderConfig.royalMail.enabled = enabled
                case KIX:
                    decoderConfig.kix.enabled = enabled
                case JapanesePost:
                    decoderConfig.japanesePost.enabled = enabled
                case MaxiCode:
                    decoderConfig.maxiCode.enabled = enabled
                default:
                    result(
                        FlutterError(
                            code: BarkoderFlutterErrors.BARCODE_TYPE_NOT_FOUNDED.errorCode,
                            message: BarkoderFlutterErrors.BARCODE_TYPE_NOT_FOUNDED.errorMessage,
                            details: nil
                        )
                    )
                }
                
                result(nil)
            }
            
        }
    }
    
    private func setMulticodeCachingEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let multicodeCachingEnabled = call.arguments as? Bool else {
            return
        }
        
        barkoderView.config?.setMulticodeCachingEnabled(multicodeCachingEnabled)
        
        result(nil)
    }
    
    private func setMulticodeCachingDuration(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let multicodeCachingDuration = call.arguments as? Int else {
            return
        }
        
        barkoderView.config?.setMulticodeCachingDuration(multicodeCachingDuration)
    }

    private func setMaximumResultsCount(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let index = call.arguments as? UInt32 else {
            return
        }

        barkoderView.config?.decoderConfig?.maximumResultsCount = Int32(index)
        
        result(nil)
    }
    
    private func setBarcodeThumbnailOnResultEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else {
            return
        }
        
        barkoderView.config?.barcodeThumbnailOnResult = enabled
    }
    
    private func setThresholdBetweenDuplicatesScans(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let thresholdBetweenDuplicatesScans = call.arguments as? Int else {
            return
        }
        
        barkoderView.config?.thresholdBetweenDuplicatesScans = thresholdBetweenDuplicatesScans

        result(nil)
    }
    
    private func setUpcEanDeblurEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else {
            return
        }
        
        barkoderView.config?.decoderConfig?.upcEanDeblur = enabled
    }
    
    private func setMisshaped1DEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else {
            return
        }
        
        barkoderView.config?.decoderConfig?.enableMisshaped1D = enabled
        
        result(nil)
    }
    
    private func setEnableVINRestrictions(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else {
            return
        }
        
        barkoderView.config?.decoderConfig?.enableVINRestrictions = enabled
        
        result(nil)
    }

    private func setDatamatrixDpmModeEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else {
            return
        }
        
        barkoderView.config?.decoderConfig?.datamatrix.dpmMode = enabled ? 1 : 0
        
        result(nil)
    }
    
    private func setQrDpmModeEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else {
            return
        }
        
        barkoderView.config?.decoderConfig?.qr.dpmMode = enabled ? 1 : 0
        
        result(nil)
    }
    
    private func setQrMicroDpmModeEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else {
            return
        }
        
        barkoderView.config?.decoderConfig?.qrMicro.dpmMode = enabled ? 1 : 0
        
        result(nil)
    }

    private func setEnableMisshaped1DEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else {
            return
        }
        
        barkoderView.config?.decoderConfig?.enableMisshaped1D = enabled
        
        result(nil)
    }
    
    private func setIdDocumentMasterChecksumEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else {
            return
        }
        
        barkoderView.config?.decoderConfig?.idDocument.masterChecksum = StandardChecksum(rawValue: enabled == true ? 1 : 0)
        
        result(nil)
    }
    
    private func scanImage(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        guard let base64Image = call.arguments as? String else {
            return
        }
        
        guard let imageData = Data(base64Encoded: base64Image, options: .ignoreUnknownCharacters) else {
            return
        }
        
        guard let image = UIImage(data: imageData) else {
            return
        }
        
        guard let config = barkoderView.config else { return }
        
        BarkoderHelper.scanImage(image, bkdConfig: config, resultDelegate: self)
        
        result(nil)
    }
    
    private func setUPCEexpandToUPCA(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else {
            return
        }
        
        barkoderView.config?.decoderConfig?.upcE.expandToUPCA = enabled
        
        result(nil)
    }
    
    private func setUPCE1expandToUPCA(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else {
            return
        }
        
        barkoderView.config?.decoderConfig?.upcE1.expandToUPCA = enabled
        
        result(nil)
    }
    
    private func setCustomOption(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let option = arguments["option"] as? String,
              let value = arguments["value"] as? Int else {
            return
        }
        
        barkoderView.config?.decoderConfig?.setcustomOption(option, value: Int32(value))
        
        result(nil)
    }
    
    private func setScanningIndicatorColor(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let hexColor = call.arguments as? String else {
            return
        }
        
        barkoderView.config?.scanningIndicatorColor = UIColor(hexString: hexColor, result: result)
        
        result(nil)
    }
    
    private func setScanningIndicatorWidth(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let width = call.arguments as? Float else {
            return
        }
        
        barkoderView.config?.scanningIndicatorWidth = width
        
        result(nil)
    }
    
    private func setScanningIndicatorAnimation(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let animation = call.arguments as? Int else {
            return
        }
        
        barkoderView.config?.scanningIndicatorAnimation = animation
        
        result(nil)
    }
    
    private func setScanningIndicatorAlwaysVisible(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let visible = call.arguments as? Bool else {
            return
        }
        
        barkoderView.config?.scanningIndicatorAlwaysVisible = visible
        
        result(nil)
    }
    
    private func setDynamicExposure(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let dynamicExposure = call.arguments as? Int else {
            return
        }
        
        barkoderView.setDynamicExposure(dynamicExposure)
        
        result(nil)
    }
    
    private func setCentricFocusAndExposure(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else {
            return
        }
        
        barkoderView.setCentricFocusAndExposure(enabled)
        
        result(nil)
    }
    
    private func setEnableComposite(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enableComposite = call.arguments as? Int else {
            return
        }
        
        barkoderView.config?.decoderConfig?.enableComposite = Int32(enableComposite)
        
        result(nil)
    }
    
    private func setVideoStabilization(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else {
            return
        }
        
        barkoderView.setVideoStabilization(enabled)
        
        result(nil)
    }
    
    private func setCamera(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let value = call.arguments as? Int,
        let cameraPosition = BarkoderView.BarkoderCameraPosition(rawValue: value) else {
            result(
                FlutterError(
                    code: BarkoderFlutterErrors.INVALID_CAMERA_POSITION.errorCode,
                    message: BarkoderFlutterErrors.INVALID_CAMERA_POSITION.errorMessage,
                    details: nil
                )
            )
            return
        }
        
        barkoderView.setCamera(cameraPosition)
        
        result(nil)
    }
    
    private func setShowDuplicatesLocations(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let value = call.arguments as? Bool else { return }
        
        barkoderView.config?.showDuplicatesLocations = value
        
        result(nil)
    }

    private func setARMode(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let index = call.arguments as? Int,
              let mode = BarkoderARMode(rawValue: index) else { return }
        
        barkoderView.config?.arConfig.arMode = mode
        
        result(nil)
    }

    private func setARResultDisappearanceDelayMs(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let value = call.arguments as? Int else { return }
        
        barkoderView.config?.arConfig.resultDisappearanceDelayMs = value
        
        result(nil)
    }

    private func setARLocationTransitionSpeed(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let value = call.arguments as? Float else { return }
        
        barkoderView.config?.arConfig.locationTransitionSpeed = value
        
        result(nil)
    }

    private func setAROverlayRefresh(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let index = call.arguments as? Int,
              let refresh = BarkoderAROverlayRefresh(rawValue: index) else { return }
        
        barkoderView.config?.arConfig.overlayRefresh = refresh
        
        result(nil)
    }

    private func setARSelectedLocationColor(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let hex = call.arguments as? String else { return }
        
        barkoderView.config?.arConfig.selectedLocationColor = UIColor(hexString: hex, result: result)
        
        result(nil)
    }

    private func setARNonSelectedLocationColor(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let hex = call.arguments as? String else { return }
        
        barkoderView.config?.arConfig.nonSelectedLocationColor = UIColor(hexString: hex, result: result)
        
        result(nil)
    }

    private func setARSelectedLocationLineWidth(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let width = call.arguments as? Float else { return }
        
        barkoderView.config?.arConfig.selectedLocationLineWidth = width
        
        result(nil)
    }

    private func setARNonSelectedLocationLineWidth(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let width = call.arguments as? Float else { return }
        
        barkoderView.config?.arConfig.nonSelectedLocationLineWidth = width
        
        result(nil)
    }

    private func setARLocationType(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let index = call.arguments as? Int,
              let type = BarkoderARLocationType(rawValue: index) else { return }
        
        barkoderView.config?.arConfig.locationType = type
        
        result(nil)
    }

    private func setARDoubleTapToFreezeEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else { return }

        barkoderView.config?.arConfig.doubleTapToFreezeEnabled = enabled
        
        result(nil)
    }
    
    private func setARImageResultEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else { return }

        barkoderView.config?.arConfig.imageResultEnabled = enabled
        
        result(nil)
    }
    
    private func setARBarcodeThumbnailOnResultEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enabled = call.arguments as? Bool else { return }

        barkoderView.config?.arConfig.barcodeThumbnailOnResult = enabled
        
        result(nil)
    }

    private func setARHeaderHeight(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let height = call.arguments as? Float else { return }
        
        barkoderView.config?.arConfig.headerHeight = height
        
        result(nil)
    }

    private func setARHeaderShowMode(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let index = call.arguments as? Int,
              let mode = BarkoderARHeaderShowMode(rawValue: index) else { return }
        
        barkoderView.config?.arConfig.headerShowMode = mode
        
        result(nil)
    }

    private func setARHeaderMaxTextHeight(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let value = call.arguments as? Float else { return }
        
        barkoderView.config?.arConfig.headerMaxTextHeight = value
        
        result(nil)
    }

    private func setARHeaderMinTextHeight(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let value = call.arguments as? Float else { return }
        
        barkoderView.config?.arConfig.headerMinTextHeight = value
        
        result(nil)
    }

    private func setARHeaderTextColorSelected(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let hex = call.arguments as? String else { return }
        
        barkoderView.config?.arConfig.headerTextColorSelected = UIColor(hexString: hex, result: result)
        
        result(nil)
    }

    private func setARHeaderTextColorNonSelected(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let hex = call.arguments as? String else { return }
        
        barkoderView.config?.arConfig.headerTextColorNonSelected = UIColor(hexString: hex, result: result)
        
        result(nil)
    }

    private func setARHeaderHorizontalTextMargin(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let value = call.arguments as? Float else { return }
        
        barkoderView.config?.arConfig.headerHorizontalTextMargin = value
        
        result(nil)
    }

    private func setARHeaderVerticalTextMargin(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let value = call.arguments as? Float else { return }
        
        barkoderView.config?.arConfig.headerVerticalTextMargin = value
        
        result(nil)
    }

    private func setARHeaderTextFormat(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let value = call.arguments as? String else { return }
        
        barkoderView.config?.arConfig.headerTextFormat = value
        
        result(nil)
    }
     
}

// MARK: - Getters

extension BarkoderPlatformView {
    
    private func isFlashAvailable(_ result: @escaping FlutterResult) {
        barkoderView.isFlashAvailable { flashAvailable in
            result(flashAvailable)
        }
    }
    
    private func isCloseSessionOnResultEnabled(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.closeSessionOnResultEnabled)
    }
    
    private func isImageResultEnabled(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.imageResultEnabled)
    }
    
    private func isLocationInImageResultEnabled(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.locationInImageResultEnabled)
    }
    
    private func isLocationInPreviewEnabled(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.locationInPreviewEnabled)
    }
    
    private func isPinchToZoomEnabled(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.pinchToZoomEnabled)
    }
    
    private func isRegionOfInterestVisible(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.regionOfInterestVisible)
    }
    
    private func isBeepOnSuccessEnabled(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.beepOnSuccessEnabled)
    }
    
    private func isVibrateOnSuccessEnabled(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.vibrateOnSuccessEnabled)
    }
    
    private func getVersion(_ result: @escaping FlutterResult) {
        result(iBarkoder.GetVersion())
    }
    
    private func getLibVersion(_ result: @escaping FlutterResult) {
        result(iBarkoder.getLibVersion())
    }

    private func getLocationLineColorHex(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.locationLineColor.toHex())
    }
    
    private func getRoiLineColorHex(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.roiLineColor.toHex())
    }
    
    private func getRoiOverlayBackgroundColorHex(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.roiOverlayBackgroundColor.toHex())
    }
    
    private func getMaxZoomFactor(_ result: @escaping FlutterResult) {
        barkoderView.getMaxZoomFactor { maxZoomFactor in
            result(maxZoomFactor)
        }
    }
    
    private func getCurrentZoomFactor(_ result: @escaping FlutterResult) {
        result(barkoderView.getCurrentZoomFactor())
    }
    
    private func getLocationLineWidth(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.locationLineWidth)
    }
    
    private func getRoiLineWidth(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.roiLineWidth)
    }
    
    private func getRegionOfInterest(_ result: @escaping FlutterResult) {
        guard let roi = barkoderView.config?.getRegionOfInterest() else {
            result(
                FlutterError(
                    code: BarkoderFlutterErrors.BARKODER_CONFIG_IS_NOT_VALID.errorCode,
                    message: BarkoderFlutterErrors.BARKODER_CONFIG_IS_NOT_VALID.errorMessage,
                    details: nil
                )
            )
            return
        }
        
        result([roi.minX, roi.minY, roi.width, roi.height])
    }
        
    private func getBarcodeTypeLengthRange(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let typeRawValue = call.arguments as? UInt32,
              let decoderConfig = barkoderView.config?.decoderConfig else {
            return
        }
        
        guard let specificConfig = SpecificConfig(decoderType: .init(rawValue: typeRawValue)) else {
            result(
                FlutterError(
                    code: BarkoderFlutterErrors.BARCODE_TYPE_NOT_FOUNDED.errorCode,
                    message: BarkoderFlutterErrors.BARCODE_TYPE_NOT_FOUNDED.errorMessage,
                    details: nil
                )
            )
            return
        }
        
        switch specificConfig.decoderType() {
        case Code128:
            result([decoderConfig.code128.minimumLength, decoderConfig.code128.maximumLength])
        case Code93:
            result([decoderConfig.code93.minimumLength, decoderConfig.code93.maximumLength])
        case Code11:
            result([decoderConfig.code11.minimumLength, decoderConfig.code11.maximumLength])
        case Msi:
            result([decoderConfig.msi.minimumLength, decoderConfig.msi.maximumLength])
        case Codabar:
            result([decoderConfig.codabar.minimumLength, decoderConfig.codabar.maximumLength])
        case Code39:
            result([decoderConfig.code39.minimumLength, decoderConfig.code39.maximumLength])
        default:
            result(
                FlutterError(
                    code: BarkoderFlutterErrors.BARCODE_TYPE_NOT_SUPPORTED.errorCode,
                    message: BarkoderFlutterErrors.BARCODE_TYPE_NOT_SUPPORTED.errorMessage,
                    details: nil
                )
            )
        }
    }
    
    private func getMsiChecksumType(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.decoderConfig?.msi.checksum.rawValue)
    }
    
    private func getCode39ChecksumType(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.decoderConfig?.code39.checksum.rawValue)
    }
    
    private func getCode11ChecksumType(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.decoderConfig?.code11.checksum.rawValue)
    }
    
    private func getEncodingCharacterSet(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.decoderConfig?.encodingCharacterSet)
    }
    
    private func getDecodingSpeed(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.decoderConfig?.decodingSpeed.rawValue)
    }
    
    private func getFormattingType(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.decoderConfig?.formatting.rawValue)
    }
    
    private func getThreadsLimit(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.getThreadsLimit())
    }
    
    private func getMaximumResultsCount(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.decoderConfig?.maximumResultsCount)
    }
    
    private func isBarcodeTypeEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let typeRawValue = call.arguments as? UInt32,
              let decoderConfig = barkoderView.config?.decoderConfig else {
            return
        }
        
        guard let specificConfig = SpecificConfig(decoderType: .init(rawValue: typeRawValue)) else {
            result(
                FlutterError(
                    code: BarkoderFlutterErrors.BARCODE_TYPE_NOT_FOUNDED.errorCode,
                    message: BarkoderFlutterErrors.BARCODE_TYPE_NOT_FOUNDED.errorMessage,
                    details: nil
                )
            )
            return
        }
        
        switch specificConfig.decoderType() {
        case Aztec:
            result(decoderConfig.aztec.enabled)
        case AztecCompact:
            result(decoderConfig.aztecCompact.enabled)
        case QR:
            result(decoderConfig.qr.enabled)
        case QRMicro:
            result(decoderConfig.qrMicro.enabled)
        case Code128:
            result(decoderConfig.code128.enabled)
        case Code93:
            result(decoderConfig.code93.enabled)
        case Code39:
            result(decoderConfig.code39.enabled)
        case Codabar:
            result(decoderConfig.codabar.enabled)
        case Code11:
            result(decoderConfig.code11.enabled)
        case Msi:
            result(decoderConfig.msi.enabled)
        case UpcA:
            result(decoderConfig.upcA.enabled)
        case UpcE:
            result(decoderConfig.upcE.enabled)
        case UpcE1:
            result(decoderConfig.upcE1.enabled)
        case Ean13:
            result(decoderConfig.ean13.enabled)
        case Ean8:
            result(decoderConfig.ean8.enabled)
        case PDF417:
            result(decoderConfig.pdf417.enabled)
        case PDF417Micro:
            result(decoderConfig.pdf417Micro.enabled)
        case Datamatrix:
            result(decoderConfig.datamatrix.enabled)
        case Code25:
            result(decoderConfig.code25.enabled)
        case Interleaved25:
            result(decoderConfig.interleaved25.enabled)
        case ITF14:
            result(decoderConfig.itf14.enabled)
        case IATA25:
            result(decoderConfig.iata25.enabled)
        case Matrix25:
            result(decoderConfig.matrix25.enabled)
        case Datalogic25:
            result(decoderConfig.datalogic25.enabled)
        case COOP25:
            result(decoderConfig.coop25.enabled)
        case Code32:
            result(decoderConfig.code32.enabled)
        case Telepen:
            result(decoderConfig.telepen.enabled)
        case Dotcode:
            result(decoderConfig.dotcode.enabled)
        case IDDocument:
            result(decoderConfig.idDocument.enabled)
        case Databar14:
            result(decoderConfig.databar14.enabled)
        case DatabarLimited:
            result(decoderConfig.databarLimited.enabled)
        case DatabarExpanded:
            result(decoderConfig.databarExpanded.enabled)
        case PostalIMB:
            result(decoderConfig.postalIMB.enabled)
        case Postnet:
            result(decoderConfig.postnet.enabled)
        case Planet:
            result(decoderConfig.planet.enabled)
        case AustralianPost:
            result(decoderConfig.australianPost.enabled)
        case RoyalMail:
            result(decoderConfig.royalMail.enabled)
        case KIX:
            result(decoderConfig.kix.enabled)
        case JapanesePost:
            result(decoderConfig.japanesePost.enabled)
        case MaxiCode:
            result(decoderConfig.maxiCode.enabled)
        default:
            result(
                FlutterError(
                    code: BarkoderFlutterErrors.BARCODE_TYPE_NOT_FOUNDED.errorCode,
                    message: BarkoderFlutterErrors.BARCODE_TYPE_NOT_FOUNDED.errorMessage,
                    details: nil
                )
            )
        }
    }
    
    private func getMulticodeCachingEnabled(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.getMulticodeCachingEnabled())
    }
    
    private func getMulticodeCachingDuration(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.getMulticodeCachingDuration())
    }
    
    private func isUpcEanDeblurEnabled(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.decoderConfig?.upcEanDeblur)
    }
    
    private func isMisshaped1DEnabled(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.decoderConfig?.enableMisshaped1D)
    }
    
    private func isVINRestrictionsEnabled(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.decoderConfig?.enableVINRestrictions)
    }
    
    private func isBarcodeThumbnailOnResultEnabled(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.barcodeThumbnailOnResult)
    }

    private func getThresholdBetweenDuplicatesScans(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.thresholdBetweenDuplicatesScans)
    }

    private func getBarkoderResolution(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.barkoderResolution.rawValue)
    }
    
    private func isDatamatrixDpmModeEnabled(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.decoderConfig?.datamatrix.dpmMode == 1 ? true : false)
    }
    
    private func isQrDpmModeEnabled(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.decoderConfig?.qr.dpmMode == 1 ? true : false)
    }
    
    private func isQrMicroDpmModeEnabled(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.decoderConfig?.qrMicro.dpmMode == 1 ? true : false)
    }
    
    private func isIdDocumentMasterChecksumEnabled(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.decoderConfig?.idDocument.masterChecksum.rawValue == 1 ? true : false)
    }
    
    private func getScanningIndicatorColorHex(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.scanningIndicatorColor.toHex())
    }
    
    private func getScanningIndicatorWidth(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.scanningIndicatorWidth)
    }
    
    private func getScanningIndicatorAnimation(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.scanningIndicatorAnimation)
    }
    
    private func isScanningIndicatorAlwaysVisible(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.scanningIndicatorAlwaysVisible)
    }
    
    private func getShowDuplicatesLocations(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.showDuplicatesLocations)
    }
    
    private func getARMode(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.arConfig.arMode.rawValue)
    }

    private func getARResultDisappearanceDelayMs(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.arConfig.resultDisappearanceDelayMs)
    }

    private func getARLocationTransitionSpeed(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.arConfig.locationTransitionSpeed)
    }

    private func getAROverlayRefresh(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.arConfig.overlayRefresh.rawValue)
    }

    private func getARSelectedLocationColor(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.arConfig.selectedLocationColor.toHex())
    }

    private func getARNonSelectedLocationColor(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.arConfig.nonSelectedLocationColor.toHex())
    }

    private func getARSelectedLocationLineWidth(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.arConfig.selectedLocationLineWidth)
    }

    private func getARNonSelectedLocationLineWidth(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.arConfig.nonSelectedLocationLineWidth)
    }

    private func getARLocationType(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.arConfig.locationType.rawValue)
    }

    private func isARDoubleTapToFreezeEnabled(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.arConfig.doubleTapToFreezeEnabled)
    }
    
    private func isARImageResultEnabled(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.arConfig.imageResultEnabled)
    }
    
    private func isARBarcodeThumbnailOnResultEnabled(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.arConfig.barcodeThumbnailOnResult)
    }

    private func getARHeaderHeight(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.arConfig.headerHeight)
    }

    private func getARHeaderShowMode(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.arConfig.headerShowMode.rawValue)
    }

    private func getARHeaderMaxTextHeight(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.arConfig.headerMaxTextHeight)
    }

    private func getARHeaderMinTextHeight(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.arConfig.headerMinTextHeight)
    }

    private func getARHeaderTextColorSelected(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.arConfig.headerTextColorSelected.toHex())
    }

    private func getARHeaderTextColorNonSelected(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.arConfig.headerTextColorNonSelected.toHex())
    }

    private func getARHeaderHorizontalTextMargin(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.arConfig.headerHorizontalTextMargin)
    }

    private func getARHeaderVerticalTextMargin(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.arConfig.headerVerticalTextMargin)
    }

    private func getARHeaderTextFormat(_ result: @escaping FlutterResult) {
        result(barkoderView.config?.arConfig.headerTextFormat)
    }
    
}

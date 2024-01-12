package com.barkoder_flutter;

import android.app.Activity;
import android.content.Context;
import android.view.View;

import com.barkoder.Barkoder;
import com.barkoder.BarkoderConfig;
import com.barkoder.BarkoderHelper;
import com.barkoder.BarkoderLog;
import com.barkoder.BarkoderView;
import com.barkoder.enums.BarkoderResolution;

import org.json.JSONObject;

import java.lang.ref.SoftReference;
import java.util.Arrays;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

@SuppressWarnings("NullableProblems") // To avoid androidX library
class BarkoderFlutterView implements PlatformView, MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private static final String TAG = BarkoderFlutterView.class.getSimpleName();

    private static final String METHOD_CHANEL_NAME = "barkoder_flutter";
    private static final String SCANNING_RESULTS_EVENT_NAME = "barkoder_flutter_scanningResultsEvent";
    private static final String LICENSE_PARAM_KEY = "licenseKey";

    private MethodChannel methodChannel;
    private EventChannel scanningResultsEvent;
    private EventChannel.EventSink scanningResultsEventSink;

    private BarkoderView bkdView;

    BarkoderFlutterView(Activity context, Map<String, Object> creationParams, BinaryMessenger binaryMessenger) {
        BarkoderLog.i(TAG, "Initializing BarkoderFlutterView");

        bkdView = new BarkoderView(context);
        configureBarkoderView(context, creationParams);

        methodChannel = new MethodChannel(binaryMessenger, METHOD_CHANEL_NAME);
        methodChannel.setMethodCallHandler(this);

        scanningResultsEvent = new EventChannel(binaryMessenger, SCANNING_RESULTS_EVENT_NAME);
        // If we have more events in the future we will need to create local callbacks
        scanningResultsEvent.setStreamHandler(this);
    }

    @Override
    public View getView() {
        BarkoderLog.i(TAG, "get BarkoderFlutterView");

        return bkdView;
    }

    @Override
    public void dispose() {
        BarkoderLog.i(TAG, "dispose BarkoderFlutterView");

        scanningResultsEvent.setStreamHandler(null);
        methodChannel.setMethodCallHandler(null);
        bkdView.stopScanning();

        scanningResultsEventSink = null;
        scanningResultsEvent = null;
        methodChannel = null;
        bkdView = null;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        scanningResultsEventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        //NO-OP
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (bkdView == null) {
            sendErrorResult(BarkoderFlutterErrors.BARKODER_VIEW_DESTROYED, null, result);
            return;
        }

        switch (call.method) {
            case "getMaxZoomFactor":
                getMaxZoomFactor(result);
                break;
            case "setZoomFactor":
                setZoomFactor((double) call.arguments, result);
                break;
            case "isFlashAvailable":
                isFlashAvailable(result);
                break;
            case "setFlashEnabled":
                setFlashEnabled((boolean) call.arguments, result);
                break;
            case "startCamera":
                startCamera(result);
                break;
            case "startScanning":
                startScanning(result);
                break;
            case "stopScanning":
                stopScanning(result);
                break;
            case "pauseScanning":
                pauseScanning(result);
                break;
            case "getLocationLineColorHex":
                getLocationLineColorHex(result);
                break;
            case "setLocationLineColor":
                setLocationLineColor((String) call.arguments, result);
                break;
            case "getLocationLineWidth":
                getLocationLineWidth(result);
                break;
            case "setLocationLineWidth":
                setLocationLineWidth((double) call.arguments, result);
                break;
            case "getRoiLineColorHex":
                getRoiLineColorHex(result);
                break;
            case "setRoiLineColor":
                setRoiLineColor((String) call.arguments, result);
                break;
            case "getRoiLineWidth":
                getRoiLineWidth(result);
                break;
            case "setRoiLineWidth":
                setRoiLineWidth((double) call.arguments, result);
                break;
            case "getRoiOverlayBackgroundColorHex":
                getRoiOverlayBackgroundColorHex(result);
                break;
            case "setRoiOverlayBackgroundColor":
                setRoiOverlayBackgroundColor((String) call.arguments, result);
                break;
            case "isCloseSessionOnResultEnabled":
                isCloseSessionOnResultEnabled(result);
                break;
            case "setCloseSessionOnResultEnabled":
                setCloseSessionOnResultEnabled((boolean) call.arguments, result);
                break;
            case "isImageResultEnabled":
                isImageResultEnabled(result);
                break;
            case "setImageResultEnabled":
                setImageResultEnabled((boolean) call.arguments, result);
                break;
            case "isLocationInImageResultEnabled":
                isLocationInImageResultEnabled(result);
                break;
            case "setLocationInImageResultEnabled":
                setLocationInImageResultEnabled((boolean) call.arguments, result);
                break;
            case "getRegionOfInterest":
                getRegionOfInterest(result);
                break;
            case "setRegionOfInterest":
                // Intentional
                // noinspection ConstantConditions
                setRegionOfInterest(call.argument("left"), call.argument("top"),
                        call.argument("width"), call.argument("height"), result);
                break;
            case "getThreadsLimit":
                getThreadsLimit(result);
                break;
            case "setThreadsLimit":
                setThreadsLimit((int) call.arguments, result);
                break;
            case "isLocationInPreviewEnabled":
                isLocationInPreviewEnabled(result);
                break;
            case "setLocationInPreviewEnabled":
                setLocationInPreviewEnabled((boolean) call.arguments, result);
                break;
            case "isPinchToZoomEnabled":
                isPinchToZoomEnabled(result);
                break;
            case "setPinchToZoomEnabled":
                setPinchToZoomEnabled((boolean) call.arguments, result);
                break;
            case "isRegionOfInterestVisible":
                isRegionOfInterestVisible(result);
                break;
            case "setRegionOfInterestVisible":
                setRegionOfInterestVisible((boolean) call.arguments, result);
                break;
            case "getBarkoderResolution":
                getBarkoderResolution(result);
                break;
            case "setBarkoderResolution":
                setBarkoderResolution((int) call.arguments, result);
                break;
            case "isBeepOnSuccessEnabled":
                isBeepOnSuccessEnabled(result);
                break;
            case "setBeepOnSuccessEnabled":
                setBeepOnSuccessEnabled((boolean) call.arguments, result);
                break;
            case "isVibrateOnSuccessEnabled":
                isVibrateOnSuccessEnabled(result);
                break;
            case "setVibrateOnSuccessEnabled":
                setVibrateOnSuccessEnabled((boolean) call.arguments, result);
                break;
            case "getVersion":
                getVersion(result);
                break;
            case "showLogMessages":
                showLogMessages((boolean) call.arguments, result);
                break;
            case "isBarcodeTypeEnabled":
                isBarcodeTypeEnabled((int) call.arguments, result);
                break;
            case "setBarcodeTypeEnabled":
                // Intentional
                // noinspection ConstantConditions
                setBarcodeTypeEnabled(call.argument("type"), call.argument("enabled"), result);
                break;
            case "getBarcodeTypeLengthRange":
                getBarcodeTypeLengthRange((int) call.arguments, result);
                break;
            case "setBarcodeTypeLengthRange":
                // Intentional
                // noinspection ConstantConditions
                setBarcodeTypeLengthRange(call.argument("type"), call.argument("min"),
                        call.argument("max"), result);
                break;
            case "getMsiChecksumType":
                getMsiChecksumType(result);
                break;
            case "setMsiChecksumType":
                setMsiChecksumType((int) call.arguments, result);
                break;
            case "getCode39ChecksumType":
                getCode39ChecksumType(result);
                break;
            case "setCode39ChecksumType":
                setCode39ChecksumType((int) call.arguments, result);
                break;
            case "getCode11ChecksumType":
                getCode11ChecksumType(result);
                break;
            case "setCode11ChecksumType":
                setCode11ChecksumType((int) call.arguments, result);
                break;
            case "getEncodingCharacterSet":
                getEncodingCharacterSet(result);
                break;
            case "setEncodingCharacterSet":
                setEncodingCharacterSet((String) call.arguments, result);
                break;
            case "getDecodingSpeed":
                getDecodingSpeed(result);
                break;
            case "setDecodingSpeed":
                setDecodingSpeed((int) call.arguments, result);
                break;
            case "getFormattingType":
                getFormattingType(result);
                break;
            case "setFormattingType":
                setFormattingType((int) call.arguments, result);
                break;
            case "setMaximumResultsCount":
                setMaximumResultsCount((int) call.arguments, result);
                break;
            case "getMaximumResultsCount":
                getMaximumResultsCount(result);
                break;
            case "setDuplicatesDelayMs":
                setDuplicatesDelayMs((int) call.arguments, result);
                break;
            case "getDuplicatesDelayMs":
                getDuplicatesDelayMs(result);
                break;
            case "setMulticodeCachingDuration":
                setMulticodeCachingDuration((int) call.arguments, result);
                break;
            case "setMulticodeCachingEnabled":
                setMulticodeCachingEnabled((boolean) call.arguments, result);
                break;
            case "setBarcodeThumbnailOnResultEnabled":
                setBarcodeThumbnailOnResultEnabled((boolean) call.arguments, result);
                break;
            case "setThresholdBetweenDuplicatesScans":
                setThresholdBetweenDuplicatesScans((int) call.arguments, result);
                break;
            case "setUpcEanDeblurEnabled":
                setUpcEanDeblurEnabled((boolean) call.arguments, result);
                break;
            case "setMisshaped1DEnabled":
                setMisshaped1DEnabled((boolean) call.arguments, result);
                break;
            case "setEnableVINRestrictions":
                setEnableVINRestrictions((boolean) call.arguments, result);
                break;
            case "isMisshaped1DEnabled":
                isMisshaped1DEnabled(result);
                break;
            case "isVINRestrictionsEnabled":
                isVINRestrictionsEnabled(result);
                break;
            case "isUpcEanDeblurEnabled":
                isUpcEanDeblurEnabled(result);
                break;
            case "isBarcodeThumbnailOnResultEnabled":
                isBarcodeThumbnailOnResultEnabled(result);
                break;
            case "getThresholdBetweenDuplicatesScans":
                getThresholdBetweenDuplicatesScans(result);
                break;
            case "configureBarkoder": //UNTIL THIS ONE TESTED
                configureBarkoder((String) call.arguments, result);
                break;
            default:
                result.notImplemented();
        }
    }

    //region Methods

    private void getVersion(MethodChannel.Result methodResult) {
        methodResult.success(Barkoder.GetVersion());
    }

    private void setVibrateOnSuccessEnabled(boolean enabled, MethodChannel.Result methodResult) {
        bkdView.config.setVibrateOnSuccessEnabled(enabled);

        methodResult.success(null);
    }

    private void isVibrateOnSuccessEnabled(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.isVibrateOnSuccessEnabled());
    }

    private void setBeepOnSuccessEnabled(boolean enabled, MethodChannel.Result methodResult) {
        bkdView.config.setBeepOnSuccessEnabled(enabled);

        methodResult.success(null);
    }

    private void isBeepOnSuccessEnabled(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.isBeepOnSuccessEnabled());
    }

    private void setBarkoderResolution(int resolutionIndex, MethodChannel.Result methodResult) {
        try {
            BarkoderResolution bkdResolution = BarkoderResolution.values()[resolutionIndex];
            bkdView.config.setBarkoderResolution(bkdResolution);

            methodResult.success(null);
        } catch (Exception ex) {
            sendErrorResult(BarkoderFlutterErrors.INVALID_RESOLUTION, ex.getMessage(), methodResult);
        }
    }

    private void getBarkoderResolution(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.getBarkoderResolution().ordinal());
    }

    private void setRegionOfInterestVisible(boolean visible, MethodChannel.Result methodResult) {
        bkdView.config.setRegionOfInterestVisible(visible);

        methodResult.success(null);
    }

    private void isRegionOfInterestVisible(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.isRegionOfInterestVisible());
    }

    private void setPinchToZoomEnabled(boolean enabled, MethodChannel.Result methodResult) {
        bkdView.config.setPinchToZoomEnabled(enabled);

        methodResult.success(null);
    }

    private void isPinchToZoomEnabled(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.isPinchToZoomEnabled());
    }

    private void setLocationInPreviewEnabled(boolean enabled, MethodChannel.Result methodResult) {
        bkdView.config.setLocationInPreviewEnabled(enabled);

        methodResult.success(null);
    }

    private void isLocationInPreviewEnabled(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.isLocationInPreviewEnabled());
    }

    private void setThreadsLimit(int threadsLimit, MethodChannel.Result methodResult) {
        try {
            BarkoderConfig.SetThreadsLimit(threadsLimit);

            methodResult.success(null);
        } catch (IllegalArgumentException ex) {
            sendErrorResult(BarkoderFlutterErrors.THREADS_LIMIT_NOT_SET, ex.getMessage(), methodResult);
        }
    }

    private void getThreadsLimit(MethodChannel.Result methodResult) {
        methodResult.success(BarkoderConfig.GetThreadsLimit());
    }

    private void setRegionOfInterest(double left, double top, double width, double height, MethodChannel.Result methodResult) {
        try {
            bkdView.config.setRegionOfInterest((float) left, (float) top, (float) width, (float) height);

            methodResult.success(null);
        } catch (IllegalArgumentException ex) {
            sendErrorResult(BarkoderFlutterErrors.ROI_NOT_SET, ex.getMessage(), methodResult);
        }
    }

    private void getRegionOfInterest(MethodChannel.Result methodResult) {
        Barkoder.BKRect roiRect = bkdView.config.getRegionOfInterest();

        methodResult.success(new float[]{
                roiRect.left, roiRect.top, roiRect.width, roiRect.height
        });
    }

    private void setLocationInImageResultEnabled(boolean enabled, MethodChannel.Result methodResult) {
        bkdView.config.setLocationInImageResultEnabled(enabled);

        methodResult.success(null);
    }

    private void isLocationInImageResultEnabled(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.isLocationInImageResultEnabled());
    }

    private void setImageResultEnabled(boolean enabled, MethodChannel.Result methodResult) {
        bkdView.config.setImageResultEnabled(enabled);

        methodResult.success(null);
    }

    private void isImageResultEnabled(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.isImageResultEnabled());
    }

    private void setCloseSessionOnResultEnabled(boolean enabled, MethodChannel.Result methodResult) {
        bkdView.config.setCloseSessionOnResultEnabled(enabled);

        methodResult.success(null);
    }

    private void isCloseSessionOnResultEnabled(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.isCloseSessionOnResultEnabled());
    }

    private void setRoiOverlayBackgroundColor(String hexColor, MethodChannel.Result methodResult) {
        try {
            bkdView.config.setRoiOverlayBackgroundColor(Util.hexColorToIntColor(hexColor));

            methodResult.success(null);
        } catch (IllegalArgumentException ex) {
            sendErrorResult(BarkoderFlutterErrors.COLOR_NOT_SET, ex.getMessage(), methodResult);
        }
    }

    private void getRoiOverlayBackgroundColorHex(MethodChannel.Result methodResult) {
        String hexColor = String.format("#%08X", bkdView.config.getRoiOverlayBackgroundColor());

        methodResult.success(hexColor);
    }

    private void setRoiLineWidth(double width, MethodChannel.Result methodResult) {
        bkdView.config.setRoiLineWidth((float) width);

        methodResult.success(null);
    }

    private void getRoiLineWidth(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.getRoiLineWidth());
    }

    private void setRoiLineColor(String hexColor, MethodChannel.Result methodResult) {
        try {
            bkdView.config.setRoiLineColor(Util.hexColorToIntColor(hexColor));

            methodResult.success(null);
        } catch (IllegalArgumentException ex) {
            sendErrorResult(BarkoderFlutterErrors.COLOR_NOT_SET, ex.getMessage(), methodResult);
        }
    }

    private void getRoiLineColorHex(MethodChannel.Result methodResult) {
        String hexColor = String.format("#%08X", bkdView.config.getRoiLineColor());

        methodResult.success(hexColor);
    }

    private void setLocationLineWidth(double width, MethodChannel.Result methodResult) {
        bkdView.config.setLocationLineWidth((float) width);

        methodResult.success(null);
    }

    private void getLocationLineWidth(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.getLocationLineWidth());
    }

    private void setLocationLineColor(String hexColor, MethodChannel.Result methodResult) {
        try {
            bkdView.config.setLocationLineColor(Util.hexColorToIntColor(hexColor));

            methodResult.success(null);
        } catch (IllegalArgumentException ex) {
            sendErrorResult(BarkoderFlutterErrors.COLOR_NOT_SET, ex.getMessage(), methodResult);
        }
    }

    private void getLocationLineColorHex(MethodChannel.Result methodResult) {
        String hexColor = String.format("#%08X", bkdView.config.getLocationLineColor());

        methodResult.success(hexColor);
    }

    private void pauseScanning(MethodChannel.Result methodResult) {
        bkdView.pauseScanning();

        methodResult.success(null);
    }

    private void stopScanning(MethodChannel.Result methodResult) {
        bkdView.stopScanning();

        methodResult.success(null);
    }

    private void startScanning(MethodChannel.Result methodResult) {
        SoftReference<EventChannel.EventSink> scanningResultsEventSinkRef = new SoftReference<>(scanningResultsEventSink);

        bkdView.startScanning((results, thumbnails, resultImage) -> {
            EventChannel.EventSink sink = scanningResultsEventSinkRef.get();
            if (sink != null)
                sink.success(Util.barkoderResultsToJsonString(results, resultImage));
        });

        methodResult.success(null);
    }

    private void startCamera(MethodChannel.Result methodResult) {
        bkdView.startCamera();

        methodResult.success(null);
    }

    private void setFlashEnabled(boolean enabled, MethodChannel.Result methodResult) {
        bkdView.setFlashEnabled(enabled);

        methodResult.success(null);
    }

    private void isFlashAvailable(MethodChannel.Result methodResult) {
        bkdView.isFlashAvailable(methodResult::success);
    }

    private void setZoomFactor(double factor, MethodChannel.Result methodResult) {
        bkdView.setZoomFactor((float) factor);

        methodResult.success(null);
    }

    private void getMaxZoomFactor(MethodChannel.Result methodResult) {
        bkdView.getMaxZoomFactor(methodResult::success);
    }

    private void showLogMessages(boolean show, MethodChannel.Result methodResult) {
        BarkoderConfig.LogsEnabled = show;

        methodResult.success(null);
    }

    private void isBarcodeTypeEnabled(int barcodeTypeOrdinal, MethodChannel.Result methodResult) {
        try {
            final Barkoder.SpecificConfig specificConfig = Util.getSpecificConfigRefFromBarcodeTypeOrdinal(barcodeTypeOrdinal,
                    bkdView.config.getDecoderConfig());

            if (specificConfig != null) {
                methodResult.success(specificConfig.enabled);
            } else {
                sendErrorResult(BarkoderFlutterErrors.BARCODE_TYPE_NOT_FOUNDED, null, methodResult);
            }
        } catch (Exception ex) {
            sendErrorResult(BarkoderFlutterErrors.BARCODE_TYPE_NOT_FOUNDED, ex.getMessage(), methodResult);
        }
    }

    private void setBarcodeTypeEnabled(int barcodeTypeOrdinal, boolean enabled, MethodChannel.Result methodResult) {
        try {
            final Barkoder.SpecificConfig specificConfig = Util.getSpecificConfigRefFromBarcodeTypeOrdinal(barcodeTypeOrdinal,
                    bkdView.config.getDecoderConfig());

            if (specificConfig != null) {
                specificConfig.enabled = enabled;
                methodResult.success(null);
            } else {
                sendErrorResult(BarkoderFlutterErrors.BARCODE_TYPE_NOT_FOUNDED, null, methodResult);
            }
        } catch (Exception ex) {
            sendErrorResult(BarkoderFlutterErrors.BARCODE_TYPE_NOT_FOUNDED, ex.getMessage(), methodResult);
        }
    }

    private void getBarcodeTypeLengthRange(int barcodeTypeOrdinal, MethodChannel.Result methodResult) {
        if (barcodeTypeOrdinal == Barkoder.BarcodeType.Code128.ordinal() ||
                barcodeTypeOrdinal == Barkoder.BarcodeType.Code93.ordinal() ||
                barcodeTypeOrdinal == Barkoder.BarcodeType.Code39.ordinal() ||
                barcodeTypeOrdinal == Barkoder.BarcodeType.Codabar.ordinal() ||
                barcodeTypeOrdinal == Barkoder.BarcodeType.Code11.ordinal() ||
                barcodeTypeOrdinal == Barkoder.BarcodeType.Msi.ordinal()) {
            try {
                final Barkoder.SpecificConfig specificConfig = Util.getSpecificConfigRefFromBarcodeTypeOrdinal(barcodeTypeOrdinal,
                        bkdView.config.getDecoderConfig());

                if (specificConfig != null) {
                    methodResult.success(Arrays.asList(specificConfig.minimumLength, specificConfig.maximumLength));
                } else {
                    sendErrorResult(BarkoderFlutterErrors.BARCODE_TYPE_NOT_FOUNDED, null, methodResult);
                }
            } catch (Exception ex) {
                sendErrorResult(BarkoderFlutterErrors.BARCODE_TYPE_NOT_FOUNDED, ex.getMessage(), methodResult);
            }
        } else {
            sendErrorResult(BarkoderFlutterErrors.BARCODE_TYPE_NOT_SUPPORTED, null, methodResult);
        }
    }

    private void setBarcodeTypeLengthRange(int barcodeTypeOrdinal, int min, int max, MethodChannel.Result methodResult) {
        if (barcodeTypeOrdinal == Barkoder.BarcodeType.Code128.ordinal() ||
                barcodeTypeOrdinal == Barkoder.BarcodeType.Code93.ordinal() ||
                barcodeTypeOrdinal == Barkoder.BarcodeType.Code39.ordinal() ||
                barcodeTypeOrdinal == Barkoder.BarcodeType.Codabar.ordinal() ||
                barcodeTypeOrdinal == Barkoder.BarcodeType.Code11.ordinal() ||
                barcodeTypeOrdinal == Barkoder.BarcodeType.Msi.ordinal()) {
            try {
                final Barkoder.SpecificConfig specificConfig = Util.getSpecificConfigRefFromBarcodeTypeOrdinal(barcodeTypeOrdinal,
                        bkdView.config.getDecoderConfig());

                if (specificConfig != null) {
                    if (specificConfig.setLengthRange(min, max) == 0)
                        methodResult.success(null);
                    else
                        sendErrorResult(BarkoderFlutterErrors.LENGTH_RANGE_NOT_VALID, null, methodResult);
                } else {
                    sendErrorResult(BarkoderFlutterErrors.BARCODE_TYPE_NOT_FOUNDED, null, methodResult);
                }
            } catch (Exception ex) {
                sendErrorResult(BarkoderFlutterErrors.BARCODE_TYPE_NOT_FOUNDED, ex.getMessage(), methodResult);
            }
        } else {
            sendErrorResult(BarkoderFlutterErrors.BARCODE_TYPE_NOT_SUPPORTED, null, methodResult);
        }
    }

    private void getMsiChecksumType(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.getDecoderConfig().Msi.checksumType.ordinal());
    }

    private void setMsiChecksumType(int checksumTypeOrdinal, MethodChannel.Result methodResult) {
        try {
            bkdView.config.getDecoderConfig().Msi.checksumType = Barkoder.MsiChecksumType.valueOf(checksumTypeOrdinal);

            methodResult.success(null);
        } catch (Exception ex) {
            sendErrorResult(BarkoderFlutterErrors.CHECKSUM_TYPE_NOT_FOUNDED, ex.getMessage(), methodResult);
        }
    }

    private void getCode39ChecksumType(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.getDecoderConfig().Code39.checksumType.ordinal());
    }

    private void setCode39ChecksumType(int checksumTypeOrdinal, MethodChannel.Result methodResult) {
        try {
            bkdView.config.getDecoderConfig().Code39.checksumType = Barkoder.Code39ChecksumType.valueOf(checksumTypeOrdinal);

            methodResult.success(null);
        } catch (Exception ex) {
            sendErrorResult(BarkoderFlutterErrors.CHECKSUM_TYPE_NOT_FOUNDED, ex.getMessage(), methodResult);
        }
    }

    private void getCode11ChecksumType(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.getDecoderConfig().Code11.checksumType.ordinal());
    }

    private void setCode11ChecksumType(int checksumTypeOrdinal, MethodChannel.Result methodResult) {
        try {
            bkdView.config.getDecoderConfig().Code11.checksumType = Barkoder.Code11ChecksumType.valueOf(checksumTypeOrdinal);

            methodResult.success(null);
        } catch (Exception ex) {
            sendErrorResult(BarkoderFlutterErrors.CHECKSUM_TYPE_NOT_FOUNDED, ex.getMessage(), methodResult);
        }
    }

    private void getEncodingCharacterSet(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.getDecoderConfig().encodingCharacterSet);
    }

    private void setEncodingCharacterSet(String characterSet, MethodChannel.Result methodResult) {
        bkdView.config.getDecoderConfig().encodingCharacterSet = characterSet;

        methodResult.success(null);
    }

    private void getDecodingSpeed(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.getDecoderConfig().decodingSpeed.ordinal());
    }

    private void setDecodingSpeed(int decodingSpeedOrdinal, MethodChannel.Result methodResult) {
        try {
            bkdView.config.getDecoderConfig().decodingSpeed = Barkoder.DecodingSpeed.valueOf(decodingSpeedOrdinal);

            methodResult.success(null);
        } catch (Exception ex) {
            sendErrorResult(BarkoderFlutterErrors.DECODING_SPEED_NOT_FOUNDED, ex.getMessage(), methodResult);
        }
    }

    private void getFormattingType(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.getDecoderConfig().formattingType.ordinal());
    }

    private void setFormattingType(int formattingTypeOrdinal, MethodChannel.Result methodResult) {
        try {
            bkdView.config.getDecoderConfig().formattingType = Barkoder.FormattingType.valueOf(formattingTypeOrdinal);

            methodResult.success(null);
        } catch (Exception ex) {
            sendErrorResult(BarkoderFlutterErrors.FORMATTING_TYPE_NOT_FOUNDED, ex.getMessage(), methodResult);
        }
    }

    private void setMaximumResultsCount(int maximumResultsCount, MethodChannel.Result methodResult) {
        try {
            bkdView.config.getDecoderConfig().maximumResultsCount = maximumResultsCount;
            
            methodResult.success(null);
        } catch (Exception ex) {
            sendErrorResult(BarkoderFlutterErrors.MAXIMUM_RESULTS_TYPE_NOT_FOUNDED, ex.getMessage(), methodResult);
        }
    }

    private void getMaximumResultsCount(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.getDecoderConfig().maximumResultsCount);
    }

    private void setDuplicatesDelayMs(int duplicatesDelayMs, MethodChannel.Result methodResult) {
        try {
            bkdView.config.getDecoderConfig().duplicatesDelayMs = duplicatesDelayMs;
            
            methodResult.success(null);
        } catch (Exception ex) {
            sendErrorResult(BarkoderFlutterErrors.DUPLICATES_DELAY_NOT_FOUNDED, ex.getMessage(), methodResult);
        }
    }

    private void getDuplicatesDelayMs(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.getDecoderConfig().duplicatesDelayMs);
    }

    private void setMulticodeCachingDuration(int multicodeCachingDuration, MethodChannel.Result methodResult) {
        BarkoderConfig.SetMulticodeCachingDuration(multicodeCachingDuration);

        methodResult.success(null);
    }

    private void setMulticodeCachingEnabled(boolean multicodeCachingEnabled, MethodChannel.Result methodResult) {
        BarkoderConfig.SetMulticodeCachingEnabled(multicodeCachingEnabled);

        methodResult.success(null);
    }

    private void setBarcodeThumbnailOnResultEnabled(boolean barcodeThumbnailOnResultEnabled, MethodChannel.Result methodResult) {
        bkdView.config.setThumbnailOnResultEnabled(barcodeThumbnailOnResultEnabled);

        methodResult.success(null);
    }

    private void setThresholdBetweenDuplicatesScans(int thresholdBetweenDuplicatesScans, MethodChannel.Result methodResult) {
        bkdView.config.setThresholdBetweenDuplicatesScans(thresholdBetweenDuplicatesScans);

        methodResult.success(null);
    }

    private void setUpcEanDeblurEnabled(boolean upcEanDeblurEnabled, MethodChannel.Result methodResult) {
        bkdView.config.getDecoderConfig().upcEanDeblur = upcEanDeblurEnabled;

        methodResult.success(null);
    }

    private void setMisshaped1DEnabled(boolean misshaped1DEnabled, MethodChannel.Result methodResult) {
        bkdView.config.getDecoderConfig().enableMisshaped1D = misshaped1DEnabled;

        methodResult.success(null);
    }

    private void setEnableVINRestrictions(boolean enableVINRestrictions, MethodChannel.Result methodResult) {
        bkdView.config.getDecoderConfig().enableVINRestrictions = enableVINRestrictions;

        methodResult.success(null);
    }

    private void isMisshaped1DEnabled(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.getDecoderConfig().enableMisshaped1D);
    }

    private void isVINRestrictionsEnabled(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.getDecoderConfig().enableVINRestrictions);
    }

    private void isUpcEanDeblurEnabled(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.getDecoderConfig().upcEanDeblur);
    }

    private void isBarcodeThumbnailOnResultEnabled(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.getThumbnailOnResulEnabled());
    }

    private void getThresholdBetweenDuplicatesScans(MethodChannel.Result methodResult) {
        methodResult.success(bkdView.config.getThresholdBetweenDuplicatesScans());
    }

    private void configureBarkoder(String barkoderConfigAsJsonString, MethodChannel.Result methodResult) {
        try {
            JSONObject configAsJson = new JSONObject(barkoderConfigAsJsonString);

            // Its easier for the users to send us hex color from the cross platform

            if (configAsJson.has("roiLineColor")) {
                String colorAsHex = configAsJson.getString("roiLineColor");
                configAsJson.put("roiLineColor", Util.hexColorToIntColor(colorAsHex));
            }

            if (configAsJson.has("roiOverlayBackgroundColor")) {
                String colorAsHex = configAsJson.getString("roiOverlayBackgroundColor");
                configAsJson.put("roiOverlayBackgroundColor", Util.hexColorToIntColor(colorAsHex));
            }

            if (configAsJson.has("locationLineColor")) {
                String colorAsHex = configAsJson.getString("locationLineColor");
                configAsJson.put("locationLineColor", Util.hexColorToIntColor(colorAsHex));
            }

            BarkoderHelper.applyJsonToConfig(bkdView.config, configAsJson);

            methodResult.success(null);
        } catch (Exception ex) {
            sendErrorResult(BarkoderFlutterErrors.BARKODER_CONFIG_IS_NOT_VALID, ex.getMessage(), methodResult);
        }
    }

    //endregion Methods

    //region Helper f-ons

    private void configureBarkoderView(Context context, Map<String, Object> creationParams) {
        bkdView.config = createConfig(context, creationParams);
    }

    private BarkoderConfig createConfig(Context context, Map<String, Object> creationParams) {
        // Its required
        @SuppressWarnings("ConstantConditions")
        String licenseKey = creationParams.get(LICENSE_PARAM_KEY).toString();

        return new BarkoderConfig(context, licenseKey, licenseCheckResult ->
                BarkoderLog.i(TAG, "LICENSE RESULT: " + licenseCheckResult.message));
    }

    private void sendErrorResult(BarkoderFlutterErrors error, String message, MethodChannel.Result result) {
        result.error(error.getErrorCode(), error.getErrorMessage()
                + (message != null ? message : ""), null);
    }

    //endregion Helper f-ons
}

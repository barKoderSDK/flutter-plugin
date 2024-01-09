package com.barkoder_flutter;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

@SuppressWarnings("NullableProblems") // To avoid androidX library
public class BarkoderFlutterPlugin implements FlutterPlugin, ActivityAware {
    private static final String TAG = BarkoderFlutterPlugin.class.getSimpleName();

    private static final String BARKODER_VIEW_TYPE_ID = "BarkoderNativeView";
    private FlutterPluginBinding flutterPluginBinding;

    @Override
    public void onAttachedToEngine(FlutterPluginBinding flutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding;
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        flutterPluginBinding = null;
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        flutterPluginBinding
                .getPlatformViewRegistry()
                .registerViewFactory(BARKODER_VIEW_TYPE_ID, new BarkoderFlutterViewFactory(binding.getActivity(), flutterPluginBinding.getBinaryMessenger()));
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        // NO-OP
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        // NO-OP
    }

    @Override
    public void onDetachedFromActivity() {
        // NO-OP
    }
}

package com.barkoder_flutter;

import android.app.Activity;
import android.content.Context;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

@SuppressWarnings("NullableProblems") // To avoid androidX library
class BarkoderFlutterViewFactory extends PlatformViewFactory {
    private final Activity parentActivity;
    private final BinaryMessenger binaryMessenger;

    BarkoderFlutterViewFactory(Activity parentActivity, BinaryMessenger binaryMessenger) {
        super(StandardMessageCodec.INSTANCE);
        this.parentActivity = parentActivity;
        this.binaryMessenger = binaryMessenger;
    }

    @Override
    public PlatformView create(Context context, int id, Object args) {
        final Map<String, Object> creationParams = (Map<String, Object>) args;

        return new BarkoderFlutterView(parentActivity, creationParams, binaryMessenger);
    }
}

package com.xiaopeng.tool.xp_tool;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

/**
 * 下载插件
 */
public class XpDownloadPlugin implements FlutterPlugin, MethodCallHandler {

    private MethodChannel mMethodChannel;

    private Context mContext;

    Handler handler = new Handler(Looper.getMainLooper());

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        mMethodChannel = new MethodChannel(binding.getBinaryMessenger(), "xp_downloader");
        mMethodChannel.setMethodCallHandler(this);

        mContext = binding.getApplicationContext();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "enqueue":
                break;
            case "cancel":
                break;
            case "pause":
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void enqueue(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        String url = call.argument("url");
        String directory = call.argument("directory");
        String fileName = call.argument("fileName");

        if (TextUtils.isEmpty(url) || TextUtils.isEmpty(directory) || TextUtils.isEmpty(fileName)) {
            result.error("-1", "invalid url, directory or fileName", null);
            return;
        }


        SystemDownloadHelper.startDownload(mContext, url, directory, fileName, false, new SystemDownloadHelper.OnSysDownloadStateChangeListener() {
            @Override
            public void onSuccess(long downloadId) {
                handler.post(() -> {
                    mMethodChannel.invokeMethod("onComplete", Collections.emptyMap());
                });
            }

            @Override
            public void onFail(long downloadId) {
                handler.post(() -> {
                    mMethodChannel.invokeMethod("onFailed", Collections.emptyMap());
                });
            }

            @Override
            public void onCancel(long downloadId) {
                handler.post(() -> {
                    mMethodChannel.invokeMethod("onCanceled", Collections.emptyMap());
                });
            }

            @Override
            public void onPending(long downloadId) {
                handler.post(() -> {
                    mMethodChannel.invokeMethod("onPending", Collections.emptyMap());
                });
            }

            @Override
            public void onRunning(long downloadId, double percent) {
                handler.post(() -> {
                    Map<String, Object> info = new HashMap<>();
                    info.put("progress", percent);
                    mMethodChannel.invokeMethod("onProgress", info);
                });
            }

            @Override
            public void onPause() {
                handler.post(() -> {
                    mMethodChannel.invokeMethod("onPause", Collections.emptyMap());
                });
            }

            @Override
            public void onStart() {
                handler.post(() -> {
                    mMethodChannel.invokeMethod("onStart", Collections.emptyMap());
                });
            }
        });
    }


}

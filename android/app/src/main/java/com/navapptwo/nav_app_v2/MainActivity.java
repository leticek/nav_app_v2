package com.navapptwo.nav_app_v2;

import androidx.annotation.NonNull;

import com.garmin.android.connectiq.ConnectIQ;
import com.garmin.android.connectiq.IQDevice;
import com.garmin.android.connectiq.exception.InvalidStateException;
import com.garmin.android.connectiq.exception.ServiceUnavailableException;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

import static java.util.Map.entry;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL_NAME = "commChannel";
    private static final String STREAM_NAME = "eventChannel";
    private ConnectIQ connectIQInstance;
    private EventChannel.EventSink eventSink;
    private List<IQDevice> availableDevices;
    private List<String> availableStringDevices;
    private IQDevice activeDevice;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL_NAME).setMethodCallHandler((call, result) -> {
            switch (call.method) {
                case "initSDK":
                    this.initSDK();
                    break;
                case "getDevices":
                    this.getAvailableDevices();
                    break;
            }
        });

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), STREAM_NAME).setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                eventSink = events;
            }

            @Override
            public void onCancel(Object arguments) {

            }
        });
    }

    private void getAvailableDevices() {
        if (this.connectIQInstance != null) {
            try {
                availableDevices = connectIQInstance.getConnectedDevices();
                availableStringDevices = new ArrayList<>();
                for (IQDevice device : availableDevices) {
                    availableStringDevices.add(device.getFriendlyName());
                }
                Map<String, Object> response = Map.ofEntries(entry("response", 3), entry("payload", availableStringDevices));
                eventSink.success(response);
            } catch (InvalidStateException e) {
                e.printStackTrace();
            } catch (ServiceUnavailableException e) {
                e.printStackTrace();
            }
        }
    }

    private void setDevice() {
        if (this.connectIQInstance != null) {
            try {
                availableDevices = connectIQInstance.getConnectedDevices();
                if (!availableDevices.isEmpty()) {
                    this.activeDevice = availableDevices.get(0);
                    this.connectIQInstance.registerForDeviceEvents(this.activeDevice, (iqDevice, iqDeviceStatus) -> {
                        if (iqDeviceStatus == IQDevice.IQDeviceStatus.CONNECTED) {
                            Map<String, Object> response = Map.ofEntries(entry("response", 4), entry("payload", this.activeDevice.getFriendlyName()));
                            eventSink.success(response);
                        } else if (iqDeviceStatus == IQDevice.IQDeviceStatus.NOT_CONNECTED) {
                            Map<String, Object> response = Map.ofEntries(entry("response", 4), entry("payload", "Hodinky nepřipojeny"));
                            eventSink.success(response);
                        } else if (iqDeviceStatus == IQDevice.IQDeviceStatus.NOT_PAIRED) {
                            Map<String, Object> response = Map.ofEntries(entry("response", 4), entry("payload", "Hodinky nespárovány"));
                            eventSink.success(response);
                        } else {
                            Map<String, Object> response = Map.ofEntries(entry("response", 4), entry("payload", "Stav připojení není znám"));
                            eventSink.success(response);
                        }
                    });
                }
            } catch (InvalidStateException e) {
                e.printStackTrace();
            } catch (ServiceUnavailableException e) {
                e.printStackTrace();
            }
        }
    }

    private void initSDK() {
        System.out.println("init SDK");
        this.connectIQInstance = ConnectIQ.getInstance(this, ConnectIQ.IQConnectType.WIRELESS);
        connectIQInstance.initialize(this, true, new ConnectIQ.ConnectIQListener() {
            @Override
            public void onSdkReady() {
                Map<String, Object> response = Map.ofEntries(entry("response", 1));
                System.out.println(response);
                eventSink.success(response);
                setDevice();
            }

            @Override
            public void onInitializeError(ConnectIQ.IQSdkErrorStatus iqSdkErrorStatus) {
                Map<String, Object> response = Map.ofEntries(entry("response", 2));
                eventSink.success(response);
            }

            @Override
            public void onSdkShutDown() {
                try {
                    connectIQInstance.unregisterAllForEvents();
                    System.out.println("SDK SHUTDOWN");
                } catch (InvalidStateException e) {
                    e.printStackTrace();
                }
            }
        });
    }
}

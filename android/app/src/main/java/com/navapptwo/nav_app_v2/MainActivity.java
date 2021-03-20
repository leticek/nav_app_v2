package com.navapptwo.nav_app_v2;


import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.garmin.android.connectiq.ConnectIQ;
import com.garmin.android.connectiq.IQApp;
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
    private IQDevice activeDevice;
    private final IQApp garminApplication = new IQApp("199253b5-157b-4c2c-93e5-833af0af44e1");

    @RequiresApi(api = Build.VERSION_CODES.R)
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
                case "openApp":
                    this.openGarminApp();
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

    @RequiresApi(api = Build.VERSION_CODES.R)
    private void openGarminApp() {
        try {
            this.connectIQInstance.openApplication(this.activeDevice, this.garminApplication, (iqDevice, iqApp, iqOpenApplicationStatus) -> {
                Map<String, Object> response;
                switch (iqOpenApplicationStatus) {
                    case PROMPT_SHOWN_ON_DEVICE:
                        response = Map.ofEntries(entry("response", 5), entry("payload", "Potvrďte na hodinkách"));
                        eventSink.success(response);
                        break;
                    case PROMPT_NOT_SHOWN_ON_DEVICE:
                        response = Map.ofEntries(entry("response", 5), entry("payload", "Chyba"));
                        eventSink.success(response);
                        break;
                    case APP_IS_NOT_INSTALLED:
                        response = Map.ofEntries(entry("response", 5), entry("payload", "Aplikace není instalována"));
                        eventSink.success(response);
                        break;
                    case APP_IS_ALREADY_RUNNING:
                        response = Map.ofEntries(entry("response", 5), entry("payload", "Aplikace již běží"));
                        eventSink.success(response);
                        break;
                    case UNKNOWN_FAILURE:
                        response = Map.ofEntries(entry("response", 5), entry("payload", "Stala se chyba"));
                        eventSink.success(response);
                        break;
                }
            });
        } catch (InvalidStateException e) {
            e.printStackTrace();
        } catch (ServiceUnavailableException e) {
            e.printStackTrace();
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.R)
    private void getAvailableDevices() {
        if (this.connectIQInstance != null) {
            try {
                List<IQDevice> availableDevices = connectIQInstance.getConnectedDevices();
                List<String> availableStringDevices = new ArrayList<>();
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

    @RequiresApi(api = Build.VERSION_CODES.R)
    private void setDevice(IQDevice device) {
        if (this.connectIQInstance != null) {
            try {
                if (device == null) {
                    this.activeDevice = connectIQInstance.getConnectedDevices().get(0);
                } else {
                    this.activeDevice = device;
                }
                this.connectIQInstance.registerForDeviceEvents(this.activeDevice, (iqDevice, iqDeviceStatus) -> {
                    Map<String, Object> response;
                    switch (iqDeviceStatus) {
                        case NOT_PAIRED:
                            response = Map.ofEntries(entry("response", 4), entry("payload", "Hodinky nespárovány"));
                            eventSink.success(response);
                            break;
                        case NOT_CONNECTED:
                            response = Map.ofEntries(entry("response", 4), entry("payload", "Hodinky nepřipojeny"));
                            eventSink.success(response);
                            break;
                        case CONNECTED:
                            response = Map.ofEntries(entry("response", 4), entry("payload", this.activeDevice.getFriendlyName()));
                            eventSink.success(response);
                            break;
                        case UNKNOWN:
                            response = Map.ofEntries(entry("response", 4), entry("payload", "Stav připojení není znám"));
                            eventSink.success(response);
                            break;
                    }
                });
            } catch (InvalidStateException | ServiceUnavailableException e) {
                e.printStackTrace();
            }
        }
    }

    private void initSDK() {
        System.out.println("init SDK");
        this.connectIQInstance = ConnectIQ.getInstance(this, ConnectIQ.IQConnectType.TETHERED);

        connectIQInstance.initialize(this, true, new ConnectIQ.ConnectIQListener() {
            @RequiresApi(api = Build.VERSION_CODES.R)
            @Override
            public void onSdkReady() {
                Map<String, Object> response = Map.ofEntries(entry("response", 1));
                System.out.println(response);
                eventSink.success(response);
                try {
                    if (!connectIQInstance.getConnectedDevices().isEmpty()) {
                        setDevice(connectIQInstance.getConnectedDevices().get(0));
                    }
                } catch (InvalidStateException e) {
                    e.printStackTrace();
                } catch (ServiceUnavailableException e) {
                    e.printStackTrace();
                }
            }

            @RequiresApi(api = Build.VERSION_CODES.R)
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



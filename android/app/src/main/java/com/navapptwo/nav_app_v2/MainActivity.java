package com.navapptwo.nav_app_v2;


import android.os.Build;
import android.os.StrictMode;

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
    StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();


    private static final String COMM_CHANNEL = "commChannel";
    private static final String EVENT_CHANNEL = "eventChannel";
    private static final String MESSAGE_CHANNEL = "messageChannel";
    private ConnectIQ connectIQInstance;
    private EventChannel.EventSink eventChannelSink = new EventChannel.EventSink() {
        @Override
        public void success(Object event) {

        }

        @Override
        public void error(String errorCode, String errorMessage, Object errorDetails) {

        }

        @Override
        public void endOfStream() {

        }
    };
    private EventChannel.EventSink messageChannelSink;
    private IQDevice activeDevice;
    private final IQApp garminApplication = new IQApp("199253b5-157b-4c2c-93e5-833af0af44e1");
    private boolean sdkInitialized = false;
    private ConnectIQ.IQConnectType CONNECTION_TYPE = ConnectIQ.IQConnectType.WIRELESS;

    @RequiresApi(api = Build.VERSION_CODES.R)
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        StrictMode.setThreadPolicy(policy);
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), COMM_CHANNEL).setMethodCallHandler((call, result) -> {
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
                case "sendMessage":
                    this.sendMessage(call.arguments);
                    break;
                case "receiveMessages":
                    this.registerForMessages();
                    break;
            }
        });

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), EVENT_CHANNEL).setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                eventChannelSink = events;
            }

            @Override
            public void onCancel(Object arguments) {

            }
        });

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), MESSAGE_CHANNEL).setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                messageChannelSink = events;
            }

            @Override
            public void onCancel(Object arguments) {

            }
        });
    }

    @RequiresApi(api = Build.VERSION_CODES.R)
    private void sendMessage(Object message) {
        try {
            this.connectIQInstance.sendMessage(activeDevice, garminApplication, message, (iqDevice, iqApp, iqMessageStatus) -> {
                Map<String, Object> response;
                switch (iqMessageStatus) {
                    case SUCCESS:
                        response = Map.ofEntries(entry("response", 1), entry("payload", "ok"));
                        messageChannelSink.success(response);
                        break;
                    case FAILURE_UNKNOWN:
                        break;
                    case FAILURE_INVALID_FORMAT:
                        break;
                    case FAILURE_MESSAGE_TOO_LARGE:
                        break;
                    case FAILURE_UNSUPPORTED_TYPE:
                        break;
                    case FAILURE_DURING_TRANSFER:
                        break;
                    case FAILURE_INVALID_DEVICE:
                        break;
                    case FAILURE_DEVICE_NOT_CONNECTED:
                        break;
                }
            });
        } catch (InvalidStateException e) {
            e.printStackTrace();
        } catch (ServiceUnavailableException e) {
            e.printStackTrace();
        }
    }
    private void registerForMessages() {
        try {
            this.connectIQInstance.registerForAppEvents(this.activeDevice, this.garminApplication, (iqDevice, iqApp, list, iqMessageStatus) -> {
                switch (iqMessageStatus) {
                    case SUCCESS:
                        messageChannelSink.success(list.get(0));
                        break;
                    case FAILURE_UNKNOWN:
                        break;
                    case FAILURE_INVALID_FORMAT:
                        break;
                    case FAILURE_MESSAGE_TOO_LARGE:
                        break;
                    case FAILURE_UNSUPPORTED_TYPE:
                        break;
                    case FAILURE_DURING_TRANSFER:
                        break;
                    case FAILURE_INVALID_DEVICE:
                        break;
                    case FAILURE_DEVICE_NOT_CONNECTED:
                        break;
                }
            });
        } catch (InvalidStateException e) {
            e.printStackTrace();
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.R)
    private void openGarminApp() {
        try {
            this.connectIQInstance.openApplication(this.activeDevice, this.garminApplication, (iqDevice, iqApp, iqOpenApplicationStatus) -> {
                Map<String, Object> response;
                switch (iqOpenApplicationStatus) {
                    case PROMPT_SHOWN_ON_DEVICE:
                        response = Map.ofEntries(entry("response", 5), entry("payload", "Potvrďte na hodinkách"));
                        eventChannelSink.success(response);
                        break;
                    case PROMPT_NOT_SHOWN_ON_DEVICE:
                        response = Map.ofEntries(entry("response", 5), entry("payload", "Chyba"));
                        eventChannelSink.success(response);
                        break;
                    case APP_IS_NOT_INSTALLED:
                        response = Map.ofEntries(entry("response", 5), entry("payload", "Aplikace není instalována"));
                        eventChannelSink.success(response);
                        break;
                    case APP_IS_ALREADY_RUNNING:
                        response = Map.ofEntries(entry("response", 5), entry("payload", "Aplikace již běží"));
                        eventChannelSink.success(response);
                        break;
                    case UNKNOWN_FAILURE:
                        response = Map.ofEntries(entry("response", 5), entry("payload", "Stala se chyba"));
                        eventChannelSink.success(response);
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
                eventChannelSink.success(response);
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
                            eventChannelSink.success(response);
                            break;
                        case NOT_CONNECTED:
                            response = Map.ofEntries(entry("response", 4), entry("payload", "Hodinky nepřipojeny"));
                            eventChannelSink.success(response);
                            break;
                        case CONNECTED:
                            response = Map.ofEntries(entry("response", 4), entry("payload", this.activeDevice.getFriendlyName()));
                            eventChannelSink.success(response);
                            break;
                        case UNKNOWN:
                            response = Map.ofEntries(entry("response", 4), entry("payload", "Stav připojení není znám"));
                            eventChannelSink.success(response);
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
        this.connectIQInstance = ConnectIQ.getInstance(this, CONNECTION_TYPE);
        try {
            if (sdkInitialized) {
                sdkInitialized = false;
                this.connectIQInstance.shutdown(this);
            }
        } catch (InvalidStateException e) {
            e.printStackTrace();
        }

        connectIQInstance.initialize(this, true, new ConnectIQ.ConnectIQListener() {
            @RequiresApi(api = Build.VERSION_CODES.R)
            @Override
            public void onSdkReady() {
                sdkInitialized = true;
                Map<String, Object> response = Map.ofEntries(entry("response", 1));
                System.out.println(response);
                eventChannelSink.success(response);
                try {
                    if (!connectIQInstance.getConnectedDevices().isEmpty() && CONNECTION_TYPE == ConnectIQ.IQConnectType.WIRELESS) {
                        setDevice(connectIQInstance.getConnectedDevices().get(0));
                    }else{
                        activeDevice = connectIQInstance.getConnectedDevices().get(0);
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
                switch (iqSdkErrorStatus) {
                    case GCM_NOT_INSTALLED:
                        System.out.println('1');
                        break;
                    case GCM_UPGRADE_NEEDED:
                        System.out.println('2');
                        break;
                    case SERVICE_ERROR:
                        System.out.println('3');
                        break;
                }
                Map<String, Object> response = Map.ofEntries(entry("response", 2));
                eventChannelSink.success(response);
            }

            @Override
            public void onSdkShutDown() {
                try {
                    sdkInitialized = false;
                    connectIQInstance.unregisterAllForEvents();
                    System.out.println("SDK SHUTDOWN");
                } catch (InvalidStateException e) {
                    e.printStackTrace();
                }
            }
        });
    }
}



package com.navapptwo.nav_app_v2;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;

import androidx.annotation.NonNull;

import com.garmin.android.connectiq.ConnectIQ;
import com.garmin.android.connectiq.ConnectIQAdbStrategy;
import com.garmin.android.connectiq.IQApp;
import com.garmin.android.connectiq.IQDevice;
import com.garmin.android.connectiq.exception.InvalidStateException;
import com.garmin.android.connectiq.exception.ServiceUnavailableException;

import java.util.ArrayList;
import java.util.HashMap;
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
    private IQApp garminApplication = new IQApp("199253b5-157b-4c2c-93e5-833af0af44e1");

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
        } catch (ServiceUnavailableException e) {
        }
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
        this.connectIQInstance = ConnectIQ.getInstance(this, ConnectIQ.IQConnectType.WIRELESS);

        connectIQInstance.initialize(this, true, new ConnectIQ.ConnectIQListener() {
            @Override
            public void onSdkReady() {
                Map<String, Object> response = Map.ofEntries(entry("response", 1));
                System.out.println(response);
                eventSink.success(response);
                try {
                    setDevice(connectIQInstance.getConnectedDevices().get(0));
                } catch (InvalidStateException e) {
                    e.printStackTrace();
                } catch (ServiceUnavailableException e) {
                    e.printStackTrace();
                }
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

class ConnectIQWrappedReceiver extends BroadcastReceiver {
    private final BroadcastReceiver receiver;

    ConnectIQWrappedReceiver(BroadcastReceiver receiver) {
        this.receiver = receiver;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        if ("com.garmin.android.connectiq.SEND_MESSAGE_STATUS".equals(intent.getAction())) {
            replaceIQDeviceById(intent, "com.garmin.android.connectiq.EXTRA_REMOTE_DEVICE");
        } else if ("com.garmin.android.connectiq.OPEN_APPLICATION".equals(intent.getAction())) {
            replaceIQDeviceById(intent, "com.garmin.android.connectiq.EXTRA_OPEN_APPLICATION_DEVICE");
        }
        receiver.onReceive(context, intent);
    }


    private static void replaceIQDeviceById(Intent intent, String extraName) {
        try {
            IQDevice device = intent.getParcelableExtra(extraName);
            if (device != null) {
                intent.putExtra(extraName, device.getDeviceIdentifier());
            }
        } catch (ClassCastException e) {
// It's already a long, i.e. on the simulator.
        }
    }

    private static void initializeConnectIQ(
            Context context, ConnectIQ connectIQ, boolean autoUI, ConnectIQ.ConnectIQListener listener) {
        if (connectIQ instanceof ConnectIQAdbStrategy) {
            connectIQ.initialize(context, autoUI, listener);
            return;
        }
        Context wrappedContext = new ContextWrapper(context) {
            private HashMap<BroadcastReceiver, BroadcastReceiver> receiverToWrapper = new HashMap<>();

            @Override
            public Intent registerReceiver(final BroadcastReceiver receiver, IntentFilter filter) {
                BroadcastReceiver wrappedRecv = new ConnectIQWrappedReceiver(receiver);
                synchronized (receiverToWrapper) {
                    receiverToWrapper.put(receiver, wrappedRecv);
                }
                return super.registerReceiver(wrappedRecv, filter);
            }

            @Override
            public void unregisterReceiver(BroadcastReceiver receiver) {
// We need to unregister the wrapped receiver.
                BroadcastReceiver wrappedReceiver = null;
                synchronized (receiverToWrapper) {
                    wrappedReceiver = receiverToWrapper.get(receiver);
                    receiverToWrapper.remove(receiver);
                }
                if (wrappedReceiver != null) super.unregisterReceiver(wrappedReceiver);
            }
        };
        connectIQ.initialize(wrappedContext, autoUI, listener);
    }
}

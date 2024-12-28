import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../data/models/config/DeviceConfig.dart';
import '../data/models/config/RpiConfig.dart';
import '../utils/LoadContent.dart';

///
/// Application-level global variable to access the WebSockets
///
WebSocketsNotifications sockets = new WebSocketsNotifications();

///
/// Put your WebSockets server IP address and port number
///
//const String _SERVER_ADDRESS1 = "ws://192.168.1.10:9441/ws/random";
//const String _SERVER_ADDRESS2 = "ws://localhost:9441/ws/random";
String _SERVER_ADDRESS1 = "";
String _SERVER_ADDRESS2 = "";
const String protocol = "ws://";
const String path = "/uberPlatform/device";
const int retryMax = 5;

class WebSocketsNotifications {
  static final WebSocketsNotifications _sockets =
      new WebSocketsNotifications._internal();

  factory WebSocketsNotifications() {
    return _sockets;
  }

  WebSocketsNotifications._internal();

  ///
  /// The WebSocket "open" channel
  ///
  StompClient? _channel;

  ///
  /// Is the connection established?
  ///
  bool _isOn = false;
  bool stateConnectionLost = false;

  // timer // reconnectDelay from Global5Config
  int wsDelaySeconds = 10;

  // retry count
  int retryCount = 0;

  // current server URL
  String currentURI = '';
  String currentTopic = "/topic/message";
  String errorTopic = "/topic/error";
  String sendTopic = "/app/device";

  ///
  /// Listeners
  /// List of methods to be called when a new message
  /// comes in.
  ///
  ObserverList<Function> _listeners = new ObserverList<Function>();

  dynamic onConnect(StompFrame frame) {
    retryCount = 0;
    _isOn = true;
    //print("@@ websocket connected: ${_channel!.connected}");
    if (_channel != null) {
      _channel!.subscribe(
          destination: currentTopic,
          callback: (StompFrame frame) {
            var message = json.decode(frame.body!);
            print(message);
            _onReceptionOfMessageFromServer(frame.body);
          });

      _channel!.subscribe(
          destination: errorTopic,
          callback: (StompFrame frame) {
            var message = json.decode(frame.body!);
            print("ERROR MESSAGE");
            print(message);
            //_onReceptionOfMessageFromServer(frame.body);
          });
      print("@@ websocket connected: ${_channel!.connected}");
    }
    setActiveRPI();
    //####################//
  }

  onError(err) {
    print("server URI: $currentURI");
    print('websocket error ==> $err');
    stateConnectionLost = true;
    print("@@ deactivating channel...");
    _channel?.deactivate();
    _channel = null;

    reconnect();
  }

  reactivate() {
    print("reactivate server URI: $currentURI");
    stateConnectionLost = true;
    print("@@ deactivating channel...");
    _channel?.deactivate();
    _channel = null;
    reconnect();
  }

  Future<bool> validatedTestConnection() async {
    bool retVal = false;
    //validate first if in testConnection endpoint
    String uri = "/uberPlatform/test";
    String rpi1 = getPrimaryUri();
    String rpi2 = getSecondaryUri();
    var resp;
    print("@@ Checking in ${rpi1 + uri}");
    resp = await LoadContent.testConnection(rpi1 + uri);
    if (LoadContent.isSuccess(resp)) {
      currentURI = _SERVER_ADDRESS1;
      retVal = true;
    } else {
      print('@@ Error in $rpi1');
      print("@@ Checking in secondary ${rpi2 + uri}");
      resp = await LoadContent.testConnection(rpi2 + uri);
      if (LoadContent.isSuccess(resp)) {
        currentURI = _SERVER_ADDRESS2;
        retVal = true;
      }
    }

    return retVal;
  }

  onDone() {
    print('@@ websocket channel closed');
    stateConnectionLost = true;
    _channel = null;
    //reconnect();
  }

  setActiveRPI() {
    String ngrokURL = currentURI.replaceAll(protocol, "https://");
    ngrokURL = ngrokURL.replaceAll(path, "");
    RPIConfig.uri = ngrokURL;
  }

  /// ----------------------------------------------------------
  /// Initialization the WebSockets connection with the server
  /// ----------------------------------------------------------
  initCommunication() async {
    ///
    /// Just in case, close any previous communication
    ///
    print("reset().....");
    reset();

    ///
    /// Open a new WebSocket communication
    ///
    _SERVER_ADDRESS1 = getPrimaryUri();
    _SERVER_ADDRESS1 = _SERVER_ADDRESS1.replaceAll("http://", "");
    _SERVER_ADDRESS1 = _SERVER_ADDRESS1.replaceAll("https://", "");
    _SERVER_ADDRESS1 = protocol + _SERVER_ADDRESS1 + path;

    _SERVER_ADDRESS2 = getSecondaryUri();
    _SERVER_ADDRESS2 = _SERVER_ADDRESS2.replaceAll("http://", "");
    _SERVER_ADDRESS2 = _SERVER_ADDRESS2.replaceAll("https://", "");
    _SERVER_ADDRESS2 = protocol + _SERVER_ADDRESS2 + path;

    try {
      if (currentURI.isEmpty) {
        currentURI = _SERVER_ADDRESS1;
        print("@@ Try connecting [$currentURI] . . . .");
      }
      print("@@ Proceeding to Channel Connect...");
      _channel = StompClient(
          config: StompConfig(
        url: currentURI,
        onConnect: onConnect,
        reconnectDelay: const Duration(seconds: 5),
        //connectionTimeout: Duration(seconds: 10),
        heartbeatIncoming: const Duration(seconds: 5),
        stompConnectHeaders: {},
        webSocketConnectHeaders: {},
        onWebSocketError: onError,
        //onWebSocketDone: onDone,
        onWebSocketDone: () {
          print("WEBSOCKET DONE");
        },
        onDisconnect: (frame) {
          print("DISCONNECTED....");
        },
        /*onDebugMessage: (p0) {
              print("Debug: ${p0}");
            },
            onStompError: (p0) {
              print("STOMP ERROR $p0");
            },
            onUnhandledReceipt: (p0) {
              print("Unhandled script: $p0");
            },
            onUnhandledMessage: (p0) {
              print("Unhandled message: $p0");
            },
            onUnhandledFrame: (p0) {
              print("Unhandled frame: $p0");
            },*/
        //beforeConnect: () {}
      ));

      _channel!.activate();
    } catch (e) {
      /// General error handling
      /// TODO
      print("ERROR needs to be handled with connection.");
      print(e);
      _isOn = false;
    }
  }

  bool isConnected() {
    if (_channel == null) return false;

    return _channel!.connected;
  }

  getPrimaryUri() {
    //print("GET PRIMARY METHOD");
    if (DeviceConfig.primary == "rpi1") {
      return DeviceConfig.rpi1;
    } else {
      return DeviceConfig.rpi2;
    }
  }

  getSecondaryUri() {
    // print("GET SECONDARY METHOD");
    print(
        "prim: ${DeviceConfig.primary}  rpi2Enabled: ${DeviceConfig.rpi2Enabled}");
    if (DeviceConfig.primary == "rpi1") {
      return (DeviceConfig.rpi2Enabled) ? DeviceConfig.rpi2 : "";
    } else {
      print("rpi1Enabled: ${DeviceConfig.rpi1Enabled}");
      return (DeviceConfig.rpi1Enabled) ? DeviceConfig.rpi1 : "";
    }
  }

  reconnect() {
    if (retryCount < 5) {
      retryCount += 1;
      print('@@ waiting for ${wsDelaySeconds} seconds');
      createTimer();
    }
    /*} else {
      changeServer();
    }*/
  }

  createTimer() {
    Timer.periodic(Duration(seconds: wsDelaySeconds), (Timer timer) async {
      if (await validatedTestConnection()) {
        try {
          print("@@ retrying ...");
          await initCommunication();
        } catch (e) {
          print("@@ error: $e");
        }
      }
      if (_channel != null) timer.cancel();
    });
  }

  changeServer() {
    print("=== Number of retries reached ===");
    print("Changing connection URI...");
    if (currentURI == _SERVER_ADDRESS1) {
      currentURI = _SERVER_ADDRESS2;
    } else {
      currentURI = _SERVER_ADDRESS1;
    }
    print('@@ connecting to $currentURI');
    retryCount = 0;
    createTimer();
  }

  /// ----------------------------------------------------------
  /// Closes the WebSocket communication
  /// ----------------------------------------------------------
  reset() {
    if (_channel != null) {
      _channel!.deactivate();
      _isOn = false;
    }
  }

  /// ---------------------------------------------------------
  /// Sends a message to the server
  /// ---------------------------------------------------------
  send(message) {
    if (_channel != null) {
      if (_isOn) {
        _channel!.send(destination: sendTopic, body: message, headers: {});
      }
    }
  }

  /// ---------------------------------------------------------
  /// Adds a callback to be invoked in case of incoming
  /// notification
  /// ---------------------------------------------------------
  addListener(Function callback) {
    _listeners.add(callback);
  }

  removeListener(Function callback) {
    _listeners.remove(callback);
  }

  /// ----------------------------------------------------------
  /// Callback which is invoked each time that we are receiving
  /// a message from the server
  /// ----------------------------------------------------------
  _onReceptionOfMessageFromServer(message) {
    //print("Reception from server:");
    //print(message);
    _listeners.forEach((Function callback) {
      callback(message);
    });
  }
}

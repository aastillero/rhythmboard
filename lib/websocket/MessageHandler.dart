import 'dart:convert';
import '../data/models/ws/EntryData.dart';

class MessageHandler {
  static EntryData onMessageRecieveHandler(message) {
    print("message from widget: $message");
    // convert message to object
    EntryData e = EntryData.fromMap(jsonDecode(message));
    print("entrydata: ${e.toMap()}");

    return e;
  }
}

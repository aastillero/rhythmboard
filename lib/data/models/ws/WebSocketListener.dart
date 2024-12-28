class WebSocketListener {
  String name;
  Function msgHandler;

  ///listen to result from self's update
  bool listenToSelf;

  ///
  WebSocketListener(this.name, this.msgHandler, {this.listenToSelf = true});
}

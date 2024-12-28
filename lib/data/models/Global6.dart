class Global6 {
  int critiqueFormtype = 0;
  int wsReconnectDelay = 15;
  bool enableLogger = false;
  bool mode3Override = false;
  int mode3Video = 1;

  Global6({this.critiqueFormtype = 0,this.wsReconnectDelay = 15, this.enableLogger = false, this.mode3Override = false, this.mode3Video = 1});

  Global6.fromMap(Map<String, dynamic> map) {
    critiqueFormtype = map['critiqueFormtype'];
    wsReconnectDelay = map['reconnectDelay'];
    enableLogger = map['enableLogger'];
    mode3Override = map['mode3Override'];
    mode3Video = map['mode3Video'];
  }

  Map<String, dynamic> toMap() {
    return {
      'critiqueFormtype': critiqueFormtype,
      'reconnectDelay': wsReconnectDelay,
      'enableLogger': enableLogger,
      'mode3Override': mode3Override,
      'mode3Video': mode3Video,
    };
  }
}

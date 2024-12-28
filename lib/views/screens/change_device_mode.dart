import 'package:flutter/material.dart';
import '../widgets/DanceFrameButton.dart';
import '../widgets/DanceframeFormContainer.dart';
import 'package:flutter/services.dart';
import '../../utils/ScreenUtil.dart';
import '../../utils/ConfigUtil.dart';

class change_device_mode extends StatefulWidget {
  static bool isEditMode = false; // false is default;
  @override
  _change_device_modeState createState() => new _change_device_modeState();
}

class _change_device_modeState extends State<change_device_mode> {
  TextEditingController _deviceModeCtrl = new TextEditingController();
  FocusNode _focusNode = new FocusNode();
  String code1 = "";
  String code2 = "";
  String code3 = "";
  String codeComp = "";
  String codeConf = "";

  void textListener() {
    setState(() {
      if (_deviceModeCtrl.text.length > 0) {
        code1 = _deviceModeCtrl.text[0];
        if (_deviceModeCtrl.text.length > 1) {
          code2 = _deviceModeCtrl.text[1];
          if (_deviceModeCtrl.text.length > 2) {
            code3 = _deviceModeCtrl.text[2];
          } else {
            code3 = "";
          }
        } else {
          code2 = "";
        }
      } else {
        code1 = "";
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    codeComp = "";
    ConfigUtil.getConfig("app_access_code").then((confValue) {
      if (confValue != null) {
        codeComp = confValue;
      }
    });
    ConfigUtil.getConfig("app_config_code").then((confValue) {
      if (confValue != null) {
        codeConf = confValue;
      }
    });
    _deviceModeCtrl.addListener(textListener);
  }

  void continueNavigate() {
    String concatCode = code1 + code2 + code3;
    print("concatCode = $concatCode");
    if (concatCode == codeComp) {
      Navigator.pushNamed(context, "/devicecontrol");
    } else if (concatCode == codeConf) {
      /*ScreenUtil.showMainFrameDialogWithCancel(context, "Wipe Device Data", "Are you sure you want to wipe all the Data on this device?").then((val){
        print("VALUE: $val");
        if(val.toLowerCase() == "ok") {
          ScreenUtil.showMainFrameDialog(context, "Wipe Device Data", "You pressed OK");
          DatabaseHelper.instance.removeDB();
          Preferences.clearPreferences().then((val){
            ScreenUtil.showMainFrameDialog(context, "Wipe Success", "Application will restart. press ok to Exit").then((val){
              exit(0);
            });
          });
        }
      });*/
      change_device_mode.isEditMode = true;
      Navigator.pushNamed(context, "/devicecontrol").then((val) {
        print("HAS POPPED FROM CHANGE DEVICE MODE");
        Navigator.pop(context);
      });
    } else {
      ScreenUtil.showMainFrameDialog(
          context, "Invalid Code", "Please input the correct Code.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: new DanceframeAppBar(
        //   height: 150.0,
        //   bg: true,
        // ),
        body: new Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [new Color(0xFFD6DFDE), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.01, 0.5])),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Expanded(
                  // PUT YOUR CONTENTS HERE in Child property
                  child: new DanceframeFormContainer(
                      alignment: Alignment.topCenter,
                      marginRight: 140.0,
                      marginLeft: 140.0,
                      marginBottom: 380.0,
                      flex: 3.0,
                      headingHeight: 40.0,
                      containerMarginTop: 26.0,
                      background: Colors.white,
                      headingText: "CHANGE DEVICE MODE",
                      child: new Container(
                        margin: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 20.0),
                        child: new Column(
                          children: <Widget>[
                            new Expanded(
                                child: Container(
                                    //color: Colors.amber,
                                    child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Stack(
                                  children: <Widget>[
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        new InkWell(
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(_focusNode);
                                            },
                                            child: new Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                border: Border.all(),
                                              ),
                                              width: 100.0,
                                              height: 100.0,
                                              child: new Center(
                                                child: Text(code1,
                                                    style: TextStyle(
                                                        fontSize: 60.0,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ),
                                            )),
                                        new InkWell(
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(_focusNode);
                                            },
                                            child: new Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                border: Border.all(),
                                              ),
                                              width: 100.0,
                                              height: 100.0,
                                              child: new Center(
                                                child: Text(code2,
                                                    style: TextStyle(
                                                        fontSize: 60.0,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ),
                                            )),
                                        new InkWell(
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(_focusNode);
                                            },
                                            child: new Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                border: Border.all(),
                                              ),
                                              width: 100.0,
                                              height: 100.0,
                                              child: new Center(
                                                child: Text(code3,
                                                    style: TextStyle(
                                                        fontSize: 60.0,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                new Container(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Text("ACCESS CODE",
                                      style: TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.w900)),
                                ),
                                new Container(
                                  padding:
                                      EdgeInsets.only(left: 20.0, top: 5.0),
                                  child: new TextField(
                                    autofocus: true,
                                    style: TextStyle(
                                      fontSize: 1.0,
                                      //fontWeight: FontWeight.w600,
                                      //letterSpacing: 100.0
                                    ),
                                    decoration: InputDecoration(
                                        focusedBorder: InputBorder.none,
                                        border: InputBorder.none),
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: <TextInputFormatter>[
                                      new LengthLimitingTextInputFormatter(3)
                                    ],
                                    cursorColor: Colors.white,
                                    controller: _deviceModeCtrl,
                                    focusNode: _focusNode,
                                  ),
                                )
                              ],
                            ))),
                            new Container(
                              height: 45.0,
                              child: new Row(
                                children: <Widget>[
                                  new DanceFrameButton(
                                    text: "CANCEL",
                                    onPressed: () {
                                      Navigator.maybePop(context);
                                    },
                                  ),
                                  new Expanded(child: Container()),
                                  new DanceFrameButton(
                                      onPressed: continueNavigate,
                                      width: 140.0,
                                      text: "CONTINUE"),
                                ],
                              ),
                            )
                          ],
                        ),
                      ))),
              // new DanceFrameFooter()
            ],
          ),
        ));
  }
}

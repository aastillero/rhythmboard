import 'package:flutter/material.dart';
import '../views/widgets/DanceFrameButton.dart';
import '../views/widgets/LoadingIndicator.dart';

class ScreenUtil {
  /*
  A method that shows a dialog screen with cancel option.
  It accepts a String message and a string title
 */
  static Future<String?> showMainFrameDialogWithCancel(
      BuildContext context, String title, String msg) async {
    return showDialog<String>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (context) {
          return AlertDialog(
            title: new Text(title),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[new Text(msg)],
              ),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text('NO'),
                onPressed: () {
                  Navigator.pop(context, "CANCEL");
                },
              ),
              new TextButton(
                child: new Text('YES'),
                onPressed: () {
                  Navigator.pop(context, "OK");
                },
              ),
            ],
          );
        }).then((val) {
      return val;
    });
  }

  static Future<String?> showWipeDialogWithCancel(
      BuildContext context, String title, String msg) async {
    return showDialog<String>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (context) {
          return AlertDialog(
            title: new Text(title),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[new Text(msg)],
              ),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context, "CANCEL");
                },
              ),
              new TextButton(
                child: new Text('YES WIPE EVERYTHING'),
                onPressed: () {
                  Navigator.pop(context, "OK");
                },
              ),
            ],
          );
        }).then((val) {
      return val;
    });
  }

  static Future<Null> showMainFrameDialog(
      BuildContext context, String title, String msg,
      {String uriRedirect = ''}) async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (context) {
          return AlertDialog(
            title: new Text(title),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[new Text(msg)],
              ),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  static Future<Null> showScratchDialog(
      BuildContext context, Function onComplete,
      {String? selectedRadio, bool isScratch = false}) async {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (context) {
          return Dialog(
            child: Container(
              decoration: new BoxDecoration(
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(14.0)),
                  border: Border.all(color: Color(0xffa5b3b7), width: 5.0),
                  color: Color(0xfff8f8f9),
                  boxShadow: <BoxShadow>[
                    new BoxShadow(
                        blurRadius: 0.0,
                        spreadRadius: 5.0,
                        color: Color(0xffa5b3b7))
                  ]),
              height: height / 2.6,
              width: width / 1.8,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Padding(
                              padding: EdgeInsets.only(top: 5.0, right: 5.0),
                              child: CircleAvatar(
                                radius: 15.0,
                                backgroundColor: Colors.black,
                                child: Container(
                                    child: new Icon(Icons.close,
                                        size: 22.0, color: Colors.white)),
                              )))
                    ],
                  ),
                  Expanded(
                      child: Container(
                    //color: Colors.amber,
                    child: Column(
                      children: <Widget>[
                        Center(
                            child: Text(
                                "${(isScratch != null && isScratch) ? "Scratch" : "Unscratch"} Couple",
                                style: TextStyle(
                                    fontSize: 33.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700))),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(top: 10.0),
                                constraints:
                                    BoxConstraints(maxWidth: width / 2.5),
                                //color: Colors.amber,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    InkWell(
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          showScratchDialog(context, onComplete,
                                              selectedRadio: "this_heat",
                                              isScratch: isScratch);
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5.0),
                                                child: (selectedRadio !=
                                                        "this_heat")
                                                    ? Icon(Icons
                                                        .radio_button_unchecked)
                                                    : Icon(Icons
                                                        .radio_button_checked)),
                                            Expanded(
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10.0),
                                                    child: Text(
                                                        "This heat only",
                                                        style: TextStyle(
                                                            fontSize: 26.0,
                                                            color:
                                                                Colors.black))))
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(top: 15.0)),
                                    InkWell(
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          showScratchDialog(context, onComplete,
                                              selectedRadio: "today_heats",
                                              isScratch: isScratch);
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5.0),
                                                child: (selectedRadio !=
                                                        "today_heats")
                                                    ? Icon(Icons
                                                        .radio_button_unchecked)
                                                    : Icon(Icons
                                                        .radio_button_checked)),
                                            Expanded(
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10.0),
                                                    child: Text(
                                                        "This heat and all remaining heats today",
                                                        style: TextStyle(
                                                            fontSize: 26.0,
                                                            color:
                                                                Colors.black))))
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(top: 15.0)),
                                    InkWell(
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          showScratchDialog(context, onComplete,
                                              selectedRadio: "all_heats",
                                              isScratch: isScratch);
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5.0),
                                                child: (selectedRadio !=
                                                        "all_heats")
                                                    ? Icon(Icons
                                                        .radio_button_unchecked)
                                                    : Icon(Icons
                                                        .radio_button_checked)),
                                            Expanded(
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10.0),
                                                    child: Text(
                                                        "This heat and all remaining heats for all days",
                                                        style: TextStyle(
                                                            fontSize: 26.0,
                                                            color:
                                                                Colors.black))))
                                          ],
                                        )),
                                  ],
                                ))),
                        Container(
                            //color: Colors.blue,
                            constraints: BoxConstraints(minHeight: 60.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                DanceFrameButton(
                                  text: "CANCEL",
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                ),
                                DanceFrameButton(
                                  text: "SAVE",
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    if (selectedRadio == "this_heat") {
                                      ScreenUtil.showScratchSuccess(context,
                                          singleHeat: true,
                                          isScratch: isScratch);
                                    } else {
                                      ScreenUtil.showScratchSuccess(context,
                                          singleHeat: false,
                                          isScratch: isScratch);
                                    }
                                    onComplete(selectedRadio);
                                  },
                                ),
                              ],
                            ))
                      ],
                    ),
                  ))
                ],
              ),
            ),
          );
        });
  }

  static Future<Null> showScratchSuccess(context,
      {bool singleHeat = true, bool isScratch = false}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return new Dialog(
          child: Container(
            decoration: new BoxDecoration(
                borderRadius:
                    const BorderRadius.all(const Radius.circular(14.0)),
                border: Border.all(color: Color(0xffa5b3b7), width: 5.0),
                color: Color(0xfff8f8f9),
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                      blurRadius: 0.0,
                      spreadRadius: 5.0,
                      color: Color(0xffa5b3b7))
                ]),
            height: height / 3.6,
            width: width / 1.8,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Padding(
                            padding: EdgeInsets.only(top: 5.0, right: 5.0),
                            child: CircleAvatar(
                              radius: 15.0,
                              backgroundColor: Colors.black,
                              child: Container(
                                  child: new Icon(Icons.close,
                                      size: 22.0, color: Colors.white)),
                            )))
                  ],
                ),
                Expanded(
                    child: Container(
                  //color: Colors.amber,
                  child: Column(
                    children: <Widget>[
                      //Center(child: Text("Scratch Couple", style: TextStyle(fontSize: 33.0, color: Colors.black, fontWeight: FontWeight.w700))),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.only(top: 10.0),
                        constraints: BoxConstraints(maxWidth: width / 2.5),
                        //color: Colors.amber,
                        alignment: Alignment.center,
                        child: (singleHeat != null && singleHeat)
                            ? Text(
                                "Current entry has been ${(isScratch != null && isScratch) ? "scratched" : "unscratched"}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 28.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600))
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("3 Heats Scratched",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 28.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600)),
                                  Text("1 - Current Heat",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600)),
                                  Text("2 - Future Heats",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                      )),
                      Container(
                          //color: Colors.blue,
                          constraints: BoxConstraints(minHeight: 60.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              DanceFrameButton(
                                text: "OK",
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  MainFrameLoadingIndicator.hideLoading(
                                      context);
                                },
                              ),
                            ],
                          ))
                    ],
                  ),
                ))
              ],
            ),
          ),
        );
      },
    );
  }
}

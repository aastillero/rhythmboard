import 'dart:async';
import 'package:flutter/material.dart';

/*
  Author: Art

  [MainFrameLoading] class contains methods
  to hide and show a [CircularProgressIndicator]
  when processes are ongoing
 */
class MainFrameLoadingIndicator {
  static bool isOpened = false;

  static void hideLoading(BuildContext context) {
    if (isOpened) {
      isOpened = false;
      Navigator.of(context).pop();
    }
  }

  /*
    Method that shows the Loading Indicator
   */
  static Future<Null> showLoading(BuildContext context) async {
    isOpened = true;

    Color _getColor(BuildContext context) {
      return Theme.of(context).dialogBackgroundColor;
    }

    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return Center(
            child: new Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 24.0),
                child: new ConstrainedBox(
                    constraints:
                        const BoxConstraints(minWidth: 25.0, minHeight: 25.0),
                    child: new Material(
                        elevation: 24.0,
                        color: _getColor(context),
                        type: MaterialType.card,
                        child: new Container(
                          padding: const EdgeInsets.all(10.0),
                          child: new CircularProgressIndicator(),
                        )))));
      },
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../screens/change_device_mode.dart';
import 'timebox.dart';

class TopBar extends StatelessWidget {
  final String eventName;
  final String? labelTime;

  const TopBar({Key? key, required this.eventName, required this.labelTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.white),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              /*child: Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: AutoSizeText(
                  "Ballroom A",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.0,
                    fontFamily: "Times new roman",
                  ),
                ),
              ),*/
              child: Container(),
            ),
            Expanded(
              flex: 8,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/mode3test");
                },
                child: Center(
                  child: AutoSizeText(
                    eventName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26.0,
                      fontFamily: "Times new roman",
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: InkWell(
                    onTap: () {
                      Get.to(change_device_mode());
                    },
                    child: TimeBox(labelTime: labelTime),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double width;
  final int dur;
  final bool heatStarted;

  const ProgressBar({
    Key? key,
    required this.width,
    required this.dur,
    required this.heatStarted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Row(
          children: [
            Stack(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: dur),
                  height: 30.0,
                  width: width,
                  color: Colors.green[700],
                ),
                Container(
                  height: 30.0,
                  width: 50.0,
                  color: heatStarted ? Colors.green[700] : Colors.white,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
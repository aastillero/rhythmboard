import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'progress_bar.dart';

class HeatSection extends StatelessWidget {
  final String currentHeatNameL1;
  final String? currentHeatNameL2;
  final String? currentDanceName;
  final Widget richText;
  final bool heatStarted;
  final double width;
  final int dur;

  const HeatSection({
    Key? key,
    required this.currentHeatNameL1,
    required this.currentHeatNameL2,
    required this.currentDanceName,
    required this.richText,
    required this.heatStarted,
    required this.width,
    required this.dur,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasL2 = currentHeatNameL2?.isNotEmpty == true;

    return Expanded(
      flex: 7,
      child: Container(
        color: Colors.white,
        //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
        child: Column(
          children: [
            // HEAT Label
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(color: Colors.green[700], border: Border.all()),
                child: const Center(
                  child: Text(
                    'HEAT',
                    style: TextStyle(
                      fontSize: 26.0,
                      color: Colors.white,
                      fontFamily: "Times new roman",
                    ),
                  ),
                ),
              ),
            ),
            // Current Heat
            Expanded(
              flex: 5,
              child: InkWell(
                onTap: () {
                  // Handle tap if needed
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide()
                      ),
                  ),
                  alignment: Alignment.center,
                  child: Center(
                    child: hasL2
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          currentHeatNameL1,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 174.0,
                            fontFamily: "Times new roman",
                          ),
                        ),
                        richText,
                      ],
                    )
                        : Text(
                      currentHeatNameL1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 174.0,
                        fontFamily: "Times new roman",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Animated Progress Bar
            ProgressBar(width: width, dur: dur, heatStarted: heatStarted),
            // Current Dance
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide()
                  ),
                ),
                child: Center(
                  child: AutoSizeText(
                    currentDanceName ?? '--',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 76.0, fontFamily: "Times new roman"),
                    maxLines: 2,
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
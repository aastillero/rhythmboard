import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class DoneSection extends StatelessWidget {
  final List<Widget> leftSlides;
  final String doneHeatNameL1;
  final String? doneHeatNameL2;
  final String? doneDanceName;

  const DoneSection({
    Key? key,
    required this.leftSlides,
    required this.doneHeatNameL1,
    required this.doneHeatNameL2,
    required this.doneDanceName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Slides
            Expanded(
              flex: 4,
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: leftSlides.length > 1,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: false,
                  viewportFraction: 1.0,
                ),
                items: leftSlides.isNotEmpty ? leftSlides : [],
              ),
            ),
            // DONE Label
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  border: Border.all(),
                ),
                child: const Center(
                  child: Text(
                    'DONE',
                    style: TextStyle(fontSize: 26.0, fontFamily: "Times new roman"),
                  ),
                ),
              ),
            ),
            // DONE Heat Name
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border.all(),
                ),
                child: Center(
                  child: (doneHeatNameL2?.isNotEmpty == true)
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        doneHeatNameL1,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 128.0,
                          fontFamily: "Times new roman",
                        ),
                      ),
                      AutoSizeText(
                        doneHeatNameL2!,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 48.0,
                          fontFamily: "Times new roman",
                        ),
                      ),
                    ],
                  )
                      : Text(
                    doneHeatNameL1,
                    style: const TextStyle(
                      fontSize: 128.0,
                      fontFamily: "Times new roman",
                    ),
                  ),
                ),
              ),
            ),
            // DONE Dance Name
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border.all(),
                ),
                child: Center(
                  child: AutoSizeText(
                    doneDanceName ?? '--',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 26, fontFamily: "Times new roman"),
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
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class OnDeckSection extends StatelessWidget {
  final List<Widget> rightSlides;
  final String nextHeatNameL1;
  final String? nextHeatNameL2;
  final String? nextDanceName;

  const OnDeckSection({
    Key? key,
    required this.rightSlides,
    required this.nextHeatNameL1,
    required this.nextHeatNameL2,
    required this.nextDanceName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasL2 = nextHeatNameL2?.isNotEmpty == true;

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
                  autoPlay: rightSlides.length > 1,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: false,
                  viewportFraction: 1.0,
                ),
                items: rightSlides.isNotEmpty ? rightSlides : [],
              ),
            ),
            // ON DECK Label
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.yellow[200],
                  border: Border.all(),
                ),
                child: const Center(
                  child: Text(
                    'ON DECK',
                    style: TextStyle(fontSize: 26.0, fontFamily: "Times new roman"),
                  ),
                ),
              ),
            ),
            // NEXT Heat Name
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.yellow[50],
                  border: Border.all(),
                ),
                child: Center(
                  child: hasL2
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        nextHeatNameL1,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 128.0,
                          fontFamily: "Times new roman",
                        ),
                      ),
                      AutoSizeText(
                        nextHeatNameL2!,
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
                    nextHeatNameL1,
                    style: const TextStyle(fontSize: 128.0, fontFamily: "Times new roman"),
                  ),
                ),
              ),
            ),
            // NEXT Dance Name
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.yellow[50],
                  border: Border.all(),
                ),
                child: Center(
                  child: AutoSizeText(
                    nextDanceName ?? '--',
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
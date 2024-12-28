import 'package:flutter/material.dart';

class TimeBox extends StatelessWidget {
  final String? labelTime;

  const TimeBox({Key? key, required this.labelTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff97040c),
        borderRadius: BorderRadius.circular(10.0),
      ),
      constraints: const BoxConstraints(minHeight: 50.0, minWidth: 140.0),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "OFFICIAL TIME",
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            labelTime ?? '',
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
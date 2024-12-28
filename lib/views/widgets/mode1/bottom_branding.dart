import 'package:flutter/material.dart';

class BottomBranding extends StatelessWidget {
  const BottomBranding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        color: Colors.black,
        width: double.infinity,
        child: Center(
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'DANCE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[900],
                    fontSize: 22.0,
                  ),
                ),
                const TextSpan(
                  text: 'FRAME ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                ),
                const TextSpan(
                  text: 'C',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 22.0),
                ),
                const TextSpan(
                  text: 'OMPETITION ',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18.0),
                ),
                const TextSpan(
                  text: 'S',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 22.0),
                ),
                const TextSpan(
                  text: 'YSTEMS',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class BallroomSection extends StatelessWidget {
  const BallroomSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1, // Smaller flex for the vertical "Ballroom A" section
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Text(
                  "A",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Times new roman",
                  ),
                ),
              ),
              Text(
                "B",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Times new roman",
                ),
              ),
              Text(
                "A",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Times new roman",
                ),
              ),
              Text(
                "L",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Times new roman",
                ),
              ),
              Text(
                "L",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Times new roman",
                ),
              ),
              Text(
                "R",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Times new roman",
                ),
              ),
              Text(
                "O",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Times new roman",
                ),
              ),
              Text(
                "O",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Times new roman",
                ),
              ),
              Text(
                "M",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Times new roman",
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Text(
                  "A",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Times new roman",
                  ),
                ),
              ),
            ],
          ),
          /*child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Center the text
            children: const [
              // top A or B
              Text(
                "A",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Times new roman",
                ),
              ),
              // Center "BALLROOM"
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "B",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Times new roman",
                    ),
                  ),
                  Text(
                    "A",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Times new roman",
                    ),
                  ),
                  Text(
                    "L",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Times new roman",
                    ),
                  ),
                  Text(
                    "L",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Times new roman",
                    ),
                  ),
                  Text(
                    "R",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Times new roman",
                    ),
                  ),
                  Text(
                    "O",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Times new roman",
                    ),
                  ),
                  Text(
                    "O",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Times new roman",
                    ),
                  ),
                  Text(
                    "M",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Times new roman",
                    ),
                  ),
                ],
              ),
              // Bottom A or B
              Text(
                "A",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Times new roman",
                ),
              ),
            ],
          ),*/
        ),
      ),
    );
  }
}
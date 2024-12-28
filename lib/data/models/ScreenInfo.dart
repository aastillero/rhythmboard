import 'dart:math';

class AxisInfo {
  double axisPX;
  double axisDPI;
  double axisInches = 0;
  AxisInfo({this.axisPX = 0, this.axisDPI = 0}) {
    axisInches = (axisPX / axisDPI);
  }
}

class DiagonalInfo {
  AxisInfo? xAxis;
  AxisInfo? yAxis;
  double diagonalInches = 0;
  double diagonalPixel = 0;
  double? dpi;
  DiagonalInfo({this.xAxis, this.yAxis}) {
    diagonalPixel =
        sqrt((xAxis!.axisPX * xAxis!.axisPX) + (yAxis!.axisPX * yAxis!.axisPX));
    diagonalInches = sqrt((xAxis!.axisInches * xAxis!.axisInches) +
        (yAxis!.axisInches * yAxis!.axisInches));
    dpi = diagonalPixel / diagonalInches;
  }
}

class NativeDeviceSizeInfo {
  double? metricsWidth;
  double? metricsXDPI;
  double? metricsHeight;
  double? metricsYDPI;
  double? metricsDensity;
  double? metricsDensityDPI;
  //double? metricsScaledDensity;
  NativeDeviceSizeInfo({
    this.metricsWidth,
    this.metricsXDPI,
    this.metricsHeight,
    this.metricsYDPI,
    this.metricsDensity,
    this.metricsDensityDPI,
  });

  NativeDeviceSizeInfo.fromJSON(Map<String, dynamic> jsonObject)
      : metricsWidth = double.parse(jsonObject['metricsWidth'].toString()),
        metricsXDPI = double.parse(jsonObject['metricsXDPI'].toString()),
        metricsHeight = double.parse(jsonObject['metricsHeight'].toString()),
        metricsYDPI = double.parse(jsonObject['metricsYDPI'].toString()),
        metricsDensity = double.parse(jsonObject['metricsDensity'].toString()),
        metricsDensityDPI =
            double.parse(jsonObject['metricsDensityDPI'].toString());
  // metricsScaledDensity =
  //     double.parse(jsonObject['metricsScaledDensity'].toString());
}

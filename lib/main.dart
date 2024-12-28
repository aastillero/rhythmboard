import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'routes/DanceframeRoute.dart';
import 'package:get/get.dart';
import 'package:flutter_logs/flutter_logs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // file downloader
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );

  //Initialize Logging
  await FlutterLogs.initLogs(
      logLevelsEnabled: [
        LogLevel.INFO,
        LogLevel.WARNING,
        LogLevel.ERROR,
        LogLevel.SEVERE
      ],
      timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
      directoryStructure: DirectoryStructure.FOR_DATE,
      logTypesEnabled: ["device", "network", "errors"],
      logFileExtension: LogFileExtension.LOG,
      logsWriteDirectoryName: "MyLogs",
      logsExportDirectoryName: "MyLogs/Exported",
      debugFileOperations: true,
      isDebuggable: true);

  runApp(UberDisplayTab());
}
// void main() {
//   SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
//   runApp(UberDisplayTab());
// }

class UberDisplayTab extends StatefulWidget {
  @override
  _UberDisplayTabState createState() => _UberDisplayTabState();
}

class _UberDisplayTabState extends State<UberDisplayTab> {
  @override
  Widget build(BuildContext context) {
    return new GetMaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: getMainFrameOnRoute,
      routes: getMainFrameRoute(),
    );
  }
}

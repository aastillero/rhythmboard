import 'package:flutter/material.dart';
import '../widgets/DanceframeAppBar.dart';
import '../widgets/MFTabComponent.dart';
import '../widgets/DeviceOne.dart';
// import 'package:uber_display/widgets/Global2ControlPanel.dart';

class control_panel extends StatefulWidget {
  @override
  _control_panelState createState() => new _control_panelState();
}

class _control_panelState extends State<control_panel> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new DanceframeAppBar(
          height: 150.0,
          mode: "TITLE",
          headerText: "CONFIGURATION SETUP",
          bg: true,
        ),
        body: Container(
          width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(width: 2.0),
                            right: BorderSide(width: 2.0),
                            left: BorderSide(width: 2.0))),
                    child: new MFTabbedComponentDemoScaffold(
                        demos: <MFComponentDemoTabData>[
                          new MFComponentDemoTabData(
                            tabName: 'Device',
                            description: '',
                            demoWidget: DeviceOne(),
                          ),
                          // new MFComponentDemoTabData(
                          //   tabName: 'Global 1',
                          //   description: '',
                          //   // demoWidget: Global1ControlPanel(),
                          // ),
                          // new MFComponentDemoTabData(
                          //   tabName: 'Global 2',
                          //   description: '',
                          //   // demoWidget: Global2ControlPanel(),
                          // ),
                          // new MFComponentDemoTabData(
                          //   tabName: 'Global 3',
                          //   description: '',
                          //   // demoWidget: Global3ControlPanel(),
                          // ),
                          // new MFComponentDemoTabData(
                          //   tabName: 'Global 4',
                          //   description: '',
                          //   // demoWidget: Global4ControlPanel(),
                          // ),
                        ]),
                  ),
                ),
              ]),
        ));
  }
}

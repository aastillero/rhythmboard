import 'package:flutter/material.dart';

import 'MFTab.dart';
import 'MFTabs.dart';

class MFComponentDemoTabData {
  final Widget? demoWidget;
  final String? exampleCodeTag;
  final String? description;
  final String? tabName;
  final VoidCallback? loadMoreCallback;
  final VoidCallback? refreshCallback;

  MFComponentDemoTabData(
      {this.demoWidget,
      this.exampleCodeTag,
      this.description,
      this.tabName,
      this.loadMoreCallback,
      this.refreshCallback});

  // @override
  // bool operator ==(Object other) {
  //   if (other.runtimeType != runtimeType) return false;
  //   final MFComponentDemoTabData typedOther = other;
  //   return typedOther.tabName == tabName &&
  //       typedOther.description == description;
  // }

  @override
  int get hashCode => hashValues(tabName.hashCode, description.hashCode);
}

class MFTabbedComponentDemoScaffold extends StatefulWidget {
  final List<MFComponentDemoTabData>? demos;
  final Key? key;
  final String? title;
  final bool hasBackButton;

  const MFTabbedComponentDemoScaffold({
    this.key,
    this.title,
    this.hasBackButton = false,
    this.demos,
  });

  @override
  _MFTabbedComponentDemoScaffoldState createState() =>
      new _MFTabbedComponentDemoScaffoldState();
}

class _MFTabbedComponentDemoScaffoldState
    extends State<MFTabbedComponentDemoScaffold> {
  List<Widget> tabs = <Widget>[];

  List<Widget> _buildTabs(double d_width) {
    double tabWidth = d_width / widget.demos!.length;
    int idx = 0;
    return widget.demos!.map<Widget>((MFComponentDemoTabData data) {
      return new MFTab(idx++, text: data.tabName, width: tabWidth);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    tabs = _buildTabs(MediaQuery.of(context).size.width);
    double _height = MediaQuery.of(context).size.height;

    return new DefaultTabController(
      length: widget.demos!.length,
      child: new Column(
        //color: Colors.amber,
        key: widget.key,
        children: <Widget>[
          new Container(
              height: 50.0,
              //color: Colors.amber,
              child: new Material(
                elevation: 5.0,
                child: new MainFrameTabBar(
                  isScrollable: false,
                  indicatorColor: new Color(0xffb3cbd7),
                  indicatorWeight: 3.0,
                  tabs: tabs,
                  tabCallback: () {
                    setState(() {
                      tabs = _buildTabs(MediaQuery.of(context).size.width);
                    });
                  },
                ),
              )),
          new Flexible(
            child: new MainFrameTabBarView(
              children:
                  widget.demos!.map<Widget>((MFComponentDemoTabData demo) {
                return new Column(
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.all(10.0),
                    ),
                    //new Container(color: Colors.amber, height: 200.0)new Expanded(child: demo.demoWidget)
                    new Flexible(
                        child: new NotificationListener<OverscrollNotification>(
                      child: new ListView(
                        children: <Widget>[demo.demoWidget!],
                      ),
                      onNotification: (OverscrollNotification notif) {
                        //print(notif.metrics.pixels);
                        if (notif.metrics.pixels > 0.0) {
                          // reached bottom
                          // handle load more content callback
                          if (demo.loadMoreCallback != null)
                            demo.loadMoreCallback!();
                        } else {
                          // reached top
                          // handle refresh callback
                          if (demo.refreshCallback != null)
                            demo.refreshCallback!();
                        }

                        return true;
                      },
                    ))
                  ],
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

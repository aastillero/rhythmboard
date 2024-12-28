import 'package:flutter/material.dart';

const double _kTabHeight = 46.0;
const double _kTextAndIconTabHeight = 72.0;
const double _kMinTabWidth = 72.0;

class MFTab extends StatefulWidget {
  VoidCallback? tapFunc;
  double? width;
  int? index;
  Key? key;
  String? text;
  Widget? icon;

  // ignore: missing_identifier
  MFTab(this.index,
      {this.width = 100.0, this.key, this.text, this.icon, this.tapFunc});

  @override
  _MFTabState createState() => new _MFTabState();
}

class _MFTabState extends State<MFTab> {
  Color bg = new Color(0xff4e748d);
  Widget? _container;

  Widget _buildLabelText() {
    return new Text(
      widget.text ?? '',
      softWrap: false,
      overflow: TextOverflow.fade,
      style: new TextStyle(fontSize: 24.0, color: Colors.black),
    );
  }

  Widget _buildContainer(double? height, Widget? label, Color? color) {
    Color containerBg;
    int? curr = DefaultTabController.of(context)?.index;

    if (widget.index == curr) {
      containerBg = bg;
    } else {
      containerBg = new Color(0xffb3cbd7);
    }

    return new Container(
      width: widget.width,
      decoration: new BoxDecoration(color: containerBg),
      padding: kTabLabelPadding,
      height: height,
      constraints: const BoxConstraints(minWidth: _kMinTabWidth),
      child: new Center(child: label),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    double? height;
    Widget? label;
    if (widget.icon == null) {
      height = _kTabHeight;
      label = _buildLabelText();
    } else if (widget.text == null) {
      height = _kTabHeight;
      label = widget.icon;
    } else {
      height = _kTextAndIconTabHeight;
      label = new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
                child: widget.icon,
                margin: const EdgeInsets.only(bottom: 10.0)),
            _buildLabelText()
          ]);
    }

    _container = _buildContainer(height, label, null);

    return new InkWell(
      child: _container,
    );
  }
}

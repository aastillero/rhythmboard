import 'package:flutter/material.dart';

class CPRadio extends StatefulWidget {
  final Function? onChange;
  final String? value;
  final String? groupValue;

  const CPRadio({
    Key? key,
    this.value,
    this.groupValue,
    this.onChange,
  }) : super(key: key);

  @override
  _CPRadioState createState() => new _CPRadioState();
}

class _CPRadioState extends State<CPRadio> {
  bool isChecked = false;

  void checkValue(val, String item) {
    //print("val: $val, listIems: $item");
    if (item != null && item == val) {
      isChecked = true;
    } else {
      isChecked = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    checkValue(widget.value, widget.groupValue ?? '');

    return InkWell(
      onTap: () {
        //setState(() {
        //print("isChecked: $isChecked");
        if (!isChecked) {
          if (widget.onChange != null) {
            Function.apply(widget.onChange!, [true]);
          }
        }
        //});
      },
      child: (isChecked)
          ? Icon(Icons.radio_button_checked, size: 30.0)
          : Icon(Icons.radio_button_unchecked, size: 30.0),
    );
  }
}

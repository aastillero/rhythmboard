import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CPCheckbox extends StatefulWidget {
  final Function? onChange;
  final String? value;
  final List<String>? groupValue;

  const CPCheckbox({
    Key? key,
    this.value,
    this.groupValue,
    this.onChange,
  }) : super(key: key);

  @override
  _CPCheckboxState createState() => new _CPCheckboxState();
}

class _CPCheckboxState extends State<CPCheckbox> {
  bool isChecked = false;

  void checkValue(val, List<String> listItems) {
    //print("val: $val, listIems: $listItems");
    if (listItems != null && listItems.contains(val)) {
      isChecked = true;
    } else {
      isChecked = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    checkValue(widget.value, widget.groupValue ?? []);

    return InkWell(
      onTap: () {
        setState(() {
          if (isChecked) {
            isChecked = false;
            if (widget.onChange != null) {
              Function.apply(widget.onChange!, [false]);
            }
          } else {
            isChecked = true;
            if (widget.onChange != null) {
              Function.apply(widget.onChange!, [true]);
            }
          }
        });
      },
      child: (isChecked)
          ? Icon(FontAwesomeIcons.solidCheckSquare, size: 26.0)
          : Icon(FontAwesomeIcons.square, size: 26.0),
    );
  }
}

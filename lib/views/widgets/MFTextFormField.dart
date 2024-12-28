import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class MFTextFormField extends StatefulWidget {
  String? labelText;
  String? hintText;
  Icon? icon;
  FormFieldSetter<String>? onSaved;
  FormFieldValidator<String>? validator;
  bool obscureText;
  TextInputType keyboardType;
  TextEditingController? controller;
  String initialValue;
  TextStyle? errorStyle;
  bool isEnabled;
  bool isDatePicker;

  MFTextFormField(
      {this.labelText,
      this.hintText,
      this.icon,
      this.onSaved,
      this.errorStyle,
      this.validator,
      this.obscureText = false,
      this.keyboardType = TextInputType.text,
      this.controller,
      this.initialValue = "",
      this.isEnabled = true,
      this.isDatePicker = false});

  @override
  _MFTextFormFieldState createState() => new _MFTextFormFieldState();
}

class _MFTextFormFieldState extends State<MFTextFormField> {
  DateTime _pickDate = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    List<Widget> rowItems = <Widget>[];
    Alignment align = Alignment.topLeft;
    EdgeInsets padding = new EdgeInsets.only(bottom: 0.0);
    InputDecoration decoration = new InputDecoration(
      //icon: widget.icon,
      hintText: widget.hintText,
      labelText: widget.labelText,
      border: InputBorder.none,
      errorStyle: widget.errorStyle,
      //hideDivider: true,
    );

    Widget field = new TextFormField(
      decoration: decoration,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      onSaved: widget.onSaved,
      validator: widget.validator,
      controller: widget.controller,
      //initialValue: widget.initialValue,
    );

    TextStyle style =
        new TextStyle(fontFamily: "Montserrat-Regular", fontSize: 16.0);

    if (!widget.isEnabled) {
      if (widget.initialValue != null) {
        field = new Text(widget.controller!.text, style: style);
      } else {
        field = new Text(widget.labelText ?? '', style: style);
      }
      align = Alignment.bottomLeft;
      padding = new EdgeInsets.only(bottom: 10.0);
    }

    if (widget.isDatePicker) {
      if (widget.controller != null &&
          (widget.controller!.text != null &&
              widget.controller!.text.isNotEmpty)) {
        _pickDate = new DateFormat("yyyy-MM-dd").parse(widget.controller!.text);
      }

      field = new _DateTimePicker(
          labelText: widget.labelText ?? '',
          selectedDate: _pickDate,
          selectDate: (DateTime date) {
            setState(() {
              _pickDate = date;
              widget.onSaved!(new DateFormat("yyyy-MM-dd").format(_pickDate));
            });
          });
    }

    if (widget.icon != null) {
      rowItems.add(new Container(
        //color: Colors.amber,
        child: widget.icon,
        margin: const EdgeInsets.only(top: 20.0),
      ));
      rowItems.add(new Padding(padding: const EdgeInsets.only(left: 10.0)));
    }
    rowItems.add(new Expanded(
        child: new Container(
      padding: padding,
      alignment: align,
      //color: Colors.indigo,
      child: field,
      //height: 50.0,
      constraints: new BoxConstraints(minHeight: 55.0),
    )));

    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new Row(
              children: rowItems,
            ),
            decoration: new BoxDecoration(
                border:
                    new Border(bottom: new BorderSide(color: Colors.white))),
          ),
        ],
      ),
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker(
      {Key? key,
      this.labelText,
      this.selectedDate,
      this.selectedTime,
      this.selectDate,
      this.selectTime})
      : super(key: key);

  final String? labelText;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final ValueChanged<DateTime>? selectDate;
  final ValueChanged<TimeOfDay>? selectTime;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime _maxDate = new DateTime.now()
        .add(new Duration(days: 365)); //add 1 year to current date
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: new DateTime(1900, 8),
      lastDate: _maxDate,
    );
    if (picked != null && picked != selectedDate) selectDate!(picked);
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: selectedTime!);
    if (picked != null && picked != selectedTime) selectTime!(picked);
  }

  @override
  Widget build(BuildContext context) {
    //print("DATE: ${selectedDate}");

    // final TextStyle valueStyle = Theme.of(context).textTheme.title;
    final TextStyle? valueStyle = Theme.of(context).textTheme.displayLarge;
    return new Container(
      //color: Colors.blue,
      //alignment: Alignment.topLeft,
      child: Row(
        children: <Widget>[
          new Expanded(
            flex: 4,
            child: new _InputDropdown(
              labelText: labelText ?? '',
              valueText: new DateFormat("yMMMMd").format(selectedDate!),
              valueStyle: valueStyle!,
              onPressed: () {
                _selectDate(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key? key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String? labelText;
  final String? valueText;
  final TextStyle? valueStyle;
  final VoidCallback? onPressed;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    TextStyle style =
        new TextStyle(fontFamily: "Montserrat-Regular", fontSize: 25.0);

    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: labelText,
        ),
        child: Container(
            //color: Colors.red,
            child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText ?? '', style: style),
            new Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        )),
      ),
    );
  }
}

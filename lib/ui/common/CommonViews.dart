import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kotak_cherry/common/enums/Priority.dart';

mixin CommonViews {
  static InputDecoration getDropwDownDecorator(String label, IconData? icon) {
    return InputDecoration(
      icon: Icon(icon, size: 24),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          // width: 1.5,
          color: Colors.blueGrey.shade700,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          // width: 1.5,
          color: Colors.blueGrey.shade700,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          width: 1.5,
          color: Colors.blueGrey.shade700,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          color: Colors.blueGrey.shade700,
          width: 1.5,
        ),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: TextStyle(color: Colors.blueGrey.shade700),
      labelText: label,
    );
  }

  //
  static InputDecoration getTextEditFieldDecorator(String label, IconData? icon) {
    return InputDecoration(
      icon: Icon(icon, size: 24),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          // width: 1.5,
          color: Colors.blueGrey.shade700,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          // width: 1.5,
          color: Colors.blueGrey.shade700,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          width: 1.5,
          color: Colors.blueGrey.shade700,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          color: Colors.blueGrey.shade700,
          width: 1.5,
        ),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: TextStyle(color: Colors.blueGrey.shade700),
      labelText: label,
    );
  }

  static Future<String> showDate(BuildContext context) async {
    String format = "yyyy-MM-dd";
    var selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        //get today's date
        firstDate: DateTime(2000),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));

    if (selectedDate != null) {
      return DateFormat(format).format(selectedDate).toString();
    }

    return "";
  }
}

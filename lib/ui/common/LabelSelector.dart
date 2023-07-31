import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotak_cherry/common/enums/TaskLabel.dart';

import '../../common/enums/Priority.dart';
import 'CommonViews.dart';

class LabelSelector {
  int initialValue = -1;
  String initialString = "Select";

  int _selectedLabel = -1;
  Function(Object?)? onChange;

  LabelSelector(this.onChange);

  void setSelectedValue(int value) {
    _selectedLabel = value;
  }

  Widget getLabels() {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.clear();
    menuItems.add(DropdownMenuItem(value: initialValue.toString(), child: Text(initialString)));

    TASK_LABEL.values.forEach((element) {
      menuItems.add(DropdownMenuItem(value: element.value.toString(), child: Text(element.name)));
    });

    return Container(
        width: 200,
        child: DropdownButtonFormField(
            value: _selectedLabel.toString(),
            isExpanded: true,
            items: menuItems,
            validator: (String? value) {
              return (_selectedLabel == -1) ? 'PLease select label.' : null;
            },
            decoration: CommonViews.getDropwDownDecorator("Select Label", null),
            onChanged: (Object? value) {
              _selectedLabel = int.parse(value.toString());
              if (onChange != null) onChange!(value);

              // setState(() {
              //   // _selectedTravelMode = value.toString();
              //   _selectedPriority = int.parse(value.toString());
              // });
            }));
  }
}

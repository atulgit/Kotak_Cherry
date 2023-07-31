import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/enums/Priority.dart';
import 'CommonViews.dart';

class PrioritySelector {
  int initialValue = -1;
  String initialString = "Select";

  int _selectedPriority = -1;
  Function(Object?)? onChange;

  PrioritySelector(this.onChange);

  void setSelectedValue(int selectedValue) {
    _selectedPriority = selectedValue;
  }

  Widget getPriorities() {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.clear();
    menuItems.add(DropdownMenuItem(value: initialValue.toString(), child: Text(initialString)));

    PRIORITY.values.forEach((element) {
      menuItems.add(DropdownMenuItem(value: element.value.toString(), child: Text(element.name)));
    });

    return Container(
        width: 200,
        child: DropdownButtonFormField(
            value: _selectedPriority.toString(),
            isExpanded: true,
            items: menuItems,
            validator: (String? value) {
              return (_selectedPriority == -1) ? 'PLease select priority.' : null;
            },
            decoration: CommonViews.getDropwDownDecorator("Select Priority", null),
            onChanged: (Object? value) {
              _selectedPriority = int.parse(value.toString());
              if (onChange != null) onChange!(value);

              // setState(() {
              //   // _selectedTravelMode = value.toString();
              //   _selectedPriority = int.parse(value.toString());
              // });
            }));
  }
}

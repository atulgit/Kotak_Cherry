import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/enums/Priority.dart';
import 'CommonViews.dart';

class SortBySelector {
  int initialValue = -1;
  String initialString = "Select";

  int _selectedFilterId = -1;
  Function(Object?)? onChange;

  SortBySelector(this.onChange);

  void setSelectedValue(int value) {
    _selectedFilterId = value;
  }

  Widget getFilters() {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.clear();
    menuItems.add(DropdownMenuItem(value: initialValue.toString(), child: Text(initialString)));
    menuItems.add(const DropdownMenuItem(value: "0", child: Text("PRIORITY")));
    menuItems.add(const DropdownMenuItem(value: "1", child: Text("DUE DATE")));

    return Container(
        width: 200,
        child: DropdownButtonFormField(
            value: _selectedFilterId.toString(),
            isExpanded: true,
            items: menuItems,
            validator: (String? value) {
              return (_selectedFilterId == -1) ? 'PLease select option.' : null;
            },
            decoration: CommonViews.getDropwDownDecorator("Sort By", null),
            onChanged: (Object? value) {
              _selectedFilterId = int.parse(value.toString());
              if (onChange != null) onChange!(value);

              // setState(() {
              //   // _selectedTravelMode = value.toString();
              //   _selectedPriority = int.parse(value.toString());
              // });
            }));
  }
}

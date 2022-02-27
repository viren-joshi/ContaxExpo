import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  final String label;
  final String? value;
  final List<DropdownMenuItem<String>> itemsList;
  final Function(String?) onChangedCallback;

  const CustomDropDown({
    Key? key,
    required this.label,
    required this.value,
    required this.itemsList,
    required this.onChangedCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          DropdownButton<String>(
            value: value,
            items: itemsList,
            onChanged: (val) {
              onChangedCallback(val);
            },
          ),
        ],
      ),
    );
  }
}
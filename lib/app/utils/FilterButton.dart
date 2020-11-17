import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {

  final Function(String) filter;

  FilterButton({this.filter});

  @override
  FilterButtonState createState() => FilterButtonState(filter);
}
class FilterButtonState extends State<FilterButton> {
  String dropdownValue = 'Todos';

  FilterButtonState(this.filter);

  final Function(String) filter;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
        filter(newValue);
      },
      items: <String>["Todos", 'Praia Vermelha', 'Gragoatá', 'Valonguinho', 'Direito']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
import 'package:flutter/material.dart';
import 'chat_screen.dart';

class CheckBox extends StatefulWidget {
  CheckBox({this.controller,this.button});

  TextEditingController controller;
  Wrapper button;
  @override
  _CheckBoxState createState() => _CheckBoxState();
}



class _CheckBoxState extends State<CheckBox> {
  List<String> daysList = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];
  List<bool> checkBoxValue = [false, false, false, false, false, false, false];

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(daysList[index]),
            value: checkBoxValue[index],
            onChanged: (bool value) {
              setState(() {
                checkBoxValue[index] = value;
                List<String> outputList = [];
                for (int i = 0; i < checkBoxValue.length; i++) {
                  if (checkBoxValue[i]) {
                    outputList.add(daysList[i]);
                  }
                }
                print(outputList);
                if(outputList.length>3){
                  widget.button.buttonDisabled=true;
                }
                else{
                  widget.button.buttonDisabled=false;
                }
                widget.controller.text=outputList.join(' ');
              });

            },
          );
        },
        itemCount: daysList.length,
        shrinkWrap: true,
      ),
    );
  }
}


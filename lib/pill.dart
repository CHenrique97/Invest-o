import 'package:flutter/material.dart';

class Pill extends StatefulWidget {
  final List<Map<String, Object>> pillData;
  Pill(this.pillData);
  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return PillState(pillData);
  }
}

class PillState extends State<Pill> {
  final List<Map<String, Object>> pillData;
  List<bool> stateList;
  PillState(this.pillData)
      : stateList = List<bool>.generate(pillData.length, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      children: [
        ...pillData.map((pillName) {
          return TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  const StadiumBorder()),
              side: MaterialStateProperty.resolveWith<BorderSide>(
                  (Set<MaterialState> states) {
                Color color = stateList[pillName['index'] as int]
                    ? Colors.black
                    : Colors.white;
                return BorderSide(color: color, width: 2);
              }),
              foregroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                Color color = stateList[pillName['index'] as int]
                    ? Colors.black
                    : Colors.white;
                return color;
              }),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                Color color = stateList[pillName['index'] as int]
                    ? Colors.white
                    : Colors.black;
                return color;
              }),
            ),
            child: Text(pillName["name"] as String),
            onPressed: () {
              setState(() {
                for (int buttonIndex = 0;
                    buttonIndex < stateList.length;
                    buttonIndex++) {
                  if (buttonIndex == pillName['index'] as int) {
                    stateList[buttonIndex] = !stateList[buttonIndex];
                  } else {
                    stateList[buttonIndex] = false;
                  }
                }
              });
            },
          );
        }),
        SizedBox(width: 50),
      ],
    );
  }
}

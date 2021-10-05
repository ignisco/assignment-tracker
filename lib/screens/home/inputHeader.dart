import 'package:assignment_tracker/main.dart';
import 'package:assignment_tracker/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputHeader extends StatefulWidget {
  final Function callback;
  final Color color;

  InputHeader(this.color, this.callback, {Key? key}) : super(key: key);

  @override
  _InputHeaderState createState() => _InputHeaderState();
}

class _InputHeaderState extends State<InputHeader> {
  String title = "Today";

  _setDate(String choice) {
    int daysAhead;
    if (choice == "Today") {
      daysAhead = 0;
    } else if (choice == "Tomorrow") {
      daysAhead = 1;
    } else {
      daysAhead = int.parse(choice.split(" ")[1]);
    }
    title = choice;
    widget.callback(daysAhead);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 200,
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: this.widget.color,
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  this.title,
                  style: Shared.instance
                      .getTheme()
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              RotatedBox(
                quarterTurns: 1,
                child: PopupMenuButton<String>(
                    tooltip: "Set",
                    onSelected: _setDate,
                    itemBuilder: (BuildContext context) {
                      return {
                        'Today',
                        "Tomorrow",
                        "Next 2 Days",
                        "Next 3 Days",
                        "Next 4 Days",
                        "Next 5 Days",
                        "Next 6 Days",
                        "Next 7 Days",
                        "Next 8 Days",
                        "Next 9 Days",
                      }.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    }),
              ),
            ],
          ))),
    );
  }
}

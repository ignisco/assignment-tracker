import 'package:assignment_tracker/auth/services.dart';
import 'package:assignment_tracker/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class EntryTile extends StatefulWidget {
  final DocumentSnapshot doc;
  final bool isFuture;
  EntryTile(this.doc, {this.isFuture = false});

  @override
  _EntryTileState createState() => _EntryTileState();
}

class _EntryTileState extends State<EntryTile> {
  @override
  Widget build(BuildContext context) {
    bool isFinished = this.widget.doc.get("isFinished");
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: SizedBox(
          height: 80,
          width: max(500, Shared.instance.getSize().width / 2.5),
          child: Opacity(
            opacity: !widget.isFuture && !isFinished
                ? 1
                : max(
                    0.3,
                    1 -
                        max(
                            0.4,
                            (widget.doc.get("timestamp") as Timestamp)
                                    .toDate()
                                    .difference(DateTime.now())
                                    .inDays
                                    .abs()
                                    .toDouble() /
                                7)),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                tileColor: isFinished
                    ? Shared.instance.getTheme().primaryColor
                    : (widget.doc.get("timestamp") as Timestamp)
                            .toDate()
                            .difference(DateTime.now())
                            .inDays
                            .isNegative
                        ? Colors.red[800]
                        : Shared.instance.getTheme().accentColor,
                title: Text(this.widget.doc.get("title"),
                    style: Shared.instance.getTheme().textTheme.headline5),
                subtitle: Text(
                    DateFormat.yMMMd().format(
                        (this.widget.doc.get("timestamp") as Timestamp)
                            .toDate()),
                    style: Shared.instance.getTheme().textTheme.subtitle1),
                trailing: SizedBox(
                  height: 100,
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Checkbox(
                        activeColor: Colors.black38,
                        value: isFinished,
                        onChanged: (bool? value) {
                          AuthService.toggleAssignment(
                              this.widget.doc.reference, value!);
                          // AnimatedList.of(context).removeItem(
                          //     widget.index, (context, animation) => widget);
                        },
                      ),
                      RotatedBox(
                        quarterTurns: 1,
                        child: PopupMenuButton<String>(
                            tooltip: "Options",
                            onSelected: (choice) {
                              switch (choice) {
                                case "Reoccuring":
                                  break;
                                case "Delete":
                                  AuthService.deleteAssignment(
                                      widget.doc.reference);
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return {'Delete', 'Reoccuring'}
                                  .map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList();
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

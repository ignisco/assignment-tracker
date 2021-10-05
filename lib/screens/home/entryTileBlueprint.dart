import 'package:assignment_tracker/auth/services.dart';
import 'package:assignment_tracker/main.dart';
import 'package:assignment_tracker/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class EntryTileBlueprint extends StatefulWidget {
  final Function callback;
  EntryTileBlueprint(this.callback);
  @override
  _EntryTileBlueprintState createState() => _EntryTileBlueprintState();
}

class _EntryTileBlueprintState extends State<EntryTileBlueprint> {
  DateTime selectedDate = DateTime.now();
  TextEditingController titleController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: SizedBox(
            width: max(500, Shared.instance.getSize().width / 2.5),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                tileColor: Shared.instance.getTheme().accentColor,
                title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextFormField(
                      controller: titleController,
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Enter a title";
                        }
                        return null;
                      },
                      style: Shared.instance.getTheme().textTheme.headline5,
                      onEditingComplete: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        AuthService.addAssignment(
                            titleController.text, selectedDate);
                        widget.callback(true);
                      },
                    )),
                subtitle: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Text(DateFormat.yMMMd().format(selectedDate),
                          style:
                              Shared.instance.getTheme().textTheme.subtitle1)),
                ),
                trailing: SizedBox(
                  height: 100,
                  width: 150,
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              AuthService.addAssignment(
                                  titleController.text, selectedDate);
                              widget.callback(true);
                            },
                            child: Text("Save"),
                            style: ElevatedButton.styleFrom(
                                primary:
                                    Shared.instance.getTheme().primaryColor)),
                        SizedBox(width: 10),
                        ElevatedButton(
                            onPressed: () {
                              widget.callback(false);
                            },
                            child: Text("Discard")),
                      ],
                    ),
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

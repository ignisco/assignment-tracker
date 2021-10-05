import 'dart:html';
import 'dart:io';
import 'dart:math';

import 'package:assignment_tracker/auth/services.dart';
import 'package:assignment_tracker/main.dart';
import 'package:assignment_tracker/screens/home/entryTileBlueprint.dart';
import 'package:assignment_tracker/screens/home/header.dart';
import 'package:assignment_tracker/screens/home/inputHeader.dart';
import 'package:assignment_tracker/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'home/entryTile.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final inputHeaderKey = GlobalKey();
  int itemCount = 0;

  ensureVisible() {
    Scrollable.ensureVisible(inputHeaderKey.currentContext!,
        alignment: 0.375, duration: Duration(milliseconds: 900));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.only(top: 100, bottom: 100),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: AuthService.userAssignments,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    List<DocumentSnapshot> list = snapshot.data!.docs!;

                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      if (itemCount >= list.length) {
                        itemCount = list.length;
                        return;
                      }
                      itemCount = list.length;
                      ensureVisible();
                    });

                    int statusSplit =
                        list.indexWhere((element) => element.get("isFinished"));
                    if (statusSplit == -1) statusSplit = list.length;
                    List<DocumentSnapshot> listOfActive =
                        list.sublist(0, statusSplit);

                    //Dividing active assignments in before and after focus period
                    int futureSplit = listOfActive.indexWhere((element) {
                      return (element.get("timestamp") as Timestamp)
                          .toDate()
                          .isBefore(DateTime.now()
                              .add(Duration(days: MyApp.focusPeriod)));
                    });
                    if (futureSplit == -1) futureSplit = listOfActive.length;

                    return Column(children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return EntryTile(list[index], isFuture: true);
                        },
                        itemCount: futureSplit,
                      ),
                      SizedBox(
                        width: max(500, Shared.instance.getSize().width / 2.5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(child: Container()),
                              Flexible(
                                child: InputHeader(
                                  Colors.blueGrey,
                                  (days) => setState(() {
                                    MyApp.focusPeriod = days;
                                    WidgetsBinding.instance!
                                        .addPostFrameCallback((_) {
                                      ensureVisible();
                                    });
                                  }),
                                  key: inputHeaderKey,
                                ),
                              ),
                              Flexible(
                                  child: Center(
                                      child: SizedBox(
                                          width: 120,
                                          height: 50,
                                          child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              hoverColor: Colors.transparent,
                                              splashColor: Colors.transparent,
                                              onTap: () {
                                                setState(() {
                                                  MyApp.isAdding = true;
                                                  WidgetsBinding.instance!
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    ensureVisible();
                                                  });
                                                });
                                              },
                                              child: Header(
                                                  "Add", Colors.green[700]!)))))
                            ]),
                      ),
                      MyApp.isAdding
                          ? EntryTileBlueprint((savedNew) => setState(() {
                                MyApp.isAdding = false;
                              }))
                          : Container(),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return EntryTile(list[index + futureSplit]);
                        },
                        itemCount: statusSplit - futureSplit,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return EntryTile(list[index + statusSplit]);
                        },
                        itemCount: list.length - statusSplit,
                      ),
                    ]);
                  }),
            ],
          )),
    );
  }
}

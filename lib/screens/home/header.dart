import 'package:assignment_tracker/shared.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final Color color;
  const Header(this.title, this.color, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      width: 120,
      height: 50,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: this.color,
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              this.title,
              style: Shared.instance
                  .getTheme()
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        )),
      ),
    ));
  }
}

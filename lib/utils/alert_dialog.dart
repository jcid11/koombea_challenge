import 'package:flutter/material.dart';

Future<void> loadingDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return  const AlertDialog(
        content: SizedBox(
          width: 100,
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    },
  );
}

Future<void> failDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return const AlertDialog(
        content:SizedBox(height: 100,width: 100,child: Center(child: Text('it failed'),),)

      );
    },
  );
}

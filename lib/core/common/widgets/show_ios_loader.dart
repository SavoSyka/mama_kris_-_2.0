import 'package:flutter/cupertino.dart';

void showIOSLoader(BuildContext context) {
  showCupertinoDialog(
    context: context,
    barrierDismissible: false, // user can't dismiss accidentally
    builder: (context) {
      return const Center(
        child: CupertinoActivityIndicator(
          radius: 24, // size
        ),
      );
    },
  );
}


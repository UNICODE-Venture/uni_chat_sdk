import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension Navigation on BuildContext {
  ///* Act as ```Navigator.pop()```
  void pop({dynamic value}) {
    return Navigator.pop(this, value);
  }

  ///* Act as ```Navigator.push()```
  Future pushTo(Widget widget) async {
    return await Navigator.push(
      this,
      MaterialPageRoute(builder: (_) => widget),
    );
  }

  ///* Act as ```Navigator.pushAndRemoveUntil()```
  Future pushToUntil(Widget widget) async {
    return await Navigator.pushAndRemoveUntil(
      this,
      MaterialPageRoute(builder: (_) => widget),
      (route) => false,
    );
  }

  ///* Act as ```Navigator.pushReplacement()```
  Future pushReplacement(Widget widget) async {
    return await Navigator.pushReplacement(
      this,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => widget,
      ),
    );
  }

  ///* Act as ```Navigator.pushNamed()```
  Future pushToNamed(String routeName) async {
    return await Navigator.pushNamed(this, routeName);
  }

  ///* Act as ```Navigator.pushNamedAndRemoveUntil()```
  Future pushNamedUntill(String routeName) async {
    return await Navigator.pushNamedAndRemoveUntil(
        this, routeName, (route) => false);
  }
}

///* Print shortcuts `print()`
printMe(dynamic data) {
  if (kDebugMode) {
    print(data);
  }
}

///* Print in log shortcuts `log()`
printMeLog(dynamic data) {
  if (kDebugMode) {
    log(data.toString(), time: DateTime.now());
  }
}

///* Add delay by passing seconds
Future delayTill(int seconds) async {
  return await Future.delayed(
    Duration(seconds: seconds),
  );
}

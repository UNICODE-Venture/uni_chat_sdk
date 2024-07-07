import 'package:flutter/material.dart';
import 'package:uni_chat_sdk/src/core/extension/size_extension.dart';

import '../theme/colors.dart';

final _colors = ColorsPalletes.instance;

class UniScaffold extends StatelessWidget {
  /// [appBar] is the app bar of the screen
  final AppBar? appBar;

  /// [body] is the body of the screen
  final Widget? body;

  /// [bottomNavigationBar] is the bottom navigation bar of the screen
  final Widget? bottomNavigationBar;

  /// [UniScaffold] is the scaffold of the screen
  const UniScaffold(
      {super.key, this.appBar, this.body, this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: _colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.rw),
        child: body,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

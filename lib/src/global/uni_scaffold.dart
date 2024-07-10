import 'package:flutter/material.dart';
import 'package:uni_chat_sdk/src/core/extension/size_extension.dart';

import '../theme/colors.dart';
import '../utils/utils.dart';

final _colors = ColorsPalletes.instance;
final _utils = UniUtils.instance;

class UniScaffold extends StatelessWidget {
  /// [appBar] is the app bar of the screen
  final PreferredSizeWidget? appBar;

  /// [body] is the body of the screen
  final Widget? body;

  /// [bottomNavigationBar] is the bottom navigation bar of the screen
  final Widget? bottomNavigationBar;

  /// [backgroundColor] is the background color of the screen
  final Color? backgroundColor;

  /// [UniScaffold] is the scaffold of the screen
  const UniScaffold(
      {super.key,
      this.appBar,
      this.body,
      this.bottomNavigationBar,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _utils.hideKeyboard(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: appBar,
        backgroundColor: backgroundColor ?? _colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.rw),
          child: body,
        ),
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}

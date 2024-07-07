import 'package:flutter/material.dart';

import '../uni_design.dart';

final _designSystem = UniDesignSystem.instance;

class AnimatedCrossFadeView extends StatelessWidget {
  final bool animationStatus;
  final Widget shownIfFalse;
  final Widget shownIfTrue;
  final VoidCallback? onPressed;
  final Duration? duration;
  final Curve firstCurve;
  final Curve sizeCurve;

  const AnimatedCrossFadeView({
    super.key,
    required this.animationStatus,
    required this.shownIfFalse,
    required this.shownIfTrue,
    this.onPressed,
    this.duration,
    this.firstCurve = Curves.easeIn,
    this.sizeCurve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: AnimatedCrossFade(
        firstChild: shownIfFalse,
        secondChild: shownIfTrue,
        crossFadeState: animationStatus
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: duration ?? _designSystem.kDefaultDuration,
        alignment: Alignment.center,
        firstCurve: firstCurve,
        sizeCurve: sizeCurve,
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';

class GlassMorphism extends StatelessWidget {
  final Widget child;
  final double sigmaVal;
  const GlassMorphism({super.key, required this.child, this.sigmaVal = 10});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: sigmaVal, sigmaY: sigmaVal),
      child: child,
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/extension/size_extension.dart';

class UniChatProvider extends StatefulWidget {
  /// You can pass you MaterialApp or any other widget as a child to this provider
  final Widget child;

  /// A provider that provides the chat functionality and state management using Riverpod
  const UniChatProvider({super.key, required this.child});

  @override
  State<UniChatProvider> createState() => _UniChatProviderState();
}

class _UniChatProviderState extends State<UniChatProvider> {
  final _screenSizes = UniScreenSizes.instance;

  @override
  Widget build(BuildContext context) {
    /// Initialize the responsive design
    _screenSizes.initUniSize(context);

    /// Initialize the provider scope
    return ProviderScope(
      child: widget.child,
    );
  }
}

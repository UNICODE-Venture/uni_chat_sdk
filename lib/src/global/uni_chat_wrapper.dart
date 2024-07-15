import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';
import 'package:uni_chat_sdk/src/core/providers/providers.dart';

import '../../generated/codegen_loader.g.dart';
import '../constants/assets_paths.dart';
import '../constants/locale.dart';
import '../core/models/config/uni_chat_config.dart';
import '../theme/theme.dart';
import 'package:timeago/timeago.dart' as time_ago;

import 'uni_chat_provider.dart';

late GlobalKey<NavigatorState> uniStateKey;

class UniChatSDKWrapper extends StatelessWidget {
  /// [home] is the child of the screen
  final Widget home;

  /// [config] is the configuration of the chat to show the chat in the way you want
  final UniChatConfig? config;

  /// [UniChatSDKWrapper] is the main widget for the uni chat package, please make sure to wrap your main widget where chat will be shown,
  ///
  /// You need to add it only if you want to use the widgets only but if you're using the [UniChatSdkView] directly then you don't need to add it.
  ///
  /// Because [UniChatSdkView] already have the [UniChatSDKWrapper] inside it.

  // Before use any of the widgets from the package, otherwise the package will not work as expected
  //
  // Also make sure you wrap your main app with our provider [UniChatProvider], otherwise the package will lead to crash
  const UniChatSDKWrapper({super.key, required this.home, this.config});

  @override
  Widget build(BuildContext context) {
    return UniChatProvider(
      child: EasyLocalization(
        path: UniAssetsPath.translations,
        useOnlyLangCode: true,
        assetLoader: const CodegenLoader(),
        supportedLocales: UniLocalizationsData.supportLocale,
        fallbackLocale: UniLocalizationsData.supportLocale.first,
        startLocale:
            config?.locale.locale ?? UniLocalizationsData.supportLocale.first,
        child: UniChatApp(home: home, config: config),
      ),
    );
  }
}

class UniChatApp extends ConsumerStatefulWidget {
  /// [home] is the child of the screen
  final Widget home;

  /// [config] is the configuration of the chat to show the chat in the way you want
  final UniChatConfig? config;

  const UniChatApp({super.key, required this.home, this.config});

  @override
  ConsumerState<UniChatApp> createState() => _UniChatAppState();
}

class _UniChatAppState extends ConsumerState<UniChatApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onStartUp());
  }

  /// [_onStartUp] is the function that will run on start up of the package
  Future _onStartUp() async {
    uniStateKey = widget.config?.stateKey ?? GlobalKey<NavigatorState>();
    UniLocalizationsData.currentLocale =
        widget.config?.locale.locale ?? context.locale;
    ref.uniChatStateNotifier.saveUniChatConfig(widget.config);

    time_ago.setLocaleMessages(
      context.locale.languageCode,
      context.locale.isArabic ? time_ago.ArMessages() : time_ago.EnMessages(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.config?.theme ?? UniChatTheme.theme,
      child: Localizations(
        locale: context.locale,
        delegates: context.localizationDelegates,
        child: Builder(
          builder: (context) => BotToastInit()(
            context,
            widget.config?.stateKey != null
                ? widget.home
                : Navigator(
                    key: uniStateKey,
                    onGenerateRoute: (_) =>
                        MaterialPageRoute(builder: (context) => widget.home),
                  ),
          ),
        ),
      ),
    );
  }
}

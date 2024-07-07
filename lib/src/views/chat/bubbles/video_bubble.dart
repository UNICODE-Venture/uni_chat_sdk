import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';
import 'package:uni_chat_sdk/src/core/extension/size_extension.dart';

import 'package:video_player/video_player.dart';

import 'package:chewie/chewie.dart';

import '../../../../uni_chat_sdk.dart';
import '../../../core/services/storage/cache_services.dart';
import '../../../global/uni_design.dart';
import '../../../global/widgets/skeleton_loading.dart';
import '../../../theme/colors.dart';
import '../../../utils/navigation.dart';

final _designSystem = UniDesignSystem.instance;
final _colors = ColorsPalletes.instance;

class VideoBubble extends StatefulWidget {
  /// [uniChatMessage] is the message that is to be displayed
  final UniChatMessage uniChatMessage;

  /// [VideoBubble] is the widget that displays the text message
  const VideoBubble({super.key, required this.uniChatMessage});

  @override
  State<VideoBubble> createState() => _VideoBubbleState();
}

class _VideoBubbleState extends State<VideoBubble> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  final _cacheServices = CacheServices.instance;

  /// Is to know whether the video is initialized or not
  bool isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  /// Initialize the video player
  Future<void> _initializeVideoPlayer() async {
    try {
      File videoFile = widget.uniChatMessage.mediaFile ??
          await _cacheServices.getFile(widget.uniChatMessage.message);
      _videoPlayerController = VideoPlayerController.file(videoFile);
      if (_videoPlayerController != null) {
        await _videoPlayerController!.initialize();
        _chewieController =
            ChewieController(videoPlayerController: _videoPlayerController!);
      }
    } catch (e) {
      printMeLog(e);
    }
    if (mounted) setState(() => isVideoInitialized = true);
  }

  @override
  void dispose() {
    _videoPlayerController?.pause();
    _chewieController?.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isVideoInitialized
        ? Container(
            width: 70.w,
            height: 160.rh,
            decoration: BoxDecoration(
              color: _colors.lightDark06,
              borderRadius: 10.br,
            ),
            child: _chewieController != null
                ? Chewie(controller: _chewieController!)
                : _designSystem.mediaError(),
          )
        : SkeletonLoading(width: 70.w, height: 160.rh);
  }
}

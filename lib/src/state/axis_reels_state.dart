import 'dart:async';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/foundation.dart';

import '../models/axis_reel_model.dart';
import '../data/default_reels_data.dart';

class AxisReelsState extends ChangeNotifier {
  /// Constructor with optional custom reel data
  /// If no custom data is provided, uses the default sample data
  /// Accepts a flat list of models and handles row generation internally
  AxisReelsState({
    List<AxisReelModel>? customReels,
    int? maxConcurrentVideos,
  })  : _reels = customReels ?? DefaultReelsData.flatList,
        _maxConcurrentVideos = maxConcurrentVideos;

  final List<AxisReelModel> _reels;
  final int? _maxConcurrentVideos;
  List<List<AxisReelModel>>? _cachedRows;

  final Map<String, CachedVideoPlayerPlusController> _videoControllers = {};
  final Map<String, bool> _isVideoInitialized = {};
  final Map<String, bool> _hasVideoError = {};
  final Map<String, int> _videoLoopCounts = {};
  final Map<String, Timer?> _autoplayTimers = {};
  final Set<String> _visibleVideoIds = {};
  final List<String> _playingVideoIds = []; // Track currently playing videos in order

  Timer? _debounceTimer;
  bool _isDisposed = false;
  static const Duration _autoplayDelay = Duration(milliseconds: 800);

  // Flatten all reels for easy access
  List<AxisReelModel> get allReels => _reels;

  /// Get reels organized into rows (2 items per row)
  /// Results are cached for performance
  List<List<AxisReelModel>> get rows {
    _cachedRows ??= _generateRows(_reels);
    return _cachedRows!;
  }

  /// Generate rows from flat list of reels (2 items per row)
  List<List<AxisReelModel>> _generateRows(List<AxisReelModel> items) {
    final List<List<AxisReelModel>> generatedRows = [];
    for (int i = 0; i < items.length; i += 2) {
      if (i + 1 < items.length) {
        generatedRows.add([items[i], items[i + 1]]);
      } else {
        // If odd number of items, last row has single item
        generatedRows.add([items[i]]);
      }
    }
    return generatedRows;
  }

  CachedVideoPlayerPlusController? getVideoController(String videoId) {
    return _videoControllers[videoId];
  }

  bool isVideoInitialized(String videoId) =>
      _isVideoInitialized[videoId] ?? false;
  bool hasVideoError(String videoId) => _hasVideoError[videoId] ?? false;
  bool isVideoVisible(String videoId) => _visibleVideoIds.contains(videoId);

  void initialize() {
    if (_isDisposed) return;

    // Preload first few videos
    final videoReels =
        allReels.where((reel) => reel.type == ReelType.video).take(3);
    for (final reel in videoReels) {
      _initializeVideoController(reel);
    }
  }

  void onVideoVisibilityChanged(String videoId, bool isVisible) {
    if (_isDisposed) return;

    if (isVisible) {
      _visibleVideoIds.add(videoId);
      _startAutoplayTimer(videoId);
    } else {
      _visibleVideoIds.remove(videoId);
      _cancelAutoplayTimer(videoId);
      _pauseVideo(videoId);
    }
  }

  void _startAutoplayTimer(String videoId) {
    if (_isDisposed) return;

    _cancelAutoplayTimer(videoId);

    _autoplayTimers[videoId] = Timer(_autoplayDelay, () {
      if (_isDisposed || !_visibleVideoIds.contains(videoId)) return;

      final reel = allReels.firstWhere((r) => r.id == videoId, orElse: () => allReels.first);
      if (!_videoControllers.containsKey(videoId)) {
        _initializeVideoController(reel);
      } else if (_isVideoInitialized[videoId] == true) {
        _playVideo(videoId);
      }
    });
  }

  void _cancelAutoplayTimer(String videoId) {
    _autoplayTimers[videoId]?.cancel();
    _autoplayTimers[videoId] = null;
  }

  void _initializeVideoController(AxisReelModel videoReel) {
    if (_isDisposed || _videoControllers.containsKey(videoReel.id)) return;

    try {
      final controller = CachedVideoPlayerPlusController.networkUrl(
        Uri.parse(videoReel.url),
        invalidateCacheIfOlderThan: const Duration(days: 30),
      );

      _videoControllers[videoReel.id] = controller;
      _isVideoInitialized[videoReel.id] = false;
      _hasVideoError[videoReel.id] = false;
      _videoLoopCounts[videoReel.id] = 0;

      controller.initialize().then((_) {
        if (_isDisposed) return;

        _isVideoInitialized[videoReel.id] = true;
        _hasVideoError[videoReel.id] = false;

        // Set video to mute by default
        controller.setVolume(0.0);

        // Set up listener for finite looping
        controller.addListener(() => _handleVideoLoop(videoReel.id));

        // Auto-play if video is visible
        if (_visibleVideoIds.contains(videoReel.id)) {
          _playVideo(videoReel.id);
        }

        notifyListeners();
      }).catchError((error) {
        if (_isDisposed) return;

        _hasVideoError[videoReel.id] = true;
        _isVideoInitialized[videoReel.id] = false;
        _videoControllers.remove(videoReel.id);
        debugPrint('Error initializing video ${videoReel.id}: $error');
        notifyListeners();
      });
    } catch (e) {
      _hasVideoError[videoReel.id] = true;
      _isVideoInitialized[videoReel.id] = false;
      debugPrint('Error creating video controller for ${videoReel.id}: $e');
      notifyListeners();
    }
  }

  void _handleVideoLoop(String videoId) {
    if (_isDisposed || !_videoControllers.containsKey(videoId)) return;

    final controller = _videoControllers[videoId]!;
    // Safe lookup
    final reel = allReels.firstWhere((r) => r.id == videoId, orElse: () => allReels.first);

    // Check if video has ended (with a small buffer for precision)
    final duration = controller.value.duration;
    final position = controller.value.position;

    if (duration.inMilliseconds > 0 &&
        position.inMilliseconds >= duration.inMilliseconds - 100) {
      final currentLoops = _videoLoopCounts[videoId] ?? 0;
      _videoLoopCounts[videoId] = currentLoops + 1;

      if (_videoLoopCounts[videoId]! < reel.loopCount) {
        // Restart the video for another loop
        controller.seekTo(Duration.zero);
        controller.play();
      } else {
        // Stop playing after reaching the loop count
        controller.pause();
        controller.seekTo(Duration.zero);
      }
    }
  }

  void _playVideo(String videoId) {
    if (_isDisposed || !_videoControllers.containsKey(videoId)) return;

    final controller = _videoControllers[videoId];
    if (controller != null && _isVideoInitialized[videoId] == true) {
      // Enforce max concurrent videos limit
      if (_maxConcurrentVideos != null && _playingVideoIds.length >= _maxConcurrentVideos) {
        // Pause the oldest playing video (first in list)
        if (_playingVideoIds.isNotEmpty) {
          final oldestVideoId = _playingVideoIds.first;
          _pauseVideoInternal(oldestVideoId);
        }
      }

      _videoLoopCounts[videoId] = 0; // Reset loop count
      controller.play();

      // Add to playing list if not already there
      _playingVideoIds.remove(videoId); // Remove if exists
      _playingVideoIds.add(videoId);    // Add to end (most recent)

      notifyListeners();
    }
  }

  void _pauseVideoInternal(String videoId) {
    if (_isDisposed || !_videoControllers.containsKey(videoId)) return;

    final controller = _videoControllers[videoId];
    if (controller != null && _isVideoInitialized[videoId] == true) {
      controller.pause();
      _playingVideoIds.remove(videoId);
    }
  }

  void _pauseVideo(String videoId) {
    if (_isDisposed || !_videoControllers.containsKey(videoId)) return;

    final controller = _videoControllers[videoId];
    if (controller != null && _isVideoInitialized[videoId] == true) {
      controller.pause();
      _playingVideoIds.remove(videoId);
      notifyListeners();
    }
  }

  void toggleVideoPlayPause(String videoId) {
    if (_isDisposed || !_videoControllers.containsKey(videoId)) return;

    final controller = _videoControllers[videoId];
    if (controller != null && _isVideoInitialized[videoId] == true) {
      if (controller.value.isPlaying) {
        _pauseVideo(videoId);
      } else {
        _playVideo(videoId);
      }
    }
  }

  void resetVideo(String videoId) {
    if (_isDisposed || !_videoControllers.containsKey(videoId)) return;

    final controller = _videoControllers[videoId];
    if (controller != null && _isVideoInitialized[videoId] == true) {
      _videoLoopCounts[videoId] = 0;
      controller.seekTo(Duration.zero);
      controller.play();
      notifyListeners();
    }
  }

  void pauseAllVideos() {
    if (_isDisposed) return;

    for (final controller in _videoControllers.values) {
      if (controller.value.isInitialized && controller.value.isPlaying) {
        controller.pause();
      }
    }
    _playingVideoIds.clear();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _debounceTimer?.cancel();

    // Cancel all autoplay timers
    for (final timer in _autoplayTimers.values) {
      timer?.cancel();
    }
    _autoplayTimers.clear();

    // Dispose all video controllers
    for (final controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
    _isVideoInitialized.clear();
    _hasVideoError.clear();
    _videoLoopCounts.clear();
    _visibleVideoIds.clear();
    _cachedRows = null;

    super.dispose();
  }
}

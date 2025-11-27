import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_awsome_video_grid/src/models/axis_reel_model.dart';
import 'package:flutter_awsome_video_grid/src/providers/axis_reels_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Builder for custom item foreground overlay
typedef ItemForegroundBuilder = Widget Function(
  BuildContext context,
  AxisReelModel reel,
  bool isVideoPlaying,
);

/// Builder for custom item background
typedef ItemBackgroundBuilder = Widget Function(
  BuildContext context,
  AxisReelModel reel,
);

class AxisReelsExploreScreen extends ConsumerStatefulWidget {
  /// List of reels to display. If null, uses default data
  final List<AxisReelModel>? reels;

  /// Optional title for the app bar. If null, no app bar is shown
  final String? title;

  /// Custom foreground builder for each item
  /// Receives the reel model and video playing state
  final ItemForegroundBuilder? foregroundBuilder;

  /// Custom background builder for each item
  /// Useful for custom gradients, overlays, etc.
  final ItemBackgroundBuilder? backgroundBuilder;

  /// Whether to show the default app bar with back button
  /// Set to false for embedding in custom scroll views
  final bool showAppBar;

  /// Whether to manage scroll internally
  /// Set to false if you want to provide your own scroll controller
  final bool manageScroll;

  /// External scroll controller (only used if manageScroll is false)
  final ScrollController? scrollController;

  /// Whether to show the video indicator icon
  final bool showVideoIndicator;

  /// Whether to show the play button overlay when video is paused
  final bool showPlayButton;

  /// Padding around the grid
  final EdgeInsets? padding;

  /// Spacing between items
  final double itemSpacing;

  /// Background color
  final Color? backgroundColor;

  /// Maximum number of videos that can play simultaneously
  /// Set to null for unlimited (not recommended for performance)
  /// Default: 2 (good balance between UX and performance)
  final int? maxConcurrentVideos;

  /// Whether to show media type icon (image/video) at bottom-left corner
  /// Default: true
  final bool showMediaTypeIcon;

  /// Custom scroll physics for the grid
  /// Useful for coordinating with DraggableScrollableSheet
  /// Example: Use NeverScrollableScrollPhysics() when embedding in DraggableScrollableSheet
  final ScrollPhysics? physics;

  /// Whether the ListView should shrinkWrap its content
  /// Set to true when using with DraggableScrollableSheet for seamless scroll coordination
  /// When true, scrolling continues from grid content to sheet at edges
  /// Default: false
  final bool shrinkWrap;

  const AxisReelsExploreScreen({
    super.key,
    this.reels,
    this.title,
    this.foregroundBuilder,
    this.backgroundBuilder,
    this.showAppBar = false,
    this.manageScroll = true,
    this.scrollController,
    this.showVideoIndicator = false,
    this.showPlayButton = true,
    this.showMediaTypeIcon = true,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.itemSpacing = 8.0,
    this.backgroundColor = Colors.transparent,
    this.maxConcurrentVideos = 2,
  });

  @override
  ConsumerState<AxisReelsExploreScreen> createState() =>
      _AxisReelsExploreScreenState();
}

class _AxisReelsExploreScreenState
    extends ConsumerState<AxisReelsExploreScreen> {
  ScrollController? _internalScrollController;

  ScrollController get _effectiveScrollController =>
      widget.scrollController ?? _internalScrollController!;

  @override
  void initState() {
    super.initState();
    // Only create internal controller if we're managing scroll
    if (widget.manageScroll && widget.scrollController == null) {
      _internalScrollController = ScrollController();
    }
  }

  @override
  void dispose() {
    // Only dispose if we created it
    _internalScrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider with the reels and maxConcurrentVideos arguments
    final axisReelsState = ref.watch(axisReelsProvider(AxisReelsProviderParams(
      reels: widget.reels,
      maxConcurrentVideos: widget.maxConcurrentVideos,
    )));

    // Get rows directly from state (no need to generate locally)
    final rows = axisReelsState.rows;

    final content = NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        return false;
      },
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(8.0),
        child: widget.manageScroll
            ? ListView.builder(
                controller: _effectiveScrollController,
                physics: widget.physics,
                shrinkWrap: widget.shrinkWrap,
                itemCount: rows.length,
                itemBuilder: (context, index) => _buildRow(context, rows[index], axisReelsState),
              )
            : Column(
                children: rows
                    .map((row) => _buildRow(context, row, axisReelsState))
                    .toList(),
              ),
      ),
    );

    // If showAppBar is false, return content directly (for embedding)
    if (!widget.showAppBar) {
      return content;
    }

    // Otherwise, wrap in Scaffold with optional AppBar
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: widget.title != null
          ? AppBar(
              backgroundColor: widget.backgroundColor == Colors.transparent
                  ? Colors.black
                  : widget.backgroundColor,
              title: Text(
                widget.title!,
                style: const TextStyle(color: Colors.white),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          : null,
      body: content,
    );
  }

  Widget _buildRow(BuildContext context, List<AxisReelModel> row, dynamic axisReelsState) {
    final itemHeight = MediaQuery.of(context).size.width * 0.6;

    return Container(
      margin: EdgeInsets.only(bottom: widget.itemSpacing),
      child: Row(
        children: [
          Expanded(
            child: _buildReelItem(row[0], axisReelsState, itemHeight),
          ),
          SizedBox(width: widget.itemSpacing),
          Expanded(
            child: row.length > 1
                ? _buildReelItem(row[1], axisReelsState, itemHeight)
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildReelItem(
      AxisReelModel reel, axisReelsState, double itemHeight) {
    return VisibilityDetector(
      key: Key(reel.id),
      onVisibilityChanged: (info) {
        if (reel.type == ReelType.video) {
          final isVisible =
              info.visibleFraction > 0.9; // 90% visibility threshold
          axisReelsState.onVideoVisibilityChanged(reel.id, isVisible);
        }
      },
      child: Container(
        height: itemHeight,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: reel.type == ReelType.image
              ? _buildImageItem(reel)
              : _buildVideoItem(reel, axisReelsState),
        ),
      ),
    );
  }

  Widget _buildImageItem(AxisReelModel reel) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: reel.url,
          fit: BoxFit.cover,
          // Use old cache while checking for new one
          cacheKey: reel.url,
          maxHeightDiskCache: 1000,
          maxWidthDiskCache: 1000,
          memCacheHeight: 1000,
          memCacheWidth: 1000,
          placeholder: (context, url) => Container(
            color: Colors.grey[800],
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white54,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[800],
            child: const Center(
              child: Icon(
                Icons.error_outline,
                color: Colors.white54,
                size: 40,
              ),
            ),
          ),
        ),
        // Custom background or default gradient
        if (widget.backgroundBuilder != null)
          widget.backgroundBuilder!(context, reel)
        else
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                ],
                stops: const [0.6, 1.0],
              ),
            ),
          ),
        // Custom foreground or default title
        if (widget.foregroundBuilder != null)
          widget.foregroundBuilder!(context, reel, false)
        else if (reel.title != null)
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Text(
              reel.title!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        // Media type icon at bottom-left
        if (widget.showMediaTypeIcon)
          Positioned(
            left: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.image,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVideoItem(AxisReelModel reel, axisReelsState) {
    final isInitialized = axisReelsState.isVideoInitialized(reel.id);
    final hasError = axisReelsState.hasVideoError(reel.id);
    final controller = axisReelsState.getVideoController(reel.id);
    final isPlaying = controller?.value.isPlaying ?? false;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Video player or thumbnail
        if (!isInitialized || hasError)
          // Show thumbnail while loading or on error
          CachedNetworkImage(
            imageUrl: reel.thumbnailUrl ?? '',
            fit: BoxFit.cover,
            // Use old cache while checking for new one
            cacheKey: reel.thumbnailUrl,
            maxHeightDiskCache: 1000,
            maxWidthDiskCache: 1000,
            memCacheHeight: 1000,
            memCacheWidth: 1000,
            placeholder: (context, url) => Container(
              color: Colors.grey[800],
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white54,
                  strokeWidth: 2,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[800],
              child: const Center(
                child: Icon(
                  Icons.videocam_off,
                  color: Colors.white54,
                  size: 40,
                ),
              ),
            ),
          )
        else if (controller != null)
          GestureDetector(
            onTap: () {
              axisReelsState.toggleVideoPlayPause(reel.id);
            },
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: CachedVideoPlayerPlus(controller),
                ),
              ),
            ),
          ),

        // Custom background or default gradient
        if (widget.backgroundBuilder != null)
          widget.backgroundBuilder!(context, reel)
        else
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                ],
                stops: const [0.6, 1.0],
              ),
            ),
          ),

        // Play button overlay (only show when paused and showPlayButton is true)
        if (widget.showPlayButton && isInitialized && !hasError && controller != null)
          GestureDetector(
            onTap: () {
              axisReelsState.toggleVideoPlayPause(reel.id);
            },
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: AnimatedOpacity(
                  opacity: isPlaying ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),

        // Video indicator (optional, default is false)
        if (widget.showVideoIndicator)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: const Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),

        // Custom foreground or default title with controls
        if (widget.foregroundBuilder != null)
          widget.foregroundBuilder!(context, reel, isPlaying)
        else
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    reel.title ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isInitialized && !hasError)
                  GestureDetector(
                    onTap: () {
                      axisReelsState.resetVideo(reel.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.replay,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),

        // Loading indicator for video initialization
        if (!isInitialized && !hasError && reel.type == ReelType.video)
          Container(
            color: Colors.black38,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white54,
                strokeWidth: 2,
              ),
            ),
          ),

        // Media type icon at bottom-left
        if (widget.showMediaTypeIcon)
          Positioned(
            left: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.videocam,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
      ],
    );
  }
}

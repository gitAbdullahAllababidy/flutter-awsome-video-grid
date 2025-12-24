import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../models/axis_reel_model.dart';
import '../state/axis_reels_state.dart';
import '../views/axis_reels_explore_screen.dart'
    show
        ItemForegroundBuilder,
        ItemBackgroundBuilder,
        VideoThumbnailBuilder,
        ImageItemBuilder;

/// Utility class for building reel rows and items
/// Extracted from AxisReelsExploreScreen for reuse in sliver implementations
class ReelRowBuilder {
  final double itemSpacing;
  final ItemForegroundBuilder? foregroundBuilder;
  final ItemBackgroundBuilder? backgroundBuilder;
  final VideoThumbnailBuilder? videoThumbnailBuilder;
  final ImageItemBuilder? imageItemBuilder;
  final BaseCacheManager? imageCacheManager;
  final BaseCacheManager? videoThumbnailCacheManager;
  final bool showVideoIndicator;
  final bool showMediaTypeIcon;
  final void Function(AxisReelModel reel)? onItemTap;

  const ReelRowBuilder({
    required this.itemSpacing,
    this.foregroundBuilder,
    this.backgroundBuilder,
    this.videoThumbnailBuilder,
    this.imageItemBuilder,
    this.imageCacheManager,
    this.videoThumbnailCacheManager,
    this.showVideoIndicator = false,
    this.showMediaTypeIcon = true,
    this.onItemTap,
  });

  /// Build a row containing 1-2 reel items
  Widget buildRow(
    BuildContext context,
    List<AxisReelModel> row,
    AxisReelsState axisReelsState,
  ) {
    final itemHeight = MediaQuery.of(context).size.width * 0.6;

    return Container(
      margin: EdgeInsets.only(bottom: itemSpacing),
      child: Row(
        children: [
          Expanded(child: buildReelItem(context, row[0], axisReelsState, itemHeight)),
          SizedBox(width: itemSpacing),
          Expanded(
            child: row.length > 1
                ? buildReelItem(context, row[1], axisReelsState, itemHeight)
                : Container(),
          ),
        ],
      ),
    );
  }

  /// Build a single reel item (image or video)
  Widget buildReelItem(
    BuildContext context,
    AxisReelModel reel,
    AxisReelsState axisReelsState,
    double itemHeight,
  ) {
    return VisibilityDetector(
      key: Key(reel.id),
      onVisibilityChanged: (info) {
        if (reel.type == ReelType.video) {
          final isVisible = info.visibleFraction > 0.9; // 90% visibility threshold
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
              ? _buildImageItem(context, reel)
              : _buildVideoItem(context, reel, axisReelsState),
        ),
      ),
    );
  }

  Widget _buildImageItem(BuildContext context, AxisReelModel reel) {
    final stack = Stack(
      fit: StackFit.expand,
      children: [
        // Custom image builder or default CachedNetworkImage
        if (imageItemBuilder != null)
          imageItemBuilder!(context, reel)
        else
          CachedNetworkImage(
            imageUrl: reel.url,
            fit: BoxFit.cover,
            useOldImageOnUrlChange: true,
            cacheKey: reel.url,
            cacheManager: imageCacheManager,
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
                child: Icon(Icons.error_outline, color: Colors.white54, size: 40),
              ),
            ),
          ),
        // Custom background or default gradient
        if (backgroundBuilder != null)
          backgroundBuilder!(context, reel)
        else
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
                stops: const [0.6, 1.0],
              ),
            ),
          ),
        // Custom foreground only (no default)
        if (foregroundBuilder != null) foregroundBuilder!(context, reel, false),
        // Media type icon at bottom-left
        if (showMediaTypeIcon)
          Positioned(
            left: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.image, color: Colors.white, size: 14),
            ),
          ),
      ],
    );

    if (onItemTap != null) {
      return GestureDetector(onTap: () => onItemTap!(reel), child: stack);
    }

    return stack;
  }

  Widget _buildVideoItem(
    BuildContext context,
    AxisReelModel reel,
    AxisReelsState axisReelsState,
  ) {
    final isInitialized = axisReelsState.isVideoInitialized(reel.id);
    final hasError = axisReelsState.hasVideoError(reel.id);
    final controller = axisReelsState.getVideoController(reel.id);
    final isPlaying = controller?.value.isPlaying ?? false;

    final stack = Stack(
      fit: StackFit.expand,
      children: [
        // Video player or thumbnail
        if (!isInitialized || hasError)
          // Show custom thumbnail builder or default behavior
          if (videoThumbnailBuilder != null)
            videoThumbnailBuilder!(context, reel)
          // Only show thumbnail if thumbnailUrl is not null or empty
          else if (reel.thumbnailUrl != null && reel.thumbnailUrl!.isNotEmpty)
            CachedNetworkImage(
              imageUrl: reel.thumbnailUrl!,
              fit: BoxFit.cover,
              useOldImageOnUrlChange: true,
              cacheKey: reel.thumbnailUrl,
              cacheManager: videoThumbnailCacheManager,
              maxHeightDiskCache: 1000,
              maxWidthDiskCache: 1000,
              memCacheHeight: 1000,
              memCacheWidth: 1000,
              placeholder: (context, url) => const SizedBox.shrink(),
              errorWidget: (context, url, error) => const SizedBox.shrink(),
            )
          else
            // No thumbnail URL provided, show nothing (loading indicator will be shown below)
            const SizedBox.shrink()
        else if (controller != null)
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: CachedVideoPlayerPlus(controller),
              ),
            ),
          ),

        // Custom background or default gradient
        if (backgroundBuilder != null)
          backgroundBuilder!(context, reel)
        else
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
                stops: const [0.6, 1.0],
              ),
            ),
          ),
        // Video indicator (optional, default is false)
        if (showVideoIndicator)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: const Icon(Icons.play_circle_outline, color: Colors.white, size: 16),
            ),
          ),

        // Custom foreground only (no default)
        if (foregroundBuilder != null) foregroundBuilder!(context, reel, isPlaying),

        // Loading indicator for video initialization
        if (!isInitialized && !hasError && reel.type == ReelType.video)
          Container(
            color: Colors.black38,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white54, strokeWidth: 2),
            ),
          ),

        // Media type icon at bottom-left
        if (showMediaTypeIcon)
          Positioned(
            left: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.videocam, color: Colors.white, size: 14),
            ),
          ),
      ],
    );
    if (onItemTap != null) {
      return GestureDetector(onTap: () => onItemTap!(reel), child: stack);
    }
    return stack;
  }
}


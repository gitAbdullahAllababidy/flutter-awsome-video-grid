import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../models/axis_reel_model.dart';
import '../providers/axis_reels_provider.dart';
import '../state/axis_reels_state.dart';

/// A generic carousel widget for displaying image and video reels.
/// Manages video playback automatically based on visibility.
class AwsomeVideoCarousel extends ConsumerStatefulWidget {
  const AwsomeVideoCarousel({
    super.key,
    required this.items,
    this.height = 300,
    this.borderRadius = 12,
    this.showMediaTypeIcon = true,
    this.showVideoIndicator = false,
    this.onItemTap,
    this.onPageChanged,
    this.initialIndex = 0,
    this.maxConcurrentVideos = 1,
    this.aspectRatio = 1.0,
    this.fit = BoxFit.cover,
  });

  final List<AxisReelModel> items;
  final double height;
  final double borderRadius;
  final bool showMediaTypeIcon;
  final bool showVideoIndicator;
  final void Function(AxisReelModel reel, int index)? onItemTap;
  final void Function(int index)? onPageChanged;
  final int initialIndex;
  final int maxConcurrentVideos;
  final double aspectRatio;
  final BoxFit fit;

  @override
  ConsumerState<AwsomeVideoCarousel> createState() => _AwsomeVideoCarouselState();
}

class _AwsomeVideoCarouselState extends ConsumerState<AwsomeVideoCarousel> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    final axisReelsState = ref.watch(
      axisReelsProvider(
        AxisReelsProviderParams(
          reels: widget.items,
          maxConcurrentVideos: widget.maxConcurrentVideos,
        ),
      ),
    );

    return SizedBox(
      height: widget.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.items.length,
          onPageChanged: (index) {
            widget.onPageChanged?.call(index);
          },
          itemBuilder: (context, index) {
            final item = widget.items[index];
            return _buildCarouselItem(context, item, axisReelsState, index);
          },
        ),
      ),
    );
  }

  Widget _buildCarouselItem(
    BuildContext context,
    AxisReelModel item,
    AxisReelsState state,
    int index,
  ) {
    return VisibilityDetector(
      key: Key('carousel-${item.id}-$index'),
      onVisibilityChanged: (info) {
        if (item.type == ReelType.video) {
          final isVisible = info.visibleFraction > 0.8;
          state.onVideoVisibilityChanged(item.id, isVisible);
        }
      },
      child: GestureDetector(
        onTap: widget.onItemTap != null ? () => widget.onItemTap!(item, index) : null,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildMediaContent(context, item, state),
            
            // Media Type Icon (Bottom Right)
            if (widget.showMediaTypeIcon)
              Positioned(
                right: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    item.type == ReelType.video ? Icons.videocam : Icons.image,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),

            // Video Play Indicator
            if (widget.showVideoIndicator && item.type == ReelType.video)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaContent(BuildContext context, AxisReelModel item, AxisReelsState state) {
    if (item.type == ReelType.image) {
      return CachedNetworkImage(
        imageUrl: item.url,
        fit: widget.fit,
        placeholder: (context, url) => Container(color: Colors.black12),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    }

    // Video Logic
    final isInitialized = state.isVideoInitialized(item.id);
    final hasError = state.hasVideoError(item.id);
    final controller = state.getVideoController(item.id);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Thumbnail with Fallback to Placeholder
        if (!isInitialized || hasError)
          CachedNetworkImage(
            imageUrl: (item.thumbnailUrl != null && item.thumbnailUrl!.isNotEmpty)
                ? item.thumbnailUrl!
                : item.url, // Fallback to video itself (the server might handle it or it might fail gracefully)
            fit: widget.fit,
            placeholder: (context, url) => Container(
              color: Colors.black,
              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.black,
              child: const Center(child: Icon(Icons.videocam_off, color: Colors.white54)),
            ),
          ),

        // Video Player
        if (isInitialized && !hasError && controller != null)
          SizedBox.expand(
            child: FittedBox(
              fit: widget.fit,
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: CachedVideoPlayerPlus(controller),
              ),
            ),
          ),
      ],
    );
  }
}

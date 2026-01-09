import 'package:flutter/material.dart';
import 'package:flutter_awsome_video_grid/flutter_awsome_video_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A wrapper around [AxisReelsExploreScreen] that provides custom pagination logic
/// using optimized slivers.
class PaginatedAwesomeVideoGrid extends ConsumerStatefulWidget {
  const PaginatedAwesomeVideoGrid({
    super.key,
    required this.items,
    required this.onLoadMore,
    this.isLoading = false,
    this.hasMore = true,
    this.errorMessage,
    this.foregroundBuilder,
    this.backgroundBuilder,
    this.imageItemBuilder,
    this.videoThumbnailBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.padding,
    this.itemSpacing = 8.0,
    this.maxConcurrentVideos = 2,
    this.crossAxisCount = 2,
    this.showVideoIndicator = true,
    this.showMediaTypeIcon = true,
    this.onItemTap,
    this.scrollPhysics,
    this.scrollController,
  });

  /// The list of items to display.
  final List<AxisReelModel> items;

  /// Callback to load more data.
  final VoidCallback onLoadMore;

  /// Whether data is currently loading.
  final bool isLoading;

  /// Whether there is more data to load.
  final bool hasMore;

  /// Error message if any.
  final String? errorMessage;

  /// Builder for custom item foreground overlay.
  final ItemForegroundBuilder? foregroundBuilder;

  /// Builder for custom item background.
  final ItemBackgroundBuilder? backgroundBuilder;

  /// Builder for custom image item widget.
  final ImageItemBuilder? imageItemBuilder;

  /// Builder for custom video thumbnail widget.
  final VideoThumbnailBuilder? videoThumbnailBuilder;

  /// Widget builder for loading state.
  final WidgetBuilder? loadingBuilder;

  /// Widget builder for empty state.
  final WidgetBuilder? emptyBuilder;

  /// Widget builder for error state.
  final WidgetBuilder? errorBuilder;

  /// Padding for the grid content.
  final EdgeInsets? padding;

  /// Spacing between items.
  final double itemSpacing;

  /// Maximum number of videos that can play simultaneously.
  final int? maxConcurrentVideos;

  /// Number of items across the cross axis.
  final int crossAxisCount;

  /// whether to show video indicator.
  final bool showVideoIndicator;

  /// whether to show media type icon.
  final bool showMediaTypeIcon;

  /// Callback when an item is tapped.
  final void Function(AxisReelModel reel)? onItemTap;

  /// Custom scroll physics.
  final ScrollPhysics? scrollPhysics;

  /// Optional external scroll controller.
  final ScrollController? scrollController;

  @override
  ConsumerState<PaginatedAwesomeVideoGrid> createState() => _PaginatedAwesomeVideoGridState();
}

class _PaginatedAwesomeVideoGridState extends ConsumerState<PaginatedAwesomeVideoGrid> {
  late final ScrollController _scrollController;
  bool _isLocalController = false;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController != null) {
      _scrollController = widget.scrollController!;
    } else {
      _scrollController = ScrollController();
      _isLocalController = true;
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    if (_isLocalController) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(PaginatedAwesomeVideoGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      _scrollController.removeListener(_onScroll);
      if (_isLocalController) {
        _scrollController.dispose();
      }

      if (widget.scrollController != null) {
        _scrollController = widget.scrollController!;
        _isLocalController = false;
      } else {
        _scrollController = ScrollController();
        _isLocalController = true;
      }
      _scrollController.addListener(_onScroll);
    }
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= 200) {
        if (!widget.isLoading && widget.hasMore) {
          widget.onLoadMore();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Initial State Handling (Empty/Error only when no items)
    if (widget.items.isEmpty) {
      if (widget.isLoading) {
        return widget.loadingBuilder?.call(context) ?? const Center(child: CircularProgressIndicator());
      }
      if (widget.errorMessage != null && widget.errorMessage!.isNotEmpty) {
        return widget.errorBuilder?.call(context) ?? Center(child: Text(widget.errorMessage!));
      }
      return widget.emptyBuilder?.call(context) ?? const Center(child: Text("No items found"));
    }

    // 2. Data State with Slivers
    // Watch the provider with the reels and maxConcurrentVideos arguments
    final axisReelsState = ref.watch(
      axisReelsProvider(
        AxisReelsProviderParams(
          reels: widget.items,
          maxConcurrentVideos: widget.maxConcurrentVideos,
          crossAxisCount: widget.crossAxisCount,
        ),
      ),
    );

    // Get rows directly from state
    final rows = axisReelsState.rows;

    // Initialize the helper builder
    final rowBuilder = ReelRowBuilder(
      itemSpacing: widget.itemSpacing,
      crossAxisCount: widget.crossAxisCount,
      foregroundBuilder: widget.foregroundBuilder,
      backgroundBuilder: widget.backgroundBuilder,
      videoThumbnailBuilder: widget.videoThumbnailBuilder,
      imageItemBuilder: widget.imageItemBuilder,
      showVideoIndicator: widget.showVideoIndicator,
      showMediaTypeIcon: widget.showMediaTypeIcon,
      onItemTap: widget.onItemTap,
    );

    return CustomScrollView(
      controller: _scrollController,
      physics: widget.scrollPhysics,
      slivers: [
        // Padding wrapper
        SliverPadding(
          padding: widget.padding ?? EdgeInsets.zero,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return rowBuilder.buildRow(context, rows[index], axisReelsState);
            }, childCount: rows.length),
          ),
        ),

        // Bottom Loading Indicator
        if (widget.isLoading && widget.items.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: widget.loadingBuilder?.call(context) ?? const CircularProgressIndicator()),
            ),
          ),

        // Bottom Error Message
        if (widget.errorMessage != null && widget.items.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(widget.errorMessage!, style: const TextStyle(color: Colors.red)),
              ),
            ),
          ),

        // Bottom padding to ensure content isn't covered by Fab or bottom bar if needed
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}
